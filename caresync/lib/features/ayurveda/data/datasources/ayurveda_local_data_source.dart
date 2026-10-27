import 'package:sqflite/sqflite.dart';
import 'package:caresync/features/ayurveda/data/models/ayurveda_item_model.dart';

abstract class AyurvedaLocalDataSource {
  Future<List<AyurvedaItemModel>> getCachedItems();
  Future<void> cacheItems(List<AyurvedaItemModel> items);
}

class AyurvedaLocalDataSourceImpl implements AyurvedaLocalDataSource {
  Database? _db;

  Future<Database> _getDatabase() async {
    if (_db != null) return _db!;
    final dbPath = await getDatabasesPath();
    final path = '$dbPath/ayurvedamodule.db';

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE Ayurveda (
            id TEXT PRIMARY KEY,
            name TEXT,
            description TEXT,
            imagePath TEXT
          )
        ''');
      },
    );
    return _db!;
  }

  @override
  Future<List<AyurvedaItemModel>> getCachedItems() async {
    final db = await _getDatabase();
    final results = await db.query('Ayurveda');
    return results.map((row) => AyurvedaItemModel.fromMap(row)).toList();
  }

  @override
  Future<void> cacheItems(List<AyurvedaItemModel> items) async {
    final db = await _getDatabase();
    final batch = db.batch();
    for (final item in items) {
      batch.insert(
        'Ayurveda',
        item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }
}
