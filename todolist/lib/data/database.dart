import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'todo.dart';

class DatabaseHelper {
  static const _databaseName = "todo.db";
  static const _databaseVersion = 1;
  static const todoTable = "todo";

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  Future<Database> get database async {
    return _database ??= await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, _databaseName);

    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate, onUpgrade: _onUpdade);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS $todoTable (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      date INTEGER DEFAULT 0,
      title String,
      memo String,
      color INTEGER,
      category String,
      done INTEGER

    )
    ''');
  }

  Future _onUpdade(Database db, int version, int newVersion) async {}

  Future<int> insertTodo(Todo todo) async {
    Database db = await instance.database;
    if (todo.id == null) {
      Map<String, dynamic> row = {
        "title": todo.title,
        "date": todo.date,
        "memo": todo.memo,
        "color": todo.color,
        "category": todo.category,
        "done": todo.done
      };
      return await db.insert(todoTable, row);
    } else {
      Map<String, dynamic> row = {
        "title": todo.title,
        "date": todo.date,
        "memo": todo.memo,
        "color": todo.color,
        "category": todo.category,
        "done": todo.done
      };
      return await db
          .update(todoTable, row, where: "id = ?", whereArgs: [todo.id]);
    }
  }

  Future<List<Todo>> getAllTodo() async {
    Database db = await instance.database;
    List<Todo> todos = [];
    List<Map<String, dynamic>> queries = await db.query(todoTable);

    for (var q in queries) {
      todos.add(Todo(
          id: q["id"],
          title: q["title"].toString(),
          memo: q["memo"].toString(),
          date: q["date"],
          color: q["color"],
          done: q["done"],
          category: q["category"]));
    }
    return todos;
  }

  Future<List<Todo>> getTodoByDate(int date) async {
    Database db = await instance.database;
    List<Todo> todos = [];
    List<Map<String, dynamic>> queries =
        await db.query(todoTable, where: "date = ?", whereArgs: [date]);

    for (var q in queries) {
      todos.add(Todo(
          id: q["id"],
          title: q["title"].toString(),
          memo: q["memo"].toString(),
          date: q["date"],
          color: q["color"],
          done: q["done"],
          category: q["category"]));
    }
    return todos;
  }
}
