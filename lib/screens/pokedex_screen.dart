import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mudkip_frontend/pokemon_manager.dart';
import 'package:mudkip_frontend/widgets/async_placeholder.dart';
import 'package:mudkip_frontend/widgets/species_entry.dart';

class PokeDexView extends StatefulWidget {
  const PokeDexView({super.key});

  @override
  State<PokeDexView> createState() => _PokeDexViewState();
}

class _PokeDexViewState extends State<PokeDexView> {
  @override
  void initState() {
    PokeAPI.pachinko.addListener(refresh);
    super.initState();
  }

  @override
  void dispose() {
    PokeAPI.pachinko.removeListener(refresh);
    super.dispose();
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AsyncPlaceholder(
        future: PokeAPI.searchSpecies(),
        childBuilder: (List<Map<String, Object?>> species) {
          return ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: species.length,
            itemExtent: 100,
            itemBuilder: (context, index) {
              Future<Species?> future =
                  PokeAPI.fetchSpecies(species[index]["id"] as int);
              return SpeciesEntry(
                  species: future,
                  onTap: () {
                    context.push("/preview", extra: future);
                  });
            },
          );
        });
  }
}
