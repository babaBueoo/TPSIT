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

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: Duration(milliseconds: 1000), vsync: this)
          ..addListener(() {
            setState(() {});
          });
  }

  @override
  void dispose() {
    animationController.dispose();
    subscription?.cancel();
    super.dispose();
  }

  double counter = 0;
  double offsetCounter = 0;

  String message1 = "Start";
  String message2 = "Pause";

  List<Color> colori1 = [Colors.green, Colors.red, Colors.yellow];
  List<Color> colori2 = [Colors.red, Colors.green];
  int statoBottone1 = 0;
  int statoBottone2 = 0;

  bool schiacciato = false;

  Stream<double>? secondStream;
  StreamSubscription<double>? subscription;

  Stream<double> tickerStream(Duration intervallo) async* {
    double tick = 0;
    while (true) {
      await Future.delayed(intervallo);
      yield tick++;
    }
  }

  Stream<double> secondiStream() async* {
    await for (final tick in tickerStream(const Duration(milliseconds: 100))) {
      yield tick / 10.0;
    }
  }

  void startCounter() {
    subscription?.cancel();
    secondStream = secondiStream();
    subscription = secondStream!.listen((sec) {
      setState(() {
        counter = sec + offsetCounter;
      });
      if ((sec + offsetCounter) % 1 < 0.1) {
        animationController.forward(from: 0);
      }
    });
  }

  void pausaCounter() {
    offsetCounter = counter;
    subscription?.cancel();
    animationController.stop();
  }

  void resumeCounter() {
    startCounter();
    double decimale = counter % 1;
    animationController.forward(from: decimale);
  }

  void stopCounter() {
    subscription?.cancel();
    animationController.stop();
    animationController.value = 0;
    setState(() {
      counter = 0;
      offsetCounter = 0;
      message1 = "Start";
      message2 = "Pause";
      schiacciato = false;
      statoBottone1 = 0;
      statoBottone2 = 0;
    });
  }

  void cambiaTesto1() {
    setState(() {
      if (message1 == "Start") {
        message1 = "Stop";
        schiacciato = true;
        startCounter();
      } else if (message1 == "Stop") {
        message1 = "Reset";
        schiacciato = false;
        pausaCounter();
      } else {
        message1 = "Start";
        schiacciato = false;
        stopCounter();
      }
    });
  }

  void cambiaTesto2() {
    setState(() {
      if (message2 == "Pause") {
        message2 = "Resume";
        pausaCounter();
      } else {
        message2 = "Pause";
        resumeCounter();
      }
    });
  }

  void cambiaColore1() {
    setState(() {
      statoBottone1 = (statoBottone1 + 1) % colori1.length;
    });
  }

  void cambiaColore2() {
    setState(() {
      statoBottone2 = (statoBottone2 + 1) % colori2.length;
    });
  }

  int minuti(double secondi) => secondi ~/ 60;
  int secondi(double secondi) => secondi.toInt() % 60;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: SizedBox(
              width: 200,
              height: 200,
              child: CircularProgressIndicator(
                color: Colors.blue,
                strokeWidth: 8,
                value: animationController.value,
              ),
            ),
          ),
          Center(
            child: Text(
              "${minuti(counter).toString().padLeft(2, '0')}:${secondi(counter).toString().padLeft(2, '0')}",
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
                          message1 == "Start"
                              ? Icons.play_arrow
                              : message1 == "Stop"
                              ? Icons.stop
                              : Icons.refresh,
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
                  const SizedBox(width: 30),
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
                          message2 == "Pause" ? Icons.pause : Icons.play_arrow,
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
