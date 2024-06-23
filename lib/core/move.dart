import 'package:pokemon_manager/pokemon_manager.dart';

/// # Move
/// ## A class that represents a move from a Game.
/// TODO: Add ability to search by moves. Not sure how to do that yet.
class Move {
  String name = "";
  int id = 0;
  String description = "";
  Typing typing = Typing(type1: Normal());
  int? power;
  int? accuracy;
  int pp;
  int priority = 0;
  List<Species> learnableBy = []; // List of species that can learn this move.
  List<Pokemon> knownBy = []; // List of pokemons that have learned this move.
  Move(
      {required this.name,
      required this.power,
      required this.typing,
      required this.accuracy,
      required this.pp});

  factory Move.fromJson(Map<String, dynamic> json) {
    return Move(
      name: json['name'],
      power: json['power'],
      typing: Typing.fromJson(json['type']),
      accuracy: json['accuracy'],
      pp: json['pp'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "power": power,
      "type": typing.toJson(),
      "accuracy": accuracy,
      "pp": pp,
    };
  }

  String getName() {
    return name;
  }

  int getId() {
    return id;
  }

  int? getPower() {
    return power;
  }

  int? getAccuracy() {
    return accuracy;
  }

  int getPp() {
    return pp;
  }

  int getPriority() {
    return priority;
  }

  bool isLearnableBy({Pokemon? pokemon, Species? species}) {
    return learnableBy.contains(pokemon?.getSpecies() ?? species!);
  }
}
