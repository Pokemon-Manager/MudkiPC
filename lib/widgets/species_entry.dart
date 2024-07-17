import 'package:flutter/material.dart';
import 'package:mudkip_frontend/pokemon_manager.dart';
import 'package:mudkip_frontend/widgets/text_with_loader.dart';

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
            child: FutureBuilder(
                future: species,
                builder: (buildContext, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                        child: AspectRatio(
                            aspectRatio: 1,
                            child: CircularProgressIndicator()));
                  } else if (snapshot.requireData == null) {
                    return const SizedBox();
                  }
                  return Row(children: [
                    SizedBox(
                      height: 96,
                      width: 96,
                      child: Image(
                        filterQuality: FilterQuality.none,
                        image: AssetImage(
                            "assets/images/sprites/${snapshot.requireData!.getId()}.png"),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    TextWithLoaderBuffer(
                        future: snapshot.requireData!.getName(),
                        text: Text(
                          "",
                          textAlign: TextAlign.left,
                          style: Theme.of(context).textTheme.titleMedium,
                        ))
                  ]);
                }),
          )),
    );
  }
}
