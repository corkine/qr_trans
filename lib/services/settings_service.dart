import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_settings.dart';

class SettingsService {
  static const String _settingsKey = 'app_settings';

  /// 加载应用设置
  static Future<AppSettings> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final settingsJson = prefs.getString(_settingsKey);

    if (settingsJson != null) {
      try {
        final Map<String, dynamic> json = jsonDecode(settingsJson);
        return AppSettings.fromJson(json);
      } catch (e) {
        // 如果解析失败，返回默认设置
        return const AppSettings();
      }
    }

    return const AppSettings();
  }

  /// 保存应用设置
  static Future<void> saveSettings(AppSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    final settingsJson = jsonEncode(settings.toJson());
    await prefs.setString(_settingsKey, settingsJson);
  }

  /// 重置为默认设置
  static Future<void> resetSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_settingsKey);
  }

  /// 更新特定设置项
  static Future<void> updateQrSize(double size) async {
    final settings = await loadSettings();
    final updatedSettings = settings.copyWith(qrSize: size);
    await saveSettings(updatedSettings);
  }

  static Future<void> updatePlaybackSpeed(int speed) async {
    final settings = await loadSettings();
    final updatedSettings = settings.copyWith(playbackSpeed: speed);
    await saveSettings(updatedSettings);
  }

  static Future<void> updateErrorCorrectionLevel(int level) async {
    final settings = await loadSettings();
    final updatedSettings = settings.copyWith(errorCorrectionLevel: level);
    await saveSettings(updatedSettings);
  }

  static Future<void> updateChunkSizeRatio(double ratio) async {
    final settings = await loadSettings();
    final updatedSettings = settings.copyWith(chunkSizeRatio: ratio);
    await saveSettings(updatedSettings);
  }

  static Future<void> updateAutoPlay(bool autoPlay) async {
    final settings = await loadSettings();
    final updatedSettings = settings.copyWith(autoPlay: autoPlay);
    await saveSettings(updatedSettings);
  }

  static Future<void> updateDarkMode(bool darkMode) async {
    final settings = await loadSettings();
    final updatedSettings = settings.copyWith(darkMode: darkMode);
    await saveSettings(updatedSettings);
  }
}
