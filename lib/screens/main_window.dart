import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:desktop_lifecycle/desktop_lifecycle.dart';
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';


class MainWindow extends StatefulWidget {
  const MainWindow({Key? key}) : super(key: key);
  @override
  State<MainWindow> createState() => MainWindowState();
}

class MainWindowState extends State<MainWindow> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Center(
        child: Text('Welcome to Pokemon Manager!'),
      ),
    );
  }
}



