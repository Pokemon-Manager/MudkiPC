class Stats {
  int hp;
  int attack;
  int defense;
  int specialAttack;
  int specialDefense;
  int speed;
  Stats(
      {required this.hp,
      required this.attack,
      required this.defense,
      required this.specialAttack,
      required this.specialDefense,
      required this.speed});

  factory Stats.fromJson(List<dynamic> json) {
    return Stats(
      hp: json[0]['base_stat'],
      attack: json[1]['base_stat'],
      defense: json[2]['base_stat'],
      specialAttack: json[3]['base_stat'],
      specialDefense: json[4]['base_stat'],
      speed: json[5]['base_stat'],
    );
  }

  List<dynamic> toJson() {
    return [
      {"hp": hp},
      {"attack": attack},
      {"defense": defense},
      {"special_attack": specialAttack},
      {"special_defense": specialDefense},
      {"speed": speed},
    ];
  }
}
