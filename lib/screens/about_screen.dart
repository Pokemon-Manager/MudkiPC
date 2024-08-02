import 'package:flutter/material.dart' as material;
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:macos_ui/macos_ui.dart' as macos;
import 'package:flutter/widgets.dart';

import 'package:mudkip_frontend/universal_builder.dart';
import 'package:mudkip_frontend/core/file_handles.dart';
import 'package:mudkip_frontend/main.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget with UniversalBuilder {
  const AboutScreen({super.key});

  @override
  Widget buildAndroid(BuildContext context) {
    return material.Scaffold(
        appBar: material.AppBar(
          title: const Text("About"),
        ),
        body: Container(
          padding: const EdgeInsets.all(8.0),
          child: buildMarkdown(),
        ));
  }

  @override
  Widget buildWindows(BuildContext context) {
    return fluent.ScaffoldPage(
        header: const Text("About"),
        content: material.Padding(
          padding: const EdgeInsets.all(8.0),
          child: buildMarkdown(),
        ));
  }

  @override
  Widget buildMacOS(BuildContext context) {
    return macos.MacosScaffold(children: [buildMarkdown()]);
  }

  Widget buildMarkdown() => MarkdownWidget(
        data: """
#### MudkiPC
##### Version ${packageInfo.version}
###### Made with ❤️ by [DrRetro](https://github.com/DrRetro2033)
---
##### Developed with Flutter:
Flutter is an open-source UI toolkit for building beautiful, natively compiled, multi-platform applications on the web, desktop, iOS, and Android.

##### Currently Supported File Formats:
  ${FileHandle.compatibleExtensions.map((e) => "- *.$e").join("\n  ")}

##### Credits:
- [Flutter](https://flutter.dev/)
- [Dart](https://dart.dev/)
- [PokeAPI](https://pokeapi.co/)
- [Flutter Markdown](https://pub.dev/packages/flutter_markdown)
- [fl_chart](https://pub.dev/packages/fl_chart)
- [url_launcher](https://pub.dev/packages/url_launcher)
- [package_info_plus](https://pub.dev/packages/package_info_plus)
- [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons)
- [rename_app](https://pub.dev/packages/rename_app)
- [sqflite](https://pub.dev/packages/sqflite)
- [sqflite_common_ffi](https://pub.dev/packages/sqflite_common_ffi)
- [sqflite_common_ffi_web](https://pub.dev/packages/sqflite_common_ffi_web)
- [file_picker](https://pub.dev/packages/file_picker)
- [desktop_multi_window](https://pub.dev/packages/desktop_multi_window)
- [go_router](https://pub.dev/packages/go_router)

The icon for the alpha version of the app was made by [Jedflah](https://www.deviantart.com/jedflah). It is subject to change.

##### Copyrights:

Copyright (c) © 2013–2023 Paul Hallett and PokéAPI contributors (https://github.com/PokeAPI/pokeapi#contributing). Pokémon and Pokémon character names are trademarks of Nintendo.

""",
        config: MarkdownConfig(configs: [
          LinkConfig(
            onTap: (url) async {
              if (await canLaunchUrl(Uri.parse(url))) {
                await launchUrl(Uri.parse(url));
              }
            },
          ),
          const H4Config(
            style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.none),
          ),
          const H5Config(
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.none),
          ),
          const H6Config(
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.none),
          ),
        ]),
        padding: const EdgeInsets.all(20),
        markdownGenerator: MarkdownGenerator(
            linesMargin: const EdgeInsets.symmetric(vertical: 1.25)),
      );
}
