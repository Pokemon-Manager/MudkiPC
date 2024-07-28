import 'package:mudkip_frontend/pokemon_manager.dart';

/// # `Class` Species
/// ## Acts as a interface for getting information about a [Species].
/// This class only contains the id of the species, and the methods in the class just calls associated functions from the `PokeAPI` class.
/// So every function is asynchronous, so be smart about fetching data for the frontend.
/// MudkiPC has packages and custom made widgets for this extact purpose. Use `TextWithLoaderBuffer`, and `AsyncPlaceholder` for safe fetching of data in the frontend.
/// ```dart
/// AsyncPlaceholder(
///   future: PokeAPI.fetchSpecies(1),
///   childBuilder: (species) => SpeciesEntry(species: species),
/// );
/// ```
///
/// There are some instances where you may want to first fetch a Pokemon and then get its Species,
/// but you would need nested FutureBuilders and AsyncPlaceholders, which is messy.
/// So, remember to use the `then` function to get the pokemon and then get its Species, and then the data you need.
/// ```dart
/// AsyncPlaceholder(
///   future: PC.fetchPokemon(1),
///   childBuilder: (pokemon) => TextWithLoaderBuffer(future: pokemon.getSpecies().then((value) => (value! as Species).getName()) as Future<String>),
/// );
/// ```

class Species {
  int id;
  int height = 0;
  int weight = 0;
  Species({required this.id});

  factory Species.fromDB(Map query) {
    Species newSpecies = Species(id: query["id"] as int);
    newSpecies.height = query["height"] as int;
    newSpecies.weight = query["weight"] as int;
    return newSpecies;
  }

  Future<String> getName() {
    return PokeAPI.fetchString(LanguageBinding(
        id: id,
        table: "pokemon_species_names",
        idColumn: "pokemon_species_id",
        stringColumn: "name",
        isNameTable: true));
  }

  int getId() {
    return id;
  }

  Future<Stats> getBaseStats() {
    return PokeAPI.fetchBaseStats(id);
  }

  Future<Typing> getTyping() {
    return PokeAPI.fetchTypingForSpecies(id);
  }

  /// # getFrontImageUrl()
  /// ## Returns the url of the front image of the pokemon.
  /// Returns a string that is the url of the front image of the pokemon.
  /// Example: https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png
  String getFrontImageUrl() {
    return "assets/images/sprites/$id.png";
  }

  /// # getBackImageUrl()
  /// ## Returns the url of the back image of the pokemon.
  /// Returns a string that is the url of the back image of the pokemon.
  /// Example: https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/1.png
  String getBackImageUrl() {
    return "images/sprites/back/$id.png";
  }

  /// # getDescription()
  /// ## Returns the description of the pokemon.
  /// Returns a string that is the description of the pokemon.
  /// Will be localized to the current language.
  Future<String> getDescription() {
    return PokeAPI.fetchString(LanguageBinding(
        id: id,
        table: "pokemon_species_flavor_text",
        idColumn: "species_id",
        stringColumn: "flavor_text",
        isNameTable: false));
  }
}

/// # `Class` Form extends `Species`
/// ## Acts as a interface for getting information about an alternate [Form] of a [Species].
/// TODO: Add form support.
class Form extends Species {
  int formID = 0;
  Form({required super.id});
}
