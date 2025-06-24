import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../login/model/user_data_model.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._init();
  static Database? db;

  DBHelper._init();

  /// Initializes the database if it is not already initialized.
  Future<Database> get database async {
    if (db != null) return db!;
    db = await initDB();
    return db!;
  }

  Future<Database> initDB() async {
    final dbPath = join(await getDatabasesPath(), 'app.db');
    return await openDatabase(
      dbPath,
      version: 2,
      onCreate: (db, version) {
        db.execute('''CREATE TABLE IF NOT EXISTS user(
   id INTEGER PRIMARY KEY AUTOINCREMENT,
   name TEXT NOT NULL,
   email TEXT UNIQUE NOT NULL,
   phone TEXT,
   image TEXT,
   password VARCHAR(255)) ''');
      },
    );
  }

  Future<int> insertUserData({UserDataModel? user}) async {
    final db = await database;
    return await db.insert('user', user!.toJson());
  }

  Future<List<UserDataModel>> getAllUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('user');
    return List.generate(
      maps.length,
      (index) {
        return UserDataModel.fromJson(maps[index]);
      },
    );
  }

  Future<UserDataModel> getUserByEmailAndPassword(String email, String password) async {
    final db = await database;
    final maps = await db.query('user', where: 'email = ? AND password = ?', whereArgs: [email, password]);
    if (maps.isNotEmpty) {
      return UserDataModel.fromJson(maps.first);
    } else {
      return UserDataModel();
    }
  }

  Future<UserDataModel> getUserByEmail(String email) async {
    final dbClient = await database;
    final maps = await dbClient.query('user', where: 'email = ?', whereArgs: [email]);
    print('Maps========R${maps.first}');
    if (maps.isNotEmpty) return UserDataModel.fromJson(maps.first);
    return UserDataModel();
  }
}
