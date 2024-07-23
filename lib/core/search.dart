class Pachinko {
  List<Pin> pins = [];

  Pachinko nickname(String nickname) {
    pins.add(NicknamePin(nickname));
    return this;
  }
}

sealed class Pin {
  dynamic compare;
  String sqlStatement = "";
  Pin(this.compare);
}

class NicknamePin extends Pin {
  NicknamePin(String super.compare);
  @override
  String get sqlStatement => "nickName = ?";
}

class SpeciesPin extends Pin {
  SpeciesPin(String super.compare);
  @override
  String get sqlStatement => "speciesID = ?";
}

class TypePin extends Pin {
  TypePin(String super.compare);
  @override
  String get sqlStatement => "(type1 = ? OR type2 = ?)";
}

class AbilityPin extends Pin {
  AbilityPin(String super.compare);
  @override
  String get sqlStatement => "ability = ?";
}

class MovePin extends Pin {
  MovePin(String super.compare);
  @override
  String get sqlStatement =>
      "move1ID = ? OR move2ID = ? OR move3ID = ? OR move4ID = ?";
}
