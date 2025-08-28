// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) => _AppSettings(
  qrSize: (json['qrSize'] as num?)?.toDouble() ?? 360.0,
  playbackSpeed: (json['playbackSpeed'] as num?)?.toInt() ?? 1000,
  errorCorrectionLevel: (json['errorCorrectionLevel'] as num?)?.toInt() ?? 1,
  chunkSizeRatio: (json['chunkSizeRatio'] as num?)?.toDouble() ?? 80.0,
  autoPlay: json['autoPlay'] as bool? ?? true,
);

Map<String, dynamic> _$AppSettingsToJson(_AppSettings instance) =>
    <String, dynamic>{
      'qrSize': instance.qrSize,
      'playbackSpeed': instance.playbackSpeed,
      'errorCorrectionLevel': instance.errorCorrectionLevel,
      'chunkSizeRatio': instance.chunkSizeRatio,
      'autoPlay': instance.autoPlay,
    };

_AppState _$AppStateFromJson(Map<String, dynamic> json) => _AppState(
  settings: json['settings'] == null
      ? const AppSettings()
      : AppSettings.fromJson(json['settings'] as Map<String, dynamic>),
  status:
      $enumDecodeNullable(_$TransferStatusEnumMap, json['status']) ??
      TransferStatus.idle,
  activeTransfer: json['activeTransfer'] == null
      ? null
      : TransferProgress.fromJson(
          json['activeTransfer'] as Map<String, dynamic>,
        ),
  currentTransferId: json['currentTransferId'] as String?,
  errorMessage: json['errorMessage'] as String?,
);

Map<String, dynamic> _$AppStateToJson(_AppState instance) => <String, dynamic>{
  'settings': instance.settings,
  'status': _$TransferStatusEnumMap[instance.status]!,
  'activeTransfer': instance.activeTransfer,
  'currentTransferId': instance.currentTransferId,
  'errorMessage': instance.errorMessage,
};

const _$TransferStatusEnumMap = {
  TransferStatus.idle: 'idle',
  TransferStatus.preparing: 'preparing',
  TransferStatus.ready: 'ready',
  TransferStatus.sending: 'sending',
  TransferStatus.receiving: 'receiving',
  TransferStatus.completed: 'completed',
  TransferStatus.error: 'error',
};
