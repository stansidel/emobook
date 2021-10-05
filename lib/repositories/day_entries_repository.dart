import 'dart:convert';
import 'dart:developer';

import 'package:emobook/models/day_entry.dart';
import 'package:emobook/models/emo_file.dart';
import 'package:nanoid/async.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';
import 'dart:typed_data';

class IdNotSetException implements Exception {}
class SourceFileMissingException implements Exception {}

class DayEntriesRepository {
  static const storageDirectory = 'entries';

  Future<Iterable<DayEntry>> getAll() async {
    var result = <DayEntry>[];
    try {
      final dir = await _localDir;
      final listing = dir.list(recursive: false);
      await for (FileSystemEntity f in listing) {
        if (f is! Directory) {
          continue;
        }
        final id = p.basename(f.path);
        try {
          final entry = await _readEntry(id);
          result.add(entry);
        } catch (e) {
          log('Failed to read entry with id $id. $e');
          continue;
        }
        result.sort((a, b) => b.date.compareTo(a.date));
      }
    } catch (e) {
      log('Error listing entries. $e');
      return [];
    }
    return result;
  }

  Future<String> updateOrSaveEntry(DayEntry entry) async {
    final effectiveId = entry.id ?? await _generateId(entry.date);
    final dataFilePath = await _fileObjectPathForId(effectiveId);
    final dataObject = entry.copyWith(id: effectiveId).toJson();
    final dataString = jsonEncode(dataObject);
    await File(dataFilePath).writeAsString(dataString);
    return effectiveId;
  }

  Future<void> removeEntry(String id) async {
    final dirPath = await _dirPathForId(id);
    final dir = Directory(dirPath);
    final dirExists = await dir.exists();
    if (!dirExists) {
      return;
    }
    await dir.delete(recursive: true);
  }

  Future<DayEntry> addImageFromBytes({required DayEntry entry, required Uint8List bytes, required String extension}) async {
    final id = entry.id;
    if (id == null) {
      throw IdNotSetException();
    }
    final entryDirPath = await _dirPathForId(id);
    final String newId = await _generateId(DateTime.now());
    final targetPath = p.join(entryDirPath, '$newId.$extension');
    final targetFile = File(targetPath);

    targetFile.writeAsBytes(bytes);

    var images = entry.images ?? [];
    images.add(EmoFile(path: targetPath, storage: EmoFileStorage.localFile));
    final newEntry = entry.copyWith(images: images);
    await updateOrSaveEntry(newEntry);
    return newEntry;
  }

  Future<DayEntry> addImage({required DayEntry entry, required String imagePath}) async {
    final id = entry.id;
    if (id == null) {
      throw IdNotSetException();
    }
    final sourceFile = File(imagePath);
    final exists = await sourceFile.exists();
    if (!exists) {
      throw SourceFileMissingException();
    }
    final entryDirPath = await _dirPathForId(id);
    var targetPath = p.join(entryDirPath, p.basename(imagePath));
    var targetFile = File(targetPath);
    final targetExists = await targetFile.exists();
    if (targetExists) {
      final String newId = await _generateId(DateTime.now());
      targetPath = p.join(entryDirPath, '$newId.${p.extension(imagePath)}');
      targetFile = File(targetPath);
    }
    await sourceFile.copy(targetPath);
    var images = entry.images ?? [];
    images.add(EmoFile(path: targetPath, storage: EmoFileStorage.localFile));
    final newEntry = entry.copyWith(images: images);
    await updateOrSaveEntry(newEntry);
    return newEntry;
  }

  Future<DayEntry> removeImage({required DayEntry entry, required EmoFile image}) async {
    var images = entry.images;
    if (images == null) {
      return entry;
    }
    if (!images.contains(image)) {
      return entry;
    }
    images.remove(image);
    final updatedEntry = entry.copyWith(images: images);
    if (image.storage != EmoFileStorage.localFile) {
      updateOrSaveEntry(updatedEntry);
      return updatedEntry;
    }
    try {
      final file = File(image.path);
      final exists = await file.exists();
      if (!exists) {
        updateOrSaveEntry(updatedEntry);
        return updatedEntry;
      }
      await file.delete(recursive: false);
    } catch (e) {
      log('Got an error deleting image: $e');
    }
    updateOrSaveEntry(updatedEntry);
    return updatedEntry;
  }

  Future<DayEntry> _readEntry(String id) async {
    final dataFilePath = await _fileObjectPathForId(id);
    final dataString = await File(dataFilePath).readAsString();
    final dataObject = jsonDecode(dataString);
    final entry = DayEntry.fromJson(dataObject);
    return entry.copyWith(id: id);
  }

  Future<String> _dirPathForId(String id, {bool createDir = true}) async {
    final dirPath = p.join((await _localDir).path, id);
    if (!createDir) {
      return dirPath;
    }
    final entryDir = await Directory(dirPath).create(recursive: true);
    return entryDir.path;
  }

  Future<String> _fileObjectPathForId(String id,
      {bool createDir = true}) async {
    final dirPath = await _dirPathForId(id, createDir: createDir);
    return p.join(dirPath, id + '.json');
  }

  Future<Directory> get _localDir async {
    final directory = await getApplicationDocumentsDirectory();

    return await Directory(p.join(directory.path, storageDirectory))
        .create(recursive: true);
  }

  Future<String> _generateId(DateTime date) async {
    final year = date.year.toString();
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    final second = date.second.toString().padLeft(2, '0');
    final uid = await nanoid(10);
    return '$year-$month-$day-$hour-$minute-$second-$uid';
  }
}
