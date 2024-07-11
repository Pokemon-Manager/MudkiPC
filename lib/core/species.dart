import 'package:mudkip_frontend/pokemon_manager.dart';

/// # `Class` Species
/// ## A class that contains all of the data for a [Pokemon]'s [Species].
/// Every instance is shared between [Pokemon]s, so if a update to [Species] is made, all [Pokemon]s will be updated with the new data.
/// At first, the plan was to make this the super class of [Pokemon]; however, that would require a lot of work arounds to get it to work.
/// So instead, [PokeAPI] stores a Map containing all of the already created [Species]s objects.
/// If you want to know more about how [Species] is created, look at the [PokeAPI] class.
class Species {
  int id;

  Species({required this.id});

  factory Species.fromDB(Map query) {
    Species newSpecies = Species(id: query["id"] as int);
    return newSpecies;
  }

  Future<String> getName() {
    return PokeAPI.fetchString(LanguageBinding(
        id: id,
        table: "pokemon_species_names",
        id_column: "pokemon_species_id",
        string_column: "name",
        isNameTable: true));
  }

  int getId() {
    return id;
  }

  Future<Stats> getBaseStats() {
    return PokeAPI.fetchBaseStats(id);
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
  Future<String> getDescription() {
    return PokeAPI.fetchString(LanguageBinding(
        id: id,
        table: "pokemon_species_flavor_text",
        id_column: "species_id",
        string_column: "flavor_text",
        isNameTable: false));
  }
}
