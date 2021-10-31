import 'package:dairy/data/diary.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'diary.dart';

class DatabaseHelper {
  static const _databaseName = "diary.db";
  static const _databaseVersion = 1;
  static const diaryTable = "diary";

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
    CREATE TABLE IF NOT EXISTS $diaryTable (
      date INTEGER DEFAULT 0,
      title String,
      memo String,
      status INTEGER,
      image String
    )
    ''');
  }

  Future _onUpdade(Database db, int version, int newVersion) async {}

  Future<int> insertdiary(Diary diary) async {
    Database db = await instance.database;
    if (diary.date == null) {
      Map<String, dynamic> row = {
        "title": diary.title,
        "date": diary.date,
        "memo": diary.memo,
        "color": diary.color,
        "category": diary.category,
        "done": diary.done
      };
      return await db.insert(diaryTable, row);
    } else {
      Map<String, dynamic> row = {
        "title": diary.title,
        "date": diary.date,
        "memo": diary.memo,
        "color": diary.color,
        "category": diary.category,
        "done": diary.done
      };
      return await db
          .update(diaryTable, row, where: "id = ?", whereArgs: [diary.id]);
    }
  }

  Future<List<Diary>> getAlldiary() async {
    Database db = await instance.database;
    List<Diary> diarys = [];
    List<Map<String, dynamic>> queries = await db.query(diaryTable);

    for (var q in queries) {
      diarys.add(Diary(
          title: q["title"].toString(),
          memo: q["memo"].toString(),
          date: q["date"],
          status: q["status"],
          image: q["image"],
          category: q["category"]));
    }
    return diarys;
  }

  Future<List<Diary>> getdiaryByDate(int date) async {
    Database db = await instance.database;
    List<Diary> diarys = [];
    List<Map<String, dynamic>> queries =
        await db.query(diaryTable, where: "date = ?", whereArgs: [date]);

    for (var q in queries) {
      diarys.add(Diary(
          id: q["id"],
          title: q["title"].toString(),
          memo: q["memo"].toString(),
          date: q["date"],
          color: q["color"],
          done: q["done"],
          category: q["category"]));
    }
    return diarys;
  }
}
