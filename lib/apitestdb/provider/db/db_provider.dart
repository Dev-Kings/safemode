import 'package:path/path.dart';
import 'package:qadata/apitestdb/model/crop_model.dart';
import 'package:qadata/apitestdb/model/data_model.dart';
import 'package:qadata/apitestdb/model/user_model.dart';
import 'package:qadata/apitestdb/model/variety_model.dart';
import 'package:qadata/dataentrytests/models/variety.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static final DBProvider _databaseProviderService = DBProvider._internal();
  factory DBProvider() => _databaseProviderService;
  DBProvider._internal();

  static Database? _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'quality-assurance.db');

    return await openDatabase(path, onCreate: _onCreate, version: 1);
  }

  Future<void> _onCreate(Database db, int version) async {
    //crops table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS crops(
        "id" INTEGER PRIMARY KEY, 
        "crop_name" TEXT
        );
    ''');

    //varieties table
    await db.execute('''
        CREATE TABLE IF NOT EXISTS varieties(
          "id" INTEGER PRIMARY KEY, 
          "crop_id" INTEGER, 
          "crop_name" TEXT, 
          "variety_code" TEXT, 
          "variety_name" TEXT, 
          FOREIGN KEY (crop_id) REFERENCES crops(id) ON DELETE SET NULL
        );
        ''');

    //users table
    await db.execute('''
        CREATE TABLE IF NOT EXISTS users(
          "id" INTEGER PRIMARY KEY, 
          "clock_number" INTEGER, 
          "firstname" TEXT, 
          "lastname" TEXT
          );
        ''');

    //data table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS data(
        "id" INTEGER PRIMARY KEY,
        "qamonitor_id" INTEGER NOT NULL,
        "user_id" INTEGER NOT NULL,
        "variety_id" INTEGER NOT NULL,
        "quantity_checked" INTEGER NOT NULL,
        "total_mistakes" INTEGER DEFAULT 0,
        "cuttings_too_thick" INTEGER DEFAULT 0,
        "cuttings_too_thin" INTEGER DEFAULT 0,
        "cuttings_too_long" INTEGER DEFAULT 0,
        "cuttings_too_short" INTEGER DEFAULT 0,
        "cuttings_too_hard" INTEGER DEFAULT 0,
        "cuttings_too_soft" INTEGER DEFAULT 0,
        "more_leaves" INTEGER DEFAULT 0,
        "less_leaves" INTEGER DEFAULT 0,
        "long_petiole" INTEGER DEFAULT 0,
        "short_petiole" INTEGER DEFAULT 0,
        "overmature_cuttings" INTEGER DEFAULT 0,
        "immature_cuttings" INTEGER DEFAULT 0,
        "short_sticking_length" INTEGER DEFAULT 0,
        "damaged_leaf" INTEGER DEFAULT 0,
        "mechanical_damage" INTEGER DEFAULT 0,
        "disease_damage" INTEGER DEFAULT 0,
        "insect_damage" INTEGER DEFAULT 0,
        "chemical_damage" INTEGER DEFAULT 0,
        "heel_leaf" INTEGER DEFAULT 0,
        "mutation" INTEGER DEFAULT 0,
        "blind_shoots" INTEGER DEFAULT 0,
        "buds" INTEGER DEFAULT 0,
        "poor_hormoning" INTEGER DEFAULT 0,
        "uneven_cut" INTEGER DEFAULT 0,
        "overgrading" INTEGER DEFAULT 0,
        "poor_packing" INTEGER DEFAULT 0,
        "overcount" INTEGER DEFAULT 0,
        "undercount" INTEGER DEFAULT 0,
        "big_leaves" INTEGER DEFAULT 0,
        "small_leaves" INTEGER DEFAULT 0,
        "big_cuttings" INTEGER DEFAULT 0,
        "small_cuttings" INTEGER DEFAULT 0,
        "is_synced_with_server"	INTEGER DEFAULT 0,
        "created_at" TEXT,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE NO ACTION ON UPDATE NO ACTION
        FOREIGN KEY (variety_id) REFERENCES varieties(id) ON DELETE NO ACTION ON UPDATE NO ACTION
      );
      ''');
  }

  createCrop(CropModel newCrop) async {
    await deleteAllCrops();
    final db = await database;
    final res = await db.insert('crops', newCrop.toJson());

    return res;
  }

  createVariety(VarietyModel newVariety) async {
    await deleteAllVarieties();
    final db = await database;
    final result = await db.insert('varieties', newVariety.toJson());

    return result;
  }

  createUser(User newUser) async {
    await deleteAllUsers();
    final db = await database;
    final result = await db.insert('users', newUser.toJson());

    return result;
  }

  createData(Data newData) async {
    await deleteAllData();
    final db = await database;
    final result = await db.insert('data', newData.toJson());

    return result;
  }

  Future<int> deleteAllCrops() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM crops');

    return res;
  }

  Future<int> deleteAllVarieties() async {
    final db = await database;
    final results = await db.rawDelete('DELETE FROM varieties');

    return results;
  }

  Future<int> deleteAllUsers() async {
    final db = await database;
    final results = await db.rawDelete('DELETE FROM users');

    return results;
  }

  Future<int> deleteAllData() async {
    final db = await database;
    final result = await db.rawDelete('DELETE FROM data');

    return result;
  }

  Future<List<CropModel>> getAllCrops() async {
    final db = await database;
    final res = await db.rawQuery('SELECT * FROM crops');

    List<CropModel> list = res.isNotEmpty
        ? res.map((crops) => CropModel.fromJson(crops)).toList()
        : [];

    return list;
  }

  Future<List<VarietyModel>> getAllVarieties() async {
    final db = await database;
    final res = await db.rawQuery('SELECT * FROM varieties');

    List<VarietyModel> list = res.isNotEmpty
        ? res.map((varieties) => VarietyModel.fromJson(varieties)).toList()
        : [];

    return list;
  }

  Future<List<Variety>> varieties() async {
  final db = await database;

  final List<Map<String, dynamic>> maps = await db.query('varieties');

  return List.generate(maps.length, (index) => Variety.fromMap(maps[index]));
  }

  Future<List<User>> getAllUsers() async {
    final db = await database;
    final res = await db.rawQuery('SELECT * FROM users');

    List<User> list =
        res.isNotEmpty ? res.map((users) => User.fromJson(users)).toList() : [];

    return list;
  }

  Future<List<Data>> getAllData() async {
    final db = await database;
    final res = await db.rawQuery('SELECT * FROM data');

    List<Data> list =
        res.isNotEmpty ? res.map((data) => Data.fromJson(data)).toList() : [];

    return list;
  }

  Future<void> deleteData(int id) async {
    final db = await database;
    await db.delete(
      'data',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
