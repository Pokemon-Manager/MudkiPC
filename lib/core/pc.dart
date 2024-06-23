import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:pokemon_manager/pokemon_manager.dart';

/// # PC
/// ## Represents the user's collection of [Pokemon], [Species], and [Trainer]s.
class PC {
  List<Pokemon> pokemons;

  /// # species
  /// ## A dictionary of all the created [Species] objects.
  /// Always check to see if the species exists before create a new one using.
  Map<int, Species> species;
  List<PKMDBFolder> pkmdbs = [];
  PC({required this.pokemons, required this.species});

  /// #addPokemon(`Pokemon pokemon`)
  /// ## Adds a [Pokemon] to the list of [pokemons].
  void addPokemon(Pokemon pokemon) {
    pokemons.add(pokemon);
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
  Future<Species?> getSpecies(int id) async {
    if (!species.containsKey(id)) { try { await createSpecies(id); } catch (e) {return null;} }
    return species[id];
  }
  /// #createSpecies(`int id`)
  /// ## Creates a [Species] from an ID.
  /// This function should only be called if the [Species] does not exist in the dictionary [species]. Just call [getSpecies] instead.
  /// Returns the created [Species] if successful.
  /// Throws an exception if the [Species] could not be created.
  Future<Species?> createSpecies(int id) async {
    print("Creating species $id");
    final response = await fetchPokeAPI("pokemon","$id");
    if (response.statusCode == 200) {
      species[id] = Species.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    }
    else {
      throw Exception("Failed to create species $id");
    }
    return species[id];
  }

  Future<http.Response> fetchPokeAPI(String section, String query) async {
      return await http.get(Uri.parse("https://pokeapi.co/api/v2/$section/$query"));
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
        if (FileHandle.isCompatibleFile(file)) {
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
