import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:pokemon_manager/screens/main_window.dart';
import 'package:pokemon_manager/core/pc.dart';

PC openedPC = PC(pokemons: [], species: {});
void main(List<String> args) {
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    runApp(const MainWindow());
  } else {
    return;
  }
}
