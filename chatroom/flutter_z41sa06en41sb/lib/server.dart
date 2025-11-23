import 'dart:io';

late ServerSocket server;
List<ChatClient> clients = [];

void main() {
  ServerSocket.bind(InternetAddress.anyIPv4, 4200).then((ServerSocket socket) {
    server = socket;
    print('aspettando per la connessione...\n');

    server.listen((client) {
      handleConnection(client);
    });
  });
}


void handleConnection(Socket socket) {
  print('Connection from ${socket.remoteAddress.address}:${socket.remotePort}');
  String? username;
  ChatClient? client;

  //richiede nome uente al client 
  socket.write('Scrivi il tuo username: ');
  
  socket.listen((data) {
    String msg = String.fromCharCodes(data).trim();

    // assegnazione ussername
    if (username == null) {  
      username = msg;

      client = ChatClient(socket, username!);
      clients.add(client!);

      // mess al solamente al nuovo utente
      socket.write("benvenuto nella  chatroom! Ci sono ${clients.length - 1} utenti online\n");
      
      // mess broadcast agli altri utenti
      broadcast('$username è entrato nella  chatroom', excludeClient: client);

      print('User "$username" è entrato. User totali: ${clients.length}');
    }

    // chhat normale
    else {
      String messaggioUser = '$username: $msg';

      // Invia il messaggio a tutti tranne al mittente
      broadcast(messaggioUser, excludeClient: client);

      print(messaggioUser);
    }
  },
  onError: (e) {
    print('Errore con $username: $e');
    removeClient(client, username);
  },
  onDone: () {
    removeClient(client, username);
  });
}

// Rimuove un client dalla chat
void removeClient(ChatClient? client, String? username) {
  clients.remove(client);
  broadcast('$username è uscito');
  print('User "$username" disconnesso. user totali: ${clients.length}');
}

// Invia un messaggio a tutti i client
// "excludeClient" permette di evitare di inviare il messaggio al mittente
void broadcast(String message, {ChatClient? excludeClient}) {
  for (ChatClient c in clients) {
    if (c != excludeClient) {
      c.write("$message\n");
    }
  }
}

//rappresenta un client con il suo socket e username
class ChatClient {
   final Socket socket;
   final String username;
  
  ChatClient(this.socket, this.username);

  // invio dati al client tramite socket
  void write(String message) {
    socket.write(message);
  }
}
