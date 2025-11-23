# App con Flutter
## Descrizione
Applicazione di chatroom in tempo reale sviluppata con Flutter e Dart, che utilizza una connessione TCP Socket per comunicare con un server locale.

## Funzionalità
- Pagina di login per inserire lo username.
- Chatroom con messaggi in tempo reale e aggiornamento dinamico.
- Visualizzazione dei messaggi con bolle separate:
- Messaggi propri a destra (blu)
- Messaggi degli altri a sinistra (grigio)
- Notifiche di entrata/uscita utenti nella chatroom.
- Gestione sicura delle connessioni TCP e chiusura socket al termine(dispose()).

## Struttura del progetto
- `main.dart` → Contiene il codice dell’app Flutter, login, chatroom e interfaccia grafica.
- `client.dart` → Server TCP  che gestisce più client contemporaneamente, memorizza username, trasmette messaggi e notifica entrate/uscite.
- `server.dart` → Client console , permette di connettersi al server, inviare/ricevere messaggi da terminale.

# Dettagli implementativi

## Server (`server.dart`)
- Ascolta su porta **4200** connessioni in arrivo.
- Gestisce **più client contemporaneamente** con lista `List<ChatClient> clients = [];`.
- Broadcast dei messaggi a tutti i client **tranne il mittente**  `excludeClient`
- Classe `ChatClient` rappresenta ogni client con il proprio socket e username

## Client Flutter (`main.dart`)
### LoginPage
- Widget **Stateful** con campo testo per inserire lo **username**

### ChatPage
- Widget **Stateful** per la chat:
  - Connessione **TCP** al server (`Socket.connect`)
  - Invio e ricezione dei messaggi
  - Aggiornamento dinamico della lista `messaggi` tramite `setState()`
  - Gestione della chiusura socket con `dispose()`

### Lista dei messaggi
- Costruita con `ListView.builder`
  - `itemCount` → numero di messaggi
  - `itemBuilder` → genera una bolla per ogni messaggio

## Client Console (`client.dart`)
- Connette al server **TCP** sulla stessa porta
- Legge input da terminale e lo invia al server
- Riceve messaggi dal server e li stampa in console
