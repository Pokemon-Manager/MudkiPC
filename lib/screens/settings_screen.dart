import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' as material;
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:mudkip_frontend/main.dart';

import 'package:mudkip_frontend/universal_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:mudkip_frontend/pokemon_manager.dart';
import 'package:path_provider/path_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with UniversalBuilder {
  @override
  Widget buildAndroid(BuildContext context) {
    return material.Scaffold(
      appBar: material.AppBar(
        leading: material.BackButton(onPressed: () {
          context.pop();
        }),
        title: const Text("Settings"),
      ),
      body: ListView(
        children: [
          const material.ListTile(
            title: Text("General",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            dense: true,
          ),
          const material.ListTile(
            title: Text("Height Chart",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          material.ListTile(
            title: const Text("Default Human Gender"),
            trailing: material.SegmentedButton(
                showSelectedIcon: false,
                segments: const [
                  material.ButtonSegment(
                      value: HeightChartGender.male,
                      icon: Icon(material.Icons.male_rounded)),
                  material.ButtonSegment(
                      value: HeightChartGender.female,
                      icon: Icon(material.Icons.female_rounded))
                ],
                selected: <HeightChartGender>{Settings.heightChartGender},
                onSelectionChanged: (gender) async {
                  await Settings.setHeightChartGender(gender.first);
                  setState(() {});
                }),
          ),
          material.ListTile(
              title: const Text("Length Format"),
              trailing: material.SegmentedButton(
                  segments: const [
                    material.ButtonSegment(
                        value: HeightChartFormat.metric, label: Text("Metric")),
                    material.ButtonSegment(
                        value: HeightChartFormat.imperial,
                        label: Text("Imperial"))
                  ],
                  selected: <HeightChartFormat>{
                    Settings.heightChartFormat
                  },
                  onSelectionChanged: (format) async {
                    await Settings.setHeightChartFormat(format.first);
                    setState(() {});
                  })),
          const material.Divider(),
          const material.ListTile(
            title: Text("Data Management",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            dense: true,
          ),
          material.ListTile(
            title: const Text("Clear Global Database Cache"),
            subtitle: const Text(
                "Deletes the Global database cache and recreates it. Useful for if you have an old version of the database cache, or if you have a corrupted cache."),
            onTap: () {
              PokeAPI.recreate();
            },
          ),
          material.ListTile(
            title: const Text("Clear User Database"),
            subtitle: const Text(
                "Deletes the user database (i.e. All data parsed from files, like your pokemon, trainers, and save backups). Files are not affected, however be sure to back up your save files before doing this just in case."),
            onTap: () {
              PC.recreate();
            },
          ),
          const material.Divider(),
          const material.ListTile(
            title: Text("Debugging",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            dense: true,
          ),
          material.ListTile(
              title: const Text("Global.db Cache Path"),
              subtitle: FutureBuilder(
                future: getApplicationCacheDirectory(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data!.path);
                  } else {
                    return const Text("Loading...");
                  }
                },
              )),
          material.ListTile(
              title: const Text("User Path"),
              subtitle: FutureBuilder(
                future: getApplicationDocumentsDirectory(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data!.path);
                  } else {
                    return const Text("Loading...");
                  }
                },
              )),
        ],
      ),
    );
  }

  @override
  Widget buildWindows(BuildContext context) {
    return fluent.NavigationView(
      appBar: fluent.NavigationAppBar(
        leading: SizedBox(
          width: 40,
          height: 40,
          child: fluent.IconButton(
              icon: const Icon(fluent.FluentIcons.back),
              onPressed: () {
                router.pop();
              }),
        ),
        title: const Text("Settings"),
      ),
      content: ListView(
        children: [
          const fluent.ListTile(
            title: Text("General",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ),
          const fluent.ListTile(
            title: Text("Height Chart",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          fluent.ListTile(
            title: const Text("Default Human Gender"),
            trailing: fluent.DropDownButton(
              title: Text(Settings.heightChartGenderAsString),
              items: [
                fluent.MenuFlyoutItem(
                  onPressed: () {
                    setState(() {
                      Settings.setHeightChartGender(HeightChartGender.male);
                    });
                  },
                  text: const Text("Male"),
                ),
                fluent.MenuFlyoutItem(
                  onPressed: () {
                    setState(() {
                      Settings.setHeightChartGender(HeightChartGender.female);
                    });
                  },
                  text: const Text("Female"),
                ),
              ],
            ),
          ),
          fluent.ListTile(
              title: const Text("Length Format"),
              trailing: fluent.DropDownButton(
                  title: Text(Settings.heightChartFormatAsString),
                  items: [
                    fluent.MenuFlyoutItem(
                        onPressed: () {
                          setState(() {
                            Settings.setHeightChartFormat(
                                HeightChartFormat.metric);
                          });
                        },
                        text: const Text("Metric")),
                    fluent.MenuFlyoutItem(
                        onPressed: () {
                          setState(() {
                            Settings.setHeightChartFormat(
                                HeightChartFormat.imperial);
                          });
                        },
                        text: const Text("Imperial"))
                  ])),
          const fluent.Divider(),
          const fluent.ListTile(
            title: Text("Data Management",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ),
          fluent.ListTile(
            title: const Text("Clear Global Database Cache"),
            subtitle: const Text(
                "Deletes the Global database cache and recreates it. Useful for if you have an old version of the database cache, or if you have a corrupted cache."),
            onPressed: () {
              PokeAPI.recreate();
            },
          ),
          fluent.ListTile(
            title: const Text("Clear User Database"),
            subtitle: const Text(
                "Deletes the user database (i.e. All data parsed from files, like your pokemon, trainers, and save backups). Files are not affected, however be sure to back up your save files before doing this just in case."),
            onPressed: () {
              PC.recreate();
            },
          ),
          const fluent.Divider(),
          const fluent.ListTile(
            title: Text("Debugging",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ),
          fluent.ListTile(
              title: const Text("Global.db Cache Path"),
              subtitle: FutureBuilder(
                future: getApplicationCacheDirectory(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data!.path);
                  } else {
                    return const Text("Loading...");
                  }
                },
              )),
          fluent.ListTile(
              title: const Text("User Path"),
              subtitle: FutureBuilder(
                future: getApplicationDocumentsDirectory(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data!.path);
                  } else {
                    return const Text("Loading...");
                  }
                },
              )),
        ],
      ),
    );
  }
}
