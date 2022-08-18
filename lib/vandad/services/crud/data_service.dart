import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:qadata/vandad/services/crud/crud_exceptions.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;

class DataService {
  Database? _db;

  List<DatabaseData> _datas = [];

  //singleton
  static final DataService _shared = DataService._sharedInstance();
  DataService._sharedInstance(){
    _datasStreamController = StreamController<List<DatabaseData>>.broadcast(
      onListen: () {
        _datasStreamController.sink.add(_datas);
      },
    );
  }
  factory DataService() => _shared;

  late final StreamController<List<DatabaseData>> _datasStreamController;

  Stream<List<DatabaseData>> get allDatas => _datasStreamController.stream;

  Future<DatabaseUser> getOrCreateUser({
    required int clockNumber,
    required String firstname,
    required String lastname,
    required String email,
  }) async {
    try {
      final user = await getUser(email: email);
      return user;
    } on CouldNotFindUser {
      final createdUser = await createUser(
        clockNumber: clockNumber,
        firstname: firstname,
        lastname: lastname,
        email: email,
      );
      return createdUser;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _cacheDatas() async {
    final allDatas = await getAllData();
    _datas = allDatas.toList();
    _datasStreamController.add(_datas);
  }

  Future<DatabaseData> updateData({
    required DatabaseData data,
    required int harvesterId,
    required int varietyId,
    required int quantityChecked,
    required int totalMistakes,
    required int thickCuttings,
    required int thinCuttings,
    required int longCuttings,
    required int shortCuttings,
    required int hardCuttings,
    required int softCuttings,
    required int moreLeaves,
    required int lessLeaves,
    required int longPetiole,
    required int shortPetiole,
    required int overmatureCuttings,
    required int immatureCuttings,
    required int shortStickingLength,
    required int damagedLeaf,
    required int mechanicalDamage,
    required int diseaseDamage,
    required int insectDamage,
    required int chemicalDamage,
    required int heelLeaf,
    required int mutation,
    required int blindShoots,
    required int buds,
    required int poorHormoning,
    required int unevenCut,
    required int overgrading,
    required int poorPacking,
    required int overcount,
    required int undercount,
    required int bigLeaves,
    required int smallLeaves,
    required int bigCuttings,
    required int smallCuttings,
  }) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    //make sure data exists
    await getData(id: data.id);

    //update DB
    final updatesCount = await db.update(dataTable, {
      harvesterIdColumn: harvesterId,
      varietyIdColumn: varietyId,
      quantityCheckedColumn: quantityChecked,
      totalMistakesColumn: totalMistakes,
      thickCuttingsColumn: thickCuttings,
      thinCuttingsColumn: thinCuttings,
      longCuttingsColumn: longCuttings,
      shortCuttingsColumn: shortCuttings,
      hardCuttingsColumn: hardCuttings,
      softCuttingsColumn: softCuttings,
      moreLeavesColumn: moreLeaves,
      lessLeavesColumn: lessLeaves,
      longPetioleColumn: longPetiole,
      shortPetioleColumn: shortPetiole,
      overmatureCuttingsColumn: overmatureCuttings,
      immatureCuttingsColumn: immatureCuttings,
      shortStickingLengthColumn: shortStickingLength,
      damagedLeafColumn: damagedLeaf,
      mechanicalDamageColumn: mechanicalDamage,
      diseaseDamageColumn: diseaseDamage,
      insectDamageColumn: insectDamage,
      chemicalDamageColumn: chemicalDamage,
      heelLeafColumn: heelLeaf,
      mutationColumn: mutation,
      blindShootsColumn: blindShoots,
      budsColumn: buds,
      poorHormoningColumn: poorHormoning,
      unevenCutColumn: unevenCut,
      overgradingColumn: overgrading,
      poorPackingColumn: poorPacking,
      overcountColumn: overcount,
      undercountColumn: undercount,
      bigLeavesColumn: bigLeaves,
      smallLeavesColumn: smallLeaves,
      bigCuttingsColumn: bigCuttings,
      smallCuttingsColumn: smallCuttings,
      isSyncedWithServerColumn: 0,
    });

    if (updatesCount == 0) {
      throw CouldNotUpdateData();
    } else {
      final updatedData = await getData(id: data.id);
      _datas.removeWhere((data) => data.id == updatedData.id);
      _datas.add(updatedData);
      _datasStreamController.add(_datas);
      return updatedData;
    }
  }

  Future<Iterable<DatabaseData>> getAllData() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final datas = await db.query(dataTable);

    return datas.map((dataRow) => DatabaseData.fromRow(dataRow));
  }

  Future<DatabaseData> getData({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final datas = await db.query(
      dataTable,
      limit: 1,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (datas.isEmpty) {
      throw CouldNotFindData();
    } else {
      final data = DatabaseData.fromRow(datas.first);
      _datas.removeWhere((data) => data.id == id);
      _datas.add(data);
      _datasStreamController.add(_datas);
      return data;
    }
  }

  Future<int> deleteAllData() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final numberOfDeletions = await db.delete(dataTable);
    _datas = [];
    _datasStreamController.add(_datas);
    return numberOfDeletions;
  }

  Future<void> deleteData({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      dataTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (deletedCount == 0) {
      throw CouldNotDeleteData();
    } else {
      _datas.removeWhere((data) => data.id == id);
      _datasStreamController.add(_datas);
    }
  }

  Future<DatabaseData> createData({required DatabaseUser owner}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    //make sure owner exists in the db with correct id
    final dbUser = await getUser(email: owner.email);
    if (dbUser != owner) {
      throw CouldNotFindUser();
    }
    const harvester = 0;
    const variety = 0;
    const quantityChecked = 0;
    const totalMistakes = 0;
    const thickCuttings = 0;
    const thinCuttings = 0;
    const longCuttings = 0;
    const shortCuttings = 0;
    const hardCuttings = 0;
    const softCuttings = 0;
    const moreLeaves = 0;
    const lessLeaves = 0;
    const longPetiole = 0;
    const shortPetiole = 0;
    const overmatureCuttings = 0;
    const immatureCuttings = 0;
    const shortStickingLength = 0;
    const damagedLeaf = 0;
    const mechanicalDamage = 0;
    const diseaseDamage = 0;
    const insectDamage = 0;
    const chemicalDamage = 0;
    const heelLeaf = 0;
    const mutation = 0;
    const blindShoots = 0;
    const buds = 0;
    const poorHormoning = 0;
    const unevenCut = 0;
    const overgrading = 0;
    const poorPacking = 0;
    const overcount = 0;
    const undercount = 0;
    const bigLeaves = 0;
    const smallLeaves = 0;
    const bigCuttings = 0;
    const smallCuttings = 0;
    //create data
    final dataId = await db.insert(dataTable, {
      qaMonitorIdColumn: owner.id,
      harvesterIdColumn: harvester,
      varietyIdColumn: variety,
      quantityCheckedColumn: quantityChecked,
      totalMistakesColumn: totalMistakes,
      thickCuttingsColumn: thickCuttings,
      thinCuttingsColumn: thinCuttings,
      longCuttingsColumn: longCuttings,
      shortCuttingsColumn: shortCuttings,
      hardCuttingsColumn: hardCuttings,
      softCuttingsColumn: softCuttings,
      moreLeavesColumn: moreLeaves,
      lessLeavesColumn: lessLeaves,
      longPetioleColumn: longPetiole,
      shortPetioleColumn: shortPetiole,
      overmatureCuttingsColumn: overmatureCuttings,
      immatureCuttingsColumn: immatureCuttings,
      shortStickingLengthColumn: shortStickingLength,
      damagedLeafColumn: damagedLeaf,
      mechanicalDamageColumn: mechanicalDamage,
      diseaseDamageColumn: diseaseDamage,
      insectDamageColumn: insectDamage,
      chemicalDamageColumn: chemicalDamage,
      heelLeafColumn: heelLeaf,
      mutationColumn: mutation,
      blindShootsColumn: blindShoots,
      budsColumn: buds,
      poorHormoningColumn: poorHormoning,
      unevenCutColumn: unevenCut,
      overgradingColumn: overgrading,
      poorPackingColumn: poorPacking,
      overcountColumn: overcount,
      undercountColumn: undercount,
      bigLeavesColumn: bigLeaves,
      smallLeavesColumn: smallLeaves,
      bigCuttingsColumn: bigCuttings,
      smallCuttingsColumn: smallCuttings,
      isSyncedWithServerColumn: 1,
    });

    final data = DatabaseData(
      id: dataId,
      qaMonitorId: owner.id,
      havesterId: harvester,
      varietyId: variety,
      quantityChecked: quantityChecked,
      totalMistakes: totalMistakes,
      thickCuttings: thickCuttings,
      thinCuttings: thinCuttings,
      longCuttings: longCuttings,
      shortCuttings: shortCuttings,
      hardCuttings: hardCuttings,
      softCuttings: softCuttings,
      moreLeaves: moreLeaves,
      lessLeaves: lessLeaves,
      longPetiole: longPetiole,
      shortPetiole: shortPetiole,
      overmatureCuttings: overmatureCuttings,
      immatureCuttings: immatureCuttings,
      shortStickingLength: shortStickingLength,
      damagedLeaf: damagedLeaf,
      mechanicalDamage: mechanicalDamage,
      diseaseDamage: diseaseDamage,
      insectDamage: insectDamage,
      chemicalDamage: chemicalDamage,
      heelLeaf: heelLeaf,
      mutation: mutation,
      blindShoots: blindShoots,
      buds: buds,
      poorHormoning: poorHormoning,
      unevenCut: unevenCut,
      overgrading: overgrading,
      poorPacking: poorPacking,
      overcount: overcount,
      undercount: undercount,
      bigLeaves: bigLeaves,
      smallLeaves: smallLeaves,
      bigCuttings: bigCuttings,
      smallCuttings: smallCuttings,
      isSyncedWithServer: true,
    );

    _datas.add(data);
    _datasStreamController.add(_datas);

    return data;
  }

  Future<DatabaseUser> getUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final results = await db.query(
      usersTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (results.isEmpty) {
      throw CouldNotFindUser();
    } else {
      return DatabaseUser.fromRow(results.first);
    }
  }

  Future<DatabaseUser> createUser({
    required int clockNumber,
    required String firstname,
    required String lastname,
    required String email,
  }) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      usersTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (results.isNotEmpty) {
      throw UserAlreadyExists();
    }
    final userId = await db.insert(usersTable, {
      clockNumberColumn: clockNumber,
      firstnameColumn: firstname,
      lastnameColumn: lastname,
      emailColumn: email.toLowerCase(),
    });

    return DatabaseUser(
      id: userId,
      clockNumber: clockNumber,
      firstname: firstname,
      lastname: lastname,
      email: email,
    );
  }

  Future<void> deleteUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      usersTable,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (deletedCount != 1) {
      throw CouldNotDeleteUser();
    }
  }

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      return db;
    }
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      await db.close();
      _db = null;
    }
  }

  Future<void> _ensureDbIsOpen() async {
    try {
      await open();
    } on DatabaseAlreadyOpenException {
      //
    }
  }

  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;

      //create users table
      await db.execute(createUsersTable);
      //create crops table
      await db.execute(createCropsTable);
      //create varieties table
      await db.execute(createVarietiesTable);
      //create data table
      await db.execute(createDataTable);
      await _cacheDatas();
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectory();
    }
  }
}

@immutable
class DatabaseUser {
  final int id;
  final int clockNumber;
  final String firstname;
  final String lastname;
  final String email;

  const DatabaseUser({
    required this.id,
    required this.clockNumber,
    required this.firstname,
    required this.lastname,
    required this.email,
  });

  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        clockNumber = map[clockNumberColumn] as int,
        firstname = map[firstnameColumn] as String,
        lastname = map[lastnameColumn] as String,
        email = map[emailColumn] as String;

  @override
  String toString() =>
      'Person, ID = $id, clocknumber = $clockNumber, firstname = $firstname, lastname = $lastname, email = $email';

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class DatabaseCrop {
  final int id;
  final String cropName;
  final bool isSyncedWithServer;

  DatabaseCrop({
    required this.id,
    required this.cropName,
    required this.isSyncedWithServer,
  });

  DatabaseCrop.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        cropName = map[cropNameColumn] as String,
        isSyncedWithServer =
            (map[isSyncedWithServerColumn] as int) == 1 ? true : false;

  @override
  String toString() =>
      'Crop, ID = $id, cropName = $cropName, isSyncedWithServer = $isSyncedWithServer';

  @override
  bool operator ==(covariant DatabaseCrop other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class DatabaseVariety {
  final int id;
  final int cropId;
  final String varietyCode;
  final String varietyName;
  final bool isSyncedWithServer;

  DatabaseVariety({
    required this.id,
    required this.cropId,
    required this.varietyCode,
    required this.varietyName,
    required this.isSyncedWithServer,
  });

  DatabaseVariety.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        cropId = map[cropIdColumn] as int,
        varietyCode = map[varietyCodeColumn] as String,
        varietyName = map[varietyNameColumn] as String,
        isSyncedWithServer =
            (map[isSyncedWithServerColumn] as int) == 1 ? true : false;

  @override
  String toString() =>
      'Variety, ID = $id, cropId = $cropId, varietyCode = $varietyCode, varietyName = $varietyName, isSyncedWithServer = $isSyncedWithServer';

  @override
  bool operator ==(covariant DatabaseVariety other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class DatabaseData {
  final int id;
  final int qaMonitorId;
  final int havesterId;
  final int varietyId;
  final int quantityChecked;
  final int totalMistakes;
  final int thickCuttings;
  final int thinCuttings;
  final int longCuttings;
  final int shortCuttings;
  final int hardCuttings;
  final int softCuttings;
  final int moreLeaves;
  final int lessLeaves;
  final int longPetiole;
  final int shortPetiole;
  final int overmatureCuttings;
  final int immatureCuttings;
  final int shortStickingLength;
  final int damagedLeaf;
  final int mechanicalDamage;
  final int diseaseDamage;
  final int insectDamage;
  final int chemicalDamage;
  final int heelLeaf;
  final int mutation;
  final int blindShoots;
  final int buds;
  final int poorHormoning;
  final int unevenCut;
  final int overgrading;
  final int poorPacking;
  final int overcount;
  final int undercount;
  final int bigLeaves;
  final int smallLeaves;
  final int bigCuttings;
  final int smallCuttings;
  final bool isSyncedWithServer;

  DatabaseData({
    required this.id,
    required this.qaMonitorId,
    required this.havesterId,
    required this.varietyId,
    required this.quantityChecked,
    required this.totalMistakes,
    required this.thickCuttings,
    required this.thinCuttings,
    required this.longCuttings,
    required this.shortCuttings,
    required this.hardCuttings,
    required this.softCuttings,
    required this.moreLeaves,
    required this.lessLeaves,
    required this.longPetiole,
    required this.shortPetiole,
    required this.overmatureCuttings,
    required this.immatureCuttings,
    required this.shortStickingLength,
    required this.damagedLeaf,
    required this.mechanicalDamage,
    required this.diseaseDamage,
    required this.insectDamage,
    required this.chemicalDamage,
    required this.heelLeaf,
    required this.mutation,
    required this.blindShoots,
    required this.buds,
    required this.poorHormoning,
    required this.unevenCut,
    required this.overgrading,
    required this.poorPacking,
    required this.overcount,
    required this.undercount,
    required this.bigLeaves,
    required this.smallLeaves,
    required this.bigCuttings,
    required this.smallCuttings,
    required this.isSyncedWithServer,
  });

  DatabaseData.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        qaMonitorId = map[qaMonitorIdColumn] as int,
        havesterId = map[harvesterIdColumn] as int,
        varietyId = map[varietyIdColumn] as int,
        quantityChecked = map[quantityCheckedColumn] as int,
        totalMistakes = map[totalMistakesColumn] as int,
        thickCuttings = map[thickCuttingsColumn] as int,
        thinCuttings = map[thinCuttingsColumn] as int,
        longCuttings = map[longCuttingsColumn] as int,
        shortCuttings = map[shortCuttingsColumn] as int,
        hardCuttings = map[hardCuttingsColumn] as int,
        softCuttings = map[softCuttingsColumn] as int,
        moreLeaves = map[moreLeavesColumn] as int,
        lessLeaves = map[lessLeavesColumn] as int,
        longPetiole = map[longPetioleColumn] as int,
        shortPetiole = map[shortPetioleColumn] as int,
        overmatureCuttings = map[overmatureCuttingsColumn] as int,
        immatureCuttings = map[immatureCuttingsColumn] as int,
        shortStickingLength = map[shortStickingLengthColumn] as int,
        damagedLeaf = map[damagedLeafColumn] as int,
        mechanicalDamage = map[mechanicalDamageColumn] as int,
        diseaseDamage = map[diseaseDamageColumn] as int,
        insectDamage = map[insectDamageColumn] as int,
        chemicalDamage = map[chemicalDamageColumn] as int,
        heelLeaf = map[heelLeafColumn] as int,
        mutation = map[mutationColumn] as int,
        blindShoots = map[blindShootsColumn] as int,
        buds = map[budsColumn] as int,
        poorHormoning = map[poorHormoningColumn] as int,
        unevenCut = map[unevenCutColumn] as int,
        overgrading = map[overgradingColumn] as int,
        poorPacking = map[poorPackingColumn] as int,
        overcount = map[overcountColumn] as int,
        undercount = map[undercountColumn] as int,
        bigLeaves = map[bigLeavesColumn] as int,
        smallLeaves = map[smallLeavesColumn] as int,
        bigCuttings = map[bigCuttingsColumn] as int,
        smallCuttings = map[smallCuttingsColumn] as int,
        isSyncedWithServer =
            (map[isSyncedWithServerColumn] as int) == 1 ? true : false;

  @override
  String toString() =>
      'Data, ID = $id, qaMonitor = $qaMonitorId, harversterId = $havesterId, varietyId = $varietyId, quantityChecked = $quantityChecked, totalMistakes = $totalMistakes, thickCuttings = $thickCuttings, thinCuttings = $thinCuttings, longCuttings = $longCuttings, shortCuttings = $shortCuttings, hardCuttings = $hardCuttings, softCuttings = $softCuttings, moreLeaves = $moreLeaves, lessLeaves = $lessLeaves, longPetiole = $longPetiole, shortPetiole = $shortPetiole, overmatureCuttings = $overmatureCuttings, immatureCuttings = $immatureCuttings, shortStickingLength = $shortStickingLength, damagedLeaf = $damagedLeaf, mechanicalDamage = $mechanicalDamage, diseaseDamage = $diseaseDamage, insectDamage = $insectDamage, chemicalDamage = $chemicalDamage, heelLeaf = $heelLeaf, mutation = $mutation, blindShoots = $blindShoots, buds = $buds, poorHormoning = $poorHormoning, unevenCut = $unevenCut, overgrading = $overgrading, poorPacking = $poorPacking, overcount = $overcount, undercount = $undercount, bigLeaves = $bigLeaves, smallLeaves = $smallLeaves, bigCuttings = $bigCuttings, smallCuttings = $smallCuttings';
  @override
  bool operator ==(covariant DatabaseData other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

const dbName = 'qa.db';
const usersTable = 'users';
const cropsTable = 'crops';
const varietiesTable = 'varieties';
const dataTable = 'data';
const idColumn = 'id';
const clockNumberColumn = 'clock_number';
const firstnameColumn = 'firstname';
const lastnameColumn = 'lastname';
const emailColumn = 'email';

const cropNameColumn = 'crop_name';
const isSyncedWithServerColumn = 'is_synced_with_server';

const cropIdColumn = 'crop_id';
const varietyCodeColumn = 'variety_code';
const varietyNameColumn = 'variety_name';

const qaMonitorIdColumn = 'qamonitor_id';
const harvesterIdColumn = 'user_id';
const varietyIdColumn = 'variety_id';
const quantityCheckedColumn = 'quantity_checked';
const totalMistakesColumn = 'total_mistakes';
const thickCuttingsColumn = 'cuttings_too_thick';
const thinCuttingsColumn = 'cuttings_too_thin';
const longCuttingsColumn = 'cuttings_too_long';
const shortCuttingsColumn = 'cuttings_too_short';
const hardCuttingsColumn = 'cuttings_too_hard';
const softCuttingsColumn = 'cuttings_too_soft';
const moreLeavesColumn = 'more_leaves';
const lessLeavesColumn = 'less_leaves';
const longPetioleColumn = 'long_petiole';
const shortPetioleColumn = 'short_petiole';
const overmatureCuttingsColumn = 'overmature_cuttings';
const immatureCuttingsColumn = 'immature_cuttings';
const shortStickingLengthColumn = 'short_sticking_length';
const damagedLeafColumn = 'damaged_leaf';
const mechanicalDamageColumn = 'mechanical_damage';
const diseaseDamageColumn = 'disease_damage';
const insectDamageColumn = 'insect_damage';
const chemicalDamageColumn = 'chemical_damage';
const heelLeafColumn = 'heel_leaf';
const mutationColumn = 'mutation';
const blindShootsColumn = 'blind_shoots';
const budsColumn = 'buds';
const poorHormoningColumn = 'poor_hormoning';
const unevenCutColumn = 'uneven_cut';
const overgradingColumn = 'overgrading';
const poorPackingColumn = 'poor_packing';
const overcountColumn = 'overcount';
const undercountColumn = 'undercount';
const bigLeavesColumn = 'big_leaves';
const smallLeavesColumn = 'small_leaves';
const bigCuttingsColumn = 'big_cuttings';
const smallCuttingsColumn = 'small_cuttings';

const createUsersTable = '''
        CREATE TABLE IF NOT EXISTS "users"(
            "id"	INTEGER,
            "clock_number"	INTEGER,
            "firstname"	TEXT,
            "lastname"	TEXT,
            "email"	TEXT UNIQUE,
            PRIMARY KEY("id" AUTOINCREMENT)
        );''';

const createCropsTable = '''
        CREATE TABLE IF NOT EXISTS "crops" (
          "id"	INTEGER NOT NULL,
          "crop_name"	TEXT NOT NULL,
          "is_synced_with_server"	INTEGER DEFAULT 0,
          PRIMARY KEY("id" AUTOINCREMENT)
      );''';

const createVarietiesTable = '''
        CREATE TABLE IF NOT EXISTS "varieties" (
          "id"	INTEGER NOT NULL,
          "crop_id"	INTEGER NOT NULL,
          "variety_code"	TEXT NOT NULL,
          "variety_name"	TEXT NOT NULL,
          "is_synced_with_server"	INTEGER DEFAULT 0,
          FOREIGN KEY("crop_id") REFERENCES "crops"("id"),
          PRIMARY KEY("id" AUTOINCREMENT)
      );''';

const createDataTable = '''
      CREATE TABLE IF NOT EXISTS "data" (
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
      );''';
