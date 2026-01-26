import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'colors.dart';


import 'model.dart';
import 'notifier.dart';


class TodoItem extends StatelessWidget {
  TodoItem({required this.todo}) : super(key: ObjectKey(todo));


  final Todo todo;


  TextStyle? _getTextStyle(bool checked) {
    if (!checked) return null;


    return const TextStyle(
      color: Colors.black45,
      decoration: TextDecoration.lineThrough,
    );
  }


  @override
  Widget build(BuildContext context) {
    final TodoListNotifier notifier = context.watch<TodoListNotifier>();


return Scaffold(
  backgroundColor: bgColor,
  body: SafeArea(
    child: Container(
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
                      onPressed: () {},
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
        ],
      ),
    ),
  ),
);




  }
}


