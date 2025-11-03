import 'package:flutter/material.dart';

import 'dart:io';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  void main() {
  Socket.connect("127.0.0.1", 3000).then((socket) {
    print('Connected to: '
        '${socket.remoteAddress.address}:${socket.remotePort}');
    socket.destroy();
  }).catchError((e) {
    // server down
    if (e is SocketException) print('SocketException => $e');
  });

  @override
  _MyHomePageState createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage>{


  @override
  Widget build(BuildContext context) {
    return Scaffold(
    );
  }
}
