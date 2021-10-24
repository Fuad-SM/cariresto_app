import 'package:restaurant_app/data/model/list_restaurant.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _instance;
  static Database? _database;

  DatabaseHelper._internal() {
    _instance = this;
  }

  factory DatabaseHelper() => _instance ?? DatabaseHelper._internal();

  static const String _tblFavorite = 'favorite';

  Future<Database> _initializeDb() async {
    var path = await getDatabasesPath();

    var db = openDatabase(
      '$path/cariresto.db',
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE $_tblFavorite (
        id TEXT PRIMARY KEY,
        name TEXT,
        description TEXT,
        pictureId TEXT,
        city TEXT,
        rating DOUBLE)
        ''');
      },
      version: 1,
    );
    return db;
  }

  Future<Database?> get database async {
    _database ??= await _initializeDb();

    return _database;
  }

  Future<void> insertFavResto(RestaurantElement resto) async {
    final db = await database;

    await db!.insert(_tblFavorite, resto.toJson());
  }

  Future<List<RestaurantElement>> getFavResto() async {
    final db = await database;

    List<Map<String, dynamic>> results = await db!.query(_tblFavorite);
    return results.map((res) => RestaurantElement.fromJson(res)).toList();
  }

  Future<Map> getFavRestoById(String id) async {
    final db = await database;

    List<Map<String, dynamic>> results = await db!.query(
      _tblFavorite,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return {};
    }
  }

  Future<void> removeFavorite(String id) async {
    final db = await database;

    await db!.delete(
      _tblFavorite,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
