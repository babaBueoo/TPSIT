import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'colors.dart';
import 'model.dart';
import 'notifier.dart';

class TodoItem extends StatefulWidget {
  TodoItem({required this.todo}) : super(key: ObjectKey(todo));

  final Todo todo;

  @override
  State<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  Map<TodoNote, TextEditingController> controllers = {};
  Map<TodoNote, FocusNode> focusNodes = {};
  TodoNote? editingNote;

  @override
  void dispose() {
    for (var controller in controllers.values) {
      controller.dispose();
    }
    for (var focusNode in focusNodes.values) {
      focusNode.dispose();
    }
    super.dispose();
  }

  TextEditingController _getController(TodoNote note) {
    if (!controllers.containsKey(note)) {
      controllers[note] = TextEditingController(text: note.text);
    }
    return controllers[note]!;
  }

  FocusNode _getFocusNode(TodoNote note) {
    if (!focusNodes.containsKey(note)) {
      focusNodes[note] = FocusNode();
    }
    return focusNodes[note]!;
  }

  void _startEditing(TodoNote note) {
    setState(() {
      editingNote = note;
      _getController(note).text = note.text;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getFocusNode(note).requestFocus();
    });
  }

  void _finishEditingAndSave(TodoListNotifier notifier, TodoNote note) {
    final controller = _getController(note);
    // Salva sempre il testo, anche se vuoto
    notifier.updateNoteText(note, controller.text);
    setState(() {
      if (editingNote == note) {
        editingNote = null;
      }
    });
  }

  void _addNewNote(TodoListNotifier notifier) {
    // Se c'è una nota in editing, salva il testo corrente
    if (editingNote != null) {
      final controller = _getController(editingNote!);
      notifier.updateNoteText(editingNote!, controller.text);
    }
    
    // Crea una nuova nota vuota
    final newNote = notifier.addNoteToTodo(widget.todo, '');
    // Inizia subito a modificarla
    setState(() {
      _startEditing(newNote);
    });
  }

  @override
  Widget build(BuildContext context) {
    final TodoListNotifier notifier = context.watch<TodoListNotifier>();

    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.todo.name,
                  style: TextStyle(
                    color: white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete_outline, color: white.withOpacity(0.5)),
                iconSize: 20,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  notifier.deleteTodo(widget.todo);
                },
              ),
            ],
          ),
          if (widget.todo.notes.isNotEmpty) const SizedBox(height: 8),
          ...widget.todo.notes.map((note) {
            final isEditing = editingNote == note;
            final controller = _getController(note);
            final focusNode = _getFocusNode(note);
            
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: note.checked,
                    onChanged: (bool? value) {
                      notifier.changeNote(note);
                    },
                    fillColor: MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.selected)) {
                        return Colors.red;
                      }
                      return white.withOpacity(0.3);
                    }),
                  ),
                  Expanded(
                    child: isEditing
                        ? TextField(
                            controller: controller,
                            focusNode: focusNode,
                            style: TextStyle(color: white, fontSize: 14),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.only(top: 12),
                              hintText: 'Scrivi qui...',
                              hintStyle: TextStyle(color: white.withOpacity(0.5)),
                            ),
                            onSubmitted: (_) => _finishEditingAndSave(notifier, note),
                            onTapOutside: (_) => _finishEditingAndSave(notifier, note),
                          )
                        : GestureDetector(
                            onTap: () => _startEditing(note),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Text(
                                note.text.isEmpty ? 'Vuoto' : note.text,
                                style: TextStyle(
                                  color: note.text.isEmpty ? white.withOpacity(0.5) : white,
                                  fontSize: 14,
                                  fontStyle: note.text.isEmpty ? FontStyle.italic : FontStyle.normal,
                                  decoration: note.checked ? TextDecoration.lineThrough : null,
                                  decorationColor: white.withOpacity(0.6),
                                  decorationThickness: 2,
                                ),
                              ),
                            ),
                          ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete_outline, color: white.withOpacity(0.5)),
                    iconSize: 18,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      notifier.deleteNoteFromTodo(widget.todo, note);
                      controllers.remove(note);
                      focusNodes.remove(note);
                    },
                  ),
                ],
              ),
            );
          }).toList(),
          const SizedBox(height: 8),
          InkWell(
            onTap: () => _addNewNote(notifier),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Icon(Icons.add, color: white.withOpacity(0.7), size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'nuova nota',
                    style: TextStyle(
                      color: white.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
