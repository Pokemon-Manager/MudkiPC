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
