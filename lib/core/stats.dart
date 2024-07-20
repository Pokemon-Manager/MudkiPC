/// # `Class` Stats
/// ## A container for stats, and required calulations for them.
/// ### Variables:
/// - [hp] is the hp stat.
/// - [attack] is the attack stat.
/// - [defense] is the defense stat.
/// - [specialAttack] is the special attack stat.
/// - [specialDefense] is the special defense stat.
/// - [speed] is the speed stat.
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

  @override
  String toString() {
    return '$hp,$attack,$defense,$specialAttack,$specialDefense,$speed';
  }

  factory Stats.fromString(String stats) {
    List<String> statList = stats.split(',');
    return Stats(
      hp: int.parse(statList[0]),
      attack: int.parse(statList[1]),
      defense: int.parse(statList[2]),
      specialAttack: int.parse(statList[3]),
      specialDefense: int.parse(statList[4]),
      speed: int.parse(statList[5]),
    );
  }
}
