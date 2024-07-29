import 'package:flutter/widgets.dart';
import 'package:mudkip_frontend/universal_builder.dart';

// ignore: must_be_immutable

///# `Class` TextWithLoaderBuffer extends `StatelessWidget`
///## A widget that displays a buffer bar while a future string is loading.
/// Shows a linear progress indicator while the future is loading.
/// Takes in a `future` and `builder` function.
/// `builder` is a function that takes in a `context` and `string` and returns a `Widget`, and should be a text widget.
/// `future` is a future that returns a string.

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
                child: UniversalLinearProgressIndicator(),
              ));
        }
      },
    );
  }
}
