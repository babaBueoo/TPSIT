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

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _textFieldController = TextEditingController();

  Future<void> _displayDialog(TodoListNotifier notifier) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('add todo item'),
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: 'type here ...'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                Navigator.of(context).pop();
                notifier.addTodo(_textFieldController.text);
                _textFieldController.clear();
              },
            ),
          ],
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
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                      icon: Icon(Icons.menu, color: white),
                      


                    ),
                    SizedBox(width: 16),
                    
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
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Icon(Icons.grid_view, color: white),
                      ),
                      SizedBox(width: 9),
                      CircleAvatar(
                        backgroundColor: white,
                        radius: 18,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ====== LISTA TODO ======
          Expanded(
            child: ListView.builder(
              itemCount: notifier.length,
              itemBuilder: (context, index) {
                return TodoItem(todo: notifier.getTodo(index));
              },
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
