import 'package:flutter/material.dart';
import 'package:mudkip_frontend/widgets/async_placeholder.dart';
import 'package:mudkip_frontend/widgets/element_bar.dart';
import 'package:mudkip_frontend/widgets/stat_chart.dart';
import 'package:mudkip_frontend/widgets/text_with_loader.dart';
import 'package:mudkip_frontend/pokemon_manager.dart';
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
            return PreviewInfo(
                title: pokemon.getNickname() as Future<String>,
                subtitle: pokemon
                    .getSpecies()
                    .then<String>((value) => (value! as Species).getName()),
                imageUrl: "assets/images/sprites/${pokemon.speciesID}.png",
                description: pokemon.getSpecies().then<String>(
                        (value) => (value! as Species).getDescription())
                    as Future<String>?,
                baseStats: pokemon.getSpecies().then<Stats>(
                        (value) => (value! as Species).getBaseStats())
                    as Future<Stats>?,
                effortStats: pokemon.getEvStats() as Stats,
                individualStats: pokemon.getIvStats() as Stats,
                typing: pokemon.getSpecies().then<Typing>(
                        (value) => (value! as Species).getTyping())
                    as Future<Typing>?);
          });
    } else if (object is Future<Species?>) {
      previewWidget = AsyncPlaceholder(
          future: object,
          childBuilder: (species) {
            return PreviewInfo(
                title: species.getName(),
                imageUrl: species.getFrontImageUrl(),
                description: species.getDescription(),
                baseStats: species.getBaseStats(),
                typing: species.getTyping());
          });
    }
    return Scaffold(
        appBar: AppBar(
          leading: BackButton(onPressed: () {
            context.pop();
          }),
          title: const Text("Preview"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: previewWidget,
        ));
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
          text: const Text(
            "",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.normal),
          )));
    }
    children.add(const SizedBox(height: 10.0));
    if (description != null) {
      children.add(TextWithLoaderBuffer(
          future: description!,
          text: const Text(
            "",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
          )));
    }

    if (baseStats != null) {
      children.add(StatChart(
        baseFuture: baseStats!,
        ev: effortStats,
        iv: individualStats,
      ));
    }

    return ListView(scrollDirection: Axis.vertical, children: children);
  }
}
