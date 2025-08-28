import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import '../models/transfer_metadata.dart';
import '../models/app_settings.dart';
import 'file_service.dart';
import 'transfer_service.dart';

/// 简化的QR服务，使用静态方法和回调替代Riverpod
class QrService {
  // QR Generator 相关
  static String? _currentQrData;
  static Timer? _playbackTimer;
  static List<String>? _qrDataList;
  static int _currentIndex = 0;
  static final List<Function(String?)> _qrListeners = [];

  // QR Scanner 相关
  static bool _scannerActive = false;
  static final List<Function(bool)> _scannerListeners = [];

  /// 当前二维码数据
  static String? get currentQrData => _currentQrData;

  /// 扫描器是否激活
  static bool get scannerActive => _scannerActive;

  /// 获取当前进度信息
  static Map<String, int>? get playbackProgress {
    if (_qrDataList == null) return null;
    
    return {
      'current': _currentIndex + 1,
      'total': _qrDataList!.length,
    };
  }

  // QR数据监听器管理
  static void addQrListener(Function(String?) listener) {
    _qrListeners.add(listener);
  }

  static void removeQrListener(Function(String?) listener) {
    _qrListeners.remove(listener);
  }

  static void _notifyQrListeners() {
    for (final listener in _qrListeners) {
      listener(_currentQrData);
    }
  }

  // 扫描器监听器管理
  static void addScannerListener(Function(bool) listener) {
    _scannerListeners.add(listener);
  }

  static void removeScannerListener(Function(bool) listener) {
    _scannerListeners.remove(listener);
  }

  static void _notifyScannerListeners() {
    for (final listener in _scannerListeners) {
      listener(_scannerActive);
    }
  }

  /// 准备QR码数据
  static Future<void> prepareQrData(File file, AppSettings settings) async {
    try {
      // 为避免 QrInputTooLongException，按 UTF-8 字节长度自适应分片
      // 取一个保守上限，适配高纠错等级也能通过
      const int maxBytesPerFrame = 1000;
      int effectiveChunkSize = math.max(128, settings.chunkSize);

      List<FileChunk> chunks;
      TransferMetadata metadata;

      // 通过多轮比例缩放，保证单帧数据字节数不超过阈值
      for (int attempt = 0; attempt < 6; attempt++) {
        chunks = await FileService.splitFileIntoChunks(file, effectiveChunkSize);
        metadata = await FileService.createTransferMetadata(
          file,
          chunks.length,
          transferId: chunks.isNotEmpty ? chunks.first.transferId : null,
        );

        // 计算当前配置下的最大帧 UTF-8 字节长度
        int maxChunkBytes = 0;
        for (final c in chunks) {
          final bytesLen = utf8.encode(jsonEncode(c.toJson())).length;
          if (bytesLen > maxChunkBytes) maxChunkBytes = bytesLen;
        }
        final int metadataBytes = utf8.encode(jsonEncode(metadata.toJson())).length;
        final int worstBytes = math.max(maxChunkBytes, metadataBytes);

        if (worstBytes <= maxBytesPerFrame) {
          // 满足要求
          final qrDataList = <String>[];
          qrDataList.add(jsonEncode(metadata.toJson()));
          for (final chunk in chunks) {
            qrDataList.add(jsonEncode(chunk.toJson()));
          }

          _qrDataList = qrDataList;
          _currentIndex = 0;
          _currentQrData = qrDataList.first; // 显示第一个（元数据）
          _notifyQrListeners();

          await TransferService.prepareSendFile(file, settings);
          return;
        }

        // 基于比例缩放估算新的分片大小（按 UTF-8 字节数主导）
        final double ratio = maxBytesPerFrame / worstBytes;
        int proposed = (effectiveChunkSize * ratio * 0.90).floor();
        if (proposed >= effectiveChunkSize) {
          // 防止停滞，确保下降
          proposed = (effectiveChunkSize / 2).floor();
        }
        effectiveChunkSize = math.max(64, proposed);
      }

      // 兜底（极端情况下仍超限）：采用小分片强制通过
      effectiveChunkSize = 256;
      chunks = await FileService.splitFileIntoChunks(file, effectiveChunkSize);
      metadata = await FileService.createTransferMetadata(
        file,
        chunks.length,
        transferId: chunks.isNotEmpty ? chunks.first.transferId : null,
      );

      final qrDataList = <String>[];
      qrDataList.add(jsonEncode(metadata.toJson()));
      for (final chunk in chunks) {
        qrDataList.add(jsonEncode(chunk.toJson()));
      }

      _qrDataList = qrDataList;
      _currentIndex = 0;
      _currentQrData = qrDataList.first;
      _notifyQrListeners();

      await TransferService.prepareSendFile(file, settings);
    } catch (e) {
      rethrow;
    }
  }

  /// 开始自动播放
  static Future<void> startAutoPlay(AppSettings settings) async {
    if (_qrDataList == null || _qrDataList!.isEmpty) return;
    
    _playbackTimer?.cancel();
    _playbackTimer = Timer.periodic(
      Duration(milliseconds: settings.playbackSpeed),
      (timer) {
        if (_currentIndex < _qrDataList!.length - 1) {
          _currentIndex++;
          _currentQrData = _qrDataList![_currentIndex];
          _notifyQrListeners();
        } else {
          // 播放完毕，重新开始
          _currentIndex = 0;
          _currentQrData = _qrDataList![_currentIndex];
          _notifyQrListeners();
        }
      },
    );
  }

  /// 停止播放
  static void stopPlayback() {
    _playbackTimer?.cancel();
    _playbackTimer = null;
  }

  /// 手动切换到下一个QR码
  static void nextQr() {
    if (_qrDataList == null || _qrDataList!.isEmpty) return;
    
    _currentIndex = (_currentIndex + 1) % _qrDataList!.length;
    _currentQrData = _qrDataList![_currentIndex];
    _notifyQrListeners();
  }

  /// 手动切换到上一个QR码
  static void previousQr() {
    if (_qrDataList == null || _qrDataList!.isEmpty) return;
    
    _currentIndex = (_currentIndex - 1) % _qrDataList!.length;
    if (_currentIndex < 0) {
      _currentIndex = _qrDataList!.length - 1;
    }
    _currentQrData = _qrDataList![_currentIndex];
    _notifyQrListeners();
  }

  /// 跳转到指定QR码
  static void jumpToQr(int index) {
    if (_qrDataList == null || 
        _qrDataList!.isEmpty || 
        index < 0 || 
        index >= _qrDataList!.length) return;
    
    _currentIndex = index;
    _currentQrData = _qrDataList![_currentIndex];
    _notifyQrListeners();
  }

  /// 重置QR生成器状态
  static void resetGenerator() {
    _playbackTimer?.cancel();
    _playbackTimer = null;
    _qrDataList = null;
    _currentIndex = 0;
    _currentQrData = null;
    _notifyQrListeners();
  }

  /// 激活扫描器
  static void activateScanner() {
    _scannerActive = true;
    _notifyScannerListeners();
  }

  /// 停用扫描器
  static void deactivateScanner() {
    _scannerActive = false;
    _notifyScannerListeners();
  }

  /// 处理扫描结果
  static Future<File?> handleScanResult(String result) async {
    try {
      // 通知传输服务处理器
      return await TransferService.handleScannedData(result);
    } catch (e) {
      // 错误处理已在传输服务中完成
      return null;
    }
  }

  /// 清理所有监听器和定时器（用于应用关闭时）
  static void dispose() {
    _playbackTimer?.cancel();
    _playbackTimer = null;
    _qrListeners.clear();
    _scannerListeners.clear();
  }
}
