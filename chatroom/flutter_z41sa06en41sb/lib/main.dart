import 'package:flutter/material.dart';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: const MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _connectionStatus = "Disconnected";

  @override
  void initState() {
    super.initState();
    // 
    _connectToServer();
  }

  
  void _connectToServer() {
    // Logica di connessione non completa
    String indexRequest = 'GET / HTTP/1.1\nConnection: close\n\n';
    // Socket.connect("localhost", 3000).then((socket) {
    //   
    // }).catchError((e) {
    // 
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Flutter Socket Connection")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Socket Connection Status:',
              style: Theme.of(context),
            ),
            Text(
              _connectionStatus,
              style: Theme.of(context).textTheme(
                    color: _connectionStatus == "Connected"
                        ? Colors.green
                        : (_connectionStatus == "Connection Failed"
                            ? Colors.red
                            : Colors.grey),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
