import 'package:mudkip_frontend/mudkipc.dart';

/// # `Class` Ability
/// ## A class that represents an ability from a Game.
class Ability {
  String name = ""; // Name of the ability.
  String description = ""; // Description of the ability.
  int id = 0; // ID of the ability.
  List<Species> learnableBy =
      []; // List of species that can learn this ability.
  List<Pokemon> knownBy =
      []; // List of pokemons that have learned this ability.
  Ability({required this.name, required this.description, required this.id});
}
