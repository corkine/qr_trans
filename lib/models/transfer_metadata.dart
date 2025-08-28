import 'package:freezed_annotation/freezed_annotation.dart';

part 'transfer_metadata.freezed.dart';
part 'transfer_metadata.g.dart';

@freezed
abstract class TransferMetadata with _$TransferMetadata {
  const factory TransferMetadata({
    required String transferId,
    required String fileName,
    required int totalChunks,
    required int fileSize,
    required String checksum,
    @Default(0) int currentChunk,
  }) = _TransferMetadata;

  factory TransferMetadata.fromJson(Map<String, dynamic> json) =>
      _$TransferMetadataFromJson(json);
}

@freezed
abstract class FileChunk with _$FileChunk {
  const factory FileChunk({
    required String transferId,
    required int chunkIndex,
    required String data,
    required String checksum,
  }) = _FileChunk;

  factory FileChunk.fromJson(Map<String, dynamic> json) =>
      _$FileChunkFromJson(json);
}

@freezed
abstract class TransferProgress with _$TransferProgress {
  const factory TransferProgress({
    required String transferId,
    required int receivedChunks,
    required int totalChunks,
    required Map<int, String> chunks,
    TransferMetadata? metadata,
  }) = _TransferProgress;

  factory TransferProgress.fromJson(Map<String, dynamic> json) =>
      _$TransferProgressFromJson(json);
}
