// ignore_for_file: must_be_immutable

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mudkip_frontend/core/pokeapi.dart';
import 'package:mudkip_frontend/main.dart';
import 'package:mudkip_frontend/screens/preview_panel.dart';
import 'package:mudkip_frontend/screens/warning_page.dart';
import 'package:mudkip_frontend/widgets/pokemon_slot.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mudkip_frontend/widgets/species_entry.dart';
import 'package:mudkip_frontend/screens/about_screen.dart';

class MainWindow extends StatefulWidget {
  const MainWindow({super.key});

  @override
  State<MainWindow> createState() => MainWindowState();
}

class MainWindowState extends State<MainWindow>
    with Destinations, TickerProviderStateMixin {
  void handleScreenChanged(int selectedScreen) {
    setState(() {
      selectedIndex = selectedScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    final showRail = MediaQuery.of(context).size.width >= 450;
    return Scaffold(
        floatingActionButtonLocation: ExpandableFab.location,
        floatingActionButton: ExpandableFab(
          distance: 90.0,
          childrenOffset: const Offset(1.0, 1.0),
          openButtonBuilder: RotateFloatingActionButtonBuilder(
            child: const Icon(Icons.add),
            fabSize: ExpandableFabSize.regular,
            heroTag: "add",
            shape: const CircleBorder(),
          ),
          closeButtonBuilder: FloatingActionButtonBuilder(
            size: 60,
            builder: (BuildContext context, void Function()? onPressed,
                Animation<double> progress) {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(20),
                ),
                onPressed: onPressed,
                iconAlignment: IconAlignment.end,
                child: const Icon(
                  Icons.close_rounded,
                  size: 35,
                ),
              );
            },
          ),
          children: [
            FloatingActionButton(
                heroTag: "addFile",
                tooltip: "Add File",
                child: const Icon(Icons.upload_file_rounded,
                    semanticLabel: "Add File"),
                onPressed: () async {
                  FilePicker.platform.pickFiles().then((result) {});
                }),
            FloatingActionButton(
                heroTag: "addFolder",
                tooltip: "Add Folder",
                child: const Icon(Icons.drive_folder_upload_rounded),
                onPressed: () {
                  FilePicker.platform.getDirectoryPath().then((result) {
                    if (result != null && context.mounted) {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                content: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                        margin: const EdgeInsets.only(left: 7),
                                        child: const Text(
                                            "Fetching Pokémon from Folder...")),
                                    const SizedBox(height: 10),
                                    const CircularProgressIndicator(),
                                  ],
                                ),
                              ),
                          barrierDismissible: false);
                      openedPC
                          .openFolder(result)
                          .then((value) => refreshPCView());
                    }
                  });
                }),
          ],
        ),
        body: Row(children: [
          if (showRail)
            SideNavRail(
              index: selectedIndex,
              onDestinationSelected: (int index) {
                handleScreenChanged(index);
              },
            )
          else
            const SizedBox(width: 0),
          Expanded(
              child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 100),
            child: destinations_widgets[selectedIndex],
          )),
        ]),
        bottomNavigationBar: showRail
            ? const SizedBox()
            : BottomNavBar(
                index: selectedIndex,
                onDestinationSelected: (int index) {
                  handleScreenChanged(index);
                },
              ),
        appBar: AppBar(title: const Text("MudkiPC")),
        drawer: Drawer(
          child: ListView(
            children: [
              const DrawerHeader(
                  decoration: BoxDecoration(color: Colors.blue),
                  child: Text("MudkiPC")),
              ListTile(
                title: const Text("Settings"),
                onTap: () {},
                leading: const Icon(Icons.settings),
              ),
              ListTile(
                title: const Text("About"),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const AboutScreen();
                  }));
                },
                leading: const Icon(Icons.info),
              ),
            ],
          ),
        ));
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 0), () {
      // Makes sure that the MaterialApp is loaded before begin the first time setup.
      start();
    });
  }

  Future<void> start() async {
    // First Dialog. Welcomes user, and gives them a disclaimer about the development of this program.
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
              actions: [
                TextButton(
                  child: const Text("OK"),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Welcome to MudkiPC!",
                      style: Theme.of(context).textTheme.titleLarge),
                  Text(
                      "This program is still in alpha, so some bugs may occur. Please report them if you encounter any. Don't hesitate to contribute!",
                      style: Theme.of(context).textTheme.titleMedium),
                ],
              ));
        });
  }

  Future<void> refreshPCView() async {
    destinations_widgets[0] = PCView();
    handleScreenChanged(0);
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }
}

class BottomNavBar extends StatelessWidget with Destinations {
  BottomNavBar(
      {super.key, required this.onDestinationSelected, required this.index});
  int index;

  Function onDestinationSelected;
  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: index,
      onDestinationSelected: (int index) {
        onDestinationSelected(index);
      },
      animationDuration: const Duration(milliseconds: 200),
      destinations: getDestinationsForBar(),
      height: 80,
    );
  }
}

class SideNavRail extends StatelessWidget with Destinations {
  SideNavRail(
      {super.key, required this.onDestinationSelected, required this.index});
  int index;

  Function onDestinationSelected;
  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: index,
      onDestinationSelected: (int index) {
        onDestinationSelected(index);
      },
      labelType: NavigationRailLabelType.all,
      destinations: getDestinationsForRail(),
    );
  }
}

class Destination extends StatelessWidget {
  Destination({super.key});
  Icon destinationIcon = const Icon(Icons.grid_view_rounded);
  String destinationLabel = 'PC';
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

class PCView extends Destination {
  // The PC view is where the user can see their Pokémon.
  PCView({super.key});

  @override
  Icon get destinationIcon => const Icon(Icons.grid_view_rounded);

  @override
  String get destinationLabel => 'PC';

  @override
  Widget build(BuildContext context) {
    if (openedPC.pokemons.isEmpty) {
      return WarningPage(
          title: "No Pokémon in sight.",
          description: "You can add some with the + button.",
          icon: Icons.announcement_rounded);
    }
    return GridView.builder(
      scrollDirection: Axis.vertical,
      itemCount: openedPC.pokemons.length,
      shrinkWrap: true,
      padding: const EdgeInsets.all(10),
      clipBehavior: Clip.antiAlias,
      itemBuilder: (BuildContext context, int index) {
        return PokemonSlot(
            pokemon: openedPC.pokemons[index],
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    PreviewPanel previewDialog =
                        PreviewPanel(object: openedPC.pokemons[index]);
                    final showFullScreenDialog =
                        MediaQuery.sizeOf(context).width < 600;
                    if (showFullScreenDialog) {
                      return Dialog.fullscreen(child: previewDialog);
                    } else {
                      return Dialog(
                          child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 600),
                              child: previewDialog));
                    }
                  });
            });
      },
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          crossAxisSpacing: 10, mainAxisSpacing: 10, maxCrossAxisExtent: 300),
    );
  }
}

class SearchAndFilters extends StatelessWidget {
  const SearchAndFilters({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SearchBar(),
          const SizedBox(width: 7.0),
          DropdownMenu<String>(
            initialSelection: "alphabetical",
            dropdownMenuEntries: const [
              DropdownMenuEntry<String>(
                  value: "alphabetical", label: "Alphabetical"),
              DropdownMenuEntry<String>(value: "id", label: "SpeciesID"),
            ],
            onSelected: (String? value) {
              print(value);
            },
          ),
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.arrow_downward_rounded),
              selectedIcon: const Icon(Icons.arrow_upward_rounded)),
        ]);
  }
}

class PokeDexView extends Destination {
  PokeDexView({super.key});

  @override
  Icon get destinationIcon => const Icon(Icons.phone_android_sharp);

  @override
  String get destinationLabel => 'Pokédex';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: PokeAPI.fetchAmountOfEntries("pokemon_species"),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
                child: AspectRatio(
                    aspectRatio: 1, child: CircularProgressIndicator()));
          }
          return ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: snapshot.requireData,
            itemBuilder: (context, index) {
              return SpeciesEntry(
                  species: PokeAPI.fetchSpecies(index + 1, false),
                  onTap: () {
                    print(index);
                  });
            },
          );
        });
  }
}

mixin Destinations {
  // ignore: non_constant_identifier_names
  List<Destination> destinations_widgets = [PCView(), PokeDexView()];

  int selectedIndex = 0;

  List<NavigationRailDestination> getDestinationsForRail() {
    List<NavigationRailDestination> destinations = [];
    for (Destination destination in destinations_widgets) {
      destinations.add(NavigationRailDestination(
          icon: destination.destinationIcon,
          label: Text(destination.destinationLabel)));
    }
    return destinations;
  }

  List<NavigationDestination> getDestinationsForBar() {
    List<NavigationDestination> destinations = [];
    for (Destination destination in destinations_widgets) {
      destinations.add(NavigationDestination(
          icon: destination.destinationIcon,
          label: destination.destinationLabel));
    }
    return destinations;
  }
}
