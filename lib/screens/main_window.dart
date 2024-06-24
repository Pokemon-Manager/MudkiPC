import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pokemon_manager/main.dart';
import 'package:pokemon_manager/theme/theme_constants.dart';
import 'package:pokemon_manager/widgets/setup_notifier.dart';
import 'package:pokemon_manager/skeletons/box.dart';
import 'package:pokemon_manager/pokemon_manager.dart';

class MainWindow extends StatefulWidget {
  const MainWindow({super.key});

  @override
  State<MainWindow> createState() => MainWindowState();
}

class MainWindowState extends State<MainWindow> {
  bool isLoading = true;
  List<Pokemon> pokemons = [];
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: themeManager.themeMode,
        home: Scaffold(
          body: Stack(
                children: [
          if (isLoading)
            const SetupNotifier()
          else
            Row(children: [
              NavigationRail(
                selectedIndex: 0,
                onDestinationSelected: (int index) {},
                destinations: const [
                  NavigationRailDestination(
                      icon: Icon(Icons.home), label: Text("Home")),
                  NavigationRailDestination(
                      icon: Icon(Icons.search), label: Text("Search")),
                ],
                trailing: Switch(value: themeManager.themeMode == ThemeMode.dark, thumbIcon: WidgetStateProperty.resolveWith<Icon>(
                  (Set<WidgetState> states) {
                    if (themeManager.themeMode == ThemeMode.dark) {
                      return const Icon(Icons.dark_mode);
                    }
                    return const Icon(Icons.light_mode);
                  }
                ), onChanged: (bool value) { themeManager.toggleTheme(value); },),
              ),
              Expanded(child: PokemonBox(pokemons: pokemons))
            ])
                ],
              ),
        ));
  }

  @override
  void initState() {
    super.initState();
    start();
  }

  Future<void> start() async {
    await openedPC
        .openFolder("C:/Users/Colly/OneDrive/Documents/Pokemon/pkmdb");
    setState(() {
      pokemons = openedPC.pokemons;
      isLoading = false;
    });
    themeManager.addListener(themeListener);
  }

  themeListener() {
    if(mounted){
        setState(() {
          
        }
      );
    }
  }
}
