import 'package:flutter/widgets.dart';
import 'model.dart';
import 'database_helper.dart';

/// Notifier che gestisce lo stato della lista di Todo e la sincronizzazione con il database
/// Estende ChangeNotifier per notificare i widget quando i dati cambiano
class TodoListNotifier with ChangeNotifier {
  // Lista in-memory delle card Todo (cache locale)
  final _todos = <Todo>[];
  
  // Istanza del database helper per operazioni di persistenza
  final _dbHelper = DatabaseHelper.instance;

  /// Numero totale di card presenti
  int get length => _todos.length;

  /// Costruttore: carica automaticamente i dati dal database all'avvio
  TodoListNotifier() {
    _loadTodos();
  }

  /// Carica tutte le card e le note dal database SQLite
  /// Chiamato automaticamente all'avvio dell'app
  Future<void> _loadTodos() async {
    final todos = await _dbHelper.readAllTodos();
    _todos.clear();
    _todos.addAll(todos);
    notifyListeners(); // Notifica i widget che i dati sono cambiati
  }

  /// Aggiunge una nuova card con le sue note iniziali
  /// [name] titolo della card
  /// [noteTexts] lista di testi per le note da creare
  Future<void> addTodo(String name, List<String> noteTexts) async {
    // 1. Crea la card nel database e ottiene l'ID generato
    final todoId = await _dbHelper.createTodo(name);
    final notes = <TodoNote>[];
    
    // 2. Crea ogni nota nel database e la aggiunge alla lista
    for (var text in noteTexts) {
      final noteId = await _dbHelper.createNote(todoId, text, false);
      final note = TodoNote(text: text, checked: false)..id = noteId;
      notes.add(note);
    }
    
    // 3. Crea l'oggetto Todo completo e lo aggiunge alla cache locale
    final todo = Todo(name: name, notes: notes)..id = todoId;
    _todos.add(todo);
    
    // 4. Notifica i widget del cambiamento (trigger rebuild)
    notifyListeners();
  }

  /// Aggiunge una nuova nota a una card esistente
  /// [todo] card a cui aggiungere la nota
  /// [noteText] testo della nuova nota
  /// Returns: la nota appena creata (con ID assegnato)
  Future<TodoNote> addNoteToTodo(Todo todo, String noteText) async {
    // 1. Salva la nota nel database
    final noteId = await _dbHelper.createNote(todo.id!, noteText, false);
    
    // 2. Crea l'oggetto nota con l'ID dal database
    final newNote = TodoNote(text: noteText, checked: false)..id = noteId;
    
    // 3. Aggiunge la nota alla lista in-memory della card
    todo.notes.add(newNote);
    
    notifyListeners();
    return newNote;
  }

  /// Aggiorna il testo di una nota esistente
  /// [note] nota da modificare
  /// [newText] nuovo testo (può essere vuoto)
  Future<void> updateNoteText(TodoNote note, String newText) async {
    // 1. Aggiorna l'oggetto in memoria
    note.text = newText;
    
    // 2. Sincronizza con il database (solo se la nota ha un ID)
    if (note.id != null) {
      await _dbHelper.updateNote(note.id!, newText, note.checked);
    }
    
    notifyListeners();
  }

  /// Elimina una nota da una card
  /// [todo] card contenente la nota
  /// [note] nota da eliminare
  Future<void> deleteNoteFromTodo(Todo todo, TodoNote note) async {
    // 1. Elimina dal database
    if (note.id != null) {
      await _dbHelper.deleteNote(note.id!);
    }
    
    // 2. Rimuove dalla lista in-memory
    todo.notes.remove(note);
    
    notifyListeners();
  }

  /// Cambia lo stato della checkbox di una nota (checked/unchecked)
  /// [note] nota di cui cambiare lo stato
  Future<void> changeNote(TodoNote note) async {
    // 1. Inverte lo stato checked
    note.checked = !note.checked;
    
    // 2. Salva il nuovo stato nel database
    if (note.id != null) {
      await _dbHelper.updateNote(note.id!, note.text, note.checked);
    }
    
    notifyListeners();
  }

  /// Elimina completamente una card e tutte le sue note
  /// [todo] card da eliminare
  /// Nota: le note vengono eliminate automaticamente grazie a ON DELETE CASCADE
  Future<void> deleteTodo(Todo todo) async {
    // 1. Elimina dal database (elimina anche le note associate)
    if (todo.id != null) {
      await _dbHelper.deleteTodo(todo.id!);
    }
    
    // 2. Rimuove dalla lista in-memory
    _todos.remove(todo);
    
    notifyListeners();
  }

  /// Ottiene una card dalla lista tramite indice
  /// [i] indice della card (0-based)
  Todo getTodo(int i) => _todos[i];
}
