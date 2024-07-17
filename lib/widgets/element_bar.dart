import 'package:flutter/material.dart';
import 'package:mudkip_frontend/pokemon_manager.dart';

class ElementBar extends StatelessWidget {
  final Future<Typing> typing;
  const ElementBar({super.key, required this.typing});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: FutureBuilder<Typing>(
          future: typing,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                  child: AspectRatio(
                      aspectRatio: 1, child: CircularProgressIndicator()));
            }
            Typing typing = snapshot.requireData;
            return Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: getElements(typing),
                ));
          }),
    );
  }

  List<Widget> getElements(Typing typing) {
    List<Widget> elements = [];
    if (typing.isSingleType()) {
      elements.add(typing.getType1().getChip());
    } else {
      elements.add(typing.getType1().getChip());
      elements.add(
          const Divider(thickness: 8.0, height: 16.0, color: Colors.white));
      elements.add(typing.getType2()!.getChip());
    }
    return elements;
  }
}
