import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test_mobile_app/app/database/models.dart';

class DatabaseService {
  static Database? _database;
  static const _tableUsers = 'users';
  static const _tableTasks = 'tasks';
  static const String tableTasks = 'tasks';
  
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final path = await getDatabasesPath();
    final databasePath = join(path, 'users.db');
    return await openDatabase(databasePath, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
        CREATE TABLE $_tableUsers(
          id INTEGER PRIMARY KEY,
          firstname TEXT,
          lastname TEXT,
          email TEXT,
          password TEXT
        )
      ''');
      await db.execute('''
        CREATE TABLE $_tableTasks(
          id TEXT PRIMARY KEY,
          title TEXT,
          description TEXT,
          status TEXT
        )
      ''');
    });
  }

  Future<void> insertTask(Map<String, dynamic> task) async {
    final db = await database;
    try {
      final id = task['id'].toString();
      final title = task['title'].toString();
      final description = task['description'].toString();
      final status = task['status'].toString();

      await db.insert(_tableTasks, {
        'id': id,
        'title': title,
        'description': description,
        'status': status,
      });
    } catch (e) {
      print('Error inserting task: $e');
      print('Values: ${task['id']}, ${task['title']}, ${task['description']}, ${task['status']}');
    }
  }

  Future<void> registerUser(User user) async {
    final db = await database;
    await db.insert(_tableUsers, user.toMap());
  }

  Future<User?> authenticateUser(String email, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_tableUsers,
        where: 'email = ?', whereArgs: [email]);
    if (maps.isNotEmpty) {
      final user = User.fromMap(maps.first);
      if (user.password == password) {
        return user;
      }
    }
    return null;
  }

  String _hashPassword(String password) {
    return md5.convert(utf8.encode(password)).toString();
  }

  Future<List<Tasks>> getTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_tableTasks);
    return List.generate(maps.length, (index) {
      return Tasks(
        id: maps[index]['id'],
        title: maps[index]['title'],
        description: maps[index]['description'],
        status: maps[index]['status'],
      );
    });
  }
}
