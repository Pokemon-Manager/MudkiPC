import 'package:flutter/material.dart';
import 'package:mudkip_frontend/pokemon_manager.dart';
import 'package:mudkip_frontend/widgets/async_placeholder.dart';
import 'package:mudkip_frontend/widgets/text_with_loader.dart';

/// # `Class` PokemonSlot extends `StatelessWidget`
/// ## A widget that displays a pokemon in the PC.
/// Shows the pokemon's sprite and the pokemon's name.
/// Takes in a `pokemon` and `onTap` function.
/// The `onTap` function is called when the pokemon is clicked.
/// The `pokemon` is the future that returns the pokemon from the PC.
/// ```dart
/// PokemonSlot(pokemon: PC.fetchPokemon(/*The unique ID of the pokemon*/), onTap: () {/*Do something when the pokemon is clicked. Usually a navigation to another screen, especially to the preview screen.*/})
/// ```
class PokemonSlot extends StatelessWidget {
  const PokemonSlot({super.key, required this.pokemon, required this.onTap});
  final Future<Pokemon?> pokemon;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          onTap();
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AsyncPlaceholder(
            future: pokemon,
            childBuilder: (value) {
              return Column(children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    width: 150,
                    height: 150,
                    child: Image(
                      width: 150,
                      height: 150,
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.none,
                      image: AssetImage(
                          "assets/images/sprites/${value!.speciesID}.png"),
                    ),
                  ),
                ),
                TextWithLoaderBuffer(
                    future: value.getNickname(),
                    builder: (context, name) => Text(name)),
              ]);
            },
          ),
        ));
  }
}
