import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TextWithLoaderBuffer extends StatelessWidget {
  Future<String> future;
  Text text;
  TextWithLoaderBuffer({super.key, required this.future, required this.text});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        print(snapshot);
        if (snapshot.hasData) {
          return Text(snapshot.requireData,
              style: text.style,
              textAlign: text.textAlign,
              overflow: text.overflow,
              softWrap: text.softWrap,
              textWidthBasis: text.textWidthBasis,
              textHeightBehavior: text.textHeightBehavior,
              maxLines: text.maxLines);
        } else {
          return const AspectRatio(
              aspectRatio: 1,
              child: Center(
                child: CircularProgressIndicator(),
              ));
        }
      },
    );
  }
}
