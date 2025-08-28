import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:open_file/open_file.dart';
import 'package:share_plus/share_plus.dart';
import '../models/app_settings.dart';
import '../services/file_service.dart';
import '../services/qr_service.dart';
import '../services/transfer_service.dart';

class ReceivePage extends StatefulWidget {
  const ReceivePage({super.key});

  @override
  State<ReceivePage> createState() => _ReceivePageState();
}

class _ReceivePageState extends State<ReceivePage> {
  MobileScannerController? _scannerController;
  List<File> _receivedFiles = [];
  bool _scannerActive = false;
  AppState? _transferState;
  bool _mounted = true;

  /// 检查当前平台是否支持扫描器
  bool get _isScannerSupported {
    if (kIsWeb) {
      // Web平台支持，但需要HTTPS
      return true;
    }

    // 移动端支持
    if (Platform.isAndroid || Platform.isIOS) {
      return true;
    }

    // 桌面端通常不支持或支持有限
    return false;
  }

  @override
  void initState() {
    super.initState();
    _loadReceivedFiles();

    // 彻底清理所有传输数据和状态
    _cleanupTransferData();

    // 确保扫描器完全停止
    _stopScanner();
    QrService.deactivateScanner();

    // 添加监听器来响应状态变化
    TransferService.addListener(_onTransferStateChanged);
    QrService.addScannerListener(_onScannerStateChanged);

    // 强制设为初始状态
    _transferState = TransferService.currentState;
    _scannerActive = false;
  }

  void _onTransferStateChanged(AppState state) {
    if (!_mounted) return;

    // 检查是否传输完成，如果完成则自动停止扫描器
    if (state.status == TransferStatus.completed && _scannerActive) {
      _stopScanner();

      // 刷新文件列表以显示新接收到的文件
      _loadReceivedFiles();

      // 显示传输完成提示
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('文件接收完成，已自动停止扫描'),
            ],
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
    }

    // 检查是否传输出错，如果出错也显示提示
    // if (state.status == TransferStatus.error && state.errorMessage != null) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Row(
    //         children: [
    //           const Icon(Icons.error, color: Colors.white),
    //           const SizedBox(width: 8),
    //           Expanded(child: Text('传输失败: ${state.errorMessage}')),
    //         ],
    //       ),
    //       backgroundColor: Theme.of(context).colorScheme.error,
    //       duration: const Duration(seconds: 5),
    //     ),
    //   );
    // }

    setState(() {
      _transferState = state;
    });
  }

  void _onScannerStateChanged(bool active) {
    if (!_mounted) return;
    setState(() {
      _scannerActive = active;
    });
  }

  @override
  Widget build(BuildContext context) {
    final transferState = _transferState ?? const AppState();

    return Scaffold(
      appBar: AppBar(
        title: const Text('接收文件'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(
              _scannerActive ? Icons.camera_alt : Icons.camera_alt_outlined,
            ),
            onPressed: _isScannerSupported ? _toggleScanner : null,
            tooltip: _isScannerSupported
                ? (_scannerActive ? '停止扫描' : '开始扫描')
                : '当前平台不支持扫描功能',
          ),
          if (_receivedFiles.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: _clearAllFiles,
              tooltip: '清空所有文件',
            ),
          const SizedBox(width: 12),
        ],
      ),
      body: SafeArea(child: _buildLayout(context, transferState)),
    );
  }

  Widget _buildLayout(BuildContext context, AppState transferState) {
    if (!_scannerActive) {
      return _receivedFiles.isEmpty
          ? _buildStartScanningCard()
          : _buildReceivedFilesList(context);
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 32, left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildScannerView(context),
            const SizedBox(height: 16),
            _buildScannerControls(context, transferState),
            if (_receivedFiles.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildReceivedFilesList(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildScannerView(BuildContext context) {
    return Card(
      elevation: 0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 300,
          child: _isScannerSupported && _scannerController != null
              ? Stack(
                  children: [
                    MobileScanner(
                      controller: _scannerController,
                      onDetect: _handleBarcodeScan,
                    ),
                    Positioned(
                      top: 16,
                      left: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '将二维码对准扫描框',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                )
              : Container(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt_outlined,
                          size: 48,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '扫描器不可用',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildScannerControls(BuildContext context, AppState transferState) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTransferProgress(context, transferState),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 12,
              children: [
                IconButton(
                  onPressed: _isScannerSupported ? _toggleFlash : null,
                  icon: const Icon(Icons.flash_on),
                  tooltip: '闪光灯',
                ),
                FilledButton.icon(
                  onPressed: _isScannerSupported ? _toggleScanner : null,
                  icon: const Icon(Icons.stop),
                  label: const Text('停止扫描'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransferProgress(BuildContext context, AppState transferState) {
    // 直接使用单个传输
    final activeTransfer = transferState.activeTransfer;

    if (activeTransfer == null) {
      return Row(
        children: [
          Icon(Icons.search, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Text('等待扫描二维码...', style: Theme.of(context).textTheme.bodyMedium),
        ],
      );
    }

    // 确保进度值是有效的
    final totalChunks = activeTransfer.totalChunks;
    final receivedChunks = activeTransfer.receivedChunks;
    final progress = totalChunks > 0 ? receivedChunks / totalChunks : 0.0;
    final fileName = activeTransfer.metadata?.fileName ?? '未知文件';

    // print('Progress bar: received=$receivedChunks, total=$totalChunks, progress=$progress');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.download, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '正在接收: $fileName',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(value: progress.clamp(0.0, 1.0)),
        const SizedBox(height: 4),
        Text(
          '$receivedChunks / $totalChunks 片段',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildStartScanningCard() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Center(
        child: Card(
          elevation: 0,
          child: InkWell(
            hoverColor: Colors.transparent,
            onTap: _isScannerSupported ? _toggleScanner : null,
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
                    Icons.qr_code_scanner,
                    size: 64,
                    color: _isScannerSupported
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.38),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _isScannerSupported ? '准备接收文件' : '扫描功能不可用',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: _isScannerSupported
                          ? null
                          : Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isScannerSupported ? '点击开始扫描二维码接收文件' : '当前平台不支持摄像头扫描功能',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: _isScannerSupported ? _toggleScanner : null,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('开始扫描'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReceivedFilesList(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.folder,
                  size: 24,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  '已接收的文件',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  '${_receivedFiles.length} 个',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // 使用 SlidableAutoCloseBehavior 确保滑动行为正常
            SlidableAutoCloseBehavior(
              child: Column(
                children: _receivedFiles
                    .map((file) => _buildFileItem(context, file))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileItem(BuildContext context, File file) {
    final fileName = file.path.split('/').last;
    final fileSize = file.lengthSync();

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Slidable(
        key: ValueKey(file.path),
        // 向右滑动删除
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => _deleteFile(context, file, skipConfirm: true),
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: '删除',
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
            ),
          ],
        ),
        // 向左滑动分享
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => _shareFile(context, file),
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              icon: Icons.share,
              label: '分享',
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _openFile(context, file),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.insert_drive_file,
                    size: 24,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fileName,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w500),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _formatFileSize(fileSize),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) =>
                        _handleFileAction(context, file, value),
                    icon: const Icon(Icons.more_vert),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'open',
                        child: ListTile(
                          leading: Icon(Icons.open_in_new),
                          title: Text('打开'),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'share',
                        child: ListTile(
                          leading: Icon(Icons.share),
                          title: Text('分享'),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: ListTile(
                          leading: Icon(Icons.delete),
                          title: Text('删除'),
                          contentPadding: EdgeInsets.zero,
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

  void _toggleScanner() {
    if (!_isScannerSupported) {
      // 显示平台不支持的提示
      if (_mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('当前平台不支持摄像头扫描功能'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
      return;
    }

    if (_scannerActive) {
      _stopScanner();
    } else {
      _startScanner();
    }
  }

  void _startScanner() {
    if (!_isScannerSupported) {
      return;
    }
    _scannerController = MobileScannerController();
    QrService.activateScanner();
    TransferService.startReceiving();
    if (mounted) {
      setState(() {
        _scannerActive = true;
      });
    }
  }

  void _stopScanner() {
    _scannerController?.dispose();
    _scannerController = null;
    QrService.deactivateScanner();

    // 清理所有传输状态和临时数据
    _cleanupTransferData();

    if (mounted) {
      setState(() {
        _scannerActive = false;
      });
    }
  }

  void _toggleFlash() {
    if (!_isScannerSupported || _scannerController == null) {
      return;
    }
    _scannerController?.toggleTorch();
  }

  Future<void> _handleBarcodeScan(BarcodeCapture capture) async {
    final barcode = capture.barcodes.firstOrNull;
    if (barcode?.rawValue != null) {
      // 移除震动反馈以避免iPhone震动
      // HapticFeedback.lightImpact();
      final file = await QrService.handleScanResult(barcode!.rawValue!);
      if (file != null) {
        _receivedFiles.add(file);
        await _loadReceivedFiles();
      }
    }
  }

  Future<void> _loadReceivedFiles() async {
    try {
      final files = await FileService.getReceivedFiles();
      setState(() {
        _receivedFiles = files;
      });
    } catch (e) {
      if (_mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('加载文件列表失败: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void _handleFileAction(BuildContext context, File file, String action) async {
    switch (action) {
      case 'open':
        await _openFile(context, file);
        break;
      case 'share':
        await _shareFile(context, file);
        break;
      case 'delete':
        await _deleteFile(context, file);
        break;
    }
  }

  Future<void> _openFile(BuildContext context, File file) async {
    try {
      final result = await OpenFile.open(file.path);

      // 检查打开结果
      if (result.type != ResultType.done) {
        if (_mounted) {
          String errorMessage;
          switch (result.type) {
            case ResultType.noAppToOpen:
              errorMessage = '没有找到可以打开此文件的应用';
              break;
            case ResultType.fileNotFound:
              errorMessage = '文件不存在或已被删除';
              break;
            case ResultType.permissionDenied:
              errorMessage = '没有权限打开此文件';
              break;
            default:
              errorMessage = '无法打开文件: ${result.message}';
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    } catch (e) {
      if (_mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('打开文件失败: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _cleanupTransferData() async {
    try {
      // 清理所有传输临时文件（更彻底的清理）
      await FileService.cleanupAllTransfers();

      // 重置传输服务状态
      TransferService.reset();

      // 清理QR服务的生成器状态（如果有残留）
      QrService.resetGenerator();
    } catch (e) {
      // 清理过程中的错误不应该影响主要功能，记录即可
      print('清理传输数据时出错: $e');
    }
  }

  Future<void> _clearAllFiles() async {
    if (_receivedFiles.isEmpty) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('清空所有文件'),
        content: Text('确定要删除所有 ${_receivedFiles.length} 个接收到的文件吗？此操作不可撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('删除全部'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        // 删除所有文件
        int deletedCount = 0;
        for (final file in _receivedFiles) {
          if (await file.exists()) {
            await file.delete();
            deletedCount++;
          }
        }

        // 清理所有传输状态和临时数据
        _cleanupTransferData();

        // 刷新文件列表
        await _loadReceivedFiles();

        if (_mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('已删除 $deletedCount 个文件'),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
          );
        }
      } catch (e) {
        if (_mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('删除文件失败: $e'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    }
  }

  Future<void> _shareFile(BuildContext context, File file) async {
    try {
      await Share.shareXFiles([XFile(file.path)]);
    } catch (e) {
      if (_mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('分享文件失败: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _deleteFile(
    BuildContext context,
    File file, {
    bool skipConfirm = false,
  }) async {
    final confirmed = skipConfirm
        ? true
        : await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('删除文件'),
              content: const Text('确定要删除这个文件吗？'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('取消'),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('删除'),
                ),
              ],
            ),
          );

    if (confirmed == true) {
      try {
        await file.delete();
        await _loadReceivedFiles();
        if (_mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('文件已删除')));
        }
      } catch (e) {
        if (_mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('删除文件失败: $e'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
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
    _mounted = false;
    // 只做清理工作，不调用setState
    _scannerController?.dispose();
    _scannerController = null;
    QrService.deactivateScanner();
    // 移除监听器
    TransferService.removeListener(_onTransferStateChanged);
    QrService.removeScannerListener(_onScannerStateChanged);
    super.dispose();
  }
}
