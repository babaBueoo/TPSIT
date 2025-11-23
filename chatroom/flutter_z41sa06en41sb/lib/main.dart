import 'package:flutter/material.dart';
import 'dart:io';

void main() {
  runApp(MyApp());
}

// ----------------------------------------------------
// APP
// ----------------------------------------------------
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: LoginPage());
  }
}

// ----------------------------------------------------
// LOGIN PAGE
// ----------------------------------------------------
// 
class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  // variabile username per memorizzare l'username
  String username = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat Login")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Inserisci il tuo username"),
            SizedBox(height: 16),

            SizedBox(
              width: 250,
              child: TextField(
                // onChanged aggiorna direttamente la variabile username
                onChanged: (value) => username= value.trim(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Username",
                ),
              ),
            ),

            SizedBox(height: 16),

            ElevatedButton(
              onPressed: () {
                if (username.isEmpty) return;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(username: username),
                  ),
                );
              },
              child: Text("Entra nella Chat"),
            ),
          ],
        ),
      ),
    );
  }
}

// ----------------------------------------------------
// CHAT PAGE CON TCP
// ----------------------------------------------------
class ChatPage extends StatefulWidget {
  final String username;

  ChatPage({required this.username});

  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  TextEditingController msgController = TextEditingController();
  List<String> messaggi = []; // lista che contiene i mess

  Socket? socket;

  @override
  void initState() {
    super.initState();
    connectToServer();
  }

  // ----------------------------------------------------
  // CONNESSIONE TCP
  // ----------------------------------------------------
  void connectToServer() async {
    try {
      socket = await Socket.connect("localhost", 4200);

      print("CONNESSO AL SERVER");

      //ascolto dei messaggi dal server
      socket!.listen((data) {
        String msg = String.fromCharCodes(data).trim();

        setState(() {
          messaggi.add(msg);
        });
      });

      //invio username al server
      socket!.write("${widget.username}\n");

    } catch (e) {
      print("ERRORE CONNESSIONE: $e");
    }
  }

  // ----------------------------------------------------
  // INVIO MESSAGGI
  // ----------------------------------------------------
  void inviaMessaggio() {
    String testo = msgController.text.trim();
    if (testo.isEmpty || socket == null) return;

    //invio al server tetso
    socket!.write("$testo\n");

    // ,ostra subito il messaggio localmente
    setState(() {
      messaggi.add("${widget.username}: $testo");
    });

    msgController.clear();
  }

  @override
  void dispose() {
    socket?.close();
    super.dispose();
  }

  // ----------------------------------------------------
  // UI DELLA CHAT
  // ----------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat - ${widget.username}")),

      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: messaggi.length,
              itemBuilder: (context, index) {
                return Chat(
                  text: messaggi[index],
                  isMe: messaggi[index].startsWith("${widget.username}:"),
                );
              },
            ),
          ),

          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: msgController,
                  decoration: InputDecoration(
                    hintText: "Scrivi un messaggio...",
                    contentPadding: EdgeInsets.all(12),
                  ),
                  onSubmitted: (_) => inviaMessaggio(),
                ),
              ),
              IconButton(
                  icon: Icon(Icons.send),
                  onPressed: inviaMessaggio
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ----------------------------------------------------
// BOLLA MESSAGGIO
// ----------------------------------------------------
class Chat extends StatelessWidget {
  final String text;
  final bool isMe;

  Chat({required this.text, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.symmetric(vertical: 3),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue[200] : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(text),
      ),
    );
  }
}
