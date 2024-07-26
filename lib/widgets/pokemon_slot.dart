import 'package:flutter/material.dart';
import 'package:mudkip_frontend/pokemon_manager.dart';
import 'package:mudkip_frontend/widgets/async_placeholder.dart';
import 'package:mudkip_frontend/widgets/text_with_loader.dart';

class PokemonSlot extends StatelessWidget {
  const PokemonSlot({super.key, required this.uniqueID, required this.onTap});
  final int uniqueID;
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
            future: PC.fetchPokemon(uniqueID),
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
