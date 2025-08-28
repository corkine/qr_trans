import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:qr_trans/models/transfer_metadata.dart';

part 'app_settings.freezed.dart';
part 'app_settings.g.dart';

@freezed
abstract class AppSettings with _$AppSettings {
  const factory AppSettings({
    @Default(200.0) double qrSize,
    @Default(1000) int playbackSpeed, // milliseconds between frames
    @Default(1) int errorCorrectionLevel,
    @Default(1024) int chunkSize, // bytes per chunk
    @Default(true) bool autoPlay,
    @Default(false) bool darkMode,
  }) = _AppSettings;

  factory AppSettings.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsFromJson(json);
}

enum TransferStatus {
  idle,
  preparing,
  ready,
  sending,
  receiving,
  completed,
  error,
}

@freezed
abstract class AppState with _$AppState {
  const factory AppState({
    @Default(AppSettings()) AppSettings settings,
    @Default(TransferStatus.idle) TransferStatus status,
    @Default([]) List<TransferProgress> activeTransfers,
    String? currentTransferId,
    String? errorMessage,
  }) = _AppState;

  factory AppState.fromJson(Map<String, dynamic> json) =>
      _$AppStateFromJson(json);
}
