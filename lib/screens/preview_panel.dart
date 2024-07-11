import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mudkip_frontend/widgets/stat_chart.dart';
import 'package:mudkip_frontend/widgets/text_with_loader.dart';
import 'package:mudkip_frontend/pokemon_manager.dart';

// ignore: must_be_immutable
class PreviewPanel extends StatelessWidget {
  Object? object;
  PreviewPanel({super.key, required this.object});

  @override
  Widget build(BuildContext context) {
    if (object is Pokemon) {
      Pokemon pokemon = object as Pokemon;
      return PreviewInfo(
          title: pokemon.getSpecies().getName(),
          subtitle: pokemon.getNickname(),
          imageUrl: pokemon.getSpecies().getFrontImageUrl(),
          description: pokemon.getSpecies().getDescription(),
          baseStats: pokemon.species.getBaseStats(),
          effortStats: pokemon.getEvStats(),
          individualStats: pokemon.getIvStats());
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
  });
  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    if (imageUrl != null) {
      children.add(CachedNetworkImage(
        imageUrl: imageUrl!,
        placeholder: (context, url) => const CircularProgressIndicator(),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ));
    } else if (icon != null) {
      children.add(Icon(icon, size: 100));
    }
    children.add(TextWithLoaderBuffer(
        future: title,
        text: Text(
          "",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
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
