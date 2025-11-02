# App con Flutter

## Descrizione
Creazione app Chrono con Flutter e Dart.

## Funzionalità
- Lista di colori associati per gestire il colore dei bottoni.
- 2 bottoni interattivi con funzionalità diverse.
- Cronometro.
- Indicatore circolare del tempo.

## Struttura del progetto
- `main.dart` → Contiene tutto il codice dell’applicazione.

Ho creato:

- Un contatore che misura il tempo in secondi e minuti tramite l'utilizzo di **Stream** per generare il tempo in maniera continua:
  - `tickerStream`: genera tick incrementali a intervalli regolari.
  - `secondiStream`: converte i tick in secondi decimali.

- Gestione dello **stato dei pulsanti e delle azioni associate**:
  - `startCounter()`: avvia il timer e aggiorna l’animazione.
  - `pausaCounter()`: mette in pausa il timer e l’animazione.
  - `resumeCounter()`: riprende il timer da dove era stato interrotto.
  - `stopCounter()`: resetta il timer, l’animazione e i pulsanti.

- Cambiamento dinamico dei **testi dei pulsanti**:
  - `cambiaTesto1()`: alterna tra Start → Stop → Reset.
  - `cambiaTesto2()`: alterna tra Pause → Resume.

- Cambio dei **colori dei pulsanti** in base allo stato corrente:
  - `cambiaColore1()` e `cambiaColore2()` gestiscono il cambio ciclico dei colori.

## Creatività personale
- Viene utilizzato un **CircularProgressIndicator** al centro dello schermo per visualizzare graficamente il progresso del timer.
- La barra è collegata a un **AnimationController**, che aggiorna il valore della progressione da 0 a 1 in un intervallo di 1 secondo.
- L’animazione viene **sincronizzata con i decimali dei secondi**:
  - Ogni volta che il timer raggiunge un nuovo secondo intero, l’animazione riparte da 0.
  - Quando il timer viene messo in pausa e poi ripreso, l’animazione riparte dal punto decimale corrente del secondo, assicurando continuità visiva.
- Lo stato dell’animazione viene continuamente aggiornato tramite un listener su `animationController` che chiama `setState()`, rendendo fluido l’aggiornamento della barra.
