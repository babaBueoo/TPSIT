import 'package:flutter/material.dart';
import 'dart:async';

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
  List<Color> colori2 = [Colors.red, Colors.green];
  int statoBottone1 = 0;
  int statoBottone2 = 0;

  bool schiacciato = false;

  void cambiaTesto1() {
    const List<String> bottone1 = ["Start", "Stop", "Restart"];
    setState(() {
      message1 = bottone1[(bottone1.indexOf(message1) + 1) % bottone1.length];

      if (message1 == "Stop" || message1 == "Restart") {
        schiacciato = true;
      } else if (message1 == "Start") {
        schiacciato = false;
      }
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
      statoBottone1 = (statoBottone1 + 1) % colori1.length;
    });
  }

  int counter = 0;
  Stream<int>? counterStream;
  StreamSubscription<int>? subscription;

  Stream<int> timedCounter(Duration interval) async* {
    int i = 0;
    while (true) {
      await Future.delayed(interval);
      yield i++;
    }
  }

  void startCounter() {
    subscription?.cancel();
    counterStream = timedCounter(const Duration(seconds: 1));
    subscription = counterStream!.listen((value) {
      setState(() {
        counter = value;
      });
    });
  }

  void pauseCounter() {
    subscription?.pause();
  }

  void resumeCounter() {
    subscription?.resume();
  }

  void stopCounter() {
    subscription?.cancel();
    setState(() {
      counter = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Text(
              '$counter',
              style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    backgroundColor: schiacciato
                        ? colori2[statoBottone2]
                        : Colors.brown.shade50,
                    foregroundColor: Colors.blueGrey.shade600,
                    onPressed: schiacciato
                        ? () {
                            cambiaTesto2();
                            cambiaColore2();
                          }
                        : null,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          iconaMessaggio2(),
                          color: Colors.blueGrey.shade600,
                        ),
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
                  const SizedBox(width: 30),
                  FloatingActionButton(
                    backgroundColor: colori1[statoBottone1],
                    foregroundColor: Colors.blueGrey.shade600,
                    onPressed: () {
                      cambiaColore1();
                      cambiaTesto1();
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          iconaMessaggio1(),
                          color: Colors.blueGrey.shade600,
                        ),
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
        ],
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
