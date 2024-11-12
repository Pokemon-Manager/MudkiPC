import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mudkip_frontend/mudkipc.dart';
import 'package:mudkip_frontend/theme/theme_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeManager>(context);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () {
          context.pop();
        }),
        title: const Text("Settings"),
      ),
      body: ListView(
        children: [
          const ListTile(
            title: Text("General",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            dense: true,
          ),
          ListTile(
              title: const Text("Dark Mode"),
              trailing: Switch.adaptive(
                  value: themeProvider.themeMode == ThemeMode.dark,
                  onChanged: (theme) {
                    final provider =
                        Provider.of<ThemeManager>(context, listen: false);
                    // print(theme);
                    provider.toggleTheme(theme);
                  })),
          const ListTile(
            title: Text("Height Chart",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          ListTile(
            title: const Text("Default Human Gender"),
            trailing: SegmentedButton(
                showSelectedIcon: false,
                segments: const [
                  ButtonSegment(
                      value: HeightChartGender.male,
                      icon: Icon(Icons.male_rounded)),
                  ButtonSegment(
                      value: HeightChartGender.female,
                      icon: Icon(Icons.female_rounded))
                ],
                selected: <HeightChartGender>{Settings.heightChartGender},
                onSelectionChanged: (gender) async {
                  await Settings.setHeightChartGender(gender.first);
                  setState(() {});
                }),
          ),
          ListTile(
              title: const Text("Length Format"),
              trailing: SegmentedButton(
                  segments: const [
                    ButtonSegment(
                        value: HeightChartFormat.metric, label: Text("Metric")),
                    ButtonSegment(
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
          const Divider(),
          const ListTile(
            title: Text("Data Management",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            dense: true,
          ),
          ListTile(
            title: const Text("Clear Database Cache"),
            subtitle: const Text(
                "Deletes the database cache and recreates it. Useful for when any data is corrupted. Userdata is not affected."),
            onTap: () {
              PokeAPI.recreate();
            },
          ),
          ListTile(
            title: const Text("Clear User Database"),
            subtitle: const Text(
                "Deletes the user database (i.e. All data parsed from files, like your pokemon, trainers, and save backups). Files are not affected, however be sure to back up your save file before doing this."),
            onTap: () {
              PC.recreate();
            },
          ),
          const Divider(),
          const ListTile(
            title: Text("Debugging",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            dense: true,
          ),
          ListTile(
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
          ListTile(
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
