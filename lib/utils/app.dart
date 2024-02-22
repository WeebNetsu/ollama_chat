import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

/// Count number of files in a directory
int countFilesInDirectory(Directory directory) {
  if (!directory.existsSync()) {
    throw ArgumentError('Directory does not exist: ${directory.path}');
  }

  int count = 0;

  for (var fileEntity in directory.listSync()) {
    if (fileEntity is File) count++;
  }

  return count;
}

/// Get the size of a directory
int getDirectorySize(FileSystemEntity file) {
  if (file is File) {
    return file.lengthSync();
  } else if (file is Directory) {
    int sum = 0;
    List<FileSystemEntity> children = file.listSync();
    for (FileSystemEntity child in children) {
      sum += getDirectorySize(child);
    }
    return sum;
  }
  return 0;
}

Future<void> openUrl(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) await launchUrl(uri);
}
