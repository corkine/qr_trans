import 'package:flutter/foundation.dart';
import 'dart:io';

bool isScannerSupported() {
  if (kIsWeb) {
    // Web平台支持，但需要HTTPS
    return false;
  }

  // 移动端支持
  if (Platform.isAndroid || Platform.isIOS) {
    return true;
  }

  // 桌面端通常不支持或支持有限
  return false;
}

/// 应用版本号 - 从构建时的 dart define 获取
const String kAppVersion = String.fromEnvironment('APP_VERSION', defaultValue: '1.0.0');

/// 获取应用版本号
String getAppVersion() {
  return kAppVersion;
}

String appName = 'QR Trans';

/// 获取完整的版本信息（包含平台信息）
String getFullVersionInfo() {
  String platform;
  if (kIsWeb) {
    platform = 'Web';
  } else if (Platform.isAndroid) {
    platform = 'Android';
  } else if (Platform.isIOS) {
    platform = 'iOS';
  } else if (Platform.isWindows) {
    platform = 'Windows';
  } else if (Platform.isMacOS) {
    platform = 'macOS';
  } else if (Platform.isLinux) {
    platform = 'Linux';
  } else {
    platform = 'Unknown';
  }
  
  return '$appName ($kAppVersion, $platform)';
}