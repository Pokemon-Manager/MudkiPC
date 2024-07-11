import 'package:flutter/material.dart';
import 'package:mudkip_frontend/main.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text("About"),
      ),
      body: buildMarkdown());

  Widget buildMarkdown() => MarkdownWidget(
        data: """
#### MudkiPC
##### Version ${packageInfo.version}
###### Made with ❤️ by [DrRetro](https://github.com/DrRetro2033)
---
##### Developed with Flutter:
Flutter is an open-source UI toolkit for building beautiful, natively compiled, multi-platform applications on the web, desktop, iOS, and Android.

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
- [window_manager](https://pub.dev/packages/window_manager)

The icon for the alpha version of the app was made by [Jedflah](https://www.deviantart.com/jedflah). It is subject to change.
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
