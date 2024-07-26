import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:go_router/go_router.dart';
import 'package:mudkip_frontend/pokemon_manager.dart';
import 'package:mudkip_frontend/widgets/async_placeholder.dart';
import 'package:mudkip_frontend/widgets/pokemon_slot.dart';
import 'package:mudkip_frontend/screens/warning_page.dart';

class PCView extends StatefulWidget {
  // The PC view is where the user can see their Pokémon.
  const PCView({super.key});

  @override
  State<PCView> createState() => _PCViewState();
}

class _PCViewState extends State<PCView> {
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
        future: PC.isEmpty("pokemons"),
        childBuilder: (isEmpty) {
          Widget body = const Placeholder();
          if (isEmpty) {
            body = WarningPage(
                title: "Your PC is empty",
                description: 'Add some Pokémon by pressing the + button',
                icon: Icons.notification_important_rounded);
          } else {
            body = AsyncPlaceholder(
                future: PC.search(),
                childBuilder: (List<Pokemon> pokemons) {
                  return GridView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: pokemons.length,
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(10),
                    clipBehavior: Clip.antiAlias,
                    itemBuilder: (BuildContext context, int index) {
                      return PokemonSlot(
                          uniqueID: pokemons[index].uniqueID!,
                          onTap: () {
                            context.push("/preview",
                                extra:
                                    PC.fetchPokemon(pokemons[index].uniqueID!));
                          });
                    },
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            maxCrossAxisExtent: 300),
                  );
                });
          }
          return Scaffold(
              floatingActionButtonLocation: ExpandableFab.location,
              floatingActionButton: ExpandableFab(
                distance: 90.0,
                childrenOffset: const Offset(1.0, 1.0),
                openButtonBuilder: RotateFloatingActionButtonBuilder(
                  child: const Icon(Icons.add),
                  fabSize: ExpandableFabSize.regular,
                  heroTag: "add",
                  shape: const CircleBorder(),
                ),
                closeButtonBuilder: FloatingActionButtonBuilder(
                  size: 60,
                  builder: (BuildContext context, void Function()? onPressed,
                      Animation<double> progress) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(20),
                      ),
                      onPressed: onPressed,
                      iconAlignment: IconAlignment.end,
                      child: const Icon(
                        Icons.close_rounded,
                        size: 35,
                      ),
                    );
                  },
                ),
                children: [
                  FloatingActionButton(
                      heroTag: "addFile",
                      tooltip: "Add File",
                      child: const Icon(Icons.upload_file_rounded,
                          semanticLabel: "Add File"),
                      onPressed: () async {
                        FilePicker.platform.pickFiles().then((result) {});
                      }),
                  FloatingActionButton(
                      heroTag: "addFolder",
                      tooltip: "Add Folder",
                      child: const Icon(Icons.drive_folder_upload_rounded),
                      onPressed: () {
                        FilePicker.platform.getDirectoryPath().then((result) {
                          if (result != null && context.mounted) {
                            showDialog(
                              // ignore: use_build_context_synchronously
                              context: context,
                              builder: (context) => AlertDialog(
                                content: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                        margin: const EdgeInsets.only(left: 7),
                                        child: const Text(
                                            "Fetching Pokémon from Folder...")),
                                    const SizedBox(height: 10),
                                    const CircularProgressIndicator(),
                                  ],
                                ),
                              ),
                              barrierDismissible: false,
                            );

                            PC.openFolder(result).then((value) {
                              if (context.mounted) {
                                context.pop();
                                context.push("/pc");
                              }
                            });
                          }
                        });
                      }),
                ],
              ),
              body: body);
        });
  }
}
