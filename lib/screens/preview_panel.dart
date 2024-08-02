import 'package:flutter/material.dart' as material;
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:macos_ui/macos_ui.dart' as macos;
// import 'package:flutter/cupertino.dart' as cupertino;
import 'package:flutter/widgets.dart';
import 'package:mudkip_frontend/universal_builder.dart';

import 'package:mudkip_frontend/widgets/async_placeholder.dart';
import 'package:mudkip_frontend/widgets/element_bar.dart';
import 'package:mudkip_frontend/widgets/height_chart.dart';
import 'package:mudkip_frontend/widgets/stat_chart.dart';
import 'package:mudkip_frontend/widgets/text_with_loader.dart';
import 'package:mudkip_frontend/pokemon_manager.dart';
import 'package:go_router/go_router.dart';

// ignore: must_be_immutable
class PreviewPanel extends StatelessWidget with UniversalBuilder {
  Future<Object?> object;
  PreviewPanel({super.key, required this.object});
  Widget? previewWidget;

  @override
  Widget build(BuildContext context) {
    previewWidget = const Placeholder();
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
    return super.build(context);
  }

  @override
  Widget buildAndroid(material.BuildContext context) {
    return material.Scaffold(
        appBar: material.AppBar(
          leading: material.BackButton(onPressed: () {
            context.pop();
          }),
          title: const Text("Preview"),
        ),
        body: getPreviewContent());
  }

  @override
  Widget buildWindows(BuildContext context) {
    return fluent.NavigationView(
        appBar: fluent.NavigationAppBar(
            leading: fluent.IconButton(
                icon: const Icon(fluent.FluentIcons.back),
                onPressed: () {
                  context.pop();
                })),
        content: getPreviewContent());
  }

  @override
  Widget buildMacOS(BuildContext context) {
    return macos.MacosScaffold(
        toolBar: const macos.ToolBar(
          title: Text("Preview"),
        ),
        children: [
          macos.ContentArea(
              builder: (context, scrollController) => getPreviewContent())
        ]);
  }

  Widget getPreviewContent() {
    return Container(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical, child: previewWidget));
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
    Future<Species?> speciesFuture = pokemon.getSpecies();
    return AsyncPlaceholder(
      future: speciesFuture,
      childBuilder: (species) => Column(children: [
        Container(
          // The pokemon's sprite.
          // TODO: Add shiny variant sprites to files and add functionlity to switch between them.
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
                style: const TextStyle(
                    fontSize: 48, fontWeight: FontWeight.bold))),
        Row(
            // The pokemon's species name and ID.
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                // The pokemon's species name.
                height: 48,
                child: TextWithLoaderBuffer(
                    future: species!.getName(),
                    builder: (context, name) =>
                        Text(name, style: const TextStyle(fontSize: 24))),
              ),
              const Center(
                // The divider between the name and ID.
                child: SizedBox(
                    height: 28,
                    width: 16,
                    child: Center(
                      child: material.VerticalDivider(
                        endIndent: 4,
                      ),
                    )),
              ),
              SizedBox(
                // The pokemon's ID.
                height: 48,
                child: Text("#${pokemon.speciesID}",
                    style: TextStyle(
                        fontSize: 24,
                        color:
                            material.Theme.of(context).secondaryHeaderColor)),
              ),
            ]),
        SizedBox(
            height: 48,
            child: ElementBar(
                typing: species!.getTyping())), // The typing of the pokemon.
        StatChart(
          // The stats of the pokemon.
          baseFuture: species!.getBaseStats(),
          iv: pokemon.iv,
          ev: pokemon.ev,
        ),
        HeightIndicator(
          // The height of the pokemon.
          pokemonHeight: species.height * 1.0,
          imageUrl: "assets/images/sprites/${pokemon.speciesID}.png",
        ),
      ]),
    );
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
        // The species's sprite.
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
          // The species's name.
          future: species.getName(),
          builder: (context, name) => Text(name,
              style:
                  const TextStyle(fontSize: 48, fontWeight: FontWeight.bold))),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        // The species's ID.
        SizedBox(
          height: 48,
          child: Text("#${species.id}",
              style: TextStyle(
                  fontSize: 24,
                  color: material.Theme.of(context).secondaryHeaderColor)),
        ),
      ]),
      SizedBox(
          height: 48,
          child: ElementBar(
              typing: species.getTyping())), // The typing of the species.
      StatChart(
        // The stats of the species.
        baseFuture: species.getBaseStats(),
        iv: null,
        ev: null,
      ),
      HeightIndicator(
        // The height of the species.
        pokemonHeight: species.height * 1.0,
        imageUrl: "assets/images/sprites/${species.id}.png",
      ),
    ]);
  }
}
