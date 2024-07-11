import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mudkip_frontend/screens/main_window.dart';
import 'package:mudkip_frontend/theme/theme_constants.dart';
import 'package:mudkip_frontend/pokemon_manager.dart';
import 'package:mudkip_frontend/theme/theme_manager.dart';
import 'package:package_info_plus/package_info_plus.dart';

Future<void> doPrefs() async {
  return;
}

ThemeManager themeManager = ThemeManager();
late PC openedPC;
late PackageInfo packageInfo;

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  await doPrefs();
  packageInfo = await PackageInfo.fromPlatform();
  openedPC = await PC.create();
  PokeAPI.create();
  if (args.firstOrNull == 'multi_window') {
    // ignore: unused_local_variable
    final windowId = int.parse(args[1]);
    final argument = args[2].isEmpty
        ? const {}
        : jsonDecode(args[2]) as Map<String, dynamic>;
    switch (argument['appId']) {
      case "pkmnmanager":
        break;
      default:
        break;
    }
  } else {
    runApp(MaterialApp(
        title: "Pokémon Manager",
        theme: lightTheme,
        darkTheme: darkTheme,
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('fr', 'FR'),
          Locale('ja', 'JP'),
          Locale('ko', 'KR'),
          Locale('es', 'ES'),
          Locale('zh', 'CN'),
          Locale('it', 'IT'),
        ],
        home: const MainWindow()));
  }
}
