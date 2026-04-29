import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/veicolo.dart';
import '../models/prenotazione.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper.init();
  static Database? databaseInstance;

  DatabaseHelper.init();

  Future<Database> get database async {
    if (databaseInstance != null) return databaseInstance!;
    databaseInstance = await initDB('babaxpark.db');
    return databaseInstance!;
  }

  Future<Database> initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: createDB,
      onUpgrade: onUpgrade,
    );
  }

  Future onUpgrade(Database db, int oldVersion, int newVersion) async {
    await db.execute('DROP TABLE IF EXISTS prenotazioni');
    await db.execute('DROP TABLE IF EXISTS veicoli');
    await createDB(db, newVersion);
  }

  Future createDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE veicoli (
  targa TEXT PRIMARY KEY
)
''');

    await db.execute('''
CREATE TABLE prenotazioni (
  id TEXT PRIMARY KEY,
  targa TEXT NOT NULL,
  id_posto INTEGER NOT NULL,
  data_inizio TEXT NOT NULL,
  data_fine TEXT NOT NULL,
  stato TEXT NOT NULL,
  FOREIGN KEY (targa) REFERENCES veicoli (targa)
)
''');
  }

  // --- CRUD VEICOLI ---
  Future<void> insertVeicolo(Veicolo veicolo) async {
    final db = await instance.database;
    await db.insert('veicoli', veicolo.toJson());
  }

  Future<int> updateVeicolo(Veicolo veicolo) async {
    final db = await instance.database;
    return await db.update(
      'veicoli',
      veicolo.toJson(),
      where: 'targa = ?',
      whereArgs: [veicolo.targa],
    );
  }

  Future<List<Veicolo>> getAllVeicoli() async {
    final db = await instance.database;
    final maps = await db.query('veicoli');
    return maps.map((json) => Veicolo.fromJson(json)).toList();
  }

  Future<int> deleteVeicolo(String targa) async {
    final db = await instance.database;
    return await db.delete('veicoli', where: 'targa = ?', whereArgs: [targa]);
  }

  Future<void> clearVeicoli() async {
    final db = await instance.database;
    await db.delete('veicoli');
  }

  // --- CRUD PRENOTAZIONI ---
  Future<int> insertPrenotazione(Prenotazione p) async {
    Database db = await database;
    return await db.insert('prenotazioni', p.toJson());
  }

  Future<int> updatePrenotazione(Prenotazione p) async {
    Database db = await database;
    return await db.update(
      'prenotazioni',
      p.toJson(),
      where: 'id = ?',
      whereArgs: [p.id],
    );
  }

  Future<List<Prenotazione>> getPrenotazioni() async {
    final db = await instance.database;
    final maps = await db.query('prenotazioni');
    return maps.map((json) => Prenotazione.fromJson(json)).toList();
  }

  Future<int> deletePrenotazione(String id) async {
    final db = await instance.database;
    return await db.delete('prenotazioni', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearPrenotazioni() async {
    final db = await instance.database;
    await db.delete('prenotazioni');
  }
}
