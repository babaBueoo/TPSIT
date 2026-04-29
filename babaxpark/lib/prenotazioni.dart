// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'repositories/parking_repository.dart';
import 'models/prenotazione.dart';
import 'services/sessione_utente.dart';

class PrenotazioniPage extends StatefulWidget {
  static const Color orange = Color(0xFFFF6B00);
  static const Color green = Color(0xFF1A7A4A);
  static const Color black = Color(0xFF0D0D0D);

  @override
  State<PrenotazioniPage> createState() => PrenotazioniPageState();
}

class PrenotazioniPageState extends State<PrenotazioniPage> {
  final ParkingRepository repository = ParkingRepository();
  List<Prenotazione> prenotazioni = [];
  bool caricando = false;
  bool serverOffline = false;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    caricaPrenotazioni();
  }

  Future<void> caricaPrenotazioni() async {
    setState(() {
      caricando = true;
      serverOffline = false;
    });
    try {
      final lista = await repository.getPrenotazioni();
      setState(() {
        prenotazioni = lista;
        caricando = false;
        serverOffline = false;
      });
    } catch (e) {
      setState(() {
        caricando = false;
        serverOffline = true;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Errore nel caricamento delle prenotazioni'),
            backgroundColor: PrenotazioniPage.orange,
          ),
        );
      }
    }
  }

  String formatDate(DateTime date) {
    List<String> days = ['Lun', 'Mar', 'Mer', 'Gio', 'Ven', 'Sab', 'Dom'];
    List<String> months = [
      'gen',
      'feb',
      'mar',
      'apr',
      'mag',
      'giu',
      'lug',
      'ago',
      'set',
      'ott',
      'nov',
      'dic',
    ];
    return "${days[date.weekday - 1]} ${date.day} ${months[date.month - 1]}"; // -1 perche date.weekday parte da 1 (Lunedì)
  }

  Future<void> selectDate(BuildContext context) async {
    DateTime? selezionata = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 1)),
    );
    if (selezionata != null && selezionata != selectedDate) {
      setState(() {
        selectedDate = selezionata;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PrenotazioniPage.black,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Center(
                child: Text(
                  "BABAX PARK",
                  style: TextStyle(
                    color: PrenotazioniPage.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              SizedBox(height: 24),

              // Sotto l'header (Data + tasto aggiorna)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Selettore Data
                  GestureDetector(
                    onTap: () => selectDate(context),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: Colors.white,
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Text(
                            formatDate(selectedDate),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Tasto aggiorna
                  caricando
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: PrenotazioniPage.orange,
                          ),
                        )
                      : IconButton(
                          onPressed: caricaPrenotazioni,
                          icon: Icon(
                            Icons.refresh,
                            color: PrenotazioniPage.orange,
                          ),
                          tooltip: 'Aggiorna',
                        ),
                ],
              ),
              SizedBox(height: 24),

              // Lista card
              Expanded(
                child: serverOffline
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.cloud_off, color: Colors.red, size: 64),
                            SizedBox(height: 16),
                            Text(
                              "Server Offline",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Non è possibile vedere gli slot o prenotare senza connessione.",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white38),
                            ),
                            SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: caricaPrenotazioni,
                              child: Text("Riprova"),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: 14, // n parcheggi
                        itemBuilder: (context, index) {
                          final postoIndex = index + 1;
                          final prenotazioniPosto = prenotazioni
                              .where((p) => p.idPosto == postoIndex)
                              .toList();
                          return PrenotazioneCard(
                            key: ValueKey('posto_$postoIndex'),
                            title: "Posto auto A$postoIndex",
                            subtitle: "1 posto auto",
                            postoIndex: postoIndex,
                            selectedDate: selectedDate,
                            prenotazioniPosto: prenotazioniPosto,
                            allPrenotazioni: prenotazioni,
                            repository: repository,
                            onRefresh: caricaPrenotazioni,
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget separato per la singola card
class PrenotazioneCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final int postoIndex;
  final DateTime selectedDate;
  final List<Prenotazione> prenotazioniPosto;
  final List<Prenotazione> allPrenotazioni;
  final ParkingRepository repository;
  final VoidCallback onRefresh;

  const PrenotazioneCard({
    super.key, // superparameters per passare valori al widget padre (StatefulWidget)
    required this.title,
    required this.subtitle,
    required this.postoIndex,
    required this.selectedDate,
    required this.prenotazioniPosto,
    required this.allPrenotazioni,
    required this.repository,
    required this.onRefresh,
  });

  @override
  State<PrenotazioneCard> createState() => PrenotazioneCardState();
}

class PrenotazioneCardState extends State<PrenotazioneCard> {
  // Stati per tracciare la selezione
  String selectedOra = "08:00";
  String selectedDurata = "01:00";
  bool inPrenotazione = false;
  late TextEditingController targaController;

  @override
  void initState() {
    super.initState();
    targaController = TextEditingController(text: SessioneUtente().targa ?? "");
  }

  @override
  void dispose() {
    targaController.dispose();
    super.dispose();
  }

  // Getter
  List<String> get orari {
    if (selectedDurata == "01:00") {
      return [
        "08:00",
        "09:00",
        "10:00",
        "11:00",
        "12:00",
        "13:00",
        "14:00",
        "15:00",
        "16:00",
        "17:00",
        "18:00",
        "19:00",
        "20:00",
        "21:00",
        "22:00",
        "23:00",
        "00:00",
        "01:00",
        "02:00",
      ];
    } else if (selectedDurata == "02:00") {
      return [
        "08:00",
        "09:00",
        "10:00",
        "11:00",
        "12:00",
        "13:00",
        "14:00",
        "15:00",
        "16:00",
        "17:00",
        "18:00",
        "19:00",
        "20:00",
        "21:00",
        "22:00",
        "23:00",
        "00:00",
        "01:00",
      ];
    } else if (selectedDurata == "03:00") {
      return [
        "08:00",
        "09:00",
        "10:00",
        "11:00",
        "12:00",
        "13:00",
        "14:00",
        "15:00",
        "16:00",
        "17:00",
        "18:00",
        "19:00",
        "20:00",
        "21:00",
        "22:00",
        "23:00",
        "00:00",
      ];
    } else {
      return [
        "08:00",
        "09:00",
        "10:00",
        "11:00",
        "12:00",
        "13:00",
        "14:00",
        "15:00",
        "16:00",
        "17:00",
        "18:00",
        "19:00",
        "20:00",
        "21:00",
        "22:00",
        "23:00",
      ];
    }
  }

  List<String> durate = ["01:00", "02:00", "03:00", "04:00"];

  String calcolaOraFine(String oraInizio, String durata) {
    final partiOraInizio = oraInizio.split(':');
    final partiDurata = durata.split(':');

    int minutiInizio =
        int.parse(partiOraInizio[0]) * 60 + int.parse(partiOraInizio[1]);
    int minutiDurata =
        int.parse(partiDurata[0]) * 60 + int.parse(partiDurata[1]);

    int minutiFineTotali = minutiInizio + minutiDurata;
    int oreFine = (minutiFineTotali ~/ 60) % 24;
    int minutiFine = minutiFineTotali % 60;

    return "${oreFine.toString().padLeft(2, '0')}:${minutiFine.toString().padLeft(2, '0')}";
  }

  // Controlla se un'ora è già occupata da una prenotazione esistente
  bool oraOccupata(String ora) {
    final d = widget.selectedDate;
    final dataStr =
        "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";

    final partiOra = ora.split(':');
    int oraMinuti = int.parse(partiOra[0]) * 60 + int.parse(partiOra[1]);

    for (final p in widget.prenotazioniPosto) {
      if (!p.dataInizio.startsWith(dataStr)) continue;
      if (p.dataInizio.length < 16 || p.dataFine.length < 16) continue;

      final partiInizio = p.dataInizio.substring(11, 16).split(':');
      final partiFine = p.dataFine.substring(11, 16).split(':');
      int inizioMinuti =
          int.parse(partiInizio[0]) * 60 + int.parse(partiInizio[1]);
      int fineMinuti = int.parse(partiFine[0]) * 60 + int.parse(partiFine[1]);

      if (oraMinuti >= inizioMinuti && oraMinuti < fineMinuti) return true;
    }
    return false;
  }

  // Costruisce una stringa ISO dalla data selezionata e un orario "HH:MM"
  String costruisciDataIso(DateTime data, String orario) {
    final parti = orario.split(':');
    final dt = DateTime(
      data.year,
      data.month,
      data.day,
      int.parse(parti[0]),
      int.parse(parti[1]),
    );
    return dt.toIso8601String();
  }

  Future<void> prenota() async {
    if (inPrenotazione) return;

    final targaInserita = targaController.text.trim().toUpperCase();
    if (targaInserita.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Inserisci la targa del veicolo!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (oraOccupata(selectedOra)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Questo posto è già occupato per questo orario!'),
          backgroundColor: PrenotazioniPage.orange,
        ),
      );
      return;
    }

    // Controllo univocità targa: la targa non può avere due prenotazioni sovrapposte
    final inizioIso = costruisciDataIso(widget.selectedDate, selectedOra);
    final fineIso = costruisciDataIso(widget.selectedDate, calcolaOraFine(selectedOra, selectedDurata));
    
    bool targaGiaPrenotata = widget.allPrenotazioni.any((p) {
      if (p.targa.toUpperCase() != targaInserita) return false;
      if (p.stato != "attiva") return false;
      // Sovrapposizione temporale
      return (inizioIso.compareTo(p.dataFine) < 0 && fineIso.compareTo(p.dataInizio) > 0);
    });

    if (targaGiaPrenotata) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Questa targa ha già una prenotazione attiva in questo orario!'),
          backgroundColor: PrenotazioniPage.orange,
        ),
      );
      return;
    }

    setState(() {
      inPrenotazione = true;
    });

    try {
      final nuovaPrenotazione = Prenotazione(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        targa: targaInserita,
        idPosto: widget.postoIndex,
        dataInizio: inizioIso,
        dataFine: fineIso,
        stato: "attiva",
      );
      await widget.repository.createPrenotazione(nuovaPrenotazione);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(' Prenotato per le $selectedOra!'),
            backgroundColor: PrenotazioniPage.green,
          ),
        );
        widget.onRefresh(); // ricarica la lista per aggiornare gli slot
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(' Errore durante la prenotazione: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    if (mounted) {
      setState(() {
        inPrenotazione = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: PrenotazioniPage.green.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titolo e sottotitolo
          Text(
            widget.title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.person, color: Colors.white38, size: 16),
              SizedBox(width: 6),
              Text(
                widget.subtitle,
                style: TextStyle(color: Colors.white38, fontSize: 14),
              ),
            ],
          ),

          Divider(color: Colors.white12, height: 32, thickness: 1),

          // Sezione TARGA
          Row(
            children: [
              Icon(Icons.directions_car, color: Colors.white70, size: 16),
              SizedBox(width: 8),
              Text(
                "Targa Veicolo",
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          TextField(
            controller: targaController,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            textCapitalization: TextCapitalization.characters,
            decoration: InputDecoration(
              hintText: "es. AB123CD",
              hintStyle: TextStyle(color: Colors.white38),
              filled: true,
              fillColor: Colors.white10,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          Divider(color: Colors.white12, height: 32, thickness: 1),

          // Sezione ORA
          Row(
            children: [
              Icon(Icons.access_time, color: Colors.white70, size: 16),
              SizedBox(width: 8),
              Text(
                "Ora",
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: orari.map((ora) {
                bool occupato = oraOccupata(ora);
                String label = "$ora - ${calcolaOraFine(ora, selectedDurata)}";
                return creaPulsanteDurata(
                  text: label,
                  isSelected: selectedOra == ora && !occupato,
                  isOccupato: occupato,
                  onTap: occupato
                      ? null
                      : () => setState(() => selectedOra = ora),
                );
              }).toList(),
            ),
          ),

          SizedBox(height: 24),

          // Sezione DURATA
          Row(
            children: [
              Icon(Icons.timer, color: Colors.white70, size: 16),
              SizedBox(width: 8),
              Text(
                "Durata",
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Wrap(
            children: durate
                .map(
                  (durata) => creaPulsanteDurata(
                    text: durata,
                    isSelected: selectedDurata == durata,
                    isOccupato: false,
                    onTap: () {
                      setState(() {
                        selectedDurata = durata;
                      });
                    },
                  ),
                )
                .toList(),
          ),

          SizedBox(height: 24),

          // Bottone Prenota in basso a destra
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: inPrenotazione ? null : prenota,
              style: ElevatedButton.styleFrom(
                backgroundColor: PrenotazioniPage.orange,
                disabledBackgroundColor: PrenotazioniPage.green,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: inPrenotazione
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      "Prenota",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget  bottoni arrotondati selezionabili
  Widget creaPulsanteDurata({
    required String text,
    required bool isSelected,
    required bool isOccupato,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        margin: EdgeInsets.only(right: 12),
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isOccupato
              ? PrenotazioniPage.green
              : isSelected
              ? PrenotazioniPage.orange
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isOccupato
                ? Colors.white12
                : isSelected
                ? PrenotazioniPage.orange
                : Colors.white24,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isOccupato
                ? Colors.white24
                : isSelected
                ? Colors.white
                : Colors.white70,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 14,
            decoration: isOccupato
                ? TextDecoration.lineThrough
                : TextDecoration.none,
            decorationColor: Colors.white30,
          ),
        ),
      ),
    );
  }
}
