import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mudkip_frontend/pokemon_manager.dart';
import 'package:mudkip_frontend/widgets/async_placeholder.dart';
import 'package:mudkip_frontend/widgets/species_entry.dart';

class PokeDexView extends StatelessWidget {
  const PokeDexView({super.key});

  @override
  Widget build(BuildContext context) {
    return AsyncPlaceholder(
        future: PokeAPI.amountOfEntries("pokemon_species"),
        childBuilder: (amount) {
          return ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: amount,
            itemExtent: 100,
            itemBuilder: (context, index) {
              return SpeciesEntry(
                  species: PokeAPI.fetchSpecies(index + 1),
                  onTap: () {
                    context.push("/preview",
                        extra: PokeAPI.fetchSpecies(index + 1));
                  });
            },
          );
        });
  }
}
