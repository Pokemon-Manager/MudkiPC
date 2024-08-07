import 'dart:io';
import 'dart:typed_data';
import 'package:mudkip_frontend/pokemon_manager.dart';

/// # `Class` FileHandle
/// ## A class that represents a file handle.
/// ### Compatible Extensions:
/// - pk6 (A Single Pokémon + Basic Trainer Info)
/// - pk7 (A Single Pokémon + Basic Trainer Info)
/// ### Planned Compatible Extensions:
/// - pk1 (A Single Pokémon + Basic Trainer Info)
/// - pk2 (A Single Pokémon + Basic Trainer Info)
/// - pk3 (A Single Pokémon + Basic Trainer Info)
/// - pk4 (A Single Pokémon + Basic Trainer Info)
/// - pk5 (A Single Pokémon + Basic Trainer Info)
/// - pk8 (A Single Pokémon + Basic Trainer Info)
/// - pk9 (A Single Pokémon + Basic Trainer Info)
/// - sav (Trainer Data + All Their Pokémon)
/// - json (A Single Pokémon + Basic Trainer Info, or Trainer Data + All Their Pokémons. Requires JSON export to be implemented.)
/// - db (All Pokémon Manager Data. Requires DB export to be implemented.)
/// - png (Pokémon Card. Requires PNG export to be implemented.)
class FileHandle {
  List<Datablock> datablocks = []; // The datablocks of the file.
  List<int> data = []; // The data of the file.
  File file; // The file.
  Uint8List? fileData; // The data of the file.
  PKMDBFolder folder; // The folder that the file is in.
  FileHandle({required this.file, required this.folder}); // Constructor.
  static const List<String> compatibleExtensions = [
    "pk6",
    "pk7"
  ]; // Add more extensions as needed

  /// # `bool` isCompatibleFile(`File file`)
  /// ## A function that checks if a file is compatible.
  static bool isCompatibleFile(File file) {
    if (compatibleExtensions.contains(file.path.split('.').last)) {
      return true;
    }
    return false;
  }

  /// # `FileHandle` toAssociatedHandle(`File file`, `PKMDBFolder? folder`)
  /// ## A function that returns the corresponding FileHandle based on the file extension.
  factory FileHandle.toAssociatedHandle(File file, PKMDBFolder folder) {
    switch (file.path.split('.').last) {
      case "pk6":
        return PK6File(file: file, folder: folder);
      case "pk7":
        return PK7File(file: file, folder: folder);
      default:
        return FileHandle(file: file, folder: folder);
    }
  }

  /// # `void` addDatablock(`Datablock datablock`)
  /// ## A function that adds a datablock to the file.
  void addDatablock(Datablock datablock) {
    datablocks.add(datablock);
  }

  /// # `void` removeDatablock(`Datablock datablock`)
  /// ## A function that removes a datablock from the file.
  void removeDatablock(Datablock datablock) {
    datablocks.remove(datablock);
  }

  /// # divideIntoDatablocks()
  /// ## A function that divides the file into datablocks.
  /// This function does not return anything, and must be overridden in subclasses.
  /// For more info on datablocks, see [Datablock] in `datablocks.dart`.
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
  void extractFromFile() {
    fileData = file.readAsBytesSync() as Uint8List?;
    data = fileData!.toList();
  }

  /// # `Future<void>` parseDatablocks()
  /// ## A function that calls [divideIntoDatablocks] and calls the [parse] function of each datablock in the file.
  /// This function does not return anything.
  Future<void> parseDatablocks() async {
    extractFromFile();
    divideIntoDatablocks();
    for (Datablock datablock in datablocks) {
      dynamic data = await datablock.parse();
      if (data is Pokemon) {
        folder.pokemons.add(data);
      }
      if (data is Trainer) {
        folder.trainers.add(data);
      }
    }
    return;
  }
}

/// # `Class` PK6File extends `FileHandle`
/// ## A class that represents a PK6 file.
class PK6File extends FileHandle {
  PK6File({required super.file, required super.folder});

  @override
  void divideIntoDatablocks() {
    addDatablock(PK6Data(fileHandle: this));
  }
}

/// # `Class` PK7File extends `FileHandle`
/// ## A class that represents a PK7 file.
class PK7File extends FileHandle {
  PK7File({required super.file, required super.folder});

  @override
  void divideIntoDatablocks() {
    addDatablock(PK7Data(fileHandle: this));
  }
}
