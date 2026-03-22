import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'colors.dart';
import 'model.dart';
import 'notifier.dart';

/// Widget che rappresenta una singola card Todo con le sue note
/// Gestisce la modifica inline delle note e l'aggiunta di nuove note
class TodoItem extends StatefulWidget {
  TodoItem({required this.todo}) : super(key: ObjectKey(todo));

  final Todo todo;

  @override
  State<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  // Map per gestire un controller separato per ogni nota
  // Chiave: oggetto TodoNote, Valore: TextEditingController per quella nota
  Map<TodoNote, TextEditingController> controllers = {};
  
  // Map per gestire il focus separato di ogni nota
  Map<TodoNote, FocusNode> focusNodes = {};
  
  // Tiene traccia di quale nota è attualmente in modifica
  TodoNote? editingNote;

  @override
  void dispose() {
    // IMPORTANTE: Pulisce tutti i controller e focus node per evitare memory leak
    for (var controller in controllers.values) { // comodità sintattica
      controller.dispose();
    }
    for (var focusNode in focusNodes.values) {
      focusNode.dispose();
    }
    super.dispose();
  }

  /// Ottiene o crea il controller per una specifica nota
  /// Pattern lazy initialization: crea solo quando necessario
  TextEditingController _getController(TodoNote note) {
    if (!controllers.containsKey(note)) { // controllo se esiste un controller per quella notaù
      controllers[note] = TextEditingController(text: note.text);
    }
    return controllers[note]!;
  }

  /// Ottiene o crea il focus node per una specifica nota
  FocusNode _getFocusNode(TodoNote note) {
    if (!focusNodes.containsKey(note)) {
      focusNodes[note] = FocusNode();
    }
    return focusNodes[note]!;
  }

  /// Attiva la modalità di modifica per una nota
  /// [note] la nota da modificare
  void _startEditing(TodoNote note) {
    setState(() {
      editingNote = note;
      _getController(note).text = note.text;
    });
    // Sposta il focus sul TextField DOPO che il widget è stato ricostruito
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getFocusNode(note).requestFocus();
    });
  }

  /// Termina la modifica e salva il testo nel database
  /// [notifier] per chiamare updateNoteText
  /// [note] la nota da salvare
  void _finishEditingAndSave(TodoListNotifier notifier, TodoNote note) {
    final controller = _getController(note);
    // Salva sempre il testo, anche se vuoto (l'utente può voler note vuote)
    notifier.updateNoteText(note, controller.text);
    setState(() {
      if (editingNote == note) {
        editingNote = null; // Esce dalla modalità editing
      }
    });
  }

  /// Aggiunge una nuova nota vuota alla card e la apre in modifica
  /// [notifier] per chiamare addNoteToTodo
  Future<void> _addNewNote(TodoListNotifier notifier) async {
    // Se c'è una nota in editing, salva prima il suo contenuto
    if (editingNote != null) {
      final controller = _getController(editingNote!);
      await notifier.updateNoteText(editingNote!, controller.text);
    }
    
    // Crea una nuova nota vuota nel database
    final newNote = await notifier.addNoteToTodo(widget.todo, '');
    
    // Apre immediatamente la nuova nota in modalità editing
    setState(() {
      _startEditing(newNote);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Ascolta i cambiamenti del notifier per aggiornare l'UI
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
          // ========== HEADER: Titolo e bottone elimina card ==========
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
          
          // Spaziatura tra titolo e note
          if (widget.todo.notes.isNotEmpty) const SizedBox(height: 8),
          
          // ========== LISTA NOTE: Checkbox + Testo/TextField + Elimina ==========
          ...widget.todo.notes.map((note) {
            final isEditing = editingNote == note;
            final controller = _getController(note);
            final focusNode = _getFocusNode(note);
            
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Checkbox per segnare la nota come completata
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
                  
                  // Area del testo: TextField in editing, Text altrimenti
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
                            // Salva quando si preme Invio
                            onSubmitted: (_) => _finishEditingAndSave(notifier, note),
                            // Salva quando si clicca fuori dal campo
                            onTapOutside: (_) => _finishEditingAndSave(notifier, note),
                          )
                        : GestureDetector(
                            // Tap sul testo per iniziare la modifica
                            onTap: () => _startEditing(note),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Text(
                                note.text.isEmpty ? 'Vuoto' : note.text,
                                style: TextStyle(
                                  color: note.text.isEmpty ? white.withOpacity(0.5) : white,
                                  fontSize: 14,
                                  fontStyle: note.text.isEmpty ? FontStyle.italic : FontStyle.normal,
                                  // Strikethrough se la nota è completata
                                  decoration: note.checked ? TextDecoration.lineThrough : null,
                                  decorationColor: white.withOpacity(0.6),
                                  decorationThickness: 2,
                                ),
                              ),
                            ),
                          ),
                  ),
                  
                  // Bottone per eliminare la singola nota
                  IconButton(
                    icon: Icon(Icons.delete_outline, color: white.withOpacity(0.5)),
                    iconSize: 18,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      notifier.deleteNoteFromTodo(widget.todo, note);
                      // Pulisce anche controller e focus node dalla memoria
                      controllers.remove(note);
                      focusNodes.remove(note);
                    },
                  ),
                ],
              ),
            );
          }).toList(),
          
          const SizedBox(height: 8),
          
          // ========== FOOTER: Bottone "+ nuova nota" ==========
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
