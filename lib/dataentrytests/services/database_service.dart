import 'package:qadata/apitestdb/model/data_model.dart';
import 'package:qadata/dataentrytests/models/crop.dart';
import 'package:qadata/dataentrytests/models/variety.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' show join;

class DatabaseService {
  //singleton
  static final DatabaseService _databaseService = DatabaseService._internal();
  factory DatabaseService() => _databaseService;
  DatabaseService._internal();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();

    final path = join(databasePath, 'quality-assurance.db');

    return await openDatabase(path, onCreate: _onCreate, version: 1);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS crops(
        "id" INTEGER PRIMARY KEY, 
        "crop_name" TEXT
        );
    ''');
    await db.execute('''
        CREATE TABLE IF NOT EXISTS varieties(
          "id" INTEGER PRIMARY KEY, 
          "crop_id"  INTEGER, 
          "crop_name" TEXT, 
          "variety_code" TEXT, 
          "variety_name" TEXT, 
          FOREIGN KEY (crop_id) REFERENCES crops(id) ON DELETE SET NULL
          );
        ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS data(
        "id" INTEGER DEFAULT 0,
        "qamonitor_id" INTEGER DEFAULT 0,
        "user_id" INTEGER DEFAULT 0,
        "variety_id" INTEGER DEFAULT 0,
        "quantity_checked" INTEGER DEFAULT 0,
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
        PRIMARY KEY("id" AUTOINCREMENT)
      );
      ''');
  }

  Future<void> insertCrop(Crop crop) async {
    final db = await _databaseService.database;

    await db.insert(
      'crops',
      crop.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertVariety(Variety variety) async {
    final db = await _databaseService.database;

    await db.insert(
      'varieties',
      variety.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertData(Data data) async {
    final db = await _databaseService.database;

    await db.insert(
      'data',
      data.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Crop>> crops() async {
    final db = await _databaseService.database;

    final List<Map<String, dynamic>> maps = await db.query('crops');

    return List.generate(maps.length, (index) => Crop.fromMap(maps[index]));
  }

  Future<Crop> crop(int id) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps =
        await db.query('crops', where: 'id = ?', whereArgs: [id]);

    return Crop.fromMap(maps[0]);
  }

  Future<List<Variety>> varieties() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query('varieties');
    return List.generate(maps.length, (index) => Variety.fromMap(maps[index]));
  }

  Future<void> updateCrop(Crop crop) async {
    final db = await _databaseService.database;

    await db.update(
      'crops',
      crop.toMap(),
      where: 'id = ?',
      whereArgs: [crop.id],
    );
  }

  Future<void> updateVariety(Variety variety) async {
    final db = await _databaseService.database;
    await db.update(
      'varieties',
      variety.toMap(),
      where: 'id = ?',
      whereArgs: [variety.id],
    );
  }

  Future<void> updateData(Data data) async {
    final db = await _databaseService.database;
    await db.update(
      'data', 
      data.toMap(),
      where: 'id = ?',
      whereArgs: [data.id],
      );
  }

  Future<void> deleteCrop(int id) async {
    final db = await _databaseService.database;

    await db.delete(
      'crops',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteVariety(int id) async {
    final db = await _databaseService.database;
    await db.delete(
      'varieties',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
