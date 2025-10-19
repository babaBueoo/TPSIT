import 'package:flutter/material.dart';
import 'dart:math';

/*
codici stato:
0 = grigio
1 = rosso
2 = verde
3 = giallo
4 = blu
*/

void main() {
  runApp(MyApp()); 
}

class MyApp extends StatelessWidget {
  MyApp({
    super.key,
  }); 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState(); 
}

class _MyHomePageState extends State<MyHomePage> {
  String message = 'Indovina la sequenza segreta';
  int vittorieMatch = 0;
  int sconfitteMatch = 0;

    List<Color> colori = [
    Colors.grey,
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.yellow,
  ];
  List<int> statiBottoni = [0, 0, 0, 0];
  List<int> sequenzaSegreta = [1, 2, 3, 4];
  Color messageColor = Colors.blueGrey.shade600;

  @override
  void initState() {
    super.initState();
    generaSequenzaCasuale();
  }

  void frasiMotivazionali(bool vittoria) {
   const  List<String> frasiVittoria = [
      " Bravo! Continua così!",
      " Fantastico!!",
      " Incredibile! Hai indovinato alla perfezione!",
      " Ottimo lavoro, la tua logica è infallibile!",
      " Sei un vero Mastermind!",
      " Bravo campione, colpo da maestro!",
      " Perfetto! Hai un talento naturale!",
      " Preciso e rapido, ottimo colpo!",
      " La tua mente è un computer di colori!",
      " Grande! Ogni vittoria ti rende più forte!",
    ];
    const List<String> frasiSconfitta = [
      "Non è questa volta... ma ci sei quasi!",
      "Ogni errore è un passo verso la vittoria!",
      "Non mollare, la prossima volta sarà tua!",
      "Pensa strategicamente, ce la farai!",
      "Non ti arrendere, sei sulla strada giusta!",
      "I grandi risultati arrivano con la pratica!",
      "Nessun problema, anche i maestri sbagliano!",
      "Riprova, hai già capito metà del gioco!",
      "Dai che la prossima è quella giusta!",
      "La sequenza giusta ti aspetta, non fermarti!",
    ];
    setState(() {
      if (vittoria) {
        message = frasiVittoria[Random().nextInt(frasiVittoria.length)];
        messageColor = Colors.green;
      } else {
        message = frasiSconfitta[Random().nextInt(frasiSconfitta.length)];
        messageColor = Colors.red;
      }
    });
  }

  void generaSequenzaCasuale() {
    for (int i = 0; i < sequenzaSegreta.length; i++) {
      int nCasuale = Random().nextInt(4) + 1;
      sequenzaSegreta[i] = nCasuale;
    }
  }

  void _checkSequence() {
    setState(() {
      bool indovinata = true;
      for (int i = 0; i < sequenzaSegreta.length; i++) {
        if (sequenzaSegreta[i] != statiBottoni[i]) {
          indovinata = false;
          break;
        }
      }

      if (indovinata) {
        frasiMotivazionali(true);
        for (int i = 0; i < statiBottoni.length; i++) {
          resettaBottoni(i);
        }
        vittorieMatch++;

        generaSequenzaCasuale();
      } else {
        frasiMotivazionali(false);
        for (int i = 0; i < statiBottoni.length; i++) {
          resettaBottoni(i);
        }
        sconfitteMatch++;
      }
    });
  }

  void _cambiaColore(int indice) {
    setState(() {
      statiBottoni[indice] = (statiBottoni[indice] + 1) % colori.length;
    });
  }

  void resettaBottoni(int indice) {
    setState(() {
      statiBottoni[indice] = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.brown.shade50,
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: messageColor,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Vittorie: $vittorieMatch',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 20),
                    Text(
                      'Sconfitte: $sconfitteMatch',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colori[statiBottoni[0]],
                        fixedSize: const Size(30, 80),
                        elevation: 5,
                      ),
                      onPressed: () => _cambiaColore(0),
                      child: Text(''),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colori[statiBottoni[1]],
                        fixedSize: Size(30, 80),
                        elevation: 5,
                      ),
                      onPressed: () => _cambiaColore(1),
                      child: Text(''),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colori[statiBottoni[2]],
                        fixedSize: Size(30, 80),
                        elevation: 5,
                      ),
                      onPressed: () => _cambiaColore(2),
                      child: Text(''),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colori[statiBottoni[3]],
                        fixedSize: Size(30, 80),
                        elevation: 5,
                      ),
                      onPressed: () => _cambiaColore(3),
                      child: Text(''),
                    ),
                  ],
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown.shade50,
                    foregroundColor: Colors.blueGrey.shade600,
                    fixedSize: Size(200, 50),
                    elevation: 5,
                    side: BorderSide(
                      color: Colors.brown.shade100,
                      width: 2,
                    ),
                  ),
                  onPressed: _checkSequence,
                  child: Text(
                    "Controlla Sequenza",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
