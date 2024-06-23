import 'package:pokemon_manager/pokemon_manager.dart';

/// # Pokémon
/// ## A class that represents a Pokémon from a Game. Extends the Species class.
///
/// ### Variables:
/// - [nickName] is the name of the Pokémon. If the Pokémon has no nickname, this will be the same as the species name.
/// - [gender] is the gender of the pokemon.
/// - [level] is the level of the pokemon.
/// - [exp] is the current experience of the pokemon.
/// - []
/// - [species] is the species of the pokemon.
/// - [ivStats] is the IVs of the Pokémon.
/// - [evStats] is the EVs of the Pokémon.
///
/// ### Functions:
/// - [setNickname] sets the nickname of the pokemon.
/// - [getNickname] gets the nickname of the pokemon.
/// - [resetNickname] resets the nickname of the pokemon to an empty string.
/// - [setIvStats] sets the IVs of the pokemon.
/// - [getIvStats] gets the IVs of the pokemon.
/// - [setEvStats] sets the EVs of the pokemon.
/// - [getEvStats] gets the EVs of the pokemon.
/// - [getSpecies] gets the species of the pokemon.
/// - [setSpecies] sets the species of the pokemon.
/// - [getBaseStats] gets the base stats of the pokemon.
class Pokemon {
  String nickName = "";
  Species species;
  int gender = 0;
  int level = 0;
  int exp = 0;
  Ability ability = Ability(name: "", description: "", id: 0);
  Move? move1;
  Move? move2;
  Move? move3;
  Move? move4;

  // Stats
  Stats ivStats = Stats(
      hp: 0,
      attack: 0,
      defense: 0,
      specialAttack: 0,
      specialDefense: 0,
      speed: 0);
  Stats evStats = Stats(
      hp: 0,
      attack: 0,
      defense: 0,
      specialAttack: 0,
      specialDefense: 0,
      speed: 0);
  Pokemon({required this.species});

  factory Pokemon.fromJson(Species species, Map<String, dynamic> json) {
    Pokemon newPokemon = Pokemon(species: species);
    for (String key in json.keys) {
      switch (key) {
        case "ivStats":
          newPokemon.setIvStats(Stats.fromJson(json[key]));
          break;
        case "evStats":
          newPokemon.setEvStats(Stats.fromJson(json[key]));
          break;
        case "gender":
          newPokemon.setGender(json[key]);
        case "nickname":
          newPokemon.setNickname(json[key]);
          break;
      }
    }
    return newPokemon;
  }

  Map<String, dynamic> toJson() {
    return {
      "nickname": nickName,
      "typing": species.typing.toJson(),
      "ivStats": ivStats.toJson(),
      "evStats": evStats.toJson(),
      "gender": gender,
      "species": species,
      "level": exp,
    };
  }

  /// Sets the nickname of the pokemon.
  /// @param nickname - The nickname of the pokemon.
  void setNickname(String nickname) {
    nickName = nickname;
  }

  // Resets the nickname of the pokemon to an empty string.
  void resetNickname() {
    nickName = "";
  }

  /// Gets the nickname of the pokemon.
  /// @returns - The nickname of the pokemon. If the pokemon has no nickname, this will be the same as the species name.
  String getNickname() {
    if (nickName == "") {
      return species.getName();
    }
    return nickName;
  }

  /// # setGender(`int gender`)
  /// ## Sets the gender of the pokemon.
  /// Get the desired gender from [Genders] in the `enums.dart` file.
  void setGender(int gender) {
    this.gender = gender;
  }

  int getGender() {
    return gender;
  }

  /// # setIvStats(`Stats ivStats`)
  /// ## Sets the IVs of the pokemon.
  /// Create a new `Stats` object with the desired IVs and pass it to this function.
  void setIvStats(Stats ivStats) {
    /// Sets the IVs of the pokemon.
    /// @param ivStats - The IVs of the pokemon.
    this.ivStats = ivStats;
  }

  Stats getIvStats() {
    /// Gets the IVs of the pokemon.
    /// @returns - The IVs of the pokemon.
    return ivStats;
  }

  /// # setEvStats(`Stats evStats`)
  /// ## Sets the EVs of the pokemon.
  /// Create a new `Stats` object with the desired EVs and pass it to this function.
  void setEvStats(Stats evStats) {
    this.evStats = evStats;
  }

  Stats getEvStats() {
    return evStats;
  }

  Species getSpecies() {
    return species;
  }

  void setSpecies(Species species) {
    species = species;
  }

  Stats getBaseStats() {
    return species.getBaseStats();
  }

  int getHash(){
    return hashCode;
  }
}