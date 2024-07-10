import 'dart:io';
import 'package:mudkip_frontend/pokemon_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:sqflite/sqflite.dart';

/// # PokeAPI
/// ## A class that represents PokeAPI.
/// The fetch functions returns the object you are looking for, so you can get the object you need.
/// If you are confused on what the difference is between this and the [PC] class, remember this:
/// - PC = User's Data (Pokemon, Items, etc.) This is not consitent.
/// - PokeAPI = PokeDex Data (Species, Moves, etc.) This is consitent.
///

enum Tables {
  species,
  moves,
  abilities,
}

class PokeAPI {
  static Database? db;
  static Map<int, Species> species = {};
  static Map<int, Move> moves = {};
  static Map<int, Ability> abilities = {};
  static Future<void> create() async {
    Directory directory = await getApplicationDocumentsDirectory();
    File globalFile = File("${directory.path}/MudkiPC/db/Global.db");
    if (!(globalFile.existsSync())) {
      ByteData data = await rootBundle.load("assets/db/Global.db");
      globalFile.createSync(recursive: true);
      globalFile.writeAsBytesSync(data.buffer.asUint8List());
    }
    PokeAPI.db = await openDatabase("${directory.path}/MudkiPC/db/Global.db",
        onConfigure: _onConfigure);
    return;
  }

  static Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  /// # fetchSpecies(`int id`)
  /// ## Fetches a species from PokeAPI.
  /// Returns a [Species] object. It fetches multiple endpoints and combines them into one Map.
  /// If you want to fetch a single endpoint, use [fetch].
  /// If you want to learn why mutiple fetches are needed, look at the [Species] class.
  /// ### Current Endpoints:
  /// - pokemon
  /// - pokemon-species
  static Future<Species> fetchSpecies(int id, bool cache) async {
    if (species.containsKey(id)) {
      return species[id]!;
    }
    Map<String, Object?> query = (await db?.rawQuery("""
      SELECT * FROM pokemon
      INNER JOIN pokemon_species ON pokemon.species_id = pokemon_species.id 
      AND pokemon.id = ?;
        """, [id]))!.first;
    return Species.fromDB(query);
  }

  static Future<List<Move?>> fetchMoves(List<int> ids) async {
    List<Move?> data = [];
    for (var id in ids) {
      data.add(await fetchMove(id));
    }
    return data;
  }

  /// # fetchMove(`int id`)
  /// ## Fetches a move from PokeAPI.
  /// Returns a [Move] object
  static Future<Move?> fetchMove(int id) async {
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

  static Future<List<int>> fetchBaseStatsAsIntPacket(int id) async {
    List<Map<String, Object?>>? query = (await db?.rawQuery("""
      SELECT * FROM pokemon_stats
      WHERE pokemon_id = ?;
    """, [id]));
    List<int> data = [];
    for (var q in query!) {
      data.insert((q['stat_id'] as int) - 1, q['base_stat'] as int);
    }
    return data;
  }

  static Future<String> fetchString(LanguageBinding binding) async {
    int languageId = LocaleIDs.getIDFromLocale(Platform.localeName);
    String table = binding.table;
    String idColumn = binding.id_column;
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
    return query!.last[binding.string_column] as String;
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
  String id_column = "id";
  int id = 0;
  String string_column = "string";
  LanguageBinding(
      {required this.table,
      required this.id_column,
      required this.id,
      required this.string_column,
      required this.isNameTable});
}
