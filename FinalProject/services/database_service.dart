import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static Database? _database;

  static Future<void> init() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'neuroblitz.db'),
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE scores(
            id TEXT PRIMARY KEY,
            gameType TEXT,
            score INTEGER,
            time INTEGER,
            date TEXT
          )
        ''');
      },
      version: 1,
    );
  }

  static Future<void> saveScore({
    required String gameType,
    required int score,
    required int time,
  }) async {
    await _database?.insert('scores', {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'gameType': gameType,
      'score': score,
      'time': time,
      'date': DateTime.now().toIso8601String(),
    });
  }

  static Future<List<Map<String, dynamic>>> getScores() async {
    return await _database?.query('scores') ?? [];
  }
}
