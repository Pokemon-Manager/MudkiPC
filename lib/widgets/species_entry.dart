import 'package:flutter/material.dart';
import 'package:mudkip_frontend/pokemon_manager.dart';
import 'package:mudkip_frontend/widgets/async_placeholder.dart';
import 'package:mudkip_frontend/widgets/text_with_loader.dart';

/// # `Class` SpeciesEntry extends `StatelessWidget`
/// ## A widget that displays a pokemon in the PC.
/// Shows the pokemon's sprite and the pokemon's name.
/// Takes in a `species` and `onTap` function.
/// The `onTap` function is called when the pokemon is clicked.
/// The `species` is used to fetch the pokemon from the PC.
class SpeciesEntry extends StatelessWidget {
  const SpeciesEntry({super.key, required this.species, required this.onTap});
  final Future<Species?> species;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 4.0),
      child: ElevatedButton(
          onPressed: () => onTap(),
          child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: AsyncPlaceholder(
                future: species,
                childBuilder: (species) => Row(children: [
                  SizedBox(
                    height: 96,
                    width: 96,
                    child: Image(
                      filterQuality: FilterQuality.none,
                      image: AssetImage(
                          "assets/images/sprites/${species.getId()}.png"),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  TextWithLoaderBuffer(
                      future: species.getName(),
                      builder: (context, name) => Text(
                            name,
                            textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.titleMedium,
                          ))
                ]),
              ))),
    );
  }

  void dispose() {
    species.ignore();
  }
}
