import 'package:flutter/material.dart' as material;
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:macos_ui/macos_ui.dart' as macos;
import 'package:flutter/cupertino.dart' as cupertino;
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:mudkip_frontend/main.dart';
// import 'package:mudkip_frontend/pokemon_manager.dart';
import 'package:mudkip_frontend/universal_builder.dart';

// ignore: must_be_immutable
class AppShell extends StatefulWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  AppShellState createState() => AppShellState();
}

class AppShellState extends State<AppShell> with UniversalBuilder {
  int _selectedIndex = 0;

  @override
  Widget buildAndroid(BuildContext context) {
    final showRail = MediaQuery.of(context).size.width >= 600;
    return material.Scaffold(
      appBar: material.AppBar(title: const Text('MudkiPC'), actions: const [
        UniversalSearchBar(),
        // SizedBox(width: 20),
      ]),
      drawer: material.Drawer(
          width: 300,
          child: ListView(
            children: [
              material.ListTile(
                title: const Text("Settings"),
                leading: const Icon(material.Icons.settings),
                onTap: () {
                  context.push("/settings");
                },
              ),
              material.ListTile(
                title: const Text("About"),
                leading: const Icon(material.Icons.info),
                onTap: () {
                  context.push("/about");
                },
              ),
            ],
          )),
      bottomNavigationBar: showRail
          ? const SizedBox()
          : BottomNavBar(
              index: _selectedIndex,
              onDestinationSelected: (int index) {
                _selectedIndex = index;
                context.go(Destinations.getPath(index));
              },
            ),
      body: Row(
        children: [
          if (showRail)
            SideNavRail(
              index: _selectedIndex,
              onDestinationSelected: (int index) {
                _selectedIndex = index;
                context.go(Destinations.getPath(index));
              },
            ),
          Expanded(
            child: widget.child,
          ),
        ],
      ),
    );
  }

  @override
  Widget buildWindows(BuildContext context) {
    return fluent.NavigationView(
      pane: fluent.NavigationPane(
          autoSuggestBox: const UniversalSearchBar(),
          selected: _selectedIndex,
          items: Destinations.getDestinationsForWindowsPane(widget.child),
          onItemPressed: (int index) {
            _selectedIndex = index;
            context.go(Destinations.getPath(index));
          }),
      appBar: const fluent.NavigationAppBar(
          title: Text("MudkiPC",
              style: TextStyle(
                  fontSize: 32, fontWeight: material.FontWeight.bold)),
          leading: null,
          automaticallyImplyLeading: false),
    );
  }

  @override
  Widget buildMacOS(BuildContext context) {
    return macos.MacosWindow(
      sidebar: macos.Sidebar(
        top: const UniversalSearchBar(),
        bottom: Row(children: [
          macos.MacosIconButton(
              icon: const Icon(cupertino.CupertinoIcons.settings),
              onPressed: () {
                context.push("/settings");
              })
        ]),
        builder: (context, scrollController) {
          return macos.SidebarItems(
              items: Destinations.getDestinationsForMacOS(),
              currentIndex: _selectedIndex,
              onChanged: (int index) {
                _selectedIndex = index;
                context.go(Destinations.getPath(index));
              });
        },
        minWidth: 300,
      ),
      child: widget.child,
    );
  }
}

// ignore: must_be_immutable
class BottomNavBar extends StatelessWidget {
  BottomNavBar(
      {super.key, required this.onDestinationSelected, required this.index});
  int index;

  Function onDestinationSelected;
  @override
  Widget build(BuildContext context) {
    return material.BottomNavigationBar(
      currentIndex: index,
      elevation: 80.0,
      onTap: (int index) {
        onDestinationSelected(index);
      },
      items: Destinations.getDestinationsForBar(),
    );
  }
}

// ignore: must_be_immutable
class SideNavRail extends StatelessWidget {
  SideNavRail(
      {super.key, required this.onDestinationSelected, required this.index});
  int index;

  Function onDestinationSelected;
  @override
  Widget build(BuildContext context) {
    return material.NavigationRail(
      selectedIndex: index,
      onDestinationSelected: (int index) {
        onDestinationSelected(index);
      },
      labelType: material.NavigationRailLabelType.all,
      destinations: Destinations.getDestinationsForRail(),
    );
  }
}

class Destination {
  String label;
  Map<String, IconData> icons;
  List<fluent.CommandBarItem>? actions = [];
  String path;

  Destination(
      {required this.label,
      required this.icons,
      required this.path,
      required this.actions});
}

class PCDestination extends Destination {
  PCDestination()
      : super(
            label: 'PC',
            icons: {
              "android": material.Icons.grid_view_rounded,
              "windows": fluent.FluentIcons.grid_view_medium,
              "macos": cupertino.CupertinoIcons.square_grid_2x2,
            },
            path: '/pc',
            actions: [
              fluent.CommandBarBuilderItem(
                  builder: (context, wrappedItem, child) =>
                      const fluent.Tooltip(message: "Add to PC"),
                  wrappedItem: fluent.CommandBarButton(
                      onPressed: () {
                        // print("Add to PC");
                      },
                      icon: const fluent.Icon(fluent.FluentIcons.add))),
            ]);
}

class PokeDexDestination extends Destination {
  PokeDexDestination()
      : super(
            label: 'PokéDex',
            icons: {
              "android": material.Icons.phone_android_rounded,
              "windows": fluent.FluentIcons.book_answers,
              "macos": cupertino.CupertinoIcons.book,
            },
            path: '/pokedex',
            actions: []);
}

class Destinations {
  static List<Destination> destinations = [
    PCDestination(),
    PokeDexDestination(),
  ];

  static List<material.NavigationRailDestination> getDestinationsForRail() {
    List<material.NavigationRailDestination> destinationsWigets = [];
    for (Destination destination in destinations) {
      destinationsWigets.add(material.NavigationRailDestination(
          icon: Icon(destination.icons["android"]),
          label: Text(destination.label)));
    }
    return destinationsWigets;
  }

  static List<material.BottomNavigationBarItem> getDestinationsForBar() {
    List<material.BottomNavigationBarItem> destinationsWigets = [];
    for (Destination destination in destinations) {
      destinationsWigets.add(BottomNavigationBarItem(
          icon: Icon(destination.icons["android"], size: 25.0),
          label: destination.label));
    }
    return destinationsWigets;
  }

  static List<fluent.NavigationPaneItem> getDestinationsForWindowsPane(
      Widget child) {
    List<fluent.NavigationPaneItem> destinationsWidgets = [];
    for (Destination destination in destinations) {
      destinationsWidgets.add(fluent.PaneItem(
          icon: Icon(destination.icons["windows"]),
          title: Text(destination.label),
          body: child));
    }
    destinationsWidgets.add(fluent.PaneItemSeparator());
    destinationsWidgets.add(fluent.PaneItemAction(
        icon: const Icon(fluent.FluentIcons.settings),
        onTap: () {
          router.push('/settings');
        },
        title: const Text("Settings")));
    return destinationsWidgets;
  }

  static List<macos.SidebarItem> getDestinationsForMacOS() {
    List<macos.SidebarItem> destinationsWigets = [];
    for (Destination destination in destinations) {
      destinationsWigets.add(macos.SidebarItem(
          leading: Center(child: Icon(destination.icons["macos"])),
          label: Text(destination.label)));
    }
    return destinationsWigets;
  }

  static String getPath(int index) => destinations[index].path;
}
