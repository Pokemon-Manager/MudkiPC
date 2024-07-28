// Name: Pokemon Manager
// Purpose: The main file for the application, and exports all of the core classes and functions in the application.
// It also contains `MudkiPC` class, which is used for paths, preferences, and other important functions.
import 'package:mudkip_frontend/core/search.dart';
import 'package:path_provider/path_provider.dart';
import 'package:queue/queue.dart';

export 'core/ability.dart';
export 'core/move.dart';
export 'core/pokemon.dart';
export 'core/databases.dart';
export 'core/species.dart';
export 'core/constants.dart';
export 'core/stats.dart';
export 'core/elements.dart';
export 'core/trainer.dart';
export 'core/extensions.dart';
export 'core/datablocks.dart';
export 'core/file_handles.dart';
export 'src/import.dart';
export 'core/search.dart';
export 'core/settings.dart';
export 'package:logging/logging.dart';

/// # `Class` MudkiPC
/// ## The main class for the application.
/// Contains functions for paths and other important functions.
class MudkiPC {
  static Queue queue = Queue(
      delay: const Duration(
          microseconds:
              10)); /* This queue is to make sure that multiple requests are not made at the same time, 
  as it could result in an overflow or an asynchronous error.*/
  static Pachinko pachinko =
      Pachinko(); // Used for searching in the application. See `search.dart` in the `core` folder for more information.
  static Future<String> get userFolder async {
    // Gets the path to the user's folder.
    return "${(await getApplicationDocumentsDirectory()).path}/MudkiPC/";
  }

  static Future<String> get cacheFolder async {
    // Gets the path to the cache folder, also known as the app data folder.
    return "${(await getApplicationCacheDirectory()).path}/MudkiPC/";
  }
}
