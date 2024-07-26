import 'package:flutter/material.dart';

class AsyncPlaceholder extends StatelessWidget {
  const AsyncPlaceholder(
      {super.key, required this.future, required this.childBuilder});
  final Future future;
  final Function childBuilder;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
                child: AspectRatio(
              aspectRatio: 1.0,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator()),
              ),
            ));
          }
          return childBuilder(snapshot.requireData!);
        });
  }
}
