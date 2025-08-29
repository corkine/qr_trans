import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
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

    return {'current': _currentIndex + 1, 'total': _qrDataList!.length};
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

  /// 根据比例计算实际chunk大小
  static int calculateChunkSize(double sizeRatio) {
    // 定义基线：最小128字节，最大300字节（保守估计避免QR码超限）
    const int minChunkSize = 128;
    const int maxChunkSize = 2000;

    // 根据比例（10-100%）计算实际大小
    double ratio = (sizeRatio - 10.0) / 90.0; // 将10-100范围映射到0-1
    ratio = math.max(0.0, math.min(1.0, ratio)); // 确保在0-1范围内

    int actualSize = (minChunkSize + (maxChunkSize - minChunkSize) * ratio)
        .round();
    return actualSize;
  }

  /// 准备QR码数据
  static Future<void> prepareQrData(File file, AppSettings settings) async {
    try {
      // 根据用户比例设置计算实际chunk大小
      int effectiveChunkSize = calculateChunkSize(settings.chunkSizeRatio);

      print(
        'QR Service: 开始准备数据 - 用户设置比例: ${settings.chunkSizeRatio.toInt()}%，实际块大小: $effectiveChunkSize 字节',
      );

      // 使用计算得到的chunk大小直接分片
      final chunks = await FileService.splitFileIntoChunks(
        file,
        effectiveChunkSize,
      );
      final metadata = await FileService.createTransferMetadata(
        file,
        chunks.length,
        transferId: chunks.isNotEmpty ? chunks.first.transferId : null,
      );

      // 生成QR数据列表
      final qrDataList = <String>[];
      qrDataList.add(jsonEncode(metadata.toJson()));
      for (final chunk in chunks) {
        qrDataList.add(jsonEncode(chunk.toJson()));
      }

      _qrDataList = qrDataList;
      _currentIndex = 0;
      _currentQrData = qrDataList.first; // 显示第一个（元数据）
      _notifyQrListeners();

      print(
        'QR Service: 生成 ${chunks.length} 个数据块，总共 ${_qrDataList!.length} 个二维码',
      );

      await TransferService.prepareSendFile(file, settings);
    } catch (e) {
      rethrow;
    }
  }

  /// Web平台专用：从字节数组准备QR码数据
  static Future<void> prepareQrDataFromBytes(
    Uint8List bytes, 
    String fileName, 
    AppSettings settings
  ) async {
    try {
      if (!kIsWeb) {
        throw UnsupportedError('此方法仅在Web平台可用');
      }

      // 根据用户比例设置计算实际chunk大小
      int effectiveChunkSize = calculateChunkSize(settings.chunkSizeRatio);

      print(
        'QR Service: 从字节数组准备数据 (Web) - 用户设置比例: ${settings.chunkSizeRatio.toInt()}%，实际块大小: $effectiveChunkSize 字节',
      );

      // 直接从字节数组分片
      final chunks = await FileService.splitBytesIntoChunks(
        bytes,
        effectiveChunkSize,
        fileName,
      );
      
      final metadata = FileService.createTransferMetadataFromBytes(
        bytes,
        fileName,
        chunks.length,
        transferId: chunks.isNotEmpty ? chunks.first.transferId : null,
      );

      // 生成QR数据列表
      final qrDataList = <String>[];
      qrDataList.add(jsonEncode(metadata.toJson()));
      for (final chunk in chunks) {
        qrDataList.add(jsonEncode(chunk.toJson()));
      }

      _qrDataList = qrDataList;
      _currentIndex = 0;
      _currentQrData = qrDataList.first; // 显示第一个（元数据）
      _notifyQrListeners();

      print(
        'QR Service: 生成 ${chunks.length} 个数据块，总共 ${_qrDataList!.length} 个二维码',
      );

      // Web平台直接设置状态，不需要文件操作
      await TransferService.prepareSendFromBytes(bytes, fileName, settings);
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

  /// 停止播放并回到第一个二维码
  static void stopAndResetToFirst() {
    _playbackTimer?.cancel();
    _playbackTimer = null;

    // 如果有二维码数据，回到第一个
    if (_qrDataList != null && _qrDataList!.isNotEmpty) {
      _currentIndex = 0;
      _currentQrData = _qrDataList![_currentIndex];
      _notifyQrListeners();
    }
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
        index >= _qrDataList!.length) {
      return;
    }

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
