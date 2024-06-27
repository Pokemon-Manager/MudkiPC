import 'package:pokemon_manager/pokemon_manager.dart';

/// # `Class` Species
/// ## A class that contains all of the data for a [Pokemon]'s [Species].
/// Every instance is shared between [Pokemon]s, so if a update to [Species] is made, all [Pokemon]s will be updated with the new data.
/// At first, the plan was to make this the super class of [Pokemon]; however, that would require a lot of work arounds to get it to work.
/// So instead, [PokeAPI] stores a Map containing all of the already created [Species]s objects.
/// If you want to know more about how [Species] is created, look at the [PokeAPI] class.
class Species {
  LocalizedString speciesNames = LocalizedString();
  LocalizedString descriptions = LocalizedString();
  int id = 0;
  Typing typing = Typing(type1: Normal());
  Stats baseStats = Stats(hp: 0, attack: 0, defense: 0, specialAttack: 0, specialDefense: 0, speed: 0);

  Species(
      {
      required this.typing,
      required this.speciesNames,
      required this.descriptions,
      required this.id,
      required this.baseStats});
  /// # Species.fromJson(`Map<String, dynamic> json`)
  /// ## Creates a new Species from a json object.
  /// Because the API fragments the data, we need to combine multiple request into one final Map.
  /// If you want, for example, the evolution chain, first you need to figure out the endpoint it is stored at.
  /// One of the evolution chain endpoints is `pokemon-species`, so just use the key of that to get the data.
  /// The `PokeAPI` will all of the required data and combine them before calling this.
  factory Species.fromJson(Map<String, dynamic> json) {
    return Species(
      id: json['pokemon']['id'],
      speciesNames: LocalizedString.fromJson(json['pokemon-species']['names']),
      descriptions: LocalizedString.fromJson(json['pokemon-species']['flavor_text_entries']),
      typing: Typing.fromJson(json['pokemon']['types']),
      baseStats: Stats.fromJson(json['pokemon']['stats']),
    );
  }

  String getName() {
    return speciesNames.getLocalizedString();
  }

  int getId() {
    return id;
  }

  Stats getBaseStats() {
    return baseStats;
  }

  /// # getFrontImageUrl()
  /// ## Returns the url of the front image of the pokemon.
  /// Returns a string that is the url of the front image of the pokemon.
  /// Example: https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png
  String getFrontImageUrl() {
    return "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png";
  }

  /// # getBackImageUrl()
  /// ## Returns the url of the back image of the pokemon.
  /// Returns a string that is the url of the back image of the pokemon.
  /// Example: https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/1.png
  String getBackImageUrl() {
    return "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/$id.png";
  }

  /// # getDescription()
  /// ## Returns the description of the pokemon.
  /// Returns a string that is the description of the pokemon.
  /// Will be localized to the current language.
  String getDescription() {
    return descriptions.getLocalizedString();
  }
}
