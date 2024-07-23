import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mudkip_frontend/screens/app_shell.dart';
import 'package:mudkip_frontend/theme/theme_constants.dart';
import 'package:mudkip_frontend/pokemon_manager.dart';
import 'package:mudkip_frontend/theme/theme_manager.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:mudkip_frontend/screens.dart';

Future<void> doPrefs() async {
  return;
}

ThemeManager themeManager = ThemeManager();
late PackageInfo packageInfo;
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
            routes: [
              GoRoute(
                path: 'fetching',
                builder: (context, state) {
                  return AlertDialog(
                    content: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                            margin: const EdgeInsets.only(left: 7),
                            child:
                                const Text("Fetching Pokémon from Folder...")),
                        const SizedBox(height: 10),
                        const CircularProgressIndicator(),
                      ],
                    ),
                  );
                },
              )
            ],
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
    runApp(ChangeNotifierProvider(
        create: (context) => ThemeManager(),
        builder: (context, _) {
          final themeProvider = Provider.of<ThemeManager>(context);
          return MaterialApp.router(
              title: "Pokémon Manager",
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: themeProvider.themeMode,
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
              routeInformationProvider: router.routeInformationProvider);
        }));
  }
}
