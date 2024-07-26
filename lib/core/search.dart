import 'package:flutter/material.dart';
import 'package:mudkip_frontend/core/databases.dart';
import 'package:mudkip_frontend/main.dart';
import 'package:mudkip_frontend/widgets/text_with_loader.dart';

class Pachinko with ChangeNotifier {
  List<Pin> pins = [];
  SearchController searchController = SearchController();
  Future<List<ListTile>> generateSuggestions(
      BuildContext context, SearchController search) async {
    List<String> initialSuggestions = [
      "nickname:",
      "species:",
      "knownMove:",
      "type:",
      "learnableMove:",
      "knownAbility:",
      "learnableAbility:",
      "generation:",
      "region:",
    ];
    List<String?> finalSuggestions = initialSuggestions
        .where((element) =>
            element.startsWith(search.value.text) &&
            element != search.value.text)
        .toList();
    List<Map<String, Object?>>? query;
    if (finalSuggestions.isEmpty && search.value.text.contains(":")) {
      switch (search.value.text.split(":")[0]) {
        case "species":
          query = await PokeAPI.getSpeciesSuggestions(
              search.value.text.split(":")[1]);
          List<String?> suggestions = [];
          for (var element in query!) {
            suggestions.add(element["name"] as String?);
          }
          finalSuggestions = suggestions;
          break;
      }
    }
    return List<ListTile>.generate(finalSuggestions.length, (index) {
      return ListTile(
        title: Text(finalSuggestions[index] ?? ""),
        onTap: () {
          if (finalSuggestions[index] != null) {
            if (search.value.text.contains(":")) {
              switch (search.value.text.split(":")[0]) {
                case "species":
                  species(query?[index]["id"] as int);
                  break;
              }
              searchController.clear();
              searchController.closeView("");
              notifyListeners();
              router.refresh();
            } else {
              search.text = finalSuggestions[index]!;
            }
          }
        },
      );
    });
  }

  String formSQLStatement() {
    if (pins.isEmpty) {
      return "";
    }
    return pins
        .map((pin) => pin.sqlStatement)
        .where((element) => element != "")
        .join(" AND ");
  }

  List<Object?> formArguments() {
    return pins
        .map((pin) => pin.compare)
        .where((element) => element != null)
        .toList();
  }

  List<Widget> getChips() {
    List<Widget> chips = [];
    for (var pin in pins) {
      chips.add(pin.getChip());
    }
    return chips;
  }

  Pachinko nickname(String nickname) {
    pins.add(NicknamePin(nickname, this));
    return this;
  }

  Pachinko species(int speciesID) {
    pins.add(SpeciesPin(speciesID, this));
    return this;
  }

  Pachinko type(int typeID) {
    pins.add(TypePin(typeID, this));
    return this;
  }

  Pachinko knownMove(int moveID) {
    pins.add(KnownMovePin(moveID, this));
    return this;
  }

  Pachinko learnableMove(int moveID) {
    pins.add(LearnableMovePin(moveID, this));
    return this;
  }

  Pachinko knownAbility(int abilityID) {
    pins.add(KnownAbilityPin(abilityID, this));
    return this;
  }

  Pachinko learnableAbility(int abilityID) {
    pins.add(LearnableAbilityPin(abilityID, this));
    return this;
  }

  void remove(Pin pin) {
    pins.remove(pin);
    notifyListeners();
    if (searchController.isOpen) {
      searchController.closeView("");
    }
    router.refresh();
  }
}

sealed class Pin {
  bool isForUserPokemon =
      false; // i.e. Is this pin for the user's pokemon or for the species?
  dynamic compare;
  String sqlStatement = "";
  Pachinko pachinkoMachine = Pachinko();
  Pin(this.compare, this.pachinkoMachine);

  String searchFilter() {
    return sqlStatement;
  }

  Widget getChip() {
    return Chip(avatar: const Icon(Icons.search), label: Text(compare));
  }
}

class NicknamePin extends Pin {
  @override
  bool get isForUserPokemon => true;
  NicknamePin(String super.compare, super.pachinkoMachine);
  @override
  String get sqlStatement => "nickName LIKE ?";
}

class SpeciesPin extends Pin {
  @override
  bool get isForUserPokemon => true;
  SpeciesPin(int super.compare, super.pachinkoMachine);
  @override
  String get sqlStatement => "speciesID = ?";

  @override
  Widget getChip() {
    return Chip(
      label: TextWithLoaderBuffer(
        future: PokeAPI.fetchString(LanguageBinding(
          table: "pokemon_species_names",
          idColumn: "pokemon_species_id",
          stringColumn: "name",
          id: compare,
          isNameTable: true,
        )),
        builder: (context, name) =>
            Text(name, style: const TextStyle(fontSize: 13)),
      ),
      deleteIcon: Icon(Icons.delete),
      onDeleted: () {
        pachinkoMachine.remove(this);
      },
    );
  }
}

class TypePin extends Pin {
  TypePin(int super.compare, super.pachinkoMachine);
  @override
  String get sqlStatement => "type_id = ?";
}

class AbilityPin extends Pin {
  AbilityPin(int super.compare, super.pachinkoMachine);
  @override
  String get sqlStatement => "ability_id = ?";
  @override
  Widget getChip() {
    return Chip(
        label: TextWithLoaderBuffer(
      future: PokeAPI.fetchString(LanguageBinding(
        table: "ability_names",
        idColumn: "ability_id",
        stringColumn: "name",
        id: compare,
        isNameTable: true,
      )),
      builder: (context, name) =>
          Text(name, style: const TextStyle(fontSize: 13)),
    ));
  }
}

class KnownAbilityPin extends AbilityPin {
  @override
  bool get isForUserPokemon => true;
  KnownAbilityPin(super.compare, super.pachinkoMachine);
  @override
  String get sqlStatement => "ability = ?";
}

class LearnableAbilityPin extends AbilityPin {
  LearnableAbilityPin(super.compare, super.pachinkoMachine);
  @override
  String get sqlStatement => "ability_id = ?";
}

class MovePin extends Pin {
  MovePin(int super.compare, super.pachinkoMachine);
  @override
  String get sqlStatement => "move_id = ?";
  @override
  Widget getChip() {
    return Chip(
        label: TextWithLoaderBuffer(
      future: PokeAPI.fetchString(LanguageBinding(
        table: "move_names",
        idColumn: "move_id",
        stringColumn: "name",
        id: compare,
        isNameTable: true,
      )),
      builder: (context, name) =>
          Text(name, style: const TextStyle(fontSize: 13)),
    ));
  }
}

class KnownMovePin extends MovePin {
  @override
  bool get isForUserPokemon => true;
  KnownMovePin(super.compare, super.pachinkoMachine);
  @override
  String get sqlStatement =>
      "move1ID = ? OR move2ID = ? OR move3ID = ? OR move4ID = ?";
}

class LearnableMovePin extends MovePin {
  LearnableMovePin(super.compare, super.pachinkoMachine);
  @override
  String get sqlStatement => "move_id = ?";
}
