import 'dart:io';
import 'package:pokedex/pokedex.dart' as PokeAPI;
import 'file_handles.dart';
import 'pokemon.dart';
import 'species.dart';
import 'trainer.dart';
import 'enums.dart';

/// # PC
/// ## Represents the user's collection of [Pokemon], [Species], and [Trainer]s.
class PC {
  List<Pokemon> pokemons;

  /// # Species
  /// ## A dictionary of all the created [Species] objects.
  /// Always check to see if the species exists before create a new one using.
  Map<int, Species> species;
  List<PKMDBFolder> pkmdbs = [];
  final pokedex = PokeAPI.Pokedex();
  PC({required this.pokemons, required this.species});

  /// Adds a [Pokemon] to the list of [pokemons].
  ///
  /// The [pokemon] parameter is the [Pokemon] object to be added.
  ///
  /// This function does not return anything.
  void addPokemon(Pokemon pokemon) {
    pokemons.add(pokemon);
  }

  /// Removes a [Pokemon] from the list of [pokemons].
  ///
  /// The [pokemon] parameter is the [Pokemon] object to be removed.
  ///
  /// This function does not return anything.
  void removePokemon(Pokemon pokemon) {
    pokemons.remove(pokemon);
  }

  void createPokemon() {
    return;
  }

  Species getSpecies(int id) {
    if (!species.containsKey(id)) {}
    return species[id]!;
  }

  void createSpecies(int id) async {
    PokeAPI.Pokemon speciesEndpoint =
        pokedex.pokemon.get(id: id) as PokeAPI.Pokemon;
    species[id] = Species.fromJson(speciesEndpoint.toJson());
    return;
  }

  void openFolder(String path) {
    pkmdbs.add(PKMDBFolder(path: path));
    pkmdbs.last.loadFolder();
    pkmdbs.last.openCompatibleFiles();
    pkmdbs.last.extractAllData();
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
        if (CompatibleFiles.isCompatibleFile(file)) {
          openFiles.add(FileHandle.toAssociatedHandle(file, this));
        }
      }
    }
  }

  void extractAllData() {
    for (FileHandle file in openFiles) {
      file.parseDatablocks();
    }
    return;
  }
}
