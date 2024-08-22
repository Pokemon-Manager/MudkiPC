import 'dart:io';
import 'package:mudkip_frontend/mudkipc.dart';

class Arceus {
  static Future<void> _start() async {
    if (Platform.isWindows) {
      await MudkiPC.extractFileFromAssets("arceus/windows/arceus.exe");
    }
    MudkiPC.extractFolderFromAssets("patterns/");
  }

  /// # static `Future<dynamic>` _run(List<String> args) async
  /// ## Runs the arceus command with the given arguments.
  /// Do not call this function directly. Use the `read` or any other function.
  static Future<dynamic> _run(List<String> args) async {
    await _start();
    ProcessResult? result;
    if (Platform.isWindows) {
      result = await Process.run(
          "${await MudkiPC.cacheFolder}arceus/windows/arceus.exe", args,
          workingDirectory: await MudkiPC.cacheFolder);
    }

    if (result!.exitCode == 0) {
      return result.stdout;
    }
  }

  static Future<dynamic> read(String filepath, String pattern) async {
    print(filepath);
    if (filepath.endsWith(".pk9")) {
      return await _run(
          ["pattern", "parse", "--file", filepath, "--pattern", pattern]);
    }
  }
}
