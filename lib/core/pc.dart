import 'dart:io';

import 'package:mudkip_frontend/pokemon_manager.dart';

/// # PC
/// ## Represents the user's collection of [Pokemon], [Species], and [Trainer]s.
class PC {
  List<Pokemon> pokemons;

  /// # species
  /// ## A dictionary of all the created [Species] objects.
  /// Always check to see if the species exists before create a new one using.
  List<PKMDBFolder> pkmdbs = [];
  PC({required this.pokemons});

  get settings => null;

  /// #addPokemon(`Pokemon pokemon`)
  /// ## Adds a [Pokemon] to the list of [pokemons].
  void addPokemon(Pokemon pokemon) {
    print(pokemon.toJson());
    pokemons.add(pokemon);
  }

  void addPokemonList(List<Pokemon> pokemonList) {
    for (var pokemon in pokemonList) {
      addPokemon(pokemon);
    }
  }

  /// #removePokemon(`Pokemon pokemon`)
  /// ## Removes a [Pokemon] from the list of [pokemons].
  void removePokemon(Pokemon pokemon) {
    pokemons.remove(pokemon);
  }

  /// #getSpecies(`int id`)
  /// ## Gets a [Species] from an ID.
  /// Returns the [Species] if it exists in the dictionary [species].
  /// If it does not exist, it will be created and then returned.
  /// #createSpecies(`int id`)
  /// ## Creates a [Species] from an ID.
  /// This function should only be called if the [Species] does not exist in the dictionary [species]. Just call [getSpecies] instead.
  /// Returns the created [Species] if successful.
  /// Throws an exception if the [Species] could not be created.

  Future<void> openFolder(String path) async {
    pkmdbs.add(PKMDBFolder(path: path));
    pkmdbs.last.loadFolder();
    pkmdbs.last.openCompatibleFiles();
    await pkmdbs.last.extractAllData();
    addPokemonList(pkmdbs.last.pokemons);
    return;
  }
}

class PKMDBFolder {
  String path;
  List<Pokemon> pokemons = [];
  List<FileSystemEntity> files = [];
  List<FileHandle> openFiles = [];
  List<Trainer> trainers = [];
  Directory directory = Directory("");

  PKMDBFolder({required this.path});

  void loadFolder() {
    directory = Directory(path);
    files = directory.listSync();
    return;
  }

  void openCompatibleFiles() {
    for (FileSystemEntity entity in files) {
      if (entity is File) {
        File file = entity;
        if (FileHandle.isCompatibleFile(file)) {
          openFiles.add(FileHandle.toAssociatedHandle(file, this));
        }
      }
    }
  }

  Future<void> extractAllData() async {
    for (FileHandle file in openFiles) {
      await file.parseDatablocks();
    }
    return;
  }
}
