import 'package:flutter/material.dart';
import 'package:mudkip_frontend/widgets/element_bar.dart';
import 'package:mudkip_frontend/widgets/stat_chart.dart';
import 'package:mudkip_frontend/widgets/text_with_loader.dart';
import 'package:mudkip_frontend/pokemon_manager.dart';

// ignore: must_be_immutable
class PreviewPanel extends StatelessWidget {
  Future<Object?> object;
  PreviewPanel({super.key, required this.object});

  @override
  Widget build(BuildContext context) {
    if (object is Future<Pokemon>) {
      return FutureBuilder(
          future: object,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                  child: SizedBox(
                child: AspectRatio(
                    aspectRatio: 1, child: CircularProgressIndicator()),
              ));
            }
            Pokemon pokemon = snapshot.requireData as Pokemon;
            return PreviewInfo(
                title: pokemon.getSpecies().getName(),
                subtitle: pokemon.getNickname(),
                imageUrl: pokemon.getSpecies().getFrontImageUrl(),
                description: pokemon.getSpecies().getDescription(),
                baseStats: pokemon.species.getBaseStats(),
                effortStats: pokemon.getEvStats(),
                individualStats: pokemon.getIvStats(),
                typing: pokemon.getSpecies().getTyping());
          });
    } else if (object is Future<Species?>) {
      return FutureBuilder(
          future: object,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                  child: AspectRatio(
                      aspectRatio: 1, child: CircularProgressIndicator()));
            }
            Species species = snapshot.requireData as Species;
            return PreviewInfo(
                title: species.getName(),
                imageUrl: species.getFrontImageUrl(),
                description: species.getDescription(),
                baseStats: species.getBaseStats(),
                typing: species.getTyping());
          });
    }
    return const Placeholder();
  }
}

// ignore: must_be_immutable
class PreviewInfo extends StatelessWidget {
  Future<String> title;
  Future<String>? subtitle;
  String? imageUrl;
  IconData? icon;
  Future<String>? description;
  Future<Stats>? baseStats;
  Stats? effortStats;
  Stats? individualStats;
  Future<Typing>? typing;
  PreviewInfo({
    super.key,
    required this.title,
    required this.description,
    this.subtitle,
    this.icon,
    this.imageUrl,
    this.baseStats,
    this.effortStats,
    this.individualStats,
    this.typing,
  });
  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    if (imageUrl != null) {
      children.add(
        Container(
          height: 250,
          padding: const EdgeInsets.all(5.0),
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
                    image: AssetImage(imageUrl!)),
              ),
            ),
          ),
        ),
      );
    } else if (icon != null) {
      children.add(Icon(icon, size: 100));
    }

    if (typing != null) {
      children.add(Container(
        height: 50,
        padding: const EdgeInsets.all(4.0),
        alignment: Alignment.center,
        child: ElementBar(typing: typing!),
      ));
    }
    children.add(TextWithLoaderBuffer(
        future: title,
        text: const Text(
          "",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
        )));

    if (subtitle != null) {
      children.add(TextWithLoaderBuffer(
          future: subtitle!,
          text: Text(
            "",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          )));
    }
    if (description != null) {
      children.add(TextWithLoaderBuffer(
          future: description!,
          text: Text(
            "",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          )));
    }

    if (baseStats != null) {
      children.add(StatChart(
        base_future: baseStats!,
        ev: effortStats,
        iv: individualStats,
      ));
    }

    return ListView(scrollDirection: Axis.vertical, children: children);
  }
}
