import 'package:flutter/widgets.dart';
import 'package:mudkip_frontend/mudkipc.dart';

/// # `Class` Pokémon
/// ## A class that represents a Pokémon from a Game. Extends the Species class.
/// This class contains all possible information about a Pokémon.
/// ### Variables:
/// - [nickName] is the name of the Pokémon. If the Pokémon has no nickname, this will be the same as the species name.
/// - [gender] is the gender of the pokemon.
/// - [level] is the level of the pokemon.
/// - [exp] is the current experience of the pokemon.
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
  int? uniqueID = 0;
  String nickName = "";
  int? pokemonID =
      0; // Not the same as unique ID. This is the ID of the species and form combined.
  int speciesID = 0;
  int? formID = 0;
  int? exp = 0;
  Stats ev;
  Stats iv;
  int? gender = 0;
  int? abilityID = 0;
  int move1ID;
  int move2ID;
  int move3ID;
  int move4ID;
  int metAt = 0;
  int? otID = 0;
  Pokemon(
      {required this.speciesID,
      required this.nickName,
      this.pokemonID,
      this.exp,
      required this.iv,
      required this.ev,
      this.gender,
      this.abilityID,
      required this.move1ID,
      required this.move2ID,
      required this.move3ID,
      required this.move4ID,
      this.otID,
      this.uniqueID});

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
  Future<String> getNickname() async {
    if (nickName == "") {
      return await (await PokeAPI.fetchSpecies(speciesID) as Species).getName();
    }
    return nickName;
  }

  /// # setGender(`int gender`)
  /// ## Sets the gender of the pokemon.
  /// Get the desired gender from [Genders] in the `enums.dart` file.
  void setGender(int gender) {
    gender = gender;
  }

  int getGender() {
    return gender!;
  }

  /// # setIvStats(`Stats ivStats`)
  /// ## Sets the IVs of the pokemon.
  /// Create a new `Stats` object with the desired IVs and pass it to this function.
  void setIvStats(Stats ivStats) {
    /// Sets the IVs of the pokemon.
    /// @param ivStats - The IVs of the pokemon.
    iv = ivStats;
  }

  Stats getIvStats() {
    return iv;
  }

  /// # setEvStats(`Stats evStats`)
  /// ## Sets the EVs of the pokemon.
  /// Create a new `Stats` object with the desired EVs and pass it to this function.
  void setEvStats(Stats evStats) {
    ev = evStats;
  }

  /// # getEvStats(`Stats evStats`)
  /// ## Gets the EVs of the pokemon.
  /// Returns the EVs of the pokemon. See [Stats] in `stats.dart` for more details.
  Stats getEvStats() {
    return ev;
  }

  /// # getSpecies(`Species species`)
  /// ## Gets the species of the pokemon.
  /// Returns the species of the pokemon. See [Species] in `species.dart` for more details.
  Future<Species?> getSpecies() {
    return PokeAPI.fetchSpecies(speciesID);
  }

  // # setSpecies(`Species species`)
  // ## Sets the species of the pokemon.
  // Set the species of the pokemon to the provided species object.
  void setSpecies(Species species) {
    species = species;
  }

  int getHash() {
    return hashCode;
  }

  /// # `Map<String, Object?>` toDB()
  /// ## Converts the pokemon to a map that can be stored in the database.
  Map<String, Object?> toDB() {
    return {
      "nickName": nickName,
      "speciesID": speciesID,
      "abilityID": abilityID,
      "pokemonID": pokemonID,
      "exp": exp,
      "move1ID": move1ID,
      "move2ID": move2ID,
      "move3ID": move3ID,
      "move4ID": move4ID,
      "iv": iv.toString(),
      "ev": ev.toString(),
      "otID": otID,
      "gender": gender,
    };
  }

  /// # `Pokemon.fromDB(Map<String, dynamic> query)`
  /// ## Creates a [Pokemon] from a map that was retrieved from the database.
  factory Pokemon.fromDB(Map<String, dynamic> query) {
    Pokemon newPokemon = Pokemon(
        uniqueID: query['uniqueID'],
        speciesID: query['speciesID'],
        nickName: query['nickName'],
        pokemonID: query['pokemonID'],
        exp: query['exp'],
        iv: Stats.fromString(query['iv']),
        ev: Stats.fromString(query['ev']),
        gender: query['gender'],
        abilityID: query['abilityID'],
        move1ID: query['move1ID'],
        move2ID: query['move2ID'],
        move3ID: query['move3ID'],
        move4ID: query['move4ID'],
        otID: query['otID']);
    return newPokemon;
  }

  static Pokemon fromArceus(Map<String, dynamic> result) {
    return Pokemon(
        speciesID: result['speciesID'],
        nickName: result['nickname'],
        exp: result['exp'],
        iv: Stats(
            hp: result["ivSpan"]['ivHp'],
            attack: result["ivSpan"]['ivAtk'],
            defense: result["ivSpan"]['ivDef'],
            specialAttack: result["ivSpan"]['ivSpAtk'],
            specialDefense: result["ivSpan"]['ivSpDef'],
            speed: result["ivSpan"]['ivSpeed']),
        ev: Stats(
            hp: result['evHp'],
            attack: result['evAtk'],
            defense: result['evDef'],
            specialAttack: result['evSpAtk'],
            specialDefense: result['evSpDef'],
            speed: result['evSpeed']),
        gender: result['genderSpan']['gender'],
        abilityID: result['ability'],
        move1ID: result['move1'],
        move2ID: result['move2'],
        move3ID: result['move3'],
        move4ID: result['move4']);
  }

  AssetImage getSprite() {
    return AssetImage("assets/images/sprites/$speciesID.png");
  }
}
