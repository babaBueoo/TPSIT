# App con flutter

## Descrizione
creazione app Inferior Mind  semplice con flutter e dart 

## Funzionalità
- Lista di colori associati a degli stati per gestire il colore dei bottoni
- 4 bottoni interattivi
- Counter delle vittorie e sconfitte
- Bottone per controllare la validità della sequenza 
- Frasi motivazionali che cambiano in funzione di vittoria o di perdita

## Come giocare
1. Premi sui bottoni colorati inizialmente in grigio per cambiare il colore che è associato a un valore.
2. Quando pensi di aver indovinato la sequenza, premi il bottone **"Controlla Sequenza"** in basso a destra.
3. Prenditi tutto il tempo che ti serve, il codice da indovinare cambiaerà solo quando vincerai, in caso di sconfitta la combinazione rimarrà la stessa
4. Leggi il messaggio per sapere se hai indovinato o meno e continua a giocare, se il messaggio si colorerà di verde avrai vinto, altrimenti se si colora di rosso, significa che hai perso

## Struttura del progetto
- `main.dart` → Contiene tutto il codice dell’applicazione.
- Stato dei colori:
  - 0 = grigio
  - 1 = rosso
  - 2 = verde
  - 3 = giallo
  - 4 = blu
    
 Ho creato:
  - una lista statiBottoni in funzione poi di confronto finale con la lista Segreta
  - un metodo per gestire le frasi motivazionali creando due liste, verificando in caso di vittoria o sconfitta tramite un boolean
  - Metodo che genera la sequenza segreta in maniera casuale
  - Metodo cambia colore nel caso in cui i bottoni venissero cliccati
  - Metodo che in caso di di vittoria o perdita lo stato dei bottoni viene ripristinato

## Creatività personale

- ho creato un generatore di frasi motivazionali, sia in caso di vincita (di colore verde) o di perdita ( di colore rosso)
  le frasi vengono selezionate in maniera casuale da una lista di frasi motivazionali
- Ho aggiunto due counter, uno per le vittorie  e uno per le sconfitte
