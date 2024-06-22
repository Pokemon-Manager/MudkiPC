import 'dart:math';
import 'dart:typed_data';

import 'package:pokemon_manager/core/pokemon.dart';
import 'package:pokemon_manager/core/stats.dart';
import 'package:pokemon_manager/core/enums.dart';
import 'package:pokemon_manager/main.dart';
class Datablock {
  List<int> data;
  Datablock({required this.data});

  /// #combineBytesToInt8(`List<int> bytes`)
  /// ## A function that combines a single byte into a 8-bit integer.
  /// This function returns a 8-bit integer.
  int combineBytesToInt8(List<int> bytes){
    ByteData byteData = ByteData.view(Uint8List.fromList(bytes).buffer);
    return byteData.getInt8(0);
  }
  /// #combineBytesToInt16(`List<int> bytes`)
  /// ## A function that combines two bytes into a 16-bit integer.
  /// This function returns a 16-bit integer.
  int combineBytesToInt16(List<int> bytes){
    ByteData byteData = ByteData.view(Uint8List.fromList(bytes).buffer);
    return byteData.getInt16(0, Endian.little);
  }

  /// #combineBytesToInt32(`List<int> bytes`)
  /// ## A function that combines four bytes into a 32-bit integer.
  /// This function returns a 32-bit integer.
  int combineBytesToInt32(List<int> bytes){
    ByteData byteData = ByteData.view(Uint8List.fromList(bytes).buffer);
    return byteData.getInt32(0, Endian.little);
  }

  void parse() {
    return;
  }
}

/// # Gen3PokemonFormat
/// ## A mixin that contains the basic functions that are required by Generation 3 and beyond.
/// The modern format is the format introduced in Generation 3, and has been extended and expanded over each subsequent generation.
/// It is more cut down and compact than the old format, and requires bitmasks and more complex calculations to extract data.
/// Offsets are relative to the start of the block.
mixin Gen3PokemonFormat implements Datablock{
  String getNickname(int offset) {
    Iterable<int> nickName = data.getRange(offset,23);
    int x = 0;
    while (x < nickName.length) {
      if (nickName.elementAt(x) == 0) {
        break;
      }
      x+=2;
    }
    return nickName.toString().replaceAll(0x00.toString(), "");
  }

  int getSpeciesID(int offset) {
    Iterable<int> speciesRange = data.getRange(offset,2);
    return combineBytesToInt16(speciesRange.toList());
  }

  int getEXP(int offset) {
    Iterable<int> levelRange = data.getRange(offset,4);
    return combineBytesToInt32(levelRange.toList());
  }
  Stats getEvStats(int offset) {
    Iterable<int> evRange = data.getRange(offset,5);
    return Stats(hp: evRange.elementAt(0), attack: evRange.elementAt(1), defense: evRange.elementAt(2), 
    specialAttack: evRange.elementAt(3), specialDefense: evRange.elementAt(4), speed: evRange.elementAt(5));
  }
  Stats getIvStats(int offset) {
    Iterable<int> ivRange = data.getRange(offset,3);
    int total = combineBytesToInt32(ivRange.toList());
    return Stats(
      hp: total & 11111, 
      attack: total >> 5 & 11111, 
      defense: total >> 10 & 11111, 
      specialAttack: total >> 15 & 11111, 
      specialDefense: total >> 20 & 11111, 
      speed: total >> 25 & 11111);
  }
  int getGender(int offset) {
    Iterable<int> ivRange = data.getRange(offset,4);
    int total = combineBytesToInt32(ivRange.toList());
    return total >> 30 & 11;
  }
}

class PK6Data extends Datablock with Gen3PokemonFormat {
  PK6Data({required super.data});
  
  @override
  void parse() {
    int speciesID = getSpeciesID(0x08);
    Pokemon newPokemon = Pokemon(species: openedPC.getSpecies(speciesID));
    newPokemon.nickName = getNickname(0x40);
    newPokemon.ivStats = getIvStats(0x74);
    newPokemon.evStats = getEvStats(0x1E);
    openedPC.addPokemon(newPokemon);
  }
}

class PK7Data extends Datablock with Gen3PokemonFormat {
  PK7Data({required super.data});

  @override
  void parse() {
    return;
  }
}