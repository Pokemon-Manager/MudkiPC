import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:mudkip_frontend/pokemon_manager.dart';

/// # PokeAPI
/// ## A class that represents PokeAPI.
/// The fetch functions returns the object you are looking for, so you can get the object you need.
/// If you are confused on what the difference is between this and the [PC] class, remember this:
/// - PC = User's Data (Pokemon, Items, etc.) This is not consitent.
/// - PokeAPI = PokeDex Data (Species, Moves, etc.) This is consitent.
///

class PokeAPI {
  static const String baseURL = "https://pokeapi.co/api/v2";
  static Map<int, Species> species = {};
  static Map<int, Move> moves = {};
  static Map<int, Ability> abilities = {};
  static Future<PokeAPI> create() async {
    return PokeAPI();
  }

  static Future<http.Response> fetch(String section, String query) async {
    return await http
        .get(Uri.parse("https://pokeapi.co/api/v2/$section/$query"));
  }

  /// # fetchSpecies(`int id`)
  /// ## Fetches a species from PokeAPI.
  /// Returns a [Species] object. It fetches multiple endpoints and combines them into one Map.
  /// If you want to fetch a single endpoint, use [fetch].
  /// If you want to learn why mutiple fetches are needed, look at the [Species] class.
  /// ### Current Endpoints:
  /// - pokemon
  /// - pokemon-species
  static Future<Species> fetchSpecies(int id) async {
    if (species.containsKey(id)) {
      return species[id]!;
    }
    Map<String, dynamic> data = {};
    dynamic response = await fetch("pokemon", "$id");
    if (response.statusCode != 200) {
      throw Exception("Failed to create species $id");
    }
    data["pokemon"] = jsonDecode(response.body) as Map<String, dynamic>;
    response = await fetch("pokemon-species", "$id");
    if (response.statusCode != 200) {
      throw Exception("Failed to create species $id");
    }
    data["pokemon-species"] = jsonDecode(response.body) as Map<String, dynamic>;
    species[id] = Species.fromJson(data);
    return species[id]!;
  }

  /// # fetchMove(`int id`)
  /// ## Fetches a move from PokeAPI.
  /// Returns a [Move] object
  static Future<Move?> fetchMove(int id) async {
    if (id == 0) {
      return null;
    }
    if (moves.containsKey(id)) {
      return moves[id]!;
    }
    Map<String, dynamic> data = {};
    dynamic response = await fetch("move", "$id");
    if (response.statusCode != 200) {
      throw Exception("Failed to create move $id");
    }
    data = jsonDecode(response.body) as Map<String, dynamic>;
    moves[id] = Move.fromJson(data);
    return moves[id];
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
