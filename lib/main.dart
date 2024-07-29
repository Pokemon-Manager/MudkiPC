import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:mudkip_frontend/universal_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:mudkip_frontend/screens/app_shell.dart';
import 'package:mudkip_frontend/pokemon_manager.dart';
import 'package:mudkip_frontend/theme/theme_manager.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:mudkip_frontend/screens.dart';

ThemeManager themeManager = ThemeManager();
late PackageInfo packageInfo;
late File logFile;
final router = GoRouter(initialLocation: "/pc", routes: <RouteBase>[
  GoRoute(
      path: "/settings",
      builder: (context, state) {
        return const SettingsScreen();
      }),
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
            },
            pageBuilder: (context, state) {
              return CustomTransitionPage<void>(
                key: UniqueKey(),
                child: const PCView(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
              );
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
  logFile = File("${await MudkiPC.userFolder}log.txt");
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    // ignore: avoid_print
    print("${record.level.name}: ${record.time}: ${record.message}");
    if (record.level == Level.INFO ||
        record.level == Level.WARNING ||
        record.level == Level.SEVERE) {
      logFile.writeAsStringSync(
          '\n${record.level.name}: ${record.time}: ${record.message}',
          mode: FileMode.append);
    }
  });
  WidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  await Settings.doPrefs();
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
    runApp(ChangeNotifierProvider(
        create: (context) => ThemeManager(),
        builder: (context, _) {
          final themeProvider = Provider.of<ThemeManager>(context);
          return UniversalBuilder.buildApp(themeProvider);
        }));
  }
}
