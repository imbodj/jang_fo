import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DictionaryDB {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'dictionnaire.db');

    // Copie la base pré-remplie depuis les assets vers le stockage local si elle n'existe pas
    if (!await File(path).exists()) {
      try {
        await Directory(dirname(path)).create(recursive: true);
        ByteData data = await rootBundle.load('assets/data/dictionnaire.db');
        List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        await File(path).writeAsBytes(bytes, flush: true);
      } catch (e) {
        // En cas d'absence du fichier asset, création d'une table locale vide
        return await openDatabase(path, version: 1, onCreate: (db, version) async {
          await db.execute('CREATE TABLE mots (mot TEXT PRIMARY KEY)');
        });
      }
    }

    return await openDatabase(path);
  }

  /// Vérifie si le mot existe dans la base de données
  static Future<bool> isWordValid(String word) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> result = await db.query(
        'mots',
        where: 'mot = ?',
        whereArgs: [word.toUpperCase()],
        limit: 1,
      );
      return result.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  /// Vérifie si le tirage permet de former au moins un mot valide
  static Future<bool> hasValidWord(List<String> tirage) async {
    List<String> best = await getBestWordsForTirage(tirage);
    return best.isNotEmpty;
  }

  /// Trouve les mots les plus longs réalisables avec le tirage donné
  static Future<List<String>> getBestWordsForTirage(List<String> tirage) async {
    final db = await database;

    final List<Map<String, dynamic>> results = await db.rawQuery(
      'SELECT mot FROM mots WHERE LENGTH(mot) <= ? ORDER BY LENGTH(mot) DESC',
      [tirage.length],
    );

    int maxLenFound = 0;
    List<String> bestWords = [];
    List<String> tirageSorted = List.from(tirage)..sort();

    for (var row in results) {
      String candidate = row['mot'] as String;
      
      // Si on a déjà trouvé des mots et que le candidat est plus court, on s'arrête
      if (maxLenFound > 0 && candidate.length < maxLenFound) {
        break;
      }

      if (_canFormWord(candidate, List.from(tirageSorted))) {
        if (maxLenFound == 0) maxLenFound = candidate.length;
        bestWords.add(candidate);
        if (bestWords.length >= 3) break; // On limite à 3 propositions max
      }
    }
    return bestWords;
  }

  static bool _canFormWord(String word, List<String> availableLetters) {
    List<String> tempTirage = List.from(availableLetters);
    for (int i = 0; i < word.length; i++) {
      if (!tempTirage.remove(word[i])) return false;
    }
    return true;
  }
}