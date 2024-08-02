import 'package:flutter/widgets.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart' as material;
import 'package:macos_ui/macos_ui.dart' as macos;
import 'package:flutter/cupertino.dart' as cupertino;

import 'package:mudkip_frontend/universal_builder.dart';

// ignore: must_be_immutable
class WarningPage extends StatelessWidget with UniversalBuilder {
  WarningPage(
      {super.key,
      required this.title,
      required this.description,
      required this.icon});

  String title = "In development";
  String description = "This feature is not yet implemented.";
  IconData icon = material.Icons.notification_important_rounded;

  @override
  Widget buildAndroid(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(material.Icons.notification_important_rounded, size: 100),
        Text(title, style: material.Theme.of(context).textTheme.titleLarge),
        Text(description,
            style: material.Theme.of(context).textTheme.titleMedium)
      ],
    ));
  }

  @override
  Widget buildWindows(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(fluent.FluentIcons.warning, size: 100),
        Text(title),
        Text(description)
      ],
    ));
  }

  @override
  Widget buildMacOS(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const macos.MacosIcon(cupertino.CupertinoIcons.question_circle_fill,
            size: 75),
        Text(title, style: const TextStyle(fontSize: 24)),
        Text(description)
      ],
    ));
  }
}
