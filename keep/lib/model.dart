class Todo {
  Todo({required this.name, required this.notes});
  String name;
  List<TodoNote> notes;

  @override
  String toString() {
    return name;
  }
}

class TodoNote {
  TodoNote({required this.text, required this.checked});
  String text;
  bool checked;
}
