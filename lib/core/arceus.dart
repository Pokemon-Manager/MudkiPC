import 'dart:io';
import 'dart:convert';
import 'package:mudkip_frontend/mudkipc.dart';

class Arceus {
  static bool hasConstellationBeenExtracted = false;

  static Future<String> get constellationPath async =>
      "${await MudkiPC.cacheFolder}constellation";
  static Future<void> _start() async {
    await MudkiPC.extractFileFromAssets("arceus/windows/arceus.exe",
        overwrite: true);
    await MudkiPC.extractFileFromAssets("arceus/pokemon_addon.arcaddon",
        overwrite: true);
  }

  /// # static `Future<dynamic>` _run(List<String> args) async
  /// ## Runs the arceus command with the given arguments.
  /// Do not call this function directly. Use the `read` or any other function.
  static Future<dynamic> _run(List<String> args) async {
    ProcessResult? result;
    if (Platform.isWindows) {
      result = await Process.run(
          "${await MudkiPC.cacheFolder}arceus/windows/arceus.exe",
          ["--internal", ...args],
          workingDirectory: await MudkiPC.cacheFolder);
    }
    if (result?.exitCode != 0) {
      throw Exception(result?.stderr);
    }
    return result?.stdout;
  }

  static Future<bool> doesConstellationExist() async {
    String result = await _run(["exists", await constellationPath]);
    if (result == "true") {
      return true;
    } else {
      return false;
    }
  }

  static Future<void> verifyConstellation() async {
    if (!hasConstellationBeenExtracted) {
      if (!await doesConstellationExist()) {
        if (!await Directory(await constellationPath).exists()) {
          await Directory(await constellationPath).create(recursive: true);
        }
        await _run(["--path", await constellationPath, "create", "MudkiPC"]);
      }
      await installAddon();
    }
    hasConstellationBeenExtracted = true;
  }

  static Future<void> installAddon() async {
    await _run([
      "--path",
      await constellationPath,
      "install",
      "${await MudkiPC.cacheFolder}arceus/pokemon_addon.arcaddon",
    ]);
  }

  static Future<dynamic> read(String filepath) async {
    await Arceus._start();
    await verifyConstellation();
    return jsonDecode(await _run([
      "--path",
      await constellationPath,
      "read",
      filepath,
    ]));
  }
}
