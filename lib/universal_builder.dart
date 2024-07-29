import 'dart:io' show Platform;

import 'package:flutter/material.dart' as material;
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/widgets.dart';

import 'package:mudkip_frontend/theme/theme_constants.dart';
import 'package:mudkip_frontend/theme/theme_manager.dart';
import 'package:mudkip_frontend/main.dart';

mixin UniversalBuilder {
  static String? overridePlatform;

  static Widget buildApp(ThemeManager themeProvider) {
    if (overridePlatform != null) {
      switch (overridePlatform) {
        case "android":
          return buildAndroidApp(themeProvider);
        case "windows":
          return buildWindowsApp(themeProvider);
        default:
          return buildAndroidApp(themeProvider);
      }
    }
    if (Platform.isAndroid) {
      return buildAndroidApp(themeProvider);
    } else {
      return buildWindowsApp(themeProvider);
    }
  }

  static Widget buildAndroidApp(ThemeManager themeProvider) {
    return material.MaterialApp.router(
        title: "Pokémon Manager",
        theme: MaterialTheme.lightTheme,
        darkTheme: MaterialTheme.darkTheme,
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
  }

  static Widget buildWindowsApp(ThemeManager themeProvider) {
    return fluent.FluentApp.router(
        theme: FluentTheme.lightTheme,
        darkTheme: FluentTheme.darkTheme,
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
  }

  Widget build(BuildContext context) {
    if (overridePlatform != null) {
      switch (overridePlatform) {
        case "android":
          return buildAndroid(context);
        case "windows":
          return buildWindows(context);
        default:
          return buildAndroid(context);
      }
    }
    if (Platform.isAndroid) {
      return buildAndroid(context);
    } else {
      return buildWindows(context);
    }
  }

  Widget buildAndroid(BuildContext context);

  Widget buildWindows(BuildContext context);
}

class UniversalCircularProgressIndicator extends StatelessWidget
    with UniversalBuilder {
  const UniversalCircularProgressIndicator({super.key});
  @override
  Widget buildAndroid(BuildContext context) {
    return const material.CircularProgressIndicator();
  }

  @override
  Widget buildWindows(BuildContext context) {
    return const fluent.ProgressRing();
  }
}

class UniversalLinearProgressIndicator extends StatelessWidget
    with UniversalBuilder {
  const UniversalLinearProgressIndicator({super.key});

  @override
  Widget buildAndroid(BuildContext context) {
    return const material.LinearProgressIndicator();
  }

  @override
  Widget buildWindows(BuildContext context) {
    return const fluent.ProgressBar();
  }
}

class UniversalChip extends StatelessWidget with UniversalBuilder {
  final String text;
  final Widget? avatar;
  const UniversalChip({super.key, this.avatar, required this.text});

  @override
  Widget buildAndroid(BuildContext context) {
    return material.Chip(
      label: Text(text),
      avatar: avatar,
    );
  }

  @override
  Widget buildWindows(BuildContext context) {
    return fluent.Button(
      onPressed: () {},
      child: material.Row(
        children: [
          if (avatar != null) avatar!,
          Text(text),
        ],
      ),
    );
  }
}

class UniversalButton extends StatelessWidget with UniversalBuilder {
  final Function onPressed;
  final Widget? child;
  const UniversalButton({super.key, this.child, required this.onPressed});

  @override
  Widget buildAndroid(BuildContext context) {
    return material.ElevatedButton(
      onPressed: () => onPressed(),
      child: child,
    );
  }

  @override
  material.Widget buildWindows(BuildContext context) {
    return fluent.Button(
      onPressed: () => onPressed(),
      child: child ?? const Text(""),
    );
  }
}
