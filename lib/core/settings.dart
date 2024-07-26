import 'package:mudkip_frontend/core/enums.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  static late SharedPreferences prefs;
  static const Map<String, dynamic> defaultSettings = {
    "isHeightChartGenderMale": true,
    "isHeightChartFormatMetric": true
  };

  static Future<void> doPrefs() async {
    prefs = await SharedPreferences.getInstance();
    await setEmptyToDefaults();
    return;
  }

  static Future<void> setHeightChartGender(HeightChartGender value) async {
    await prefs.setBool(
        "isHeightChartGenderMale", value == HeightChartGender.male);
  }

  static Future<void> setHeightChartFormat(HeightChartFormat value) async {
    await prefs.setBool(
        "isHeightChartFormatMetric", value == HeightChartFormat.metric);
  }

  static HeightChartGender get heightChartGender {
    bool? isMale = prefs.getBool("isHeightChartGenderMale");
    if (isMale == true) {
      return HeightChartGender.male;
    } else {
      return HeightChartGender.female;
    }
  }

  static HeightChartFormat get heightChartFormat {
    bool? isMetric = prefs.getBool("isHeightChartFormatMetric");
    if (isMetric == true) {
      return HeightChartFormat.metric;
    } else {
      return HeightChartFormat.imperial;
    }
  }

  static Future<void> resetToDefaults() async {
    await prefs.clear();
    await setEmptyToDefaults();
    return;
  }

  static Future<void> setEmptyToDefaults() async {
    for (String key in defaultSettings.keys) {
      if (prefs.containsKey(key)) {
        continue;
      }
      if (defaultSettings[key] is bool) {
        await prefs.setBool(key, defaultSettings[key] as bool);
      } else if (defaultSettings[key] is int) {
        await prefs.setInt(key, defaultSettings[key] as int);
      } else if (defaultSettings[key] is double) {
        await prefs.setDouble(key, defaultSettings[key] as double);
      } else if (defaultSettings[key] is String) {
        await prefs.setString(key, defaultSettings[key] as String);
      }
    }
    return;
  }
}
