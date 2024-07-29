import 'package:flutter/widgets.dart';
import 'package:mudkip_frontend/universal_builder.dart';

/// # `Class` AsyncPlaceholder extends `StatelessWidget`
/// ## A widget that displays a placeholder while a future is loading.
/// Shows a circular progress indicator while the future is loading.
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
                    child: UniversalCircularProgressIndicator()),
              ),
            ));
          }
          return childBuilder(snapshot.requireData!);
        });
  }
}
