import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:args/args.dart';
import 'package:path/path.dart' as path;

const ossDirPrefix = "oss://cm-front-pages/qr_trans/";

Future<void> main(List<String> arguments) async {
  final parser = ArgParser()
    ..addFlag('help', abbr: 'h', help: 'Print this usage information.', negatable: false)
    ..addFlag('oss', help: 'Upload to OSS.', negatable: false)
    ..addFlag('release', help: 'Compile and release to zip/web.', negatable: false)
    ..addFlag('only-sync-version', help: 'Only sync version to lib/version.dart.', negatable: false);

  var normalizedArgs = arguments
      .map((e) => e.startsWith('-') && !e.startsWith('--') && e.length > 2 ? '-$e' : e)
      .toList();

  final ArgResults argResults;
  try {
    argResults = parser.parse(normalizedArgs);
  } catch (e) {
    p(e.toString());
    p("Usage: dart release.dart [options]");
    p(parser.usage);
    return;
  }

  if (argResults['help'] as bool || normalizedArgs.isEmpty) {
    p("Usage: dart release.dart [options]");
    p(parser.usage);
    return;
  }

  bool doOss = argResults['oss'] as bool;
  bool doRelease = argResults['release'] as bool;
  bool doSyncOnly = argResults['only-sync-version'] as bool;

  if (!doOss && !doRelease && !doSyncOnly) {
    p("Usage: dart release.dart [options]");
    p(parser.usage);
    return;
  }

  // 动态读取 pubspec.yaml 的版本号
  final pubspecFile = File('pubspec.yaml');
  if (!await pubspecFile.exists()) {
    throw Exception('pubspec.yaml not found');
  }
  final pubspecContent = await pubspecFile.readAsString();
  final versionMatch = RegExp(r'^version:\s*([^\s]+)', multiLine: true).firstMatch(pubspecContent);
  if (versionMatch == null) {
    throw Exception('version not found in pubspec.yaml');
  }
  final appVersion = versionMatch.group(1)!;

  // 将提取的版本号同步写入 lib/version.dart
  final versionDartFile = File('lib/version.dart');
  await versionDartFile.writeAsString('const String version = "$appVersion";\n');
  p("✅ Synced lib/version.dart to $appVersion");

  if (doSyncOnly) {
    p("🎉 Version sync completed. Exiting.");
    return;
  }

  const appName = "qr_trans.exe";
  final zipFileName = "qr_trans_windows_$appVersion.zip";

  const windowsTargetPath = "build/windows/x64/runner/Release";
  const webTargetPath = "build/web";

  if (doRelease) {
    await run("flutter --version", ignorePrintResult: true);
    
    p("🚀 Start Compile Windows...");
    await runDetail(["flutter", "build", "windows", "--target=lib/main.dart"]);
    
    p("🚀 Start Compile Web...");
    await runDetail(["flutter", "build", "web", "--web-renderer=canvaskit", "--base-href=/qr_trans/", "--target=lib/main.dart"]);

    final exeFile = File("$windowsTargetPath/$appName");
    if (!await exeFile.exists()) {
      p("⚠️ Compiled windows exe not found, please check build logs.");
    }

    p("📦 Creating Windows Zip...");
    // 直接将 ZIP 包打入 Web 产物目录下的 /release 子文件夹，方便一并上传
    await createZip(windowsTargetPath, "$webTargetPath/release/$zipFileName");
    p("✅ Build Web and Windows Zip done!");
  }

  if (doOss) {
    p("🚀 Start uploading to OSS...");
    
    // 将整个 web 目录同步到 OSS，它天然包含了刚刚打好放进去的 release 绿包
    await run("ossutil64 cp -r $webTargetPath/ $ossDirPrefix --force --update");
    
    p("✅ OSS upload finished!");
  }

  p("🎉 All done!");
}

void p(dynamic o) {
  if (o is ProcessResult) {
    print(o.stdout);
    if (o.stderr.toString().isNotEmpty) {
      print(o.stderr);
    }
  } else {
    print(o);
  }
}

Future<ProcessResult> run(
  String cmd, {
  bool ignoreExitCode = false,
  bool ignoreResult = false,
  bool ignorePrintResult = false,
  String? workingDir,
}) async {
  final r = await Process.run(
    "powershell",
    ["-NoProfile", "-NonInteractive", "-Command", cmd],
    workingDirectory: workingDir,
  );
  if (!ignoreResult && !ignorePrintResult) p(r);
  if (r.exitCode == 0 || ignoreExitCode || ignoreResult) {
    return r;
  } else {
    throw Exception("Exception when running：$cmd\n${r.stderr}");
  }
}

Future<void> createZip(String sourceDir, String outputPath) async {
  p("Creating zip from $sourceDir to $outputPath");
  final archive = Archive();
  final sourceDirectory = Directory(sourceDir);

  await for (final file in sourceDirectory.list(recursive: true)) {
    if (file is File) {
      final relativePath = path
          .relative(file.path, from: sourceDir)
          .replaceAll(RegExp(r'\\'), '/');
      final data = await file.readAsBytes();
      final archiveFile = ArchiveFile(relativePath, data.length, data);
      archive.addFile(archiveFile);
    }
  }

  final zipData = ZipEncoder().encode(archive);
  final outFile = File(outputPath);
  if (!await outFile.parent.exists()) {
    await outFile.parent.create(recursive: true);
  }
  await outFile.writeAsBytes(zipData!);
  p("Zip file created successfully at $outputPath");
}

Future<int> runDetail(List<String> cmd, {String? workingDir}) async {
  final r = await Process.start(
    "cmd",
    ["/c", ...cmd],
    workingDirectory: workingDir,
  );
  r.stdout.transform(utf8.decoder).listen((event) {
    stdout.write(event);
  });
  r.stderr.transform(utf8.decoder).listen((event) {
    stderr.write(event);
  });
  return await r.exitCode;
}
