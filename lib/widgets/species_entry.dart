import "package:flutter/material.dart";
import "package:mudkip_frontend/core/species.dart";
import "package:mudkip_frontend/widgets/async_placeholder.dart";
import "package:mudkip_frontend/widgets/text_with_loader.dart";

class SpeciesEntry extends StatelessWidget {
  const SpeciesEntry({super.key, required this.species, required this.onTap});
  final Future<Species?> species;
  final Function(Future<Species?>) onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 100,
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 4.0),
        child: ElevatedButton(
            onPressed: () => onTap(species),
            child: AsyncPlaceholder(
                future: species,
                childBuilder: (Species value) => Row(
                      children: [
                        SizedBox(
                            width: 96,
                            height: 96,
                            child: Image(
                                filterQuality: FilterQuality.none,
                                image: value.getSprite())),
                        const SizedBox(width: 10.0),
                        TextWithLoaderBuffer(
                            future: value.getName(),
                            builder: (context, name) => Text(
                                  name,
                                  textAlign: TextAlign.left,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ))
                      ],
                    ))));
  }
}
