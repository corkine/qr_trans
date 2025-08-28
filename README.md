# QR传输

一个通过二维码在设备间安全传输文件的跨平台Flutter应用。

## 功能特色

✨ **核心功能**
- 🔄 跨平台文件传输（Android、iOS、Windows、macOS、Linux）
- 📱 通过二维码传输，无需网络连接
- 🔒 安全可靠的数据传输
- 📄 支持任意文件类型

⚙️ **高级功能**
- 📐 可调节的二维码大小
- ⏱️ 可调节的播放速度
- 🔧 多种纠错等级
- 🌗 暗色模式支持
- 💾 设置自动保存

## 使用方法

### 发送文件
1. 点击首页的 **"发送文件"** 按钮
2. 选择要发送的文件
3. 等待文件处理完成
4. 点击 **"开始播放"** 自动播放二维码序列
5. 在接收设备上扫描二维码

### 接收文件
1. 点击首页的 **"接收文件"** 按钮
2. 点击 **"开始扫描"** 启动相机
3. 扫描发送设备上的二维码
4. 等待文件传输完成
5. 查看已接收的文件并进行分享或删除

### 设置调整
1. 点击首页的 **"设置"** 按钮
2. 调整以下参数：
   - **QR码大小**：调整二维码显示尺寸
   - **播放速度**：调整二维码切换间隔时间
   - **数据块大小**：平衡传输速度和稳定性
   - **纠错等级**：提高二维码识别成功率
   - **暗色模式**：切换应用主题

## 技术架构

### 核心技术栈
- **Flutter**: 跨平台UI框架
- **Riverpod**: 状态管理
- **Freezed**: 数据模型代码生成
- **Build Runner**: 代码生成工具

### 主要依赖
- `qr_flutter`: 二维码生成
- `mobile_scanner`: 二维码扫描
- `file_picker`: 文件选择
- `shared_preferences`: 本地设置存储
- `share_plus`: 文件分享
- `path_provider`: 文件路径管理

### 项目结构
```
lib/
├── main.dart                 # 应用入口
├── models/                   # 数据模型
│   ├── app_settings.dart     # 应用设置模型
│   └── transfer_metadata.dart # 传输元数据模型
├── providers/                # Riverpod状态提供者
│   ├── settings_provider.dart # 设置管理
│   ├── transfer_provider.dart # 传输状态管理
│   └── qr_provider.dart      # 二维码处理
├── services/                 # 业务服务
│   ├── file_service.dart     # 文件处理服务
│   └── settings_service.dart # 设置存储服务
├── pages/                    # 页面组件
│   ├── home_page.dart        # 首页
│   ├── send_page.dart        # 发送页面
│   ├── receive_page.dart     # 接收页面
│   └── settings_page.dart    # 设置页面
└── utils/                    # 工具类
    └── responsive.dart       # 响应式布局工具
```

## 开发环境配置

### 系统要求
- Flutter SDK ≥ 3.8.0
- Dart SDK ≥ 3.8.0

### 安装步骤
1. 克隆仓库
```bash
git clone <repository-url>
cd qr_trans
```

2. 安装依赖
```bash
flutter pub get
```

3. 生成代码
```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

4. 运行应用
```bash
# 开发模式
flutter run

# 构建发布版本
flutter build apk        # Android
flutter build ipa        # iOS
flutter build windows    # Windows
flutter build macos      # macOS
flutter build linux      # Linux
```

## 配置说明

### 权限配置

#### Android (`android/app/src/main/AndroidManifest.xml`)
```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
```

#### iOS (`ios/Runner/Info.plist`)
```xml
<key>NSCameraUsageDescription</key>
<string>需要访问相机来扫描二维码</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>需要访问相册来选择文件</string>
```

### 性能优化建议
- **数据块大小**: 网络环境较差时降低数据块大小
- **纠错等级**: 扫描困难时提高纠错等级
- **播放速度**: 根据扫描设备性能调整播放速度

## 常见问题

### Q: 扫描二维码失败怎么办？
A: 尝试以下解决方案：
- 确保光线充足
- 保持适当的扫描距离
- 在设置中提高纠错等级
- 降低播放速度

### Q: 文件传输中断怎么办？
A: 
- 应用会自动保存已接收的数据片段
- 重新扫描可以继续传输
- 检查存储空间是否充足

### Q: 如何提高传输速度？
A:
- 增加数据块大小
- 提高播放速度
- 确保二维码显示清晰

## 贡献指南

欢迎提交Issue和Pull Request！

1. Fork此仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启Pull Request

## 许可证

本项目采用 MIT 许可证。详情请查看 [LICENSE](LICENSE) 文件。

## 联系方式

如有问题或建议，请通过以下方式联系：
- 提交Issue: [GitHub Issues](https://github.com/yourname/qr_trans/issues)
- 邮箱: your.email@example.com

---

⭐ 如果这个项目对你有帮助，请给它一个星标！