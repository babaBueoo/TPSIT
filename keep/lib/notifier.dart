import 'package:flutter/widgets.dart';
import 'model.dart';

class TodoListNotifier with ChangeNotifier {
  final _todos = <Todo>[];

  int get length => _todos.length;

  void addTodo(String name, List<String> noteTexts) {
    final notes = noteTexts.map((text) => TodoNote(text: text, checked: false)).toList();
    _todos.add(Todo(name: name, notes: notes));
    notifyListeners();
  }

  TodoNote addNoteToTodo(Todo todo, String noteText) {
    final newNote = TodoNote(text: noteText, checked: false);
    todo.notes.add(newNote);
    notifyListeners();
    return newNote;
  }

  void updateNoteText(TodoNote note, String newText) {
    note.text = newText;
    notifyListeners();
  }

  void deleteNoteFromTodo(Todo todo, TodoNote note) {
    todo.notes.remove(note);
    notifyListeners();
  }

  void changeNote(TodoNote note) {
    note.checked = !note.checked;
    notifyListeners();
  }

  void deleteTodo(Todo todo) {
    _todos.remove(todo);
    notifyListeners();
  }

  Todo getTodo(int i) => _todos[i];
}
