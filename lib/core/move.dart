import 'package:mudkip_frontend/pokemon_manager.dart';

/// # `Class` Move
/// ## A class that represents a move from a Game.
class Move {
  int id = 0; // ID of the move.
  String description = ""; // Description of the move.
  int? power; // Power of the move.
  int? accuracy; // Accuracy of the move.
  int pp; // PP of the move.
  int priority = 0; // Priority of the move.
  Move({required this.power, required this.accuracy, required this.pp});

  factory Move.fromJson(Map<String, dynamic> json) {
    return Move(
      power: json['power'],
      accuracy: json['accuracy'],
      pp: json['pp'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "power": power,
      "accuracy": accuracy,
      "pp": pp,
    };
  }

  factory Move.fromDB(Map<String, Object?> query) {
    return Move(
      power: query['power'] as int?,
      accuracy: query['accuracy'] as int?,
      pp: query['pp'] as int,
    );
  }
  Future<String> getName() {
    return PokeAPI.fetchString(LanguageBinding(
        id: id,
        table: "move_names",
        idColumn: "move_id",
        stringColumn: "name",
        isNameTable: true));
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
}
