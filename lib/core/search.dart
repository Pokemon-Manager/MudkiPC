import 'dart:async';

import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:macos_ui/macos_ui.dart' as macos;
// import 'package:flutter/cupertino.dart' as cupertino;
import 'package:flutter/material.dart' as material;
import 'package:flutter/widgets.dart';

import 'package:mudkip_frontend/core/databases.dart';
import 'package:mudkip_frontend/main.dart';
import 'package:mudkip_frontend/universal_builder.dart';
import 'package:mudkip_frontend/widgets/text_with_loader.dart';

/// # `Class` Pachinko with `ChangeNotifier`
/// ## A class that contains functions for searching in the application.
/// Contains a list of pins, a search controller, and a function to generate suggestions.
class Pachinko with ChangeNotifier {
  List<Pin> pins = [];
  Future<List<Suggestion>> generateSuggestions(String search) async {
    // Generate suggestions for the search bar.
    List<String> initialSuggestions = [
      // The initial suggestions
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
        .where((element) => element.startsWith(search) && element != search)
        .toList(); // Gets the suggestions that start with the search bar text.
    // Function onSelected = (int value) {
    //   search.text = finalSuggestions[value] ?? "";
    // };
    if (finalSuggestions.isEmpty && search.contains(":")) {
      switch (search.split(":")[0]) {
        case "species":
          List<Map<String, Object?>>? query =
              await PokeAPI.getSpeciesSuggestions(search.split(":")[1]);
          List<String?> suggestions = [];
          for (var element in query!) {
            suggestions.add(element["name"] as String?);
          }
          // onSelected = (int value) {
          //   species(query[value]["id"] as int);
          //   clearSearchBar();
          // };
          finalSuggestions = suggestions;
          break;
      }
    }
    List<Suggestion> finalList =
        List.generate(finalSuggestions.length, (int index) {
      return Suggestion(finalSuggestions[index]!, index, () {});
    });
    return finalList;
  }

  void clearSearchBar() {
    notifyListeners();
    router.refresh();
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
    router.refresh();
  }
}

/// # `Class` Suggestion
/// ## A class that represents a suggestion for the search bar.
/// Contains a name, an id, and an onSelect function. There are different implementations of this class for each platform.
class Suggestion {
  String name;
  int id;
  Function? onSelect;
  Suggestion(this.name, this.id, this.onSelect);

  material.ListTile getForMaterial() {
    return material.ListTile(
      title: Text(name),
      onTap: onSelect != null ? () => onSelect!() : null,
    );
  }

  fluent.ListTile getForFluent() {
    return fluent.ListTile(
      title: Text(name),
      onPressed: onSelect != null ? () => onSelect!() : null,
    );
  }

  macos.MacosListTile getForMacOS() {
    return macos.MacosListTile(
      title: Text(name),
      onClick: onSelect != null ? () => onSelect!() : null,
    );
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
    return UniversalChip(
        avatar: const Icon(material.Icons.search), text: compare);
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
    return material.Chip(
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
      deleteIcon: const Icon(material.Icons.delete),
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
    return UniversalChip(
        text: "",
        avatar: TextWithLoaderBuffer(
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
    return UniversalChip(
        text: "",
        avatar: TextWithLoaderBuffer(
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
  String get sqlStatement => "move1 = ? OR move2 = ? OR move3 = ? OR move4 = ?";
}

class LearnableMovePin extends MovePin {
  LearnableMovePin(super.compare, super.pachinkoMachine);
  @override
  String get sqlStatement => "move_id = ?";
}
