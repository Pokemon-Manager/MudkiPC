import 'package:flutter/material.dart';

class SetupNotifier extends StatefulWidget {
  const SetupNotifier({super.key});
  @override
  SetupNotifierState createState() => SetupNotifierState();
}

// ignore: must_be_immutable
class SetupNotifierState extends State<SetupNotifier> {
  String text = "Setting up...";

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Expanded(
          child: FittedBox(
        fit: BoxFit.contain,
        alignment: Alignment.center,
        child: Container(
            width: 200,
            height: 150,
            decoration: BoxDecoration(
              color: ThemeData.dark().scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: ThemeData.dark().shadowColor,
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            child: Center(
                child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Text(
                  text,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      decoration: TextDecoration.none),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 10,
                ),
                const CircularProgressIndicator(),
                const SizedBox(
                  height: 10,
                ),
              ],
            ))),
      )),
    );
  }
}
