import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:pokemon_manager/pokemon_manager.dart';

/// # PokeAPI
/// ## A class that represents PokeAPI.
/// The fetch functions returns the object you are looking for, so you can get the object you need.
/// If you are confused on what the difference is between this and the [PC] class, remember this:
/// - PC = User's Data (Pokemon, Items, etc.) This is not consitent.
/// - PokeAPI = PokeDex Data (Species, Moves, etc.) This is consitent.
class PokeAPI {
  static const String baseURL = "https://pokeapi.co/api/v2";
  static Map<int, Species> species = {};
  static Map<int, Move> moves = {};
  static Map<int, Ability> abilities = {};
  static Future<http.Response> fetch(String section, String query) async {
    return await http
        .get(Uri.parse("https://pokeapi.co/api/v2/$section/$query"));
  }

  /// # fetchSpecies(`int id`)
  /// ## Fetches a species from PokeAPI.
  ///
  static Future<Species> fetchSpecies(int id) async {
    if (species.containsKey(id)) {
      return species[id]!;
    }
    final response = await fetch("pokemon", "$id");
    if (response.statusCode == 200) {
      species[id] =
          Species.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      return species[id]!;
    } else {
      throw Exception("Failed to create species $id");
    }
  }

  /// # fetchMove(`int id`)
  /// ## Fetches a move from PokeAPI.
  /// Returns a [Move] object
  static Future<Move> fetchMove(int id) async {
    final response = await fetch("move", "$id");
    if (response.statusCode == 200) {
      moves[id] =
          Move.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      return moves[id]!;
    } else {
      throw Exception("Failed to create move $id");
    }
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

  static Future<Image> fetchImage(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return Image.memory(response.bodyBytes);
    } else {
      throw Exception("Failed to fetch image");
    }
  }
}
