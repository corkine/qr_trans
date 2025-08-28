import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
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
    _recoverTransfers();

    // 添加监听器来响应状态变化
    TransferService.addListener(_onTransferStateChanged);
    QrService.addScannerListener(_onScannerStateChanged);

    // 获取初始状态
    _transferState = TransferService.currentState;
    _scannerActive = QrService.scannerActive;
  }

  Future<void> _recoverTransfers() async {
    try {
      await TransferService.recoverTransfers();
    } catch (e) {
      if (_mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('恢复传输失败: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void _onTransferStateChanged(AppState state) {
    if (!_mounted) return;
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
              icon: const Icon(Icons.refresh),
              onPressed: _loadReceivedFiles,
              tooltip: '刷新文件列表',
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
                  color: Theme.of(context).colorScheme.surfaceVariant,
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
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                OutlinedButton.icon(
                  onPressed: _isScannerSupported ? _toggleFlash : null,
                  icon: const Icon(Icons.flash_on),
                  label: const Text('闪光灯'),
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
    final activeTransfer = transferState.activeTransfers.isNotEmpty
        ? transferState.activeTransfers.first
        : null;

    if (activeTransfer == null) {
      return Row(
        children: [
          Icon(Icons.search, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Text('等待扫描二维码...', style: Theme.of(context).textTheme.bodyMedium),
        ],
      );
    }

    final progress = activeTransfer.receivedChunks / activeTransfer.totalChunks;
    final fileName = activeTransfer.metadata?.fileName ?? '未知文件';

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
        LinearProgressIndicator(value: progress),
        const SizedBox(height: 4),
        Text(
          '${activeTransfer.receivedChunks} / ${activeTransfer.totalChunks} 片段',
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
                        : Theme.of(context).colorScheme.onSurface.withOpacity(0.38),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _isScannerSupported ? '准备接收文件' : '扫描功能不可用',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: _isScannerSupported 
                          ? null 
                          : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isScannerSupported 
                        ? '点击开始扫描二维码接收文件'
                        : '当前平台不支持摄像头扫描功能',
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
            ...(_receivedFiles.map((file) => _buildFileItem(context, file))),
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
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  _formatFileSize(fileSize),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) => _handleFileAction(context, file, value),
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
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
  }

  void _stopScanner() {
    _scannerController?.dispose();
    _scannerController = null;
    QrService.deactivateScanner();
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
      HapticFeedback.lightImpact();
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
      case 'share':
        await _shareFile(context, file);
        break;
      case 'delete':
        await _deleteFile(context, file);
        break;
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

  Future<void> _deleteFile(BuildContext context, File file) async {
    final confirmed = await showDialog<bool>(
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
