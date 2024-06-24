import 'dart:convert';
import 'package:window_manager/window_manager.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_manager/pokemon_manager.dart';
import 'package:pokemon_manager/theme/theme_manager.dart';

ThemeManager themeManager = ThemeManager();
PC openedPC = PC(pokemons: []);
void main(List<String> args) {
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
    runApp(MainWindow());
    WindowManager.instance.setTitle("Pokémon Manager");
  }
}
