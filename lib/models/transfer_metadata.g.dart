// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_metadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransferMetadata _$TransferMetadataFromJson(Map<String, dynamic> json) =>
    _TransferMetadata(
      transferId: json['transferId'] as String,
      fileName: json['fileName'] as String,
      totalChunks: (json['totalChunks'] as num).toInt(),
      fileSize: (json['fileSize'] as num).toInt(),
      checksum: json['checksum'] as String,
      currentChunk: (json['currentChunk'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$TransferMetadataToJson(_TransferMetadata instance) =>
    <String, dynamic>{
      'transferId': instance.transferId,
      'fileName': instance.fileName,
      'totalChunks': instance.totalChunks,
      'fileSize': instance.fileSize,
      'checksum': instance.checksum,
      'currentChunk': instance.currentChunk,
    };

_FileChunk _$FileChunkFromJson(Map<String, dynamic> json) => _FileChunk(
  transferId: json['transferId'] as String,
  chunkIndex: (json['chunkIndex'] as num).toInt(),
  data: json['data'] as String,
  checksum: json['checksum'] as String,
);

Map<String, dynamic> _$FileChunkToJson(_FileChunk instance) =>
    <String, dynamic>{
      'transferId': instance.transferId,
      'chunkIndex': instance.chunkIndex,
      'data': instance.data,
      'checksum': instance.checksum,
    };

_TransferProgress _$TransferProgressFromJson(Map<String, dynamic> json) =>
    _TransferProgress(
      transferId: json['transferId'] as String,
      receivedChunks: (json['receivedChunks'] as num).toInt(),
      totalChunks: (json['totalChunks'] as num).toInt(),
      chunks: (json['chunks'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(int.parse(k), e as String),
      ),
      metadata: json['metadata'] == null
          ? null
          : TransferMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TransferProgressToJson(_TransferProgress instance) =>
    <String, dynamic>{
      'transferId': instance.transferId,
      'receivedChunks': instance.receivedChunks,
      'totalChunks': instance.totalChunks,
      'chunks': instance.chunks.map((k, e) => MapEntry(k.toString(), e)),
      'metadata': instance.metadata,
    };
