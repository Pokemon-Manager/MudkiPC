import 'package:pokemon_manager/core/stats.dart';
import 'package:pokemon_manager/core/elements.dart';

class Species {
  String speciesName = "";
  int id = 0;
  Typing typing = Typing(type1: Normal());
  Stats baseStats;
  Species(
      {required this.speciesName,
      required this.typing,
      required this.id,
      required this.baseStats});

  factory Species.fromJson(Map<String, dynamic> json) {
    return Species(
      id: json['id'],
      typing: Typing.fromJson(json['types']),
      speciesName: json['name'],
      baseStats: Stats.fromJson(json['stats']),
    );
  }

  String getName() {
    return speciesName;
  }

  int getId() {
    return id;
  }

  Stats getBaseStats() {
    return baseStats;
  }
}
