import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mudkip_frontend/screens/main_window.dart';
import 'package:mudkip_frontend/theme/theme_constants.dart';
import 'package:pokemon_manager_backend/pokemon_manager.dart';
import 'package:mudkip_frontend/theme/theme_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> doPrefs() async {
  prefs = await SharedPreferences.getInstance();
  return;
}

ThemeManager themeManager = ThemeManager();
PC openedPC = PC(pokemons: []);
SharedPreferences? prefs;

void main(List<String> args) async {
  await doPrefs();
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
        home: const MainWindow()));
  }
}
