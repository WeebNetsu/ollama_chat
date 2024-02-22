import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class UserPreferencesModel {
  static const saveFileName = "user_preferences.json";

  /// If the user has slow internet, they can enable this
  /// which will implement manual page reloads and some
  /// other features to improve app performance
  bool slowInternetMode = false;

  Future<bool> saveToFileData() async {
    Directory appDir = await getApplicationDocumentsDirectory();

    try {
      final encodedData = jsonEncode({
        "slowInternetMode": slowInternetMode,
      });

      final newFile = await File("${appDir.path}/$saveFileName").create();

      await newFile.writeAsString(
        encodedData,
        mode: FileMode.write,
      );

      return true;
    } catch (err) {
      debugPrint(err.toString());
    }

    return false;
  }

  /// Load data from file, if failed, it will return false
  Future<bool> loadDataFromFile() async {
    final Directory appDir = await getApplicationDocumentsDirectory();

    final File saveFile = File("${appDir.path}/$saveFileName");

    if (!saveFile.existsSync()) {
      await saveToFileData();
      return true;
    }

    final saveData = await saveFile.readAsString();
    final userDataJson = jsonDecode(saveData);

    if (userDataJson['slowInternetMode'] != null) {
      slowInternetMode = userDataJson['slowInternetMode'] == true ? true : false;
    }
    return true;
  }
}
