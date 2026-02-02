import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'colors.dart';
import 'model.dart';
import 'notifier.dart';
import 'widgets.dart';

void main() {
  runApp(const MyApp());
}

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
      home: ChangeNotifierProvider<TodoListNotifier>(
        create: (_) => TodoListNotifier(),
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
  Future<void> _displayDialog(TodoListNotifier notifier) async {
    final nameController = TextEditingController();
    final noteControllers = [TextEditingController()];

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: cardColor,
              title: Text('Aggiungi nota', style: TextStyle(color: white)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
              actions: <Widget>[
                TextButton(
                  child: Text('Annulla', style: TextStyle(color: white.withOpacity(0.7))),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model.dart';
import 'notifier.dart';
import 'widgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'am043 todo list',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.red)),
      home: ChangeNotifierProvider<TodoListNotifier>(
        create: (notifier) => TodoListNotifier(),
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

}
                ),
                TextButton(
                  child: const Text('Aggiungi', style: TextStyle(color: Colors.red)),
                  onPressed: () {
                    if (nameController.text.trim().isEmpty) {
                      return;
                    }
                    
                    final noteTexts = noteControllers
                        .map((c) => c.text.trim())
                        .where((text) => text.isNotEmpty)
                        .toList();
                    
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
    final TodoListNotifier notifier = context.watch<TodoListNotifier>();

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              width: MediaQuery.of(context).size.width,
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: null,
                        disabledColor: white,
                        icon: const Icon(Icons.menu),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        height: 55,
                        width: 200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "cerca la tua nota",
                              style: TextStyle(
                                color: white.withOpacity(0.5),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: const Icon(Icons.grid_view, color: white),
                        ),
                        const SizedBox(width: 9),
                        const CircleAvatar(
                          backgroundColor: white,
                          radius: 18,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: MasonryGridView(
                todos: notifier,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displayDialog(notifier),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class MasonryGridView extends StatelessWidget {
  final TodoListNotifier todos;

  const MasonryGridView({super.key, required this.todos});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columnWidth = constraints.maxWidth / 2;
        
        List<Widget> column1 = [];
        List<Widget> column2 = [];
        
        for (int i = 0; i < todos.length; i++) {
          final todoItem = TodoItem(todo: todos.getTodo(i));
          
          if (i % 2 == 0) {
            column1.add(todoItem);
          } else {
            column2.add(todoItem);
          }
        }
        
        return SingleChildScrollView(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
