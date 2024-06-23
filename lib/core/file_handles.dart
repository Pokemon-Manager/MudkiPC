import 'dart:io';
import 'dart:typed_data';
import 'datablocks.dart';
import 'pc.dart';

/// ### Compatible Extensions:
/// - pk6 (A Single Pokémon + Basic Trainer Info)
/// ### Planned Compatible Extensions:
/// - pk1 (A Single Pokémon + Basic Trainer Info)
/// - pk2 (A Single Pokémon + Basic Trainer Info)
/// - pk3 (A Single Pokémon + Basic Trainer Info)
/// - pk4 (A Single Pokémon + Basic Trainer Info)
/// - pk5 (A Single Pokémon + Basic Trainer Info)
/// - pk7 (A Single Pokémon + Basic Trainer Info)
/// - pk8 (A Single Pokémon + Basic Trainer Info)
/// - pk9 (A Single Pokémon + Basic Trainer Info)
/// - sav (Trainer Data + All Their Pokémon)
/// - json (A Single Pokémon + Basic Trainer Info, or Trainer Data + All Their Pokémons. Requires JSON export to be implemented.)
/// - db (All Pokémon Manager Data. Requires DB export to be implemented.)
class FileHandle {
  List<Datablock> datablocks = [];
  File file;
  Uint8List? fileData;
  PKMDBFolder? folder;
  FileHandle({required this.file, this.folder});
  static const List<String> compatibleExtensions = [
    "pk6",
  ];

  static bool isCompatibleFile(File file) {
    if (compatibleExtensions.contains(file.path.split('.').last)) {
      return true;
    }
    return false;
  }

  /// # toAssociatedHandle(`File file`, `PKMDBFolder? folder`)
  /// ## A function that returns the corresponding FileHandle based on the file extension.
  factory FileHandle.toAssociatedHandle(File file, PKMDBFolder? folder) {
    switch (file.path.split('.').last) {
      case "pk6":
        return PK6File(file: file, folder: folder);
      default:
        return FileHandle(file: file, folder: folder);
    }
  }

  void addDatablock(Datablock datablock) {
    datablocks.add(datablock);
  }

  void removeDatablock(Datablock datablock) {
    datablocks.remove(datablock);
  }

  /// # divideIntoDatablocks()
  /// ## A function that divides the file into datablocks.
  /// This function does not return anything, and must be overridden in subclasses. For more info on datablocks, see [Datablock] in `datablocks.dart`.
  /// ```dart
  /// class ExampleFile extends FileHandle {
  ///   @override
  ///   void divideIntoDatablocks() {
  ///     fileData = file.readAsBytesSync() as Uint8List?;
  ///     PK6Data pkData = PK6Data(data: fileData!);
  ///     datablocks.add(pkData);
  ///   }
  /// }
  /// ```
  void divideIntoDatablocks() {
    return;
  }

  /// # parseDatablocks()
  /// ## A function that calls [divideIntoDatablocks] and calls the [parse] function of each datablock in the file.
  /// This function does not return anything.
  /// ```dart
  ///  void parseDatablocks() {
  ///   divideIntoDatablocks();
  ///   for (Datablock datablock in datablocks) {
  ///     datablock.parse();
  ///   }
  ///  }
  /// ```
  void parseDatablocks() {
    divideIntoDatablocks();
    for (Datablock datablock in datablocks) {
      datablock.parse();
    }
    return;
  }
}

class PK6File extends FileHandle {
  PK6File({required super.file, super.folder});

  @override
  void divideIntoDatablocks() {
    fileData = file.readAsBytesSync() as Uint8List?;
    PK6Data pkData = PK6Data(data: fileData!);
    datablocks.add(pkData);
  }
}
