import 'dart:io';
import 'package:mudkip_frontend/pokemon_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:hive/hive.dart';
import 'package:queue/queue.dart';

/* 
Name: Databases
Purpose: This file contains the databases that are used in the app.

There are two databases in the app. There is the PokeAPI database that is used to fetch data from the permanent and slightly slower SQLite database.

The other database, [PC] is used to store dynamic and ever changing data like the user's Pokémon, their trainers, and other fluctating data. It uses a NoSQL database called Hive. Hive is a key-value database that is used to store data, so use it like a dictionary if needed.

Both have the same structure, so they work exactly the same way despite having different databases. If you want to fetch for data, use the functions that start with `fetch`. For example, use functions named `fetchPokemon`, `fetchTrainer`, `fetchSpecies`, etc. There is also `fetch` functions that start with a underscore. Those are for internal use only, to force me and other developers to always add a fetch request to the queue rather than directly accessing the database. Every other function is just for logic purposes (e.g. `amountOfEntries` is just for getting the max amount of entries for the list and grid views, without need null logic for them).

If you are still confused on what the difference is between [PokeAPI] and the [PC] class, remember this:
- PC = User's Data (Pokemon, Items, etc.) This is not consitent.
- PokeAPI = PokeDex Data (Species, Moves, etc.) This is consitent.
*/

/// # PokeAPI
/// ## A class that represents PokeAPI.
/// The fetch functions returns the object you are looking for, so you can get the object you need.
final class PokeAPI {
  static Database?
      db; // The database object that is accessed to fetch data. See `Global.db` in the `access/db` folder for the SQLite database used.
  static Queue queue = Queue(
      delay: const Duration(
          microseconds:
              100)); /* This queue is to make sure that multiple requests are not made at the same time, 
  as it could result in an overflow or an asynchronous error.*/

  /// # `Future<void>` create() async
  /// ## Checks to see if the database exists and if it doesn't, it extracts it from the asset bundle.
  /// The database is stored in the `access/db/` and is named `Global.db`.
  static Future<void> create() async {
    Directory directory =
        await getApplicationCacheDirectory(); // Gets the cache directory for the device.
    File globalFile = File(
        "${directory.path}/MudkiPC/db/Global.db"); // Initializes the file object to check if the database exists.
    if (!(globalFile.existsSync())) {
      ByteData data = await rootBundle.load(
          "assets/db/Global.db"); // Loads the database from the asset bundle.
      globalFile.createSync(recursive: true); // Creates the file.
      globalFile.writeAsBytesSync(data.buffer
          .asUint8List()); // Writes the data from the asset bundle to the created file.
    }
    PokeAPI.db = await openDatabase("${directory.path}/MudkiPC/db/Global.db",
        onConfigure: _onConfigure); // Opens the database.
    return;
  }

  /// # `Future<void>` _onConfigure(`Database db`) async
  /// ## Configures the database for foreign keys.
  static Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  /// # `Future<Species?>` fetchSpecies(`int id`) async
  /// ## Fetches a species from PokeAPI.
  /// Returns a [Species] object. It fetches from multiple tables and combines them into one object.
  /// Adds the request for the species to the queue to be fetched later.
  static Future<Species?> fetchSpecies(int id) async {
    return queue.add(() => _fetchSpecies(id));
  }

  /// # `Future<Species?>` _fetchSpecies(`int id`) async
  /// ## See [fetchSpecies] for details.
  /// This function is what actually fetches the data from the database.
  static Future<Species?> _fetchSpecies(int id) async {
    List<Map<String, Object?>>? query = (await db?.rawQuery("""
      SELECT * FROM pokemon
      INNER JOIN pokemon_species ON pokemon.species_id = pokemon_species.id 
      AND pokemon.id = ?;
        """, [id]));
    if (query == null || query.isEmpty) {
      return null;
    }
    return Species.fromDB(query.first);
  }

  /// # `Future<List<Move?>>` fetchSpecies(`int id`) async
  /// ## Fetches a species from PokeAPI.
  ///
  static Future<List<Move?>> fetchMoves(List<int> ids) async {
    List<Move?> data = [];
    for (var id in ids) {
      data.add(await fetchMove(id));
    }
    return data;
  }

  /// # `Future<Move?>` fetchMove(`int id`)
  /// ## Fetches a move from PokeAPI.
  /// Adds the request for the move to the queue to be fetched later.
  static Future<Move?> fetchMove(int id) {
    return queue.add(() => _fetchMove(id));
  }

  /// # `Future<Move?>` _fetchMove(`int id`) async
  /// ## See [fetchMove] for details.
  /// This function is what actually fetches the data from the database.
  static Future<Move?> _fetchMove(int id) async {
    if (id == 0) {
      return null;
    }
    Map<String, Object?> query = (await db?.rawQuery("""
      SELECT * FROM moves
      WHERE moves.id = ?;
    """, [id]))!.first;
    query = changeEmptyStringsToNull(query);
    return Move.fromDB(query);
  }

  static Future<Stats> fetchBaseStats(int id) async {
    List<Map<String, Object?>> stats = [];
    for (var i in [1, 2, 3, 4, 5, 6]) {
      List<Map<String, Object?>>? query = (await db?.rawQuery("""
      SELECT * FROM pokemon_stats
      WHERE pokemon_id = ? AND stat_id = ?;
    """, [id, i]));
      if (query == null || query.isEmpty) {
        continue;
      }
      stats.add(query.first);
    }
    return Stats(
        hp: stats[0]["base_stat"] as int,
        attack: stats[1]["base_stat"] as int,
        defense: stats[2]["base_stat"] as int,
        specialAttack: stats[3]["base_stat"] as int,
        specialDefense: stats[4]["base_stat"] as int,
        speed: stats[5]["base_stat"] as int);
  }

  static Future<String> fetchString(LanguageBinding binding) async {
    return queue.add(() async => _fetchString(binding));
  }

  static Future<String> _fetchString(LanguageBinding binding) async {
    int languageId = LocaleIDs.getIDFromLocale(Platform.localeName);
    String table = binding.table;
    String idColumn = binding.idColumn;
    String languageColumn = "";
    if (binding.isNameTable) {
      languageColumn = "local_language_id";
    } else {
      languageColumn = "language_id";
    }
    List<Map<String, Object?>>? query = (await db?.rawQuery("""
      SELECT * FROM $table
      WHERE $idColumn = ? AND $languageColumn = ?;
    """, [binding.id, languageId]));
    return (query!.last[binding.stringColumn] as String)
        .replaceAll(RegExp('\n'), ' ');
  }

  static Future<Typing> fetchTypingForSpecies(int id) async {
    return queue.add(() async => _fetchTypingForSpecies(id));
  }

  static Future<Typing> _fetchTypingForSpecies(int id) async {
    List<Map<String, Object?>>? query = (await db?.rawQuery("""
      SELECT * FROM pokemon_types
      WHERE pokemon_types.pokemon_id = ?;
    """, [id]));
    return Typing.fromDB(query!);
  }

  static Map<String, Object?> changeEmptyStringsToNull(
      Map<String, Object?> query) {
    Map<String, Object?> newQuery = {};
    for (var key in query.keys) {
      if (query[key] == "") {
        newQuery[key] = null;
        continue;
      }
      newQuery[key] = query[key];
    }
    return newQuery;
  }

  static Future<int?> amountOfEntries(String table) async {
    var x = await db?.rawQuery('SELECT * FROM $table;');
    int? count = x?.length;
    return count;
  }

  static search(String query) async {}

  // static Future<Ability> getAbility(int id) async {
  //   final response = await fetchPokeAPI("ability","$id");
  //   if (response.statusCode == 200) {
  //     return Ability.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  //   }
  //   else {
  //     throw Exception("Failed to create ability $id");
  //   }
  // }
}

class LanguageBinding {
  String table = "pokemon_species_names";
  bool isNameTable = true;
  String idColumn = "id";
  int id = 0;
  String stringColumn = "string";
  LanguageBinding(
      {required this.table,
      required this.idColumn,
      required this.id,
      required this.stringColumn,
      required this.isNameTable});
}

/// # PC
/// ## Represents the user's collection of [Pokemon], [Species], and [Trainer]s.
final class PC {
  static Box? db;
  static Queue queue = Queue(delay: const Duration(microseconds: 100));
  static Stream<bool> isReady = const Stream.empty();
  static List<PKMDBFolder> pkmdbs = [];

  static Future<void> create() async {
    Directory directory = await getApplicationDocumentsDirectory();
    Hive.init("${directory.path}/MudkiPC/db/");
    db = await Hive.openBox("pc");
  }

  /// #addPokemon(`Pokemon pokemon`)
  /// ## Adds a [Pokemon] to the list of [pokemons].
  static void addPokemon(Pokemon pokemon) {
    db?.put(db!.length + 1, pokemon.toDB());
  }

  static void addPokemonList(List<Pokemon> pokemonList) {
    for (var pokemon in pokemonList) {
      addPokemon(pokemon);
    }
  }

  /// #removePokemon(`Pokemon pokemon`)
  /// ## Removes a [Pokemon] from the list of [pokemons].
  static void removePokemon(Pokemon pokemon) {}

  static Future<Pokemon> fetchPokemon(int id) async {
    return queue.add(() async => _fetchPokemon(id));
  }

  static Future<Pokemon> _fetchPokemon(int id) async {
    return Pokemon.fromDB(db?.get(id));
  }

  static Future<void> openFolder(String path) async {
    PKMDBFolder pkmdb = PKMDBFolder(path: path);
    pkmdb.loadFolder();
    pkmdb.openCompatibleFiles();
    await pkmdb.extractAllData();
    return;
  }

  static Future<bool> isEmpty(String table) async {
    return db?.isEmpty ?? true;
  }

  static Future<int?> amountOfEntries(String table) async {
    return db?.length;
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
    PC.addPokemonList(pokemons);
    return;
  }
}
