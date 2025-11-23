import 'dart:io';
late Socket socket;
void main() {
  Socket.connect("localhost", 4200).then((Socket sock) {
    socket = sock;


    socket.listen(
      dataHandler,
      onError: errorHandler,
      onDone: doneHandler,
      cancelOnError: false,
    );
  }, onError: (e) {
    print("Unable to connect: $e");
    exit(1);
  });


  // Ascolta stdin e invia al server
  stdin.listen((data) {
    String input = String.fromCharCodes(data).trim();
    if (input.isNotEmpty) {
      socket.write('$input\n');
    }
  });
}


void dataHandler(data) {
  print(String.fromCharCodes(data).trim());
}


void errorHandler(error, StackTrace trace) {
  print('Error: $error');
}


void doneHandler() {
  print('Disconnected from server');
  socket.destroy();
  exit(0);
}
