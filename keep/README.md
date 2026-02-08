# App Todo List con Flutter e SQLite

## Descrizione
Applicazione di gestione note in stile Google Keep realizzata con Flutter e Dart, con persistenza dei dati tramite database SQLite locale.

## Funzionalità
- Card personalizzate con titolo e note multiple
- Modifica inline delle note tramite tap sul testo
- Checkbox per segnare le note come completate
- Aggiunta dinamica di nuove note
- Layout Masonry Grid (2 colonne) con altezze flessibili
- Persistenza dei dati con database SQLite

## Struttura del progetto
- `main.dart` → Entry point dell'app e UI principale
- `model.dart` → Modelli dati (Todo e TodoNote)
- `notifier.dart` → Gestione stato e sincronizzazione database
- `widgets.dart` → Widget TodoItem per le card
- `database_helper.dart` → Operazioni su SQLite
- `colors.dart` → Palette colori

Ho creato:

### Database SQLite con pattern Singleton
- Tabella `todos`: memorizza le card (id, name)
- Tabella `notes`: memorizza le note (id, todoId, text, checked)

### Architettura Cache-Aside
- Cache in-memory (`_todos`) per accesso veloce in RAM
- Database SQLite per persistenza permanente su disco

### State Management con Provider
- `TodoListNotifier` estende `ChangeNotifier` per notificare i widget
- Metodi: `addTodo()`, `addNoteToTodo()`, `updateNoteText()`, `deleteNoteFromTodo()`, `changeNote()`, `deleteTodo()`
- Caricamento automatico dei dati all'avvio con `_loadTodos()`

### Sistema di editing inline
- Map di `TextEditingController` per gestire ogni nota indipendentemente
- Tap sul testo → apre TextField in editing

## Creatività personale
### Layout Masonry Grid personalizzato
Implementato layout masonry completamente custom senza librerie esterne, con algoritmo di distribuzione alternata su 2 colonne:
- Card pari → colonna 1
- Card dispari → colonna 2

### Memory leak prevention
- Dispose automatico di tutti i controller in `dispose()` per evitare perdite di memoria

- Barra di ricerca con icone non funzionanti simili a keep
