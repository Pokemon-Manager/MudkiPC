import 'package:flutter/material.dart' as material;
import 'package:fluent_ui/fluent_ui.dart' as fluent;

// ignore: constant_identifier_names
const COLOR_PRIMARY = material.Colors.blue;

class MaterialTheme {
  static material.ThemeData lightTheme = material.ThemeData(
      useMaterial3: true,
      brightness: material.Brightness.light,
      scaffoldBackgroundColor: material.Colors.white,
      colorScheme: material.ColorScheme.fromSeed(
          seedColor: COLOR_PRIMARY, brightness: material.Brightness.light),
      elevatedButtonTheme: material.ElevatedButtonThemeData(
        style: material.ElevatedButton.styleFrom(
            shape: const material.RoundedRectangleBorder(
          borderRadius:
              material.BorderRadius.all(material.Radius.circular(20.0)),
        )),
      ));

  static material.ThemeData darkTheme = material.ThemeData(
      useMaterial3: true,
      brightness: material.Brightness.dark,
      scaffoldBackgroundColor: const material.Color.fromARGB(255, 1, 7, 19),
      colorScheme: material.ColorScheme.fromSeed(
          seedColor: COLOR_PRIMARY, brightness: material.Brightness.dark),
      elevatedButtonTheme: material.ElevatedButtonThemeData(
        style: material.ElevatedButton.styleFrom(
            shape: const material.RoundedRectangleBorder(
          borderRadius:
              material.BorderRadius.all(material.Radius.circular(20.0)),
        )),
      ));
}

class FluentTheme {
  static fluent.FluentThemeData lightTheme = fluent.FluentThemeData(
    brightness: fluent.Brightness.light,
    activeColor: COLOR_PRIMARY,
    inactiveColor: material.Colors.grey,
  );

  static fluent.FluentThemeData darkTheme = fluent.FluentThemeData(
    brightness: fluent.Brightness.dark,
    activeColor: COLOR_PRIMARY,
    inactiveColor: material.Colors.grey,
  );
}
