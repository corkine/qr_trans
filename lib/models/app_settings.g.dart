// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) => _AppSettings(
  qrSize: (json['qrSize'] as num?)?.toDouble() ?? 200.0,
  playbackSpeed: (json['playbackSpeed'] as num?)?.toInt() ?? 1000,
  errorCorrectionLevel: (json['errorCorrectionLevel'] as num?)?.toInt() ?? 1,
  chunkSize: (json['chunkSize'] as num?)?.toInt() ?? 1024,
  autoPlay: json['autoPlay'] as bool? ?? true,
  darkMode: json['darkMode'] as bool? ?? false,
);

Map<String, dynamic> _$AppSettingsToJson(_AppSettings instance) =>
    <String, dynamic>{
      'qrSize': instance.qrSize,
      'playbackSpeed': instance.playbackSpeed,
      'errorCorrectionLevel': instance.errorCorrectionLevel,
      'chunkSize': instance.chunkSize,
      'autoPlay': instance.autoPlay,
      'darkMode': instance.darkMode,
    };

_AppState _$AppStateFromJson(Map<String, dynamic> json) => _AppState(
  settings: json['settings'] == null
      ? const AppSettings()
      : AppSettings.fromJson(json['settings'] as Map<String, dynamic>),
  status:
      $enumDecodeNullable(_$TransferStatusEnumMap, json['status']) ??
      TransferStatus.idle,
  activeTransfers:
      (json['activeTransfers'] as List<dynamic>?)
          ?.map((e) => TransferProgress.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  currentTransferId: json['currentTransferId'] as String?,
  errorMessage: json['errorMessage'] as String?,
);

Map<String, dynamic> _$AppStateToJson(_AppState instance) => <String, dynamic>{
  'settings': instance.settings,
  'status': _$TransferStatusEnumMap[instance.status]!,
  'activeTransfers': instance.activeTransfers,
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
