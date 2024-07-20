import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mudkip_frontend/screens/app_shell.dart';
import 'package:mudkip_frontend/theme/theme_constants.dart';
import 'package:mudkip_frontend/pokemon_manager.dart';
import 'package:mudkip_frontend/theme/theme_manager.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:mudkip_frontend/screens.dart';

Future<void> doPrefs() async {
  return;
}

ThemeManager themeManager = ThemeManager();
late PackageInfo packageInfo;
final router = GoRouter(initialLocation: "/pc", routes: <RouteBase>[
  GoRoute(
      path: "/about",
      builder: (context, state) {
        return const AboutScreen();
      }),
  GoRoute(
      path: "/preview",
      builder: (context, state) {
        return PreviewPanel(object: state.extra! as Future<dynamic>);
      }),
  ShellRoute(
      routes: <RouteBase>[
        GoRoute(
            path: "/pc",
            builder: (context, state) {
              return const PCView();
            }),
        GoRoute(
            path: "/pokedex",
            builder: (context, state) {
              return const PokeDexView();
            }),
      ],
      builder: (context, state, child) {
        return AppShell(child: child);
      }),
]);

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  await doPrefs();
  packageInfo = await PackageInfo.fromPlatform();
  await PokeAPI.create();
  await PC.create();
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
    runApp(MaterialApp.router(
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
          Locale('it', 'IT')
        ],
        routeInformationParser: router.routeInformationParser,
        routerDelegate: router.routerDelegate,
        routeInformationProvider: router.routeInformationProvider));
  }
}
