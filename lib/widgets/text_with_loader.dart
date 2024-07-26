import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TextWithLoaderBuffer extends StatelessWidget {
  Future<String> future;
  Function builder;
  TextWithLoaderBuffer(
      {super.key, required this.future, required this.builder});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return builder(context, snapshot.requireData);
        } else {
          return const AspectRatio(
              aspectRatio: 1,
              child: Center(
                child: LinearProgressIndicator(),
              ));
        }
      },
    );
  }
}
