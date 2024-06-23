import 'dart:typed_data';

import 'package:pokemon_manager/main.dart';
import 'package:pokemon_manager/pokemon_manager.dart';

/// # `Class` Datablock
/// ## A class that represents a datablock from a Game.
/// Datablocks are used to store data in files. Datablocks should be used in combination with other Datablocks to create a file handle.
/// For example, a save file will requires one block for the general data, one for the trainer, and one for each Pokémon.
class Datablock {
  FileHandle fileHandle;
  int offset =
      0x00; // Offset of the datablock in the file. ALWAYS USE HEXADECIMAL INSTEAD OF DECIMAL, FOR CONSISTENCY.
  Datablock?
      parent; // The datablock that this datablock is relative to. In other words, is the datablock inside of another datablock.
  List<Datablock> children =
      []; // List of datablocks that are children of this datablock.
  Datablock({required this.fileHandle}); // Constructor.

  /// #combineBytesToInt8(`List<int> bytes`)
  /// ## A function that combines a single byte into a 8-bit integer.
  /// This function returns a 8-bit integer.
  int combineBytesToInt8(List<int> bytes) {
    ByteData byteData = ByteData.view(Uint8List.fromList(bytes).buffer);
    return byteData.getInt8(0);
  }

  /// #combineBytesToInt16(`List<int> bytes`)
  /// ## A function that combines two bytes into a 16-bit integer.
  /// This function returns a 16-bit integer.
  int combineBytesToInt16(List<int> bytes) {
    ByteData byteData = ByteData.view(Uint8List.fromList(bytes).buffer);
    return byteData.getInt16(0, Endian.little);
  }

  /// #combineBytesToInt32(`List<int> bytes`)
  /// ## A function that combines four bytes into a 32-bit integer.
  /// This function returns a 32-bit integer.
  int combineBytesToInt32(List<int> bytes) {
    ByteData byteData = ByteData.view(Uint8List.fromList(bytes).buffer);
    return byteData.getInt32(0, Endian.little);
  }

  Iterable<int> getRange(int offset, int length) {
    return fileHandle.data.getRange(
        getAbsoluteOffset(offset), getAbsoluteOffset(offset) + length);
  }

  String getString(int offset, int length) {
    Iterable<int> string = getRange(offset, length);
    List<int> shortedString = [];
    int x = 0;
    while (x < string.length) {
      if (string.elementAt(x) == 0) {
        break;
      }
      shortedString.add(string.elementAt(x));
      x += 2;
    }
    String z = String.fromCharCodes(shortedString);
    z = z.replaceAll(String.fromCharCode(0x00), "");
    return z;
  }

  /// # makeThisChildOf(`Datablock datablock`)
  /// ## A function that makes this datablock a child of the given datablock.
  void makeThisChildOf(Datablock datablock) {
    datablock.children.add(this);
    parent = datablock;
  }

  /// # makeThisParentOf(`Datablock datablock`)
  /// ## A function that makes this datablock a parent of the given datablock.
  void makeThisParentOf(Datablock datablock) {
    datablock.offset += getAbsoluteOffset(0x00);
    children.add(datablock);
    datablock.parent = this;
  }

  /// # getAbsoluteOffset(`int offset`)
  /// ## A function that returns the absolute offset of the relative offset.
  /// The absolute offset is the offset of the datablock relative to its parent datablocks.
  /// In other words, it is the offset of the datablock inside all of its parent datablocks.
  int getAbsoluteOffset(int relativeOffset) {
    Datablock? currentRelativeBlock = parent;
    List<Datablock> parentBlocks = [];
    while (currentRelativeBlock != null) {
      parentBlocks.add(currentRelativeBlock);
      currentRelativeBlock = currentRelativeBlock.parent;
    }
    int y = 0x00;
    for (Datablock datablock in parentBlocks) {
      y += datablock.offset;
    }
    return y + offset + relativeOffset;
  }

  /// # getDatablockAtOffset(`int offset`)
  /// ## A function that returns the datablock at the given offset.
  /// TODO: Might want to change this in the future.
  Datablock getDatablockAtOffset(int offset) {
    Datablock? currentRelativeBlock = parent;
    List<Datablock> parentBlocks = [];
    while (currentRelativeBlock != null) {
      parentBlocks.add(currentRelativeBlock);
      currentRelativeBlock = currentRelativeBlock.parent;
    }
    while (currentRelativeBlock!.children.isNotEmpty) {
      if (currentRelativeBlock.children.length == 1) {
        currentRelativeBlock = currentRelativeBlock.children[0];
      } else {
        for (int x = 0; x + 1 < currentRelativeBlock!.children.length; x++) {
          if (currentRelativeBlock.children[x].offset <= offset &&
              currentRelativeBlock.children[x + 1].offset > offset) {
            currentRelativeBlock = currentRelativeBlock.children[x];
            break;
          }
        }
      }
    }
    return currentRelativeBlock;
  }

  Future<void> parse() async {
    return;
  }
}

/// # `Mixin` Gen3PokemonFormat
/// ## A mixin that contains the basic functions that are required by Generation 3 and beyond.
/// The modern format was introduced in Generation 3, and has been extended and expanded over each subsequent generation.
/// It is more cut down and compact than the old format, and requires bitmasks and more complex calculations to extract data.
/// Offsets are relative to the start of the block, so that it can be used in save files, as save files contain mutliple Pokémon and Trainers.
mixin Gen3PokemonFormat implements Datablock {
  String getNickname(int offset) {
    return getString(offset, 24);
  }

  int getSpeciesID(int offset) {
    Iterable<int> speciesRange = getRange(offset, 2);
    return combineBytesToInt16(speciesRange.toList());
  }

  int getEXP(int offset) {
    Iterable<int> levelRange = getRange(offset, 4);
    return combineBytesToInt32(levelRange.toList());
  }

  Stats getEvStats(int offset) {
    Iterable<int> evRange = getRange(offset, 6);
    return Stats(
        hp: evRange.elementAt(0),
        attack: evRange.elementAt(1),
        defense: evRange.elementAt(2),
        specialAttack: evRange.elementAt(3),
        specialDefense: evRange.elementAt(4),
        speed: evRange.elementAt(5));
  }

  Stats getIvStats(int offset) {
    Iterable<int> ivRange = getRange(offset, 4);
    int total = combineBytesToInt32(ivRange.toList());
    return Stats(
        hp: total >> 0 & 31,
        attack: total >> 5 & 31,
        defense: total >> 10 & 31,
        specialAttack: total >> 15 & 31,
        specialDefense: total >> 20 & 31,
        speed: total >> 25 & 31);
  }

  int getGender(int offset) {
    Iterable<int> ivRange = getRange(offset, 4);
    int total = combineBytesToInt32(ivRange.toList());
    return total >> 30 & 11;
  }

  Future<List<Move>> getMoves(int offset) async {
    Iterable<int> moveRange = getRange(offset, 8);
    List<Move> moves = [];
    for (int i = 0; i < 4; i++) {
      int moveID = combineBytesToInt16(
          [moveRange.elementAt(i * 2), moveRange.elementAt(i * 2 + 1)]);
      moves.add(await PokeAPI.fetchMove(moveID));
    }
    return moves;
  }
}

/// # `PK6Data`
/// ## A class that represents the block that contains data for Generation 6.
/// This class extends the `Datablock` class and implements the `Gen3PokemonFormat` mixin.
/// Used in pk6 and gen 6 save files.
/// ```dart
/// PK6Data({required super.data});
/// ```
class PK6Data extends Datablock with Gen3PokemonFormat {
  PK6Data({required super.fileHandle});

  @override
  Future<void> parse() async {
    int speciesID = getSpeciesID(0x08);
    Species? species = await PokeAPI.fetchSpecies(speciesID);
    Pokemon newPokemon = Pokemon(species: species);
    newPokemon.nickName = getNickname(0x40);
    newPokemon.ivStats = getIvStats(0x74);
    newPokemon.evStats = getEvStats(0x1E);
    List<Move> moves = await getMoves(0x5A);
    newPokemon.move1 = moves[0];
    newPokemon.move2 = moves[1];
    newPokemon.move3 = moves[2];
    newPokemon.move4 = moves[3];
    openedPC.addPokemon(newPokemon);
  }
}

class PK7Data extends Datablock with Gen3PokemonFormat {
  PK7Data({required super.fileHandle});

  @override
  Future<void> parse() async {
    return;
  }
}
