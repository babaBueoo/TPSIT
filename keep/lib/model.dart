class Todo {
  Todo({required this.name, required this.notes});
  int? id;
  String name;
  List<TodoNote> notes;

  @override
  String toString() {
    return name;
  }
}

class TodoNote {
  TodoNote({required this.text, required this.checked});
  int? id;
  String text;
  bool checked;
}
