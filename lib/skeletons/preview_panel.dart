import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mudkip_frontend/widgets/stat_chart.dart';
import 'package:mudkip_frontend/pokemon_manager.dart';

// ignore: must_be_immutable
class PreviewPanel extends StatelessWidget {
  Pokemon pokemon;
  PreviewPanel({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.all(16.0),
      children: [
        CachedNetworkImage(
            imageUrl: pokemon.getSpecies().getFrontImageUrl(),
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            fit: BoxFit.contain,
            filterQuality: FilterQuality.none,
            height: 300),
        Text(pokemon.getNickname(),
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 50)),
        Text(pokemon.getSpecies().getName(),
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
        Text(pokemon.getSpecies().getDescription(),
            textAlign: TextAlign.center,
            style:
                const TextStyle(fontWeight: FontWeight.normal, fontSize: 16)),
        StatChart(
            base: pokemon.getBaseStats(),
            iv: pokemon.getIvStats(),
            ev: pokemon.getEvStats()),
      ],
    );
  }
}
