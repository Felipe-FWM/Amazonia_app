import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:amazonia_app/models/tree_model.dart';

class DBService {
  Future<Database> get database async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'trees.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE trees("
          "id TEXT PRIMARY KEY, "
          "name TEXT, "
          "imageUrl TEXT, "
          "botanicalDescription TEXT, "
          "reproductiveBiology TEXT, "
          "ecologicalAspects TEXT, "
          "usage TEXT"
          ")",
        );
      },
      version: 1,
    );
  }

  Future<void> saveTreeData(List<TreeModel> trees) async {
    final db = await database;
    Batch batch = db.batch();

    for (var tree in trees) {
      batch.insert(
        'trees',
        tree.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit();
  }

  Future<List<TreeModel>> getCachedTrees() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('trees');

    return List.generate(maps.length, (i) {
      return TreeModel.fromMap(maps[i]);
    });
  }

  // Função para limpar os dados do banco
  Future<void> clearDatabase() async {
    final db = await database;
    await db.delete('trees');
  }
}
