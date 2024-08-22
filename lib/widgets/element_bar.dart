import 'package:flutter/widgets.dart';
import 'package:mudkip_frontend/mudkipc.dart';
import 'package:mudkip_frontend/widgets/async_placeholder.dart';

/// # `Class` ElementBar extends `StatelessWidget`
/// ## A widget that displays the element types of a pokemon.
/// Shows each type as a chip.
class ElementBar extends StatelessWidget {
  final Future<Typing> typing;
  const ElementBar({super.key, required this.typing});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: AsyncPlaceholder(
        future: typing,
        childBuilder: (typing) {
          return Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: getElements(typing),
              ));
        },
      ),
    );
  }

  List<Widget> getElements(Typing typing) {
    List<Widget> elements = [];
    if (typing.isSingleType()) {
      elements.add(typing.getType1().getChip());
    } else {
      elements.add(typing.getType1().getChip());
      elements.add(typing.getType2()!.getChip());
    }
    return elements;
  }
}
