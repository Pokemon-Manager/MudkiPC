import 'package:flutter/material.dart';
import 'package:pokemon_manager/pokemon_manager.dart';
import 'package:pokemon_manager/widgets/pokemon_slot.dart';

/// # PokemonBox
/// ## A GridView that displays every [PokemonSlot] in the [pokemons] list from the [openedPC].
class PokemonBox extends StatelessWidget {
  final List<Pokemon> pokemons;
  const PokemonBox({super.key, required this.pokemons});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: pokemons.length,
      padding: const EdgeInsets.all(10),
      itemBuilder: (BuildContext context, int index) {
        return PokemonSlot(pokemon: pokemons[index]);
      },
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          crossAxisSpacing: 10, mainAxisSpacing: 10, maxCrossAxisExtent: 300),
    );
  }
}
