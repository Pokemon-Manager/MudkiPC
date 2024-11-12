import "package:flutter/material.dart";
import "package:mudkip_frontend/core/pokemon.dart";
import "package:mudkip_frontend/widgets/async_placeholder.dart";
import "package:mudkip_frontend/widgets/text_with_loader.dart";

class PokemonSlot extends StatelessWidget {
  final Future<Pokemon> pokemon;
  final Function(Future<Pokemon>) onTap;
  const PokemonSlot({super.key, required this.pokemon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onTap(pokemon),
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AsyncPlaceholder(
            future: pokemon,
            childBuilder: (Pokemon value) {
              return Column(children: [
                Expanded(
                  child: getImage(value),
                ),
                TextWithLoaderBuffer(
                    future: value.getNickname(),
                    builder: (context, name) => Text(name))
              ]);
            },
          )),
    );
  }

  Widget getImage(Pokemon value) {
    try {
      return Image(
          width: 150,
          height: 150,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.none,
          image: value.getSprite());
    } catch (_) {
      return const Icon(Icons.question_mark_rounded);
    }
  }
}
