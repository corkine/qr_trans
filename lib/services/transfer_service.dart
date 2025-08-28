import 'dart:async';
import 'dart:convert';
import 'dart:io';
import '../models/app_settings.dart';
import '../models/transfer_metadata.dart';
import 'file_service.dart';

/// 简化的传输服务，使用静态方法和回调替代Riverpod
class TransferService {
  static AppState _currentState = const AppState();
  static final List<Function(AppState)> _listeners = [];

  /// 当前状态
  static AppState get currentState => _currentState;

  /// 添加状态监听器
  static void addListener(Function(AppState) listener) {
    _listeners.add(listener);
  }

  /// 移除状态监听器
  static void removeListener(Function(AppState) listener) {
    _listeners.remove(listener);
  }

  /// 通知所有监听器状态变化
  static void _notifyListeners() {
    for (final listener in _listeners) {
      listener(_currentState);
    }
  }

  /// 更新状态
  static void _updateState(AppState newState) {
    _currentState = newState;
    _notifyListeners();
  }

  /// 准备发送文件
  static Future<void> prepareSendFile(File file, AppSettings settings) async {
    try {
      _updateState(_currentState.copyWith(status: TransferStatus.preparing));
      
      final chunks = await FileService.splitFileIntoChunks(file, settings.chunkSize);
      final metadata = await FileService.createTransferMetadata(
        file,
        chunks.length,
        transferId: chunks.isNotEmpty ? chunks.first.transferId : null,
      );
      
      // 创建新的传输进度
      final progress = TransferProgress(
        transferId: metadata.transferId,
        receivedChunks: 0,
        totalChunks: metadata.totalChunks,
        chunks: {},
        metadata: metadata,
      );

      _updateState(_currentState.copyWith(
        status: TransferStatus.ready,
        currentTransferId: metadata.transferId,
        activeTransfers: [..._currentState.activeTransfers, progress],
      ));
    } catch (e) {
      _updateState(_currentState.copyWith(
        status: TransferStatus.error,
        errorMessage: '文件准备失败: $e',
      ));
    }
  }

  /// 开始播放QR码
  static Future<void> startPlayback() async {
    if (_currentState.currentTransferId == null) return;
    
    try {
      _updateState(_currentState.copyWith(status: TransferStatus.sending));
    } catch (e) {
      _updateState(_currentState.copyWith(
        status: TransferStatus.error,
        errorMessage: '播放启动失败: $e',
      ));
    }
  }

  /// 停止播放
  static void stopPlayback() {
    _updateState(_currentState.copyWith(status: TransferStatus.ready));
  }

  /// 开始接收文件
  static void startReceiving() {
    _updateState(_currentState.copyWith(status: TransferStatus.receiving));
  }

  /// 处理扫描到的QR码数据
  static Future<File?> handleScannedData(String qrData) async {
    try {
      final Map<String, dynamic> data = 
          Map<String, dynamic>.from(jsonDecode(qrData));
      
      // 检查是否为元数据
      if (data.containsKey('fileName')) {
        final metadata = TransferMetadata.fromJson(data);
        await _handleMetadata(metadata);
      } else {
        final chunk = FileChunk.fromJson(data);
        final file = await _handleChunk(chunk);
        if (file != null) {
          return file;
        }
      }
    } catch (e) {
      _updateState(_currentState.copyWith(
        status: TransferStatus.error,
        errorMessage: '数据解析失败: $e',
      ));
      return null;
    }
    return null;
  }

  /// 处理元数据
  static Future<void> _handleMetadata(TransferMetadata metadata) async {
    // 检查是否已存在该传输
    final existingIndex = _currentState.activeTransfers.indexWhere(
      (t) => t.transferId == metadata.transferId,
    );
    
    if (existingIndex != -1) {
      // 传输已存在，不重复创建
      return;
    }

    // 保存元数据以便恢复
    await FileService.saveTransferMetadata(metadata);

    final progress = TransferProgress(
      transferId: metadata.transferId,
      receivedChunks: 0,
      totalChunks: metadata.totalChunks,
      chunks: {},
      metadata: metadata,
    );

    _updateState(_currentState.copyWith(
      currentTransferId: metadata.transferId,
      activeTransfers: [..._currentState.activeTransfers, progress],
      status: TransferStatus.receiving,
    ));
  }

  /// 处理数据块
  static Future<File?> _handleChunk(FileChunk chunk) async {
    final transferIndex = _currentState.activeTransfers.indexWhere(
      (t) => t.transferId == chunk.transferId,
    );

    if (transferIndex == -1) {
      _updateState(_currentState.copyWith(
        status: TransferStatus.error,
        errorMessage: '未找到对应的传输: ${chunk.transferId}',
      ));
      return null;
    }

    final transfer = _currentState.activeTransfers[transferIndex];
    
    // 检查是否已接收过该数据块
    if (transfer.chunks.containsKey(chunk.chunkIndex)) {
      // 重复接收，不处理但不报错
      return null;
    }
    
    // 验证数据块的完整性
    try {
      final isValid = await FileService.validateChunk(chunk);
      if (!isValid) {
        _updateState(_currentState.copyWith(
          status: TransferStatus.error,
          errorMessage: '数据块 ${chunk.chunkIndex} 校验失败',
        ));
        return null;
      }
    } catch (e) {
      _updateState(_currentState.copyWith(
        status: TransferStatus.error,
        errorMessage: '数据块校验过程出错: $e',
      ));
      return null;
    }
    
    // 保存数据块到本地存储
    await FileService.saveChunk(chunk);
    
    // 更新进度
    final updatedChunks = Map<int, String>.from(transfer.chunks);
    updatedChunks[chunk.chunkIndex] = chunk.data;
    
    final updatedTransfer = transfer.copyWith(
      receivedChunks: updatedChunks.length,
      chunks: updatedChunks,
    );

    final updatedTransfers = List<TransferProgress>.from(_currentState.activeTransfers);
    updatedTransfers[transferIndex] = updatedTransfer;

    _updateState(_currentState.copyWith(activeTransfers: updatedTransfers));

    // 检查是否完成
    if (updatedTransfer.receivedChunks == updatedTransfer.totalChunks) {
      final file = await _completeTransfer(updatedTransfer);
      if (file != null) {
        return file;
      }
    }
    return null;
  }

  /// 完成传输
  static Future<File?> _completeTransfer(TransferProgress transfer) async {
    try {
      if (transfer.metadata == null) {
        throw Exception('缺少元数据');
      }

      final file = await FileService.assembleFile(
        transfer.metadata!,
        transfer.chunks,
      );

      // 清理临时文件
      await FileService.cleanupTransfer(transfer.transferId);

      _updateState(_currentState.copyWith(
        status: TransferStatus.completed,
        currentTransferId: null,
      ));

      // 移除已完成的传输
      final updatedTransfers = _currentState.activeTransfers
          .where((t) => t.transferId != transfer.transferId)
          .toList();
      
      _updateState(_currentState.copyWith(activeTransfers: updatedTransfers));
      return file;
    } catch (e) {
      _updateState(_currentState.copyWith(
        status: TransferStatus.error,
        errorMessage: '文件组装失败: $e',
      ));
      return null;
    }
  }

  /// 重置状态
  static void reset() {
    _updateState(const AppState());
  }

  /// 恢复未完成的传输
  static Future<void> recoverTransfers() async {
    try {
      final recoveredTransfers = await FileService.recoverIncompleteTransfers();
      if (recoveredTransfers.isNotEmpty) {
        _updateState(_currentState.copyWith(
          activeTransfers: [..._currentState.activeTransfers, ...recoveredTransfers],
          status: TransferStatus.receiving,
        ));
      }
    } catch (e) {
      _updateState(_currentState.copyWith(
        status: TransferStatus.error,
        errorMessage: '传输恢复失败: $e',
      ));
    }
  }

  /// 清除错误
  static void clearError() {
    _updateState(_currentState.copyWith(
      status: TransferStatus.idle,
      errorMessage: null,
    ));
  }

  /// 清理所有监听器（用于应用关闭时）
  static void dispose() {
    _listeners.clear();
  }
}
