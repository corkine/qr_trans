// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path_provider/path_provider.dart';
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
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      QrService.resetGenerator();
      // 清除接收页面可能留下的传输状态
      TransferService.reset();
      // 请求焦点以启用键盘控制
      _focusNode.requestFocus();
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

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    // 只处理按键按下事件，避免重复触发
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    // 只有在选择了文件时才响应键盘事件
    if (_selectedFile == null) return KeyEventResult.ignored;

    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowLeft:
        _previousQr();
        return KeyEventResult.handled;
      case LogicalKeyboardKey.arrowRight:
        _nextQr();
        return KeyEventResult.handled;
      case LogicalKeyboardKey.space:
        if (_isPlaying) {
          _pausePlayback();
        } else {
          _startPlayback();
        }
        return KeyEventResult.handled;
      case LogicalKeyboardKey.escape:
        _stopAndReset();
        return KeyEventResult.handled;
      default:
        return KeyEventResult.ignored;
    }
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
      body: Focus(
        focusNode: _focusNode,
        onKeyEvent: _handleKeyEvent,
        autofocus: true,
        child: SafeArea(child: _buildLayout(context, transferState)),
      ),
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
      padding: const EdgeInsets.only(bottom: 52),
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
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FilledButton.icon(
                        onPressed: _pickFile,
                        icon: const Icon(Icons.folder_open),
                        label: const Text('选择文件'),
                      ),
                      const SizedBox(width: 12),
                      FilledButton.icon(
                        onPressed: _createFileFromClipboard,
                        icon: const Icon(Icons.content_paste),
                        label: const Text('文本拷贝'),
                        style: FilledButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHighest,
                          foregroundColor: Theme.of(
                            context,
                          ).colorScheme.onSurface,
                        ),
                      ),
                    ],
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
        padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
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
                  Row(
                    children: [
                      Text(
                        _formatFileSize(fileSize),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 5),
                      if (_playbackProgress != null) ...[
                        Text(
                          '• ${_playbackProgress!['total']} 个二维码 • ${_settings!.chunkSizeRatio.toInt()}% 数据密度',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ],
                    ],
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
            const SizedBox(height: 30),
            Row(
              spacing: 12,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _selectedFile != null
                      ? (_isPlaying ? _pausePlayback : _startPlayback)
                      : null,
                  icon: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    size: 32,
                  ),
                  tooltip: _isPlaying ? '暂停' : '开始',
                ),
                IconButton(
                  onPressed: _isPlaying || _selectedFile != null
                      ? _stopAndReset
                      : null,
                  icon: const Icon(Icons.stop),
                  tooltip: '停止',
                ),
                IconButton(
                  onPressed: _selectedFile != null ? _previousQr : null,
                  icon: const Icon(Icons.skip_previous),
                  tooltip: '上一个',
                ),
                IconButton(
                  onPressed: _selectedFile != null ? _nextQr : null,
                  icon: const Icon(Icons.skip_next),
                  tooltip: '下一个',
                ),
                if (playbackProgress != null) ...[
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      value:
                          playbackProgress['current']! /
                          playbackProgress['total']!,
                      color: Theme.of(context).colorScheme.primary,
                      strokeWidth: 2,
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                    ),
                  ),
                  Text(
                    '${playbackProgress['current']} / ${playbackProgress['total']}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ],
            ),
            if (transferState.status == TransferStatus.error) ...[
              const SizedBox(height: 10),
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

            // 键盘快捷键提示
            if (_selectedFile != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      '键盘快捷键',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 16,
                      runSpacing: 4,
                      children: [
                        _buildKeyTip('← →', '切换二维码'),
                        _buildKeyTip('空格', '播放/暂停'),
                        _buildKeyTip('Esc', '停止并重置'),
                      ],
                    ),
                  ],
                ),
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

  Widget _buildKeyTip(String keys, String description) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.outline.withValues(alpha: 0.3),
              width: 0.5,
            ),
          ),
          child: Text(
            keys,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontFamily: 'monospace',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 4),
        Text(description, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }

  Future<void> _pickFile() async {
    try {
      print('_pickFile: 开始选择文件');
      final file = await FileService.pickFile();
      print('_pickFile: 选择文件完成，结果: $file');

      if (file != null && mounted) {
        print('_pickFile: 文件选择成功，设置状态');
        setState(() {
          _selectedFile = file;
        });
        await _prepareQrData(file);
      } else if (file == null) {
        print('_pickFile: 没有选择文件或用户取消');
        // 用户取消选择，不显示错误消息
      }
    } catch (e, stackTrace) {
      print('_pickFile: 文件选择发生错误: $e');
      print('_pickFile: 错误堆栈: $stackTrace');

      if (mounted) {
        String errorMessage = '文件选择失败';

        // 根据错误类型提供更具体的错误信息
        if (e.toString().contains('Permission denied') ||
            e.toString().contains('permission')) {
          errorMessage = '文件选择失败: 权限不足，请检查应用权限设置';
        } else if (e.toString().contains('Platform')) {
          errorMessage = '文件选择失败: 当前平台不支持文件选择功能';
        } else {
          errorMessage = '文件选择失败: $e';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Theme.of(context).colorScheme.error,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  Future<void> _createFileFromClipboard() async {
    try {
      // 从剪贴板获取文本
      final ClipboardData? clipboardData = await Clipboard.getData(
        Clipboard.kTextPlain,
      );

      if (clipboardData?.text == null || clipboardData!.text!.trim().isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('剪贴板中没有文本内容'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
        return;
      }

      // 生成带时间戳的文件名
      final now = DateTime.now();
      final timestamp =
          '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}_${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
      final fileName = 'chipboard_$timestamp.txt';

      // 显示预览弹窗
      final shouldProceed = await _showClipboardPreview(
        clipboardData.text!,
        fileName,
      );
      if (!shouldProceed) return;

      // 创建临时文件
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/$fileName');

      // 写入剪贴板内容
      await tempFile.writeAsString(clipboardData.text!);

      if (mounted) {
        setState(() {
          _selectedFile = tempFile;
        });
        await _prepareQrData(tempFile);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('从剪贴板创建文件失败: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<bool> _showClipboardPreview(String content, String fileName) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: SizedBox(
                width: double.maxFinite,
                height: MediaQuery.of(context).size.height * 0.8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    Text(
                      fileName,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Container(
                        width: double.maxFinite,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Theme.of(
                              context,
                            ).colorScheme.outline.withValues(alpha: 0.3),
                          ),
                        ),
                        child: SingleChildScrollView(
                          child: SelectableText(
                            content,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(fontFamily: 'monospace'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('取消'),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('确认发送'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  Future<void> _prepareQrData(File file) async {
    try {
      print(
        'Send Page: 准备 QR 数据，当前设置比例: ${_settings?.chunkSizeRatio.toInt()}%',
      );
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
    // 检查是否已有QR数据，如果没有则准备数据
    if (_selectedFile != null && QrService.currentQrData == null) {
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

  void _pausePlayback() {
    QrService.stopPlayback();
    if (mounted) {
      setState(() {
        _isPlaying = false;
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

  void _stopAndReset() {
    // 停止播放并回到第一个二维码，不清除文件选择
    QrService.stopAndResetToFirst();
    TransferService.reset();
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
    _focusNode.dispose();
    QrService.stopPlayback();
    TransferService.removeListener(_onTransferStateChanged);
    QrService.removeQrListener(_onQrDataChanged);
    super.dispose();
  }
}
