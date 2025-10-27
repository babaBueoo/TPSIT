import 'package:flutter/material.dart';

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

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String message1 = "Start";
  String message2 = "Pause";
  List<Color> colori1 = [Colors.green, Colors.red, Colors.yellow];
  List<Color> colori2 = [Colors.green, Colors.red, Colors.yellow];
  int statoBottone1 = 0;
  int statoBottone2 = 0;

  void cambiaTesto1() {
    const List<String> bottone1 = ["Start", "Stop", "Restart"];
    setState(() {
      message1 = bottone1[(bottone1.indexOf(message1) + 1) % bottone1.length];
    });
  }

  void cambiaTesto2() {
    const List<String> bottone2 = ["Pause", "Resume"];
    setState(() {
      message2 = bottone2[(bottone2.indexOf(message2) + 1) % bottone2.length];
    });
  }

void cambiaColore2() {
    setState(() {
      statoBottone2 = (statoBottone2 + 1) % colori2.length;
    });
  }
  void cambiaColore1() {
    setState(() {
      statoBottone1 = (statoBottone1 + 1) % colori2.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FloatingActionButton(
                backgroundColor: Colors.brown.shade50,
                foregroundColor: Colors.blueGrey.shade600,
                onPressed: cambiaTesto2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(iconaMessaggio2(), color: Colors.blueGrey.shade600),
                    Text(
                      message2,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.blueGrey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 30),
              FloatingActionButton(
                backgroundColor: Colors.brown.shade50,
                foregroundColor: Colors.blueGrey.shade600,
                onPressed: cambiaTesto1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(iconaMessaggio1(), color: Colors.blueGrey.shade600),
                    Text(
                      message1,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.blueGrey.shade600,
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

  IconData iconaMessaggio1() {
    if (message1 == "Start") {
      return Icons.play_arrow;
    } else if (message1 == "Stop") {
      return Icons.stop;
    } else if (message1 == "Restart") {
      return Icons.refresh;
    }
    return Icons.play_arrow;
  }

  IconData iconaMessaggio2() {
    if (message2 == "Pause") {
      return Icons.pause;
    } else if (message2 == "Resume") {
      return Icons.play_arrow;
    }
    return Icons.pause;
  }
}
