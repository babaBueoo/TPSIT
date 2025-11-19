import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: LoginPage());
  }
}

// ----------------------------------------------------
// LOGIN PAGE
// ----------------------------------------------------
class LoginPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();

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
                controller: usernameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Username",
                ),
              ),
            ),

            SizedBox(height: 16),

            ElevatedButton(
              onPressed: () {
                String user = usernameController.text.trim();
                if (user.isEmpty) return;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(username: user),
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
   String username;

  ChatPage({required this.username});

  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
   TextEditingController msgController = TextEditingController();
  List<String> messaggi = []; // lista dei messsaggi

  @override
  void initState() {
    super.initState();
  }

  void inviaMessaggio() {
    String testo = msgController.text.trim();
    if (testo.isEmpty) return;

    setState(() {
      messaggi.add("${widget.username}: $testo");
    });

    msgController.clear();
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
            /*  
 ListView(
  children: [
    Text(messaggi[0]),
    Text(messaggi[1]),
    Text(messaggi[2]),
  ],
) */
            child: ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: messaggi.length, // per listview .builder per dire quantit elementi deve costruire
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
                ),
              ),

              IconButton(icon: Icon(Icons.send), onPressed: inviaMessaggio),
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
  String text;
  bool isMe;

  Chat({required this.text, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue[200] : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(text),
      ),
    );
  }
}
