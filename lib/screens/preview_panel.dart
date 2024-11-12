import 'package:flutter/material.dart';
import 'package:mudkip_frontend/widgets/async_placeholder.dart';
import 'package:mudkip_frontend/widgets/element_bar.dart';
import 'package:mudkip_frontend/widgets/height_chart.dart';
import 'package:mudkip_frontend/widgets/stat_chart.dart';
import 'package:mudkip_frontend/widgets/text_with_loader.dart';
import 'package:mudkip_frontend/mudkipc.dart';
import 'package:go_router/go_router.dart';

// ignore: must_be_immutable
class PreviewPanel extends StatelessWidget {
  Future<Object?> object;
  PreviewPanel({super.key, required this.object});

  @override
  Widget build(BuildContext context) {
    Widget previewWidget = const Placeholder();
    if (object is Future<Pokemon>) {
      previewWidget = AsyncPlaceholder(
          future: object,
          childBuilder: (pokemon) {
            return PokemonPreview(pokemon: pokemon);
          });
    } else if (object is Future<Species?>) {
      previewWidget = AsyncPlaceholder(
          future: object,
          childBuilder: (species) {
            return SpeciesPreview(species: species);
          });
    }

    return Scaffold(
        appBar: AppBar(
          leading: BackButton(onPressed: () {
            context.pop();
          }),
          title: const Text("Preview"),
        ),
        body: Container(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
              scrollDirection: Axis.vertical, child: previewWidget),
        ));
  }
}

// ignore: must_be_immutable
class PokemonPreview extends StatelessWidget {
  Pokemon pokemon;
  PokemonPreview({
    super.key,
    required this.pokemon,
  });
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        // The pokemon's sprite. TODO: Add shiny variant sprites to files and add functionlity to switch between them.
        // TODO: Add regional forms support.
        height: 250,
        alignment: Alignment.bottomCenter,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            height: 200,
            width: 200,
            child: AspectRatio(
              aspectRatio: 1,
              child: Image(
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.none,
                  image: AssetImage(
                      "assets/images/sprites/${pokemon.speciesID}.png")),
            ),
          ),
        ),
      ),
      TextWithLoaderBuffer(
          // The pokemon's name.
          future: pokemon.getNickname(),
          builder: (context, name) => Text(name,
              style:
                  const TextStyle(fontSize: 48, fontWeight: FontWeight.bold))),
      Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 48,
              child: AsyncPlaceholder(
                  future: pokemon.getSpecies(),
                  childBuilder: (species) => TextWithLoaderBuffer(
                      future: species!.getName(),
                      builder: (context, name) =>
                          Text(name, style: const TextStyle(fontSize: 24)))),
            ),
            const Center(
              child: SizedBox(
                  height: 28,
                  width: 16,
                  child: Center(
                    child: VerticalDivider(
                      endIndent: 4,
                    ),
                  )),
            ),
            SizedBox(
              height: 48,
              child: Text("#${pokemon.speciesID}",
                  style: TextStyle(
                      fontSize: 24,
                      color: Theme.of(context).textTheme.titleLarge?.color)),
            ),
          ]),
      SizedBox(
          height: 48,
          child: AsyncPlaceholder(
              future: pokemon.getSpecies(),
              childBuilder: (species) {
                return ElementBar(typing: species!.getTyping());
              })),
      AsyncPlaceholder(
          future: pokemon.getSpecies(),
          childBuilder: (species) {
            return StatChart(
              baseFuture: species!.getBaseStats(),
              iv: pokemon.iv,
              ev: pokemon.ev,
            );
          }),
      AsyncPlaceholder(
          future: pokemon.getSpecies(),
          childBuilder: (Species species) {
            return HeightIndicator(
              pokemonHeight: species.height * 1.0,
              imageUrl: "assets/images/sprites/${pokemon.speciesID}.png",
            );
          }),
    ]);
  }
}

// ignore: must_be_immutable
class SpeciesPreview extends StatelessWidget {
  Species species;
  SpeciesPreview({
    super.key,
    required this.species,
  });
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        height: 250,
        alignment: Alignment.bottomCenter,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            height: 200,
            width: 200,
            child: AspectRatio(
              aspectRatio: 1,
              child: Image(
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.none,
                  image: AssetImage("assets/images/sprites/${species.id}.png")),
            ),
          ),
        ),
      ),
      TextWithLoaderBuffer(
          future: species.getName(),
          builder: (context, name) => Text(name,
              style:
                  const TextStyle(fontSize: 48, fontWeight: FontWeight.bold))),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        SizedBox(
          height: 48,
          child: Text("#${species.id}",
              style: TextStyle(
                  fontSize: 24, color: Theme.of(context).secondaryHeaderColor)),
        ),
      ]),
      SizedBox(height: 48, child: ElementBar(typing: species.getTyping())),
      StatChart(
        baseFuture: species.getBaseStats(),
        iv: null,
        ev: null,
      ),
      HeightIndicator(
        pokemonHeight: species.height * 1.0,
        imageUrl: "assets/images/sprites/${species.id}.png",
      ),
    ]);
  }
}
