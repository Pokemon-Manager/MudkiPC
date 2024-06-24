import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_manager/pokemon_manager.dart';

class PokemonSlot extends StatelessWidget {
  const PokemonSlot({super.key, required this.pokemon});
  final Pokemon pokemon;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {},
        child: Tooltip(
            message: pokemon.getSpecies().getName().capitalize(),
            enableTapToDismiss: false,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: [
                Expanded(
                    child: FittedBox(
                        fit: BoxFit.cover,
                        child: CachedNetworkImage(
                            imageUrl: pokemon.getSpecies().getFrontImageUrl(),
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error)))),
                Text(pokemon.getNickname())
              ]),
            )));
  }
}
