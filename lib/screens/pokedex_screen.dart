import 'package:flutter/widgets.dart';
// import 'package:flutter/material.dart' as material;
// import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:macos_ui/macos_ui.dart' as macos;
// import 'package:flutter/cupertino.dart' as cupertino;
import 'package:mudkip_frontend/universal_builder.dart';

import 'package:go_router/go_router.dart';
import 'package:mudkip_frontend/pokemon_manager.dart';
import 'package:mudkip_frontend/widgets/async_placeholder.dart';
import 'package:mudkip_frontend/widgets/species_entry.dart';

class PokeDexView extends StatefulWidget {
  const PokeDexView({super.key});

  @override
  State<PokeDexView> createState() => _PokeDexViewState();
}

class _PokeDexViewState extends State<PokeDexView> with UniversalBuilder {
  @override
  void initState() {
    MudkiPC.pachinko.addListener(refresh);
    super.initState();
  }

  @override
  void dispose() {
    MudkiPC.pachinko.removeListener(refresh);
    super.dispose();
  }

  void refresh() {
    setState(() {});
  }

  Widget buildList(BuildContext context) {
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

  @override
  Widget buildAndroid(BuildContext context) {
    return buildList(context);
  }

  @override
  Widget buildWindows(BuildContext context) {
    return buildList(context);
  }

  @override
  Widget buildMacOS(BuildContext context) {
    return macos.MacosScaffold(
        toolBar: const macos.ToolBar(
          title: Text("PokéDex"),
        ),
        children: [
          macos.ContentArea(
              builder: (context, scrollController) => buildList(context))
        ]);
  }
}
