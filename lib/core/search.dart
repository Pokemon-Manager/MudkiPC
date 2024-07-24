import 'package:flutter/material.dart';

class Pachinko {
  List<Pin> pins = [];

  Pachinko nickname(String nickname) {
    pins.add(NicknamePin(nickname, this));
    return this;
  }
}

sealed class Pin {
  dynamic compare;
  String sqlStatement = "";
  Pachinko pachinkoMachine = Pachinko();
  Pin(this.compare, this.pachinkoMachine);
  Widget getChip() {
    return Chip(avatar: const Icon(Icons.search), label: Text(compare));
  }
}

class NicknamePin extends Pin {
  NicknamePin(String super.compare, super.pachinkoMachine);
  @override
  String get sqlStatement => "nickName = ?";
}

class SpeciesPin extends Pin {
  SpeciesPin(int super.compare, super.pachinkoMachine);
  @override
  String get sqlStatement => "speciesID = ?";
}

class TypePin extends Pin {
  TypePin(int super.compare, super.pachinkoMachine);
  @override
  String get sqlStatement => "(type1 = ? OR type2 = ?)";
}

class AbilityPin extends Pin {
  AbilityPin(int super.compare, super.pachinkoMachine);
  @override
  String get sqlStatement => "ability = ?";
}

class MovePin extends Pin {
  MovePin(int super.compare, super.pachinkoMachine);
  @override
  String get sqlStatement =>
      "move1ID = ? OR move2ID = ? OR move3ID = ? OR move4ID = ?";
}
