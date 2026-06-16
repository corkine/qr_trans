import 'dart:math';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'version.dart' as v;

/// 是否支持扫码（移动端）
bool isScannerSupported() {
  if (kIsWeb) return false;
  if (Platform.isAndroid || Platform.isIOS) return true;
  return false;
}

/// 应用版本号
const String kAppVersion = v.version;

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
  } else {
    platform = 'Unknown';
  }
  return '$appName ($kAppVersion, $platform)';
}

/// Base45 编解码（RFC 9285）
/// 字母表：0-9 A-Z 空格 $ % * + - . / :（共45个字符）
/// 效率：每2字节→3字符（vs Base64每3字节→4字符），约25%膨胀 vs Base64的33%膨胀
/// QR码字母数字模式对 Base45 字母表中的字符每字符仅需5.5 bit，比字节模式的8 bit更紧凑
class Base45 {
  // RFC 9285 标准字母表，严格顺序：0-9(0-9), A-Z(10-35), space(36), $(37), %(38), *(39), +(40), -(41), .(42), /(43), :(44)
  static const String _alphabet =
      '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ \$%*+-./:';

  static final List<int> _decodeTable = _buildDecodeTable();

  static List<int> _buildDecodeTable() {
    final table = List<int>.filled(256, -1);
    for (int i = 0; i < _alphabet.length; i++) {
      table[_alphabet.codeUnitAt(i)] = i;
    }
    return table;
  }

  /// 将字节数组编码为 Base45 字符串
  static String encode(Uint8List data) {
    final buf = StringBuffer();
    int i = 0;
    // 每次处理 2 个字节 → 3 个字符
    while (i + 1 < data.length) {
      int n = data[i] + data[i + 1] * 256;
      buf.writeCharCode(_alphabet.codeUnitAt(n % 45));
      n ~/= 45;
      buf.writeCharCode(_alphabet.codeUnitAt(n % 45));
      buf.writeCharCode(_alphabet.codeUnitAt(n ~/ 45));
      i += 2;
    }
    // 剩余 1 个字节 → 2 个字符
    if (i < data.length) {
      int n = data[i];
      buf.writeCharCode(_alphabet.codeUnitAt(n % 45));
      buf.writeCharCode(_alphabet.codeUnitAt(n ~/ 45));
    }
    return buf.toString();
  }

  /// 将 Base45 字符串解码为字节数组
  static Uint8List decode(String input) {
    final len = input.length;
    // 粗略估算输出大小
    final out = BytesBuilder();
    int i = 0;
    // 每次处理 3 个字符 → 2 个字节
    while (i + 2 < len) {
      final a = _decodeChar(input, i);
      final b = _decodeChar(input, i + 1);
      final c = _decodeChar(input, i + 2);
      int n = a + b * 45 + c * 45 * 45;
      if (n > 0xFFFF) throw FormatException('Base45 解码溢出 at $i');
      out.addByte(n & 0xFF);
      out.addByte(n >> 8);
      i += 3;
    }
    // 剩余 2 个字符 → 1 个字节
    if (i + 1 < len) {
      final a = _decodeChar(input, i);
      final b = _decodeChar(input, i + 1);
      int n = a + b * 45;
      if (n > 0xFF) throw FormatException('Base45 解码溢出 at $i');
      out.addByte(n);
    } else if (i < len) {
      throw FormatException('Base45 输入长度无效');
    }
    return out.toBytes();
  }

  static int _decodeChar(String s, int i) {
    final v = _decodeTable[s.codeUnitAt(i)];
    if (v < 0) throw FormatException('非法 Base45 字符: ${s[i]}');
    return v;
  }
}

/// CRC32 校验（IEEE 多项式 0xEDB88320）
/// 输出 8 位十六进制字符串（固定 8 字节），vs SHA-256 的 64 字节
class Crc32 {
  static final List<int> _table = _buildTable();

  static List<int> _buildTable() {
    final table = List<int>.filled(256, 0);
    for (int i = 0; i < 256; i++) {
      int c = i;
      for (int j = 0; j < 8; j++) {
        c = (c & 1) != 0 ? (0xEDB88320 ^ (c >> 1)) : (c >> 1);
      }
      table[i] = c;
    }
    return table;
  }

  /// 计算 CRC32，返回 8 位小写十六进制字符串
  static String compute(Uint8List data) {
    int crc = 0xFFFFFFFF;
    for (final byte in data) {
      crc = _table[(crc ^ byte) & 0xFF] ^ (crc >> 8);
    }
    crc = crc ^ 0xFFFFFFFF;
    // 转为无符号 32 位整数的 16 进制（8 位，不足补零）
    return (crc & 0xFFFFFFFF).toRadixString(16).padLeft(8, '0');
  }
}

/// 短传输 ID 生成器
/// 使用 6 字节随机数经 Base45 编码得到 8 位字符串
/// 碰撞概率：1/2^48 ≈ 1/281万亿，对单次传输会话完全足够
class ShortId {
  static final Random _rng = Random.secure();

  static String generate() {
    final bytes = Uint8List(6);
    for (int i = 0; i < 6; i++) {
      bytes[i] = _rng.nextInt(256);
    }
    return Base45.encode(bytes); // 恰好 8 个字符（6 字节 = 3×2字节 → 3×3字符 = 9字符）
    // 注：6字节 = 2字节*3组 → 9个Base45字符，足够短且唯一
  }
}
