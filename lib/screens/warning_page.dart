import 'package:flutter/material.dart';

// ignore: must_be_immutable
class WarningPage extends StatelessWidget {
  WarningPage(
      {super.key,
      required this.title,
      required this.description,
      required this.icon});

  String title = "In development";
  String description = "This feature is not yet implemented.";
  IconData icon = Icons.notification_important_rounded;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(Icons.notification_important_rounded, size: 100),
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        Text(description, style: Theme.of(context).textTheme.titleMedium)
      ],
    ));
  }
}
