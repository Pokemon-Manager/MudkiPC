import 'dart:io';

/// # `Class` LocalizedString
/// ## A class that acts as a container for localized strings.
/// PokeAPI has a number of localized strings already available.
/// So, why not use those strings to have multi-language support?
/// This is a simple class that stores the strings in a map, and contains a factory to easily create create the localized strings.
class LocalizedString {
  Map<String, String> strings = {};

  LocalizedString();
  String get(String key) => strings[key] ?? "String not found";
  String getLocalizedString() {
    String locale = Platform.localeName;
    switch (locale) {
      case "en_US":
        locale = "en";
        break;
      default:
        break;
    }
    return format(get(locale));
  }
  
  String format(String string) {
    return string.replaceAll('\n', ' ');
  }

  factory LocalizedString.fromJson(List<dynamic> json) {
    LocalizedString newString = LocalizedString();
    for (Map<String, dynamic> entry in json) {
      for (String key in entry.keys) {
        if(entry[key] is String) {
          newString.strings[entry["language"]["name"]] = entry[key];
        }
      }
    }
    return newString;
  }
}