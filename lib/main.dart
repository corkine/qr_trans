import 'package:flutter/material.dart';
import 'models/app_settings.dart';
import 'pages/home_page.dart';
import 'services/settings_service.dart';

void main() {
  runApp(const QrTransApp());
}

class QrTransApp extends StatefulWidget {
  const QrTransApp({Key? key}) : super(key: key);

  @override
  State<QrTransApp> createState() => _QrTransAppState();
}

class _QrTransAppState extends State<QrTransApp> {
  AppSettings? _settings;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });
      final settings = await SettingsService.loadSettings();
      if (mounted) {
        setState(() {
          _settings = settings;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return MaterialApp(
        title: 'QR传输',
        debugShowCheckedModeBanner: false,
        theme: _buildLightTheme(),
        home: const Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    if (_error != null) {
      return MaterialApp(
        title: 'QR传输',
        debugShowCheckedModeBanner: false,
        theme: _buildLightTheme(),
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text('应用启动失败', style: TextStyle(fontSize: 20)),
                const SizedBox(height: 8),
                Text('错误: $_error'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadSettings,
                  child: const Text('重试'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return MaterialApp(
      title: 'QR传输',
      debugShowCheckedModeBanner: false,
      theme: _buildLightTheme(),
      home: const HomePage(),
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
