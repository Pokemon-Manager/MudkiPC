import 'dart:io';
import 'package:mudkip_frontend/core/arceus.dart';
import 'package:mudkip_frontend/mudkipc.dart';
import 'package:queue/queue.dart';
/* 
Name: Databases
Purpose: This file contains the databases that are used in the app.

There are two databases in the app. There is the PokeAPI database that is used to fetch data from the `Global.db` file.

The other database, [PC] is used to store dynamic and ever changing data like the user's Pokémon, their trainers, and other fluctating data. It also uses a SQLite database.

Both have the same structure, so they work exactly the same way. If you want to fetch for data, use the functions that start with `fetch`. For example, use functions named `fetchPokemon`, `fetchTrainer`, `fetchSpecies`, etc. There is also `fetch` functions that start with a underscore. Those are for internal use only, to force me and other developers to always add a fetch request to the queue rather than directly accessing the database. Every other function is just for logic purposes (e.g. `amountOfEntries` is just for getting the max amount of entries for the list and grid views, without needing null logic for them).

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
  static Logger log = Logger("PokeAPI"); // Used for logging.

  /// # `Future<void>` create() async
  /// ## Checks to see if the database exists and if it doesn't, it extracts it from the asset bundle.
  /// The database is stored in the `assets/db/` and is named `Global.db`.
  static Future<void> create() async {
    await MudkiPC.extractFileFromAssets("db/Global.db");
    PokeAPI.db = await openDatabase("${await MudkiPC.cacheFolder}db/Global.db",
        onConfigure: _onConfigure); // Opens the database.
    return;
  }

  static recreate() async {
    await databaseFactory
        .deleteDatabase("${await MudkiPC.cacheFolder}db/Global.db");
    await PokeAPI.create();
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
    return MudkiPC.queue.add(() => _fetchSpecies(id));
  }

  /// # `Future<Species?>` _fetchSpecies(`int id`) async
  /// ## See [fetchSpecies] for details.
  /// This function is what actually fetches the data from the database.
  static Future<Species?> _fetchSpecies(int id) async {
    List<Map<String, Object?>>? results = await db?.rawQuery("""
      SELECT * FROM pokemon
      INNER JOIN pokemon_species ON pokemon.species_id = pokemon_species.id 
      AND pokemon.id = ?;
        """, [id]);
    if (results == null || results.isEmpty) {
      return null;
    }
    return Species.fromDB(results.first);
  }

  /// # `Future<List<Map<String, Object?>>>` searchSpecies() async
  /// ## Does a search on the species table.
  /// The search is done using the [Pachinko] object inside the [PokeAPI].
  static Future<List<Map<String, Object?>>> searchSpecies() async {
    List<Map<String, Object?>>? x;
    if (MudkiPC.pachinko.pins.isEmpty) {
      x = await db?.rawQuery('SELECT * FROM pokemon_species;');
    } else {
      x = await db?.rawQuery(
          'SELECT id AS speciesID, * FROM pokemon_species WHERE ${MudkiPC.pachinko.formSQLStatement()};',
          MudkiPC.pachinko.formArguments());
    }
    return x!;
  }

  /// # `Future<List<Move?>>` fetchSpecies(`int id`) async
  /// ## Fetches a species from PokeAPI.
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
    return MudkiPC.queue.add(() => _fetchMove(id));
  }

  /// # `Future<Move?>` _fetchMove(`int id`) async
  /// ## See [fetchMove] for details.
  /// This function is what actually fetches the data from the database.
  static Future<Move?> _fetchMove(int id) async {
    if (id == 0) {
      return null;
    }
    Map<String, Object?> results = (await db?.rawQuery("""
      SELECT * FROM moves
      WHERE moves.id = ?;
    """, [id]))!.first;
    results = changeEmptyStringsToNull(results);
    return Move.fromDB(results);
  }

  /// # `Future<Stats>` fetchBaseStats(`int id`) async
  /// ## Fetches the base stats from PokeAPI.
  /// Adds the request for the base stats to the queue to be fetched later.
  /// This function will always return a [Stats] object for the given species.
  static Future<Stats> fetchBaseStats(int id) async {
    return MudkiPC.queue.add(() => _fetchBaseStats(id));
  }

  /// # `Future<Stats>` _fetchBaseStats(`int id`) async
  /// ## See [fetchBaseStats] for details.
  /// This function is what actually fetches the data from the database.
  static Future<Stats> _fetchBaseStats(int id) async {
    List<Map<String, Object?>> stats = [];
    for (var i in [1, 2, 3, 4, 5, 6]) {
      List<Map<String, Object?>>? results = (await db?.rawQuery("""
      SELECT * FROM pokemon_stats
      WHERE pokemon_id = ? AND stat_id = ?;
    """, [id, i]));
      if (results == null || results.isEmpty) {
        continue;
      }
      stats.add(results.first);
    }
    return Stats(
        hp: stats[0]["base_stat"] as int,
        attack: stats[1]["base_stat"] as int,
        defense: stats[2]["base_stat"] as int,
        specialAttack: stats[3]["base_stat"] as int,
        specialDefense: stats[4]["base_stat"] as int,
        speed: stats[5]["base_stat"] as int);
  }

  /// # `Future<String>` fetchString(`LanguageBinding binding`) async
  /// ## Fetches a string from the database.
  /// Adds the request for the string to the queue to be fetched later.
  /// The reason for this asynchronous fetch of strings is for multi-language support by using the names and descriptions already inside the PokeAPI database.
  static Future<String> fetchString(LanguageBinding binding) async {
    return MudkiPC.queue.add(() async => _fetchString(binding));
  }

  /// # `Future<String>` _fetchString(`LanguageBinding binding`) async
  /// ## See [fetchString] for details.
  /// This function uses a `LanguageBinding` object to fetch the string from the database.
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
    List<Map<String, Object?>>? results = (await db?.rawQuery("""
      SELECT * FROM $table
      WHERE $idColumn = ? AND $languageColumn = ?;
    """, [binding.id, languageId]));
    return (results!.last[binding.stringColumn] as String)
        .replaceAll(RegExp('\n'), ' ');
  }

  /// # `Future<Typing>` fetchTypingForSpecies(`int id`) async
  /// ## Fetches a typing from PokeAPI.
  /// Adds the request for the typing to the queue to be fetched later.
  /// This function will always return a [Typing] object for the given species.
  static Future<Typing> fetchTypingForSpecies(int id) async {
    return MudkiPC.queue.add(() async => _fetchTypingForSpecies(id));
  }

  /// # `Future<Typing>` _fetchTypingForSpecies(`int id`) async
  /// ## See [fetchTypingForSpecies] for details.
  /// This function is what actually fetches the data from the database.
  static Future<Typing> _fetchTypingForSpecies(int id) async {
    List<Map<String, Object?>>? results = (await db?.rawQuery("""
      SELECT * FROM pokemon_types
      WHERE pokemon_types.pokemon_id = ?;
    """, [id]));
    return Typing.fromDB(results!);
  }

  /// # `Map<String, Object?>` changeEmptyStringsToNull(`Map<String, Object?> results`)
  /// ## A fix for a werid quirk of the SQLite database.
  /// The problem lies in the fact that for some reason, sqflite returns null values as an empty string.
  /// Which is fine for varibles that are Strings, but not for numbers.
  /// As a result, Dart will catch a cast mismatch and throw an error.
  /// This function fixes that issue by replacing the empty string with null.
  /// Currently the only function that uses this is the `_fetchMove` function,
  /// however if the issue pops up in the future, all results should be
  /// passed through this function before being returned.
  static Map<String, Object?> changeEmptyStringsToNull(
      Map<String, Object?> results) {
    Map<String, Object?> newResults = {};
    for (var key in results.keys) {
      if (results[key] == "") {
        newResults[key] = null;
        continue;
      }
      newResults[key] = results[key];
    }
    return newResults;
  }

  /// # `Future<List<Map<String, Object?>>>` getSpeciesSuggestions(`String name`) async
  /// ## Gets all the species entries that match the name.
  /// Adds the request for the species suggestions to the queue to be fetched later.
  /// Any entries that match the name in the current language will be returned.
  /// Only returns 10 results at a time for better performance.
  static Future<List<Map<String, Object?>>?> getSpeciesSuggestions(
      String name) async {
    return MudkiPC.queue.add(() async => _getSpeciesSuggestions(name));
  }

  /// # `Future<List<Map<String, Object?>>>` _getSpeciesSuggestions(`String name`) async
  /// ## See [getSpeciesSuggestions] for details.
  /// This function is what actually fetches the data from the database.
  static Future<List<Map<String, Object?>>?> _getSpeciesSuggestions(
      String name) async {
    int languageId = LocaleIDs.getIDFromLocale(Platform.localeName);
    List<Map<String, Object?>>? results = (await db?.rawQuery("""
      SELECT * FROM pokemon_species
      INNER JOIN pokemon_species_names ON id = pokemon_species_id AND local_language_id = ? AND (name LIKE ? OR id = ?) LIMIT 10;
    """, [languageId, "%$name%", name]));
    return results;
  }

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
  bool isNameTable =
      true; // For some reason, the name table has a different column name for language, so we need to use this to specify if the table contains names or not.
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
  static Database? db; // The database instance.
  static Queue queue = Queue(
      delay: const Duration(
          microseconds: 100)); // The queue for database operations.

  /// # `Future<PC>` create()
  /// ## Creates the user's PC.
  /// Creates the PC as a singleton.
  static create() async {
    Database db = await databaseFactory.openDatabase(
        "${await MudkiPC.cacheFolder}db/User.db",
        options: OpenDatabaseOptions(onConfigure: _onConfigure));
    return await PC.createTables(db);
  }

  /// # `Future<void>` recreate()
  /// ## Recreates the user's PC.
  /// Deletes the user's SQLite Database inside the user folder and rebuilds a new one.
  /// Use for reset the application.
  static void recreate() async {
    databaseFactory.deleteDatabase("${await MudkiPC.cacheFolder}db/User.db");
    PC.create();
  }

  /// # `Future<void>` _onConfigure(`Database db`) async
  /// ## Configures the database for foreign keys.
  static Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  /// # `Future<void>` createTables(`Database db`)
  /// ## Creates the tables in the database.
  static Future<void> createTables(Database db) async {
    await db.execute("""CREATE TABLE IF NOT EXISTS trainers (
      trainerID INTEGER PRIMARY KEY AUTOINCREMENT,
      id INTEGER UNIQUE,
      name TEXT,
      gameID INTEGER,
      gender INTEGER
    );""");
    await db.execute("""CREATE TABLE IF NOT EXISTS pokemons (
      uniqueID INTEGER PRIMARY KEY AUTOINCREMENT,
      nickName TEXT,
      speciesID INTEGER,
      abilityID INTEGER,
      pokemonID INTEGER,
      gender INTEGER,
      exp INTEGER,
      iv TEXT,
      ev TEXT,
      move1ID INTEGER,
      move2ID INTEGER,
      move3ID INTEGER,
      move4ID INTEGER,
      otID INTEGER,
      CONSTRAINT fk_ot FOREIGN KEY (otID) REFERENCES trainers(trainerID)
    );""");
    PC.db = db;
  }

  /// # `Future<int?>` amountOfEntries(String table)
  /// ## Returns the amount of entries in a table.
  static Future<int?> amountOfEntries(String table) async {
    var x = await db?.rawQuery('SELECT * FROM $table;');
    int? count = x?.length;
    return count;
  }

  /// # `Future<void>` addPokemon(`Pokemon pokemon`)
  /// ## Adds a [Pokemon] to the `pokemons` table.
  static Future<void> addPokemon(Pokemon pokemon) async {
    // print("Adding ${pokemon.nickName}");
    await db?.insert("pokemons", pokemon.toDB());
    return;
  }

  /// # `Future<void>` addPokemonList(`List<Pokemon> pokemonList`)
  /// ## Adds a list of [Pokemon] to the `pokemons` table.
  /// Adds a list of [Pokemon] to the `pokemons` table.
  static Future<void> addPokemonList(List<Pokemon> pokemonList) async {
    for (var pokemon in pokemonList) {
      await addPokemon(pokemon);
    }
  }

  /// # `Future<int?>` addTrainer(`Trainer trainer`)
  /// ## Adds a [Trainer] to the `trainers` table.
  /// Adds a [Trainer] to the `trainers` table.
  static Future<int?> addTrainer(Trainer trainer) async {
    await db?.insert("trainers", trainer.toDB(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
    return findTrainerID(trainer);
  }

  /// # `Future<int?>` findTrainerID(`Trainer trainer`)
  /// ## Finds the ID of a [Trainer] in the `trainers` table.
  /// Finds the ID of a [Trainer] in the `trainers` table.
  static Future<int?> findTrainerID(Trainer trainer) async {
    List<Map<String, Object?>>? results = await db?.query("trainers",
        where: "id = ? AND gameID = ? AND name = ?",
        whereArgs: [trainer.id, trainer.gameID, trainer.name]);
    if (results!.isEmpty) return null;
    return results.first["trainerID"] as int?;
  }

  static Future<int?> findTrainerIDByName(String name) async {
    List<Map<String, Object?>>? results =
        await db?.query("trainers", where: "name = ?", whereArgs: [name]);
    if (results!.isEmpty) return null;
    return results.first["trainerID"] as int?;
  }

  /// # `void` removePokemon(`Pokemon pokemon`)
  /// ## Removes a [Pokemon] from the table of [pokemons].
  static void removePokemon(Pokemon pokemon) {}

  /// # `Future<Pokemon>` fetchPokemon(`int id`)
  /// ## Fetches a [Pokemon] from the table of [pokemons].
  /// Fetches a [Pokemon] from the table of [pokemons].
  static Future<Pokemon> fetchPokemon(int id) async {
    return queue.add(() async => _fetchPokemon(id));
  }

  /// # `Future<Pokemon>` _fetchPokemon(`int id`)
  /// ## See [fetchPokemon] for details.
  /// This function is what actually fetches the [Pokemon] from the database.
  static Future<Pokemon> _fetchPokemon(int id) async {
    List<Map<String, Object?>>? results = (await db?.rawQuery("""
      SELECT * FROM pokemons
      WHERE pokemons.uniqueID = ?;
    """, [id]));
    return Pokemon.fromDB(results!.first);
  }

  /// # `Future<void>` openFolder(`String path`)
  /// ## Opens a folder and extracts the data from it.
  static Future<void> openFolder(String path) async {
    for (var entry in Directory(path).listSync()) {
      if (entry is! File) continue;
      dynamic result;
      if (entry.path.endsWith(".pk9")) {
        result = await Arceus.read(entry.path, "./patterns/files/pk9.yaml");
      } else if (entry.path.endsWith(".pk8")) {
        result = await Arceus.read(entry.path, "./patterns/files/pk8.yaml");
      } else if (entry.path.endsWith(".pk7")) {
        result = await Arceus.read(entry.path, "./patterns/files/pk7.yaml");
      }
      print(result);
      if (result == null) print("Failed to read ${entry.path}");
      if (result != null && result is Map<String, dynamic>) {
        result["otID"] =
            await findTrainerIDByName(result["ot_nickname"] as String);
        if (result["otID"] == null) {
          result["otID"] = await addTrainer(Trainer(
              name: result["ot_nickname"] as String,
              gameID: result["version"]));
        }
        await addPokemon(Pokemon.fromArceus(result));
      }
    }
  }

  /// # `Future<bool>` isEmpty(String table)
  /// ## Checks if a table is empty.
  static Future<bool> isEmpty(String table) async {
    return await amountOfEntries(table) == 0;
  }

  /// # `Future<List<Pokemon>>` search()
  /// ## Searches for pokemons in the database.
  static Future<List<Pokemon>> search() async {
    List<Map<String, Object?>>? x;
    if (MudkiPC.pachinko.pins.isEmpty) {
      x = await db?.rawQuery('SELECT * FROM pokemons;');
    } else {
      x = await db?.rawQuery(
          'SELECT * FROM pokemons WHERE ${MudkiPC.pachinko.formSQLStatement()};',
          MudkiPC.pachinko.formArguments());
    }
    return x!.map((e) => Pokemon.fromDB(e)).toList();
  }
}
