import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'colors.dart';
import 'model.dart';
import 'notifier.dart';
import 'widgets.dart';

void main() {
  runApp(const MyApp());
}

/// Widget root dell'applicazione
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'am043 todo list',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
      ),
      // ChangeNotifierProvider: fornisce il TodoListNotifier a tutti i widget figli
      // In questo modo tutti i widget possono accedere e ascoltare i cambiamenti dello stato
      home: ChangeNotifierProvider<TodoListNotifier>(
        create: (_) => TodoListNotifier(), // Crea il notifier (che carica i dati dal DB)
        child: const MyHomePage(title: 'am043 todo list'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  /// Mostra il dialog per aggiungere una nuova card con note
  /// [notifier] il TodoListNotifier per salvare la nuova card
  Future<void> _displayDialog(TodoListNotifier notifier) async {
    final nameController = TextEditingController();
    final noteControllers = [TextEditingController()]; // Parte con 1 nota vuota

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Non chiude cliccando fuori
      builder: (BuildContext context) {
        // StatefulBuilder permette di aggiornare il dialog quando aggiungi/rimuovi campi nota
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: cardColor,
              title: Text('Aggiungi nota', style: TextStyle(color: white)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ========== CAMPO TITOLO ==========
                    TextField(
                      controller: nameController,
                      style: TextStyle(color: white),
                      decoration: InputDecoration(
                        labelText: 'Titolo',
                        labelStyle: TextStyle(color: white.withOpacity(0.7)),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: white.withOpacity(0.3)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // ========== CAMPI NOTE (dinamici) ==========
                    // Genera un TextField per ogni controller nella lista
                    ...List.generate(noteControllers.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: noteControllers[index],
                                style: TextStyle(color: white),
                                decoration: InputDecoration(
                                  labelText: 'Nota ${index + 1}',
                                  labelStyle: TextStyle(color: white.withOpacity(0.7)),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: white.withOpacity(0.3)),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                ),
                              ),
                            ),
                            // Mostra il bottone rimuovi solo se ci sono almeno 2 note
                            if (noteControllers.length > 1)
                              IconButton(
                                icon: Icon(Icons.remove_circle_outline, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    noteControllers.removeAt(index);
                                  });
                                },
                              ),
                          ],
                        ),
                      );
                    }),
                    
                    // ========== BOTTONE AGGIUNGI NOTA ==========
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          noteControllers.add(TextEditingController());
                        });
                      },
                      icon: Icon(Icons.add, color: Colors.red),
                      label: Text('Aggiungi nota', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              ),
              
              // ========== AZIONI DEL DIALOG ==========
              actions: <Widget>[
                TextButton(
                  child: Text('Annulla', style: TextStyle(color: white.withOpacity(0.7))),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Aggiungi', style: TextStyle(color: Colors.red)),
                  onPressed: () {
                    // Validazione: il titolo deve essere presente
                    if (nameController.text.trim().isEmpty) {
                      return;
                    }
                    
                    // Raccoglie solo le note non vuote
                    final noteTexts = noteControllers
                        .map((c) => c.text.trim())
                        .where((text) => text.isNotEmpty)
                        .toList();
                    
                    // Salva la nuova card con le note nel database
                    notifier.addTodo(nameController.text, noteTexts);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Ascolta i cambiamenti del TodoListNotifier
    final TodoListNotifier notifier = context.watch<TodoListNotifier>();

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // ========== HEADER: Barra di ricerca (non funzionale) ==========
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              height: 55,
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: black.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 3,
                  )
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: null, // Menu disabilitato
                    disabledColor: white,
                    icon: const Icon(Icons.menu),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "cerca la tua nota",
                      style: TextStyle(
                        color: white.withOpacity(0.5),
                        fontSize: 16,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {}, // Grid view (già attivo)
                    icon: const Icon(Icons.grid_view, color: white),
                  ),
                  const SizedBox(width: 4),
                  const CircleAvatar(
                    backgroundColor: white,
                    radius: 16,
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ),
            
            // ========== BODY: Griglia masonry con le card ==========
            Expanded(
              child: MasonryGridView(
                todos: notifier,
              ),
            ),
          ],
        ),
      ),
      
      // ========== FAB: Bottone per aggiungere nuova card ==========
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displayDialog(notifier),
        backgroundColor: Colors.red,
        child: const Icon(Icons.add, color: white),
      ),
    );
  }
}

/// Widget che implementa il layout Masonry Grid 
/// Distribuisce le card su 2 colonne con altezze variabili
class MasonryGridView extends StatelessWidget {
  final TodoListNotifier todos;

  const MasonryGridView({super.key, required this.todos});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Ogni colonna occupa metà della larghezza disponibile
        final columnWidth = constraints.maxWidth / 2;
        
        List<Widget> column1 = []; // Colonna sinistra
        List<Widget> column2 = []; // Colonna destra
        
        // Distribuisce le card alternando tra le due colonne
        // Card pari (0,2,4...) → colonna 1
        // Card dispari (1,3,5...) → colonna 2
        for (int i = 0; i < todos.length; i++) {
          final todoItem = TodoItem(todo: todos.getTodo(i));
          
          if (i % 2 == 0) {
            column1.add(todoItem);
          } else {
            column2.add(todoItem);
          }
        }
        
        // Layout finale: due colonne scrollabili affiancate
        return SingleChildScrollView(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start, // Allinea in alto
            children: [
              SizedBox(
                width: columnWidth,
                child: Column(
                  children: column1,
                ),
              ),
              SizedBox(
                width: columnWidth,
                child: Column(
                  children: column2,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
