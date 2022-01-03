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

  Future<int> insertDiary(Diary diary) async {
    Database db = await instance.database;

    List<Diary> diaries = await getDiariesByDate(diary.date);
    Map<String, dynamic> row = {
      "title": diary.title,
      "date": diary.date,
      "memo": diary.memo,
      "image": diary.image,
      "status": diary.status
    };
    if (diaries.isEmpty) {
      return await db.insert(diaryTable, row);
    } else {
      return await db
          .update(diaryTable, row, where: "date = ?", whereArgs: [diary.date]);
    }
  }

  Future<List<Diary>> getAllDiary() async {
    Database db = await instance.database;
    List<Diary> diarys = [];
    List<Map<String, dynamic>> queries = await db.query(diaryTable);

    for (var q in queries) {
      diarys.add(Diary(
          title: q["title"].toString(),
          memo: q["memo"].toString(),
          date: q["date"],
          image: q["image"],
          status: q["status"]));
    }
    return diarys;
  }

  Future<List<Diary>> getDiariesByDate(int date) async {
    Database db = await instance.database;
    List<Diary> diaries = [];
    List<Map<String, dynamic>> queries =
        await db.query(diaryTable, where: "date = ?", whereArgs: [date]);

    for (var q in queries) {
      diaries.add(Diary(
          title: q["title"].toString(),
          memo: q["memo"].toString(),
          date: q["date"],
          image: q["image"],
          status: q["status"]));
    }
    return diaries;
  }
}
