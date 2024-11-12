import 'package:flutter/material.dart' as material;

// ignore: constant_identifier_names
const COLOR_PRIMARY = material.Colors.blue;

material.ThemeData lightTheme = material.ThemeData(
    useMaterial3: true,
    brightness: material.Brightness.light,
    scaffoldBackgroundColor: material.Colors.white,
    primaryTextTheme: material.Typography.blackCupertino,
    colorScheme: material.ColorScheme.fromSeed(
        seedColor: COLOR_PRIMARY, brightness: material.Brightness.light),
    elevatedButtonTheme: material.ElevatedButtonThemeData(
      style: material.ElevatedButton.styleFrom(
          shape: const material.RoundedRectangleBorder(
        borderRadius: material.BorderRadius.all(material.Radius.circular(20.0)),
      )),
    ));

material.ThemeData darkTheme = material.ThemeData(
    useMaterial3: true,
    brightness: material.Brightness.dark,
    scaffoldBackgroundColor: const material.Color.fromARGB(255, 1, 7, 19),
    colorScheme: material.ColorScheme.fromSeed(
        seedColor: COLOR_PRIMARY, brightness: material.Brightness.dark),
    elevatedButtonTheme: material.ElevatedButtonThemeData(
      style: material.ElevatedButton.styleFrom(
          shape: const material.RoundedRectangleBorder(
        borderRadius: material.BorderRadius.all(material.Radius.circular(20.0)),
      )),
    ));
