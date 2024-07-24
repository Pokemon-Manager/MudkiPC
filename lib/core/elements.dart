import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mudkip_frontend/pokemon_manager.dart';

/// # Typing
/// ## A class that represents the typing of a [Species] or [Move].
///
/// Try to always use [isSingleType] to check if the typing is single or dual, before trying to access type2.
/// Example:
/// ```dart
/// if (typing.isSingleType()) {
///   // then it means that type2 is null
/// }
/// else {
///   // then it means that type2 is not null and can be safely accessed.
/// }
/// ```
class Typing {
  TypeElement type1;
  TypeElement? type2; // can be null

  Typing({required this.type1, this.type2});

  /// # isSingleType()
  /// ## Checks if this Typing instance is single or dual.
  /// Returns true if the Typing instance is single, false if it is dual.
  bool isSingleType() {
    return type2 == null;
  }

  /// # getType1()
  /// ## Gets the first type of this Typing instance.
  /// Returns the first type element of the Typing instance.
  TypeElement getType1() {
    return type1;
  }

  /// # getType2()
  /// ## Gets the second type of this Typing instance.
  /// Returns the second type element of the Typing instance, which can be null.
  TypeElement? getType2() {
    return type2;
  }

  /// # getMultiplier(`TypeElement type_to_check`)
  /// ## Gets the multiplier of this Typing instance.
  /// Returns the multiplier of the Typing instance.
  double getMultiplier(TypeElement typeToCheck) {
    // TODO: implement getMultiplier
    return 1.0;
  }

  factory Typing.fromJson(dynamic json) {
    if (json is List<dynamic>) {
      if (json.length == 1) {
        return Typing(type1: TypeElement.fromJson(json.first));
      } else {
        return Typing(
            type1: TypeElement.fromJson(json.first as Map<String, dynamic>),
            type2: TypeElement.fromJson(json.last as Map<String, dynamic>));
      }
    } else if (json is Map<String, dynamic>) {
      return Typing(type1: TypeElement.fromJson({"type": json}));
    } else {
      return Typing(type1: Normal());
    }
  }

  factory Typing.fromDB(List<Map<String, Object?>> query) {
    if (query.length == 1) {
      return Typing(type1: TypeElement.fromDB(query.first));
    } else {
      return Typing(
          type1: TypeElement.fromDB(query.first as Map<String, dynamic>),
          type2: TypeElement.fromDB(query.last as Map<String, dynamic>));
    }
  }

  Map<String, dynamic> toJson() {
    if (isSingleType()) {
      return {"type1": type1.toJson()};
    } else {
      return {"type1": type1.toJson(), "type2": type2!.toJson()};
    }
  }
}

abstract class TypeElement {
  String get name;
  List<Type> get weakTo;
  List<Type> get resistTo;
  List<Type> get immuneTo;

  /// # toJson(`Map<String, dynamic> json`)
  /// ## Creates a TypeElement instance from JSON.
  /// Returns a TypeElement instance.
  factory TypeElement.fromJson(Map<String, dynamic> json) {
    switch (json['type']['name']) {
      case 'normal':
        return Normal();
      case 'fire':
        return Fire();
      case 'water':
        return Water();
      case 'electric':
        return Electric();
      case 'grass':
        return Grass();
      case 'ice':
        return Ice();
      case 'fighting':
        return Fighting();
      case 'poison':
        return Poison();
      case 'ground':
        return Ground();
      case 'flying':
        return Flying();
      case 'psychic':
        return Psychic();
      case 'bug':
        return Bug();
      case 'rock':
        return Rock();
      case 'ghost':
        return Ghost();
      case 'dragon':
        return Dragon();
      case 'dark':
        return Dark();
      case 'steel':
        return Steel();
      case 'fairy':
        return Fairy();
      case 'stellar':
        return Stellar();
      default:
        throw Exception('Unknown type: ${json['name']}');
    }
  }

  factory TypeElement.fromDB(Map<String, Object?> query) {
    switch (query['type_id']) {
      case Elements.none:
        return Normal();
      case Elements.normal:
        return Normal();
      case Elements.fire:
        return Fire();
      case Elements.water:
        return Water();
      case Elements.electric:
        return Electric();
      case Elements.grass:
        return Grass();
      case Elements.ice:
        return Ice();
      case Elements.fighting:
        return Fighting();
      case Elements.poison:
        return Poison();
      case Elements.ground:
        return Ground();
      case Elements.flying:
        return Flying();
      case Elements.psychic:
        return Psychic();
      case Elements.bug:
        return Bug();
      case Elements.rock:
        return Rock();
      case Elements.ghost:
        return Ghost();
      case Elements.dragon:
        return Dragon();
      case Elements.dark:
        return Dark();
      case Elements.steel:
        return Steel();
      case Elements.fairy:
        return Fairy();
      case Elements.stellar:
        return Stellar();
      default:
        throw Exception('Unknown type: ${query['type_id']}');
    }
  }

  /// # isWeakTo(`Type type`, `TypeElement element`)
  /// ## Checks if `element` is weak to `type`.
  /// Returns true if `element` is weak to `type`, false if not.
  static bool isWeakTo(Type type, TypeElement element) {
    return element.weakTo.contains(type);
  }

  /// # isResistTo(`Type type`, `TypeElement element`)
  /// ## Checks if `element` is resistant to `type`.
  /// Returns true if `element` is resistant to `type`, false if not.
  static bool isResistTo(Type type, TypeElement element) {
    return element.resistTo.contains(type);
  }

  /// # isImmuneTo(`Type type`, `TypeElement element`)
  /// ## Checks if `element` is immune to `type`.
  /// Returns true if `element` is immune to `type`, false if not.
  static bool isImmuneTo(Type type, TypeElement element) {
    return element.immuneTo.contains(type);
  }

  /// # toJson(`TypeElement element`)
  /// ## Converts this TypeElement instance to JSON.
  /// Returns a [Map<String, dynamic>] object.
  Map<String, dynamic> toJson();
  Widget getIcon();
  Widget getChip();
}

mixin ElementFunctions implements TypeElement {
  @override
  Widget getIcon() {
    return Center(child: SvgPicture.asset("assets/svg/$name.svg", height: 60));
  }

  @override
  Widget getChip() {
    return Chip(avatar: getIcon(), label: Text(name.capitalize()));
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': toString().split('.').last.toLowerCase(),
      'weakTo': weakTo
          .map((e) => e.toString().split('.').last.toLowerCase())
          .toList(),
      'resistTo': resistTo
          .map((e) => e.toString().split('.').last.toLowerCase())
          .toList(),
      'immuneTo': immuneTo
          .map((e) => e.toString().split('.').last.toLowerCase())
          .toList(),
    };
  }
}

/// # Normal
/// ## A class that represents the Normal type.
/// ### Weak To:
/// - Fighting
/// ### Resist To:
/// - Ghost

class Normal with ElementFunctions implements TypeElement {
  @override
  String get name => 'normal';
  @override
  List<Type> get weakTo => [Fighting];
  @override
  List<Type> get resistTo => [Ghost];
  @override
  List<Type> get immuneTo => [];
}

/// # Fire
/// ## A class that represents the Fire type.
/// ### Weak To:
/// - Water
/// - Ground
/// - Rock
/// ### Resist To:
/// - Fire
/// - Grass
/// - Ice
/// - Bug
/// - Steel
/// - Fairy
class Fire with ElementFunctions implements TypeElement {
  @override
  String get name => 'fire';
  @override
  List<Type> get weakTo => [Water, Ground, Rock];
  @override
  List<Type> get resistTo => [Fire, Grass, Ice, Bug, Steel, Fairy];
  @override
  List<Type> get immuneTo => [];
}

/// # Water
/// ## A class that represents the Water type.
/// ### Weak To:
/// - Grass
/// - Electric
/// ### Resist To:
/// - Fire
/// - Water
/// - Ice
/// - Steel
class Water with ElementFunctions implements TypeElement {
  @override
  String get name => 'water';
  @override
  List<Type> get weakTo => [Electric, Grass];
  @override
  List<Type> get resistTo => [Fire, Ice, Steel, Water];
  @override
  List<Type> get immuneTo => [];
}

/// # Electric
/// ## A class that represents the Electric type.
/// ### Weak To:
/// - Ground
/// ### Resist To:
/// - Water
/// - Flying
/// - Steel
class Electric with ElementFunctions implements TypeElement {
  @override
  String get name => 'electric';
  @override
  List<Type> get weakTo => [Ground];
  @override
  List<Type> get resistTo => [Water, Flying, Steel];
  @override
  List<Type> get immuneTo => [];
}

/// # Grass
/// ## A class that represents the Grass type.
/// ### Weak To:
/// - Fire
/// - Ice
/// - Poison
/// - Flying
/// - Bug
/// ### Resist To:
/// - Water
/// - Grass
/// - Electric
/// - Ground
class Grass with ElementFunctions implements TypeElement {
  @override
  String get name => 'grass';
  @override
  List<Type> get weakTo => [Fire, Ice, Poison, Flying, Bug];
  @override
  List<Type> get resistTo => [Water, Grass, Electric, Ground];
  @override
  List<Type> get immuneTo => [];
}

/// # Ice
/// ## A class that represents the Ice type.
/// ### Weak To:
/// - Fire
/// - Fighting
/// - Rock
/// - Steel
/// ### Resist To:
/// - Ice
class Ice with ElementFunctions implements TypeElement {
  @override
  String get name => 'ice';
  @override
  List<Type> get weakTo => [Fighting, Rock, Steel, Fire];
  @override
  List<Type> get resistTo => [Ice];
  @override
  List<Type> get immuneTo => [];
}

/// # Fighting
/// ## A class that represents the Fighting type.
/// ### Weak To:
/// - Flying
/// - Psychic
/// - Rock
/// ### Resist To:
/// - Bug
/// - Grass
/// - Ice
class Fighting with ElementFunctions implements TypeElement {
  @override
  String get name => 'fighting';
  @override
  List<Type> get weakTo => [Flying, Psychic, Rock];
  @override
  List<Type> get resistTo => [Bug, Grass, Ice];
  @override
  List<Type> get immuneTo => [];
}

/// # Poison
/// ## A class that represents the Poison type.
/// ### Weak To:
/// - Ground
/// - Psychic
/// ### Resist To:
/// - Fairy
/// - Grass
class Poison with ElementFunctions implements TypeElement {
  @override
  String get name => 'poison';
  @override
  List<Type> get weakTo => [Ground, Psychic];
  @override
  List<Type> get resistTo => [Fairy, Grass];
  @override
  List<Type> get immuneTo => [];
}

/// # Ground
/// ## A class that represents the Ground type.
/// ### Weak To:
/// - Water
/// - Grass
/// - Ice
/// ### Resist To:
/// - Poison
/// - Rock
/// - Steel
/// ### Immune To:
/// - Electric
class Ground with ElementFunctions implements TypeElement {
  @override
  String get name => 'ground';
  @override
  List<Type> get weakTo => [Water, Grass, Ice];
  @override
  List<Type> get resistTo => [Poison, Rock, Steel];
  @override
  List<Type> get immuneTo => [Electric];
}

/// # Flying
/// ## A class that represents the Flying type.
/// ### Weak To:
/// - Electric
/// - Ice
/// - Rock
/// ### Resist To:
/// - Grass
/// - Fighting
/// - Bug
/// ### Immune To:
/// - Ground
class Flying with ElementFunctions implements TypeElement {
  @override
  String get name => 'flying';
  @override
  List<Type> get weakTo => [Electric, Ice, Rock];
  @override
  List<Type> get resistTo => [Grass, Fighting, Bug];
  @override
  List<Type> get immuneTo => [Ground];
}

/// # Psychic
/// ## A class that represents the Psychic type.
/// ### Weak To:
/// - Bug
/// - Ghost
/// - Dark
/// ### Resist To:
/// - Fighting
/// - Poison
class Psychic with ElementFunctions implements TypeElement {
  @override
  String get name => 'psychic';
  @override
  List<Type> get weakTo => [Bug, Ghost, Dark];
  @override
  List<Type> get resistTo => [Fighting, Poison];
  @override
  List<Type> get immuneTo => [];
}

/// # Bug
/// ## A class that represents the Bug type.
/// ### Weak To:
/// - Fire
/// - Flying
/// - Rock
/// ### Resist To:
/// - Grass
/// - Fighting
/// - Ground
class Bug with ElementFunctions implements TypeElement {
  @override
  String get name => 'bug';
  @override
  List<Type> get weakTo => [Fire, Flying, Rock];
  @override
  List<Type> get resistTo => [Grass, Fighting, Ground];
  @override
  List<Type> get immuneTo => [];
}

/// # Rock
/// ## A class that represents the Rock type.
/// ### Weak To:
/// - Fighting
/// - Ground
/// - Steel
/// ### Resist To:
/// - Fire
/// - Ice
/// - Flying
/// - Bug
class Rock with ElementFunctions implements TypeElement {
  @override
  String get name => 'rock';
  @override
  List<Type> get weakTo => [Fighting, Ground, Steel];
  @override
  List<Type> get resistTo => [Fire, Ice, Flying, Bug];
  @override
  List<Type> get immuneTo => [];
}

/// # Ghost
/// ## A class that represents the Ghost type.
/// ### Weak To:
/// - Ghost
/// - Dark
/// ### Resist To:
/// - Poison
/// - Bug
/// ### Immune To:
/// - Normal
/// - Fighting
class Ghost with ElementFunctions implements TypeElement {
  @override
  String get name => 'ghost';
  @override
  List<Type> get weakTo => [Dark, Ghost];
  @override
  List<Type> get resistTo => [Poison, Bug];
  @override
  List<Type> get immuneTo => [Normal, Fighting];
}

/// # Dragon
/// ## A class that represents the Dragon type.
/// ### Weak To:
/// - Steel
/// ### Resist To:
/// - Fire
/// - Water
/// - Grass
/// - Electric
class Dragon with ElementFunctions implements TypeElement {
  @override
  String get name => 'dragon';
  @override
  List<Type> get weakTo => [Ice, Dragon, Fairy];
  @override
  List<Type> get resistTo => [Fire, Water, Electric, Grass];
  @override
  List<Type> get immuneTo => [];
}

/// # Dark
/// ## A class that represents the Dark type.
/// ### Weak To:
/// - Fighting
/// - Bug
/// - Ghost
/// ### Resist To:
/// - Dark
/// - Ghost
/// ### Immune To:
/// - Psychic
class Dark with ElementFunctions implements TypeElement {
  @override
  String get name => 'dark';
  @override
  List<Type> get weakTo => [Fighting, Bug, Ghost];
  @override
  List<Type> get resistTo => [Ghost, Dark];
  @override
  List<Type> get immuneTo => [Psychic];
}

/// # Steel
/// ## A class that represents the Steel type.
/// ### Weak To:
/// - Fire
/// - Fighting
/// - Ground
/// ### Resist To:
/// - Normal
/// - Grass
/// - Ice
/// - Flying
/// - Rock
/// - Bug
/// - Dragon
/// - Steel
/// ### Immune To:
/// - Poison
class Steel with ElementFunctions implements TypeElement {
  @override
  String get name => 'steel';
  @override
  List<Type> get weakTo => [Fire, Fighting, Ground];
  @override
  List<Type> get resistTo =>
      [Normal, Grass, Ice, Flying, Rock, Bug, Dragon, Steel, Fairy];
  @override
  List<Type> get immuneTo => [Poison];
}

/// # Fairy
/// ## A class that represents the Fairy type.
/// ### Weak To:
/// - Steel
/// ### Resist To:
/// - Fighting
/// - Bug
/// - Dark
/// ### Immune To:
/// - Dragon
class Fairy with ElementFunctions implements TypeElement {
  @override
  String get name => 'fairy';
  @override
  List<Type> get weakTo => [Steel];
  @override
  List<Type> get resistTo => [Fighting, Bug, Dark];
  @override
  List<Type> get immuneTo => [Dragon];
}

class Stellar with ElementFunctions implements TypeElement {
  @override
  String get name => 'stellar';
  @override
  List<Type> get weakTo => [];
  @override
  List<Type> get resistTo => [];
  @override
  List<Type> get immuneTo => [];
}
