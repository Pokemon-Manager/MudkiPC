import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart' as material;
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:macos_ui/macos_ui.dart' as macos;
import 'package:flutter/cupertino.dart' as cupertino;
import 'package:flutter/widgets.dart';
import 'package:mudkip_frontend/universal_builder.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:go_router/go_router.dart';
import 'package:mudkip_frontend/mudkipc.dart';
import 'package:mudkip_frontend/widgets/async_placeholder.dart';
import 'package:mudkip_frontend/widgets/pokemon_slot.dart';
import 'package:mudkip_frontend/screens/warning_page.dart';

class PCView extends StatefulWidget {
  // The PC view is where the user can see their Pokémon.
  const PCView({super.key});

  @override
  State<PCView> createState() => _PCViewState();
}

class _PCViewState extends State<PCView> with UniversalBuilder {
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

  @override
  Widget buildAndroid(BuildContext context) {
    return AsyncPlaceholder(
        future: PC.isEmpty("pokemons"),
        childBuilder: (isEmpty) {
          Widget body = const Placeholder();
          if (isEmpty) {
            body = WarningPage(
                title: "Your PC is empty",
                description: 'Add some Pokémon by pressing the + button',
                icon: material.Icons.notification_important_rounded);
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
                          pokemon: PC.fetchPokemon(pokemons[index].uniqueID!),
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
          return material.Scaffold(
              floatingActionButtonLocation: ExpandableFab.location,
              floatingActionButton: ExpandableFab(
                distance: 90.0,
                childrenOffset: const Offset(1.0, 1.0),
                openButtonBuilder: RotateFloatingActionButtonBuilder(
                  child: const Icon(material.Icons.add),
                  fabSize: ExpandableFabSize.regular,
                  heroTag: "add",
                  shape: const CircleBorder(),
                ),
                closeButtonBuilder: FloatingActionButtonBuilder(
                  size: 60,
                  builder: (BuildContext context, void Function()? onPressed,
                      Animation<double> progress) {
                    return material.ElevatedButton(
                      style: material.ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(20),
                      ),
                      onPressed: onPressed,
                      iconAlignment: material.IconAlignment.end,
                      child: const Icon(
                        material.Icons.close_rounded,
                        size: 35,
                      ),
                    );
                  },
                ),
                children: [
                  material.FloatingActionButton(
                      heroTag: "addFile",
                      tooltip: "Add File",
                      child: const Icon(material.Icons.upload_file_rounded,
                          semanticLabel: "Add File"),
                      onPressed: () async {
                        FilePicker.platform.pickFiles().then((result) {});
                      }),
                  material.FloatingActionButton(
                      heroTag: "addFolder",
                      tooltip: "Add Folder",
                      child: const Icon(
                          material.Icons.drive_folder_upload_rounded),
                      onPressed: () {
                        FilePicker.platform.getDirectoryPath().then((result) {
                          if (result != null && context.mounted) {
                            material.showDialog(
                              // ignore: use_build_context_synchronously
                              context: context,
                              builder: (context) => material.AlertDialog(
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
                                    const material.CircularProgressIndicator(),
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

  @override
  Widget buildWindows(BuildContext context) {
    return fluent.ScaffoldPage(
      header: material.Padding(
        padding: const EdgeInsets.only(
          right: 16.0,
          bottom: 8.0,
        ),
        child: fluent.CommandBar(
            crossAxisAlignment: fluent.CrossAxisAlignment.center,
            mainAxisAlignment: fluent.MainAxisAlignment.end,
            primaryItems: [
              fluent.CommandBarButton(
                onPressed: () {
                  FilePicker.platform.getDirectoryPath().then((result) {
                    if (result != null && context.mounted) {
                      fluent.showDialog(
                        // ignore: use_build_context_synchronously
                        context: context,
                        builder: (context) => material.AlertDialog(
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
                              const material.CircularProgressIndicator(),
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
                },
                icon: const Icon(fluent.FluentIcons.add),
                label: const Text("Add"),
              )
            ]),
      ),
      content: AsyncPlaceholder(
          future: PC.isEmpty("pokemons"),
          childBuilder: (isEmpty) {
            Widget body = const Placeholder();
            if (isEmpty) {
              body = WarningPage(
                  title: "Your PC is empty",
                  description: 'Add some Pokémon by pressing the + button',
                  icon: fluent.FluentIcons.warning);
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
                            pokemon: PC.fetchPokemon(pokemons[index].uniqueID!),
                            onTap: () {
                              context.push("/preview",
                                  extra: PC
                                      .fetchPokemon(pokemons[index].uniqueID!));
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
            return body;
          }),
    );
  }

  @override
  Widget buildMacOS(BuildContext context) {
    return macos.MacosScaffold(
        toolBar: macos.ToolBar(
          title: const Text("PC"),
          actions: [
            macos.ToolBarIconButton(
                label: "Add",
                icon: const Icon(cupertino.CupertinoIcons.add),
                showLabel: true,
                onPressed: () {
                  FilePicker.platform.getDirectoryPath().then((result) {
                    if (result != null && context.mounted) {
                      macos.showMacosAlertDialog(
                        // ignore: use_build_context_synchronously
                        context: context,
                        builder: (context) => const macos.MacosAlertDialog(
                          title: Text("Fetching Pokemons from Folder..."),
                          appIcon: Icon(cupertino.CupertinoIcons.add),
                          message: Text("Please wait"),
                          primaryButton: macos.PushButton(
                              controlSize: macos.ControlSize.regular,
                              child: Text("Waiting")),
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
                })
          ],
        ),
        children: [
          macos.ContentArea(
            builder: (BuildContext context, ScrollController scrollController) {
              return AsyncPlaceholder(
                  future: PC.isEmpty("pokemons"),
                  childBuilder: (isEmpty) {
                    Widget body = const Placeholder();
                    if (isEmpty) {
                      body = WarningPage(
                          title: "Your PC is empty",
                          description:
                              'Add some Pokémon by pressing the + button',
                          icon: fluent.FluentIcons.warning);
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
                                    pokemon: PC.fetchPokemon(
                                        pokemons[index].uniqueID!),
                                    onTap: () {
                                      context.push("/preview",
                                          extra: PC.fetchPokemon(
                                              pokemons[index].uniqueID!));
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
                    return body;
                  });
            },
          ),
        ]);
  }
}
