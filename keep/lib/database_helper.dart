import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'model.dart';

/// Helper per la gestione del database SQLite locale
/// Implementa il pattern Singleton per garantire una sola istanza del database
class DatabaseHelper {
  // Istanza unica del DatabaseHelper (Singleton pattern)
  static final DatabaseHelper instance = DatabaseHelper._init();
  
  // Riferimento al database SQLite
  static Database? _database;

  // Costruttore privato per impedire istanziazione diretta
  DatabaseHelper._init();

  /// Getter per ottenere il database
  /// Se il database non esiste ancora, lo inizializza
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('todos.db');
    return _database!;
  }

  /// Inizializza il database creando il file e le tabelle
  /// [filePath] nome del file database (es. 'todos.db')
  Future<Database> _initDB(String filePath) async {
    // Ottiene il percorso della directory dei database del sistema
    final dbPath = await getDatabasesPath();
    
    // Combina il percorso della directory con il nome del file
    final path = join(dbPath, filePath);

    // Apre (o crea se non esiste) il database
    return await openDatabase(
      path,
      version: 1, // Versione del database (utile per future migrazioni)
      onCreate: _createDB, // Callback chiamata solo alla prima creazione
    );
  }

  /// Crea lo schema del database (tabelle e relazioni)
  /// Chiamata automaticamente solo quando il database viene creato per la prima volta
  Future _createDB(Database db, int version) async {
    // Tabella TODOS: contiene le card principali
    await db.execute('''
      CREATE TABLE todos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,  -- ID univoco auto-incrementante
        name TEXT NOT NULL                      -- Titolo della card (obbligatorio)
      )
    ''');

    // Tabella NOTES: contiene le singole note dentro ogni card
    await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,  -- ID univoco auto-incrementante
        todoId INTEGER NOT NULL,                -- Riferimento alla card padre
        text TEXT NOT NULL,                     -- Testo della nota (obbligatorio)
        checked INTEGER NOT NULL,               -- Stato checkbox (0=false, 1=true)
        FOREIGN KEY (todoId) REFERENCES todos (id) ON DELETE CASCADE
        -- Quando una card viene eliminata, tutte le sue note vengono eliminate automaticamente
      )
    ''');
  }

  // ========== CRUD OPERATIONS PER TODO ==========

  /// Crea una nuova card (Todo) nel database
  /// [name] titolo della card
  /// Returns: ID della card appena creata
  Future<int> createTodo(String name) async {
    final db = await database;
    return await db.insert('todos', {'name': name});
  }

  /// Legge tutte le card con le relative note dal database
  /// Returns: Lista di oggetti Todo completi di note
  Future<List<Todo>> readAllTodos() async {
    final db = await database;
    
    // Ottiene tutte le card dalla tabella todos
    final todosMap = await db.query('todos');
    
    List<Todo> todos = [];
    
    // Per ogni card, carica anche le sue note
    for (var todoMap in todosMap) {
      final todoId = todoMap['id'] as int;
      
      // Query per ottenere tutte le note di questa card
      final notesMap = await db.query(
        'notes',
        where: 'todoId = ?',  // Filtra per todoId
        whereArgs: [todoId],   // Valore sicuro per evitare SQL injection
      );
      
      // Converte i dati delle note da Map a oggetti TodoNote
      final notes = notesMap.map((noteMap) {
        return TodoNote(
          text: noteMap['text'] as String,
          checked: (noteMap['checked'] as int) == 1, // Converte da int a bool
        )..id = noteMap['id'] as int; // Assegna l'ID alla nota
      }).toList();
      
      // Crea l'oggetto Todo con tutte le sue note
      todos.add(Todo(
        name: todoMap['name'] as String,
        notes: notes,
      )..id = todoId); // Assegna l'ID alla card
    }
    
    return todos;
  }

  /// Elimina una card dal database
  /// [id] ID della card da eliminare
  /// Returns: numero di righe eliminate (dovrebbe essere 1)
  /// Nota: ON DELETE CASCADE elimina automaticamente tutte le note associate
  Future<int> deleteTodo(int id) async {
    final db = await database;
    return await db.delete('todos', where: 'id = ?', whereArgs: [id]);
  }

  // ========== CRUD OPERATIONS PER NOTE ==========

  /// Crea una nuova nota all'interno di una card
  /// [todoId] ID della card padre
  /// [text] testo della nota
  /// [checked] stato della checkbox
  /// Returns: ID della nota appena creata
  Future<int> createNote(int todoId, String text, bool checked) async {
    final db = await database;
    return await db.insert('notes', {
      'todoId': todoId,
      'text': text,
      'checked': checked ? 1 : 0, // Converte bool a int (SQLite non ha tipo bool)
    });
  }

  /// Aggiorna il testo e lo stato di una nota esistente
  /// [noteId] ID della nota da aggiornare
  /// [text] nuovo testo
  /// [checked] nuovo stato checkbox
  /// Returns: numero di righe aggiornate (dovrebbe essere 1)
  Future<int> updateNote(int noteId, String text, bool checked) async {
    final db = await database;
    return await db.update(
      'notes',
      {'text': text, 'checked': checked ? 1 : 0},
      where: 'id = ?',
      whereArgs: [noteId],
    );
  }

  /// Elimina una singola nota dal database
  /// [noteId] ID della nota da eliminare
  /// Returns: numero di righe eliminate (dovrebbe essere 1)
  Future<int> deleteNote(int noteId) async {
    final db = await database;
    return await db.delete('notes', where: 'id = ?', whereArgs: [noteId]);
  }

  /// Chiude la connessione al database
  /// Da chiamare quando l'app viene chiusa (opzionale, gestito automaticamente)
  Future close() async {
    final db = await database;
    db.close();
  }
}
