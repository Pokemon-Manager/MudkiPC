import 'package:flutter/material.dart';
import 'package:mudkip_frontend/core/databases.dart';
import 'package:mudkip_frontend/widgets/text_with_loader.dart';

class Pachinko {
  List<Pin> pins = [];

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
}

sealed class Pin {
  bool isForUserPokemon =
      false; // i.e. Is this pin for the user's pokemon or for the species?
  dynamic compare;
  String sqlStatement = "";
  Pachinko pachinkoMachine = Pachinko();
  Pin(this.compare, this.pachinkoMachine);
  Widget getChip() {
    return Chip(avatar: const Icon(Icons.search), label: Text(compare));
  }
}

class NicknamePin extends Pin {
  @override
  bool get isForUserPokemon => true;
  NicknamePin(String super.compare, super.pachinkoMachine);
  @override
  String get sqlStatement => "nickName = ?";
}

class SpeciesPin extends Pin {
  @override
  bool get isForUserPokemon => true;
  SpeciesPin(int super.compare, super.pachinkoMachine);
  @override
  String get sqlStatement => "speciesID = ?";
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
