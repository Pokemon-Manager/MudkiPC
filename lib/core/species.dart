import 'package:flutter/material.dart';
import 'package:pokemon_manager/pokemon_manager.dart';

class Species {
  String speciesName = "";
  IconData icon = Icons.question_mark;
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

  void setIcon(IconData icon) {
    this.icon = icon;
  }

  IconData getIcon() {
    return icon;
  }

  String getFrontImageUrl() {
    return "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png";
  }

  String getBackImageUrl() {
    return "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/$id.png";
  }
}
