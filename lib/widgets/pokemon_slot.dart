import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_manager_backend/pokemon_manager.dart';

class PokemonSlot extends StatelessWidget {
  const PokemonSlot({super.key, required this.pokemon, required this.onTap});
  final Pokemon pokemon;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          onTap();
        },
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
                            const Icon(Icons.error),
                        filterQuality: FilterQuality.none))),
            Text(pokemon.getNickname())
          ]),
        ));
  }
}
