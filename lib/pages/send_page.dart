import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/app_settings.dart';
import '../services/file_service.dart';
import '../services/settings_service.dart';
import '../services/qr_service.dart';
import '../services/transfer_service.dart';

class SendPage extends StatefulWidget {
  const SendPage({super.key});

  @override
  State<SendPage> createState() => _SendPageState();
}

class _SendPageState extends State<SendPage> {
  File? _selectedFile;
  bool _isPlaying = false;
  AppSettings? _settings;
  AppState? _transferState;
  String? _qrData;
  Map<String, int>? _playbackProgress;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      QrService.resetGenerator();
      TransferService.clearError();
    });

    TransferService.addListener(_onTransferStateChanged);
    QrService.addQrListener(_onQrDataChanged);

    _loadSettings();

    _transferState = TransferService.currentState;
    _qrData = QrService.currentQrData;
    _playbackProgress = QrService.playbackProgress;
  }

  void _onTransferStateChanged(AppState state) {
    if (!mounted) return;
    setState(() {
      _transferState = state;
    });
  }

  void _onQrDataChanged(String? qrData) {
    if (!mounted) return;
    setState(() {
      _qrData = qrData;
      _playbackProgress = QrService.playbackProgress;
    });
  }

  Future<void> _loadSettings() async {
    try {
      final settings = await SettingsService.loadSettings();
      if (mounted) {
        setState(() {
          _settings = settings;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('加载设置失败: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_settings == null) {
      return Scaffold(body: const Center(child: CircularProgressIndicator()));
    }

    final transferState = _transferState ?? const AppState();

    return Scaffold(
      appBar: AppBar(
        title: const Text('发送文件'),
        centerTitle: false,
        actions: [
          if (_selectedFile != null)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _resetSending,
                tooltip: '重新选择文件',
              ),
            ),
        ],
      ),
      body: SafeArea(child: _buildLayout(context, transferState)),
    );
  }

  Widget _buildLayout(BuildContext context, AppState transferState) {
    if (_selectedFile == null) {
      return _buildFileUploadCard();
    }
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 32, left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildFileInfoCard(),
            _buildQrDisplayCard(
              _qrData,
              _settings!,
              _playbackProgress,
              transferState,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileUploadCard() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Center(
        child: Card(
          elevation: 0,
          child: InkWell(
            hoverColor: Colors.transparent,
            onTap: _pickFile,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 300,
              padding: const EdgeInsets.only(
                left: 64,
                right: 64,
                top: 16,
                bottom: 16,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cloud_upload_outlined,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '选择要发送的文件',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '点击选择文件或拖拽文件到此处',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: _pickFile,
                    icon: const Icon(Icons.folder_open),
                    label: const Text('选择文件'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFileInfoCard() {
    if (_selectedFile == null) return const SizedBox.shrink();

    final fileName = _selectedFile!.path.split('/').last;
    final fileSize = _selectedFile!.lengthSync();

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.insert_drive_file,
              size: 32,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fileName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatFileSize(fileSize),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: _resetSending,
              icon: const Icon(Icons.close),
              tooltip: '移除文件',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQrDisplayCard(
    String? qrData,
    AppSettings settings,
    Map<String, int>? playbackProgress,
    AppState transferState,
  ) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            qrData != null
                ? _safeQrWidget(qrData, settings)
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.qr_code_2, size: 48, color: Colors.grey),
                        const SizedBox(height: 8),
                        Text('准备中...', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 12,
              children: [
                FilledButton.icon(
                  onPressed: _selectedFile != null && !_isPlaying
                      ? _startPlayback
                      : null,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('开始'),
                ),
                OutlinedButton.icon(
                  onPressed: _isPlaying ? _stopPlayback : null,
                  icon: const Icon(Icons.stop),
                  label: const Text('停止'),
                ),
                OutlinedButton.icon(
                  onPressed: _selectedFile != null ? _previousQr : null,
                  icon: const Icon(Icons.skip_previous),
                  label: const Text('上一个'),
                ),
                OutlinedButton.icon(
                  onPressed: _selectedFile != null ? _nextQr : null,
                  icon: const Icon(Icons.skip_next),
                  label: const Text('下一个'),
                ),
              ],
            ),
            if (transferState.status == TransferStatus.error) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        transferState.errorMessage ?? '未知错误',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            if (playbackProgress != null) ...[
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value:
                    playbackProgress['current']! / playbackProgress['total']!,
              ),
              const SizedBox(height: 4),
              Text(
                '${playbackProgress['current']} / ${playbackProgress['total']}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _safeQrWidget(String qrData, AppSettings settings) {
    const int maxBytesPerFrame = 10000; // 低于库限制 10208，留余量
    final int dataLen = utf8.encode(qrData).length;
    if (dataLen > maxBytesPerFrame) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Colors.orange,
                size: 40,
              ),
              const SizedBox(height: 8),
              Text(
                '二维码数据过长（${dataLen}B）\n请重新选择文件或降低分片大小',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      );
    }

    final size = MediaQuery.sizeOf(context);

    return QrImageView(
      data: qrData,
      version: QrVersions.auto,
      size: max(min(size.width, size.height) * 0.7, settings.qrSize),
      backgroundColor: Colors.white,
      errorCorrectionLevel: settings.errorCorrectionLevel,
    );
  }

  Future<void> _pickFile() async {
    try {
      final file = await FileService.pickFile();
      if (file != null && mounted) {
        setState(() {
          _selectedFile = file;
        });
        await _prepareQrData(file);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('文件选择失败: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _prepareQrData(File file) async {
    try {
      await QrService.prepareQrData(file, _settings!);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('文件准备失败: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _startPlayback() async {
    // 在开始播放前，重新准备分片，确保使用最新的自适应分片逻辑
    if (_selectedFile != null) {
      await _prepareQrData(_selectedFile!);
    }
    if (!mounted) return;
    await QrService.startAutoPlay(_settings!);
    if (mounted) {
      setState(() {
        _isPlaying = true;
      });
    }
  }

  void _stopPlayback() {
    QrService.stopPlayback();
    if (mounted) {
      setState(() {
        _isPlaying = false;
      });
    }
  }

  void _nextQr() {
    QrService.nextQr();
  }

  void _previousQr() {
    QrService.previousQr();
  }

  void _resetSending() {
    _stopPlayback();
    QrService.resetGenerator();
    TransferService.reset();
    if (mounted) {
      setState(() {
        _selectedFile = null;
      });
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  @override
  void dispose() {
    QrService.stopPlayback();
    TransferService.removeListener(_onTransferStateChanged);
    QrService.removeQrListener(_onQrDataChanged);
    super.dispose();
  }
}
