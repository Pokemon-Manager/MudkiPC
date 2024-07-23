import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mudkip_frontend/pokemon_manager.dart';
import 'package:mudkip_frontend/theme/theme_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
            title: Text("General"),
            dense: true,
          ),
          ListTile(
              title: const Text("Dark Mode"),
              trailing: Switch.adaptive(
                  value: themeProvider.themeMode == ThemeMode.dark,
                  onChanged: (theme) {
                    final provider =
                        Provider.of<ThemeManager>(context, listen: false);
                    print(theme);
                    provider.toggleTheme(theme);
                  })),
          const Divider(),
          const ListTile(
            title: Text("Data Management"),
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
            title: Text("Debugging"),
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
