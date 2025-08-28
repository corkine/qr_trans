import 'package:flutter/material.dart';
import '../models/app_settings.dart';
import '../services/settings_service.dart';
import '../utils/responsive.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.restore),
            onPressed: () => _showResetDialog(context),
            tooltip: '重置设置',
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
            ? _buildErrorView(context, _error!)
            : Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Column(
                      spacing: 16,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildDisplaySection(context, _settings!),
                        _buildTransferSection(context, _settings!),
                        _buildAdvancedSection(context, _settings!),
                        _buildAppSection(context, _settings!),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildDisplaySection(BuildContext context, AppSettings settings) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '显示设置',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // QR码大小设置
            _buildSliderSetting(
              context: context,
              title: 'QR码大小',
              subtitle: '调整生成的二维码尺寸',
              value: settings.qrSize,
              min: 100.0,
              max: 400.0,
              divisions: 30,
              format: (value) => '${value.round()} px',
              onChanged: (value) async {
                await SettingsService.updateQrSize(value);
                await _loadSettings();
              },
            ),

            const Divider(),

            // 暗色模式
            _buildSwitchSetting(
              context: context,
              title: '暗色模式',
              subtitle: '使用深色主题',
              value: settings.darkMode,
              onChanged: (value) async {
                await SettingsService.updateDarkMode(value);
                await _loadSettings();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransferSection(BuildContext context, AppSettings settings) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '传输设置',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // 播放速度
            _buildSliderSetting(
              context: context,
              title: '播放速度',
              subtitle: '二维码切换间隔时间',
              value: settings.playbackSpeed.toDouble(),
              min: 500.0,
              max: 3000.0,
              divisions: 25,
              format: (value) => '${(value / 1000).toStringAsFixed(1)} 秒',
              onChanged: (value) async {
                await SettingsService.updatePlaybackSpeed(value.round());
                await _loadSettings();
              },
            ),

            const Divider(),

            // 数据块大小
            _buildSliderSetting(
              context: context,
              title: '数据块大小',
              subtitle: '二维码数据量比例（系统自动计算实际字节数）',
              value: settings.chunkSizeRatio,
              min: 10.0,
              max: 100.0,
              divisions: 18,
              format: (value) => '${value.toInt()}%',
              onChanged: (value) async {
                await SettingsService.updateChunkSizeRatio(value);
                await _loadSettings();
              },
            ),

            const Divider(),

            // 自动播放
            _buildSwitchSetting(
              context: context,
              title: '自动播放',
              subtitle: '文件准备完成后自动开始播放',
              value: settings.autoPlay,
              onChanged: (value) async {
                await SettingsService.updateAutoPlay(value);
                await _loadSettings();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedSection(BuildContext context, AppSettings settings) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '高级设置',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // 纠错等级
            _buildDropdownSetting<int>(
              context: context,
              title: '纠错等级',
              subtitle: '二维码的容错能力',
              value: settings.errorCorrectionLevel,
              items: const [
                DropdownMenuItem(value: 0, child: Text('低 (L) - 约7%')),
                DropdownMenuItem(value: 1, child: Text('中 (M) - 约15%')),
                DropdownMenuItem(value: 2, child: Text('高 (Q) - 约25%')),
                DropdownMenuItem(value: 3, child: Text('最高 (H) - 约30%')),
              ],
              onChanged: (value) async {
                if (value != null) {
                  await SettingsService.updateErrorCorrectionLevel(value);
                  await _loadSettings();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppSection(BuildContext context, AppSettings settings) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '应用信息',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('关于应用'),
              subtitle: const Text('查看应用信息和版本'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showAboutDialog(context),
            ),

            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text('使用帮助'),
              subtitle: const Text('了解如何使用应用'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showHelpDialog(context),
            ),

            ListTile(
              leading: Icon(
                Icons.restore,
                color: Theme.of(context).colorScheme.error,
              ),
              title: Text(
                '重置设置',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              subtitle: const Text('恢复所有设置为默认值'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showResetDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliderSetting({
    required BuildContext context,
    required String title,
    required String subtitle,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required String Function(double) format,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            Text(
              format(value),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildSwitchSetting({
    required BuildContext context,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
      contentPadding: EdgeInsets.zero,
      dense: true,
      hoverColor: Colors.transparent,
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _buildDropdownSetting<T>({
    required BuildContext context,
    required String title,
    required String subtitle,
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorView(BuildContext context, String error) {
    return Center(
      child: Padding(
        padding: ResponsiveUtils.getPadding(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text('设置加载失败', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              error,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton(onPressed: _loadSettings, child: const Text('重试')),
          ],
        ),
      ),
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('重置设置'),
        content: const Text('确定要重置所有设置为默认值吗？此操作不可撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () async {
              await SettingsService.resetSettings();
              await _loadSettings();
              if (mounted) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('设置已重置')));
              }
            },
            child: const Text('重置'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'QR传输',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.qr_code_2, size: 48),
      children: [
        const Text('通过二维码在设备间安全传输文件的跨平台应用。'),
        const SizedBox(height: 16),
        const Text('开发者信息：'),
        const Text('• 使用 Flutter 开发'),
        const Text('• 支持 Android、iOS、Windows、macOS、Linux'),
        const Text('• 开源项目'),
      ],
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('使用帮助'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('发送文件：', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('1. 点击"发送文件"按钮'),
              Text('2. 选择要发送的文件'),
              Text('3. 点击"开始播放"自动播放二维码'),
              Text('4. 在接收设备上扫描二维码'),
              SizedBox(height: 16),
              Text('接收文件：', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('1. 点击"接收文件"按钮'),
              Text('2. 点击"开始扫描"启动相机'),
              Text('3. 扫描发送设备上的二维码'),
              Text('4. 等待文件传输完成'),
              SizedBox(height: 16),
              Text('设置：', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('• QR码大小：调整二维码显示尺寸'),
              Text('• 播放速度：调整二维码切换间隔'),
              Text('• 纠错等级：提高二维码识别成功率'),
              Text('• 数据块大小：平衡传输速度和稳定性'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }
}
