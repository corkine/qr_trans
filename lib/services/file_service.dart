// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../models/transfer_metadata.dart';

class FileService {
  static const _uuid = Uuid();

  /// 选择文件并返回文件信息
  static Future<File?> pickFile() async {
    try {
      print('开始选择文件...');
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      print('文件选择结果: $result');

      if (result != null) {
        print('选择结果不为空，文件数量: ${result.files.length}');
        if (result.files.isNotEmpty && result.files.single.path != null) {
          final filePath = result.files.single.path!;
          print('选择的文件路径: $filePath');
          return File(filePath);
        } else {
          print('文件路径为空或没有选择文件');
        }
      } else {
        print('用户取消了文件选择');
      }
      return null;
    } catch (e, stackTrace) {
      print('文件选择过程中发生错误: $e');
      print('错误堆栈: $stackTrace');
      rethrow; // 重新抛出异常，让上层处理
    }
  }

  /// 将文件分割为多个数据块
  static Future<List<FileChunk>> splitFileIntoChunks(
    File file,
    int chunkSize,
  ) async {
    final bytes = await file.readAsBytes();
    final transferId = _uuid.v4();
    final chunks = <FileChunk>[];

    for (int i = 0; i < bytes.length; i += chunkSize) {
      final end = (i + chunkSize < bytes.length) ? i + chunkSize : bytes.length;
      final chunkData = bytes.sublist(i, end);
      final chunkIndex = i ~/ chunkSize;

      final chunk = FileChunk(
        transferId: transferId,
        chunkIndex: chunkIndex,
        data: base64Encode(chunkData),
        checksum: _calculateChecksum(chunkData),
      );

      chunks.add(chunk);
    }

    return chunks;
  }

  /// Web平台专用：将字节数组分割为多个数据块
  static Future<List<FileChunk>> splitBytesIntoChunks(
    Uint8List bytes,
    int chunkSize,
    String fileName,
  ) async {
    if (!kIsWeb) {
      throw UnsupportedError('此方法仅在Web平台可用');
    }

    final transferId = _uuid.v4();
    final chunks = <FileChunk>[];

    for (int i = 0; i < bytes.length; i += chunkSize) {
      final end = (i + chunkSize < bytes.length) ? i + chunkSize : bytes.length;
      final chunkData = bytes.sublist(i, end);
      final chunkIndex = i ~/ chunkSize;

      final chunk = FileChunk(
        transferId: transferId,
        chunkIndex: chunkIndex,
        data: base64Encode(chunkData),
        checksum: _calculateChecksum(chunkData),
      );

      chunks.add(chunk);
    }

    return chunks;
  }

  /// 创建传输元数据
  static Future<TransferMetadata> createTransferMetadata(
    File file,
    int totalChunks, {
    String? transferId,
  }) async {
    final bytes = await file.readAsBytes();
    final fileName = file.path.split('/').last;

    return TransferMetadata(
      transferId: transferId ?? _uuid.v4(),
      fileName: fileName,
      totalChunks: totalChunks,
      fileSize: bytes.length,
      checksum: _calculateChecksum(bytes),
    );
  }

  /// Web平台专用：从字节数组创建传输元数据
  static TransferMetadata createTransferMetadataFromBytes(
    Uint8List bytes,
    String fileName,
    int totalChunks, {
    String? transferId,
  }) {
    if (!kIsWeb) {
      throw UnsupportedError('此方法仅在Web平台可用');
    }

    return TransferMetadata(
      transferId: transferId ?? _uuid.v4(),
      fileName: fileName,
      totalChunks: totalChunks,
      fileSize: bytes.length,
      checksum: _calculateChecksum(bytes),
    );
  }

  // 已移除保存数据块功能

  /// 组装文件块并保存完整文件
  static Future<File> assembleFile(
    TransferMetadata metadata,
    Map<int, String> chunks,
  ) async {
    final directory = await getApplicationDocumentsDirectory();
    final outputFile = await _getUniqueFileName(directory, metadata.fileName);

    // 确保输出目录存在
    if (!outputFile.parent.existsSync()) {
      outputFile.parent.createSync(recursive: true);
    }

    final assembledBytes = <int>[];

    // 按顺序组装数据块
    for (int i = 0; i < metadata.totalChunks; i++) {
      if (!chunks.containsKey(i)) {
        throw Exception('缺少数据块 $i');
      }

      final chunkData = base64Decode(chunks[i]!);
      assembledBytes.addAll(chunkData);
    }

    // 验证文件完整性
    final assembledChecksum = _calculateChecksum(
      Uint8List.fromList(assembledBytes),
    );
    if (assembledChecksum != metadata.checksum) {
      throw Exception('文件校验失败');
    }

    // 验证文件大小
    if (assembledBytes.length != metadata.fileSize) {
      throw Exception(
        '文件大小不匹配: 期望 ${metadata.fileSize}, 实际 ${assembledBytes.length}',
      );
    }

    await outputFile.writeAsBytes(assembledBytes);
    return outputFile;
  }

  /// 获取唯一文件名，避免重名覆盖
  static Future<File> _getUniqueFileName(
    Directory directory,
    String fileName,
  ) async {
    final receivedDir = Directory('${directory.path}/received');
    if (!receivedDir.existsSync()) {
      receivedDir.createSync(recursive: true);
    }

    // 分离文件名和扩展名
    final lastDotIndex = fileName.lastIndexOf('.');
    final baseName = lastDotIndex > 0
        ? fileName.substring(0, lastDotIndex)
        : fileName;
    final extension = lastDotIndex > 0 ? fileName.substring(lastDotIndex) : '';

    File candidateFile = File('${receivedDir.path}/$fileName');
    int counter = 1;

    // 如果文件已存在，添加计数后缀
    while (candidateFile.existsSync()) {
      final newFileName = '${baseName}_$counter$extension';
      candidateFile = File('${receivedDir.path}/$newFileName');
      counter++;
    }

    return candidateFile;
  }

  /// 清理临时文件
  static Future<void> cleanupTransfer(String transferId) async {
    final directory = await getApplicationDocumentsDirectory();
    final transferDir = Directory('${directory.path}/transfers/$transferId');

    if (transferDir.existsSync()) {
      transferDir.deleteSync(recursive: true);
    }
  }

  /// 清理所有传输临时文件
  static Future<void> cleanupAllTransfers() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final transfersDir = Directory('${directory.path}/transfers');

      if (transfersDir.existsSync()) {
        // 删除整个 transfers 目录及其所有内容
        transfersDir.deleteSync(recursive: true);
      }
    } catch (e) {
      // 清理失败不应该影响主要功能，记录即可
      print('清理传输临时文件失败: $e');
    }
  }

  /// 验证数据块的完整性
  static Future<bool> validateChunk(FileChunk chunk) async {
    try {
      final chunkData = base64Decode(chunk.data);
      final calculatedChecksum = _calculateChecksum(chunkData);
      return calculatedChecksum == chunk.checksum;
    } catch (e) {
      // base64解码失败或其他错误
      return false;
    }
  }

  /// 计算数据校验和
  static String _calculateChecksum(Uint8List data) {
    final digest = sha256.convert(data);
    return digest.toString();
  }

  // 已移除恢复功能

  // 已移除保存元数据功能

  /// 获取接收到的文件列表
  static Future<List<File>> getReceivedFiles() async {
    final directory = await getApplicationDocumentsDirectory();
    final receivedDir = Directory('${directory.path}/received');

    if (!receivedDir.existsSync()) {
      return [];
    }

    return receivedDir.listSync().whereType<File>().toList();
  }
}
