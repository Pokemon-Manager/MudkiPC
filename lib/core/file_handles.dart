import 'dart:io';
import 'dart:typed_data';
import 'datablocks.dart';
import 'pc.dart';

class FileHandle {
  List<Datablock> datablocks = [];
  File file;
  Uint8List? fileData;
  PKMDBFolder? folder;
  FileHandle({required this.file, this.folder});

  /// # toAssociatedHandle(`File file`, `PKMDBFolder? folder`)
  /// ## A function that returns the corresponding FileHandle based on the file type.
  /// To see all compatible file types, see [CompatibleFiles] in `enums.dart`.
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
    fileData = file.readAsBytes() as Uint8List?;
    PK6Data pkData = PK6Data(data: fileData!);
    datablocks.add(pkData);
  }
}
