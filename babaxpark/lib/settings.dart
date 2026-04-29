// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'repositories/parking_repository.dart';
import 'models/prenotazione.dart';
import 'services/sessione_utente.dart';
import 'login.dart';

class SettingsPage extends StatefulWidget {
  static const Color orange = Color(0xFFFF6B00);
  static const Color green = Color(0xFF1A7A4A);
  static const Color black = Color(0xFF0D0D0D);

  @override
  State<SettingsPage> createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  final ParkingRepository repository = ParkingRepository();
  List<Prenotazione> prenotazioni = [];
  bool caricamento = false;
  bool isRegolamentoExpanded = false;

  @override
  void initState() {
    super.initState();
    caricaPrenotazioni();
  }

  Future<void> caricaPrenotazioni() async {
    setState(() {
      caricamento = true;
    });
    try {
      final lista = await repository.getPrenotazioni();
      setState(() {
        prenotazioni = lista;
        caricamento = false;
      });
    } catch (e) {
      setState(() {
        caricamento = false;
      });
    }
  }

  //a data ISO in formato leggibile
  String formattaData(String iso) {
    try {
      final dt = DateTime.parse(iso).toLocal();
      return "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}  ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
    } catch (e) {
      return iso;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SettingsPage.black,
      appBar: AppBar(
        backgroundColor: SettingsPage.black,
        title: Text(
          'Dati e Info',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          caricamento
              ? Padding(
                  padding: EdgeInsets.all(14),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: SettingsPage.orange,
                    ),
                  ),
                )
              : IconButton(
                  onPressed: caricaPrenotazioni,
                  icon: Icon(Icons.refresh, color: SettingsPage.orange),
                  tooltip: 'Aggiorna',
                ),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Sezione Account
                    Text(
                      "ACCOUNT",
                      style: TextStyle(
                        color: Colors.white38,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: SettingsPage.orange.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: SettingsPage.orange.withValues(
                              alpha: 0.2,
                            ),
                            radius: 28,
                            child: Icon(
                              Icons.person,
                              color: SettingsPage.orange,
                              size: 30,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  SessioneUtente().nome ?? "Ospite",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  SessioneUtente().email ?? "nessuna email",
                                  style: TextStyle(
                                    color: Colors.white38,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 32),

                    // Sezione Le mie prenotazioni
                    Text(
                      "LE MIE PRENOTAZIONI",
                      style: TextStyle(
                        color: Colors.white38,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: 12),

                    if (caricamento)
                      Center(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: CircularProgressIndicator(
                            color: SettingsPage.orange,
                          ),
                        ),
                      )
                    else if (prenotazioni.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: SettingsPage.orange.withValues(alpha: 0.4),
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.receipt_long,
                              color: Colors.white38,
                              size: 40,
                            ),
                            SizedBox(height: 12),
                            Text(
                              "Nessuna prenotazione salvata.",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Column(
                        children: prenotazioni
                            .map((p) => cardPrenotazione(p))
                            .toList(),
                      ),

                    SizedBox(height: 32),

                    // Sezione Info
                    Text(
                      "INFO",
                      style: TextStyle(
                        color: Colors.white38,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: 12),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isRegolamentoExpanded = !isRegolamentoExpanded;
                        });
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: SettingsPage.green.withValues(alpha: 0.4),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: SettingsPage.green.withValues(
                                  alpha: 0.10,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.description_outlined,
                                color: SettingsPage.green,
                                size: 22,
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                "Regolamento",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Icon(
                              isRegolamentoExpanded
                                  ? Icons.keyboard_arrow_down
                                  : Icons.arrow_forward_ios,
                              color: SettingsPage.green,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Paragrafo a comparsa
                    if (isRegolamentoExpanded)
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(top: 12),
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: SettingsPage.green.withValues(alpha: 0.4),
                          ),
                        ),
                        child: Text(
                          "1. No sta far el volpe, se te rivi qua e no te ghe a prenotazion te ve fora dae bae\n\n"
                          "2. Confidemo nea bona fede, ogni tanto buta un ocio sull'orario di uscita dal parchejo\n\n"
                          "3. No vojo vedar rivar macchine dea mutua (elettriche), in tal caso, no sta sorpendarte de trovar strissi o speci/speceti spacai\n\n"
                          "4. Ocio a parchejar a modo o ti ga i morti cani\n\n"
                          "5. Se te vedi gaine porsei o altre bestie nel parchejo avisame che i se scampai daea boarìa\n\n"
                          "6. Sia dal cavalo, sia dal musso, sta tre passi lontan dal cueo",
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ),

                    SizedBox(height: 32),

                    // Tasto Logout
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          SessioneUtente().logout();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                            (route) => false,
                          );
                        },
                        icon: Icon(Icons.logout, color: Colors.white),
                        label: Text(
                          "Esci",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: SettingsPage.green,
                          padding: EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget card per una singola prenotazione
  Widget cardPrenotazione(Prenotazione p) {
    bool attiva = p.stato == "attiva";
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF222222),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: attiva
              ? SettingsPage.green.withValues(alpha: 0.4)
              : SettingsPage.orange.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: SettingsPage.orange.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.local_parking,
              color: SettingsPage.orange,
              size: 24,
            ),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Posto A${p.idPosto}",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  "${formattaData(p.dataInizio)}",
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
                Text(
                  "${formattaData(p.dataFine)}",
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
                SizedBox(height: 3),
                Text(
                  "Targa: ${p.targa}",
                  style: TextStyle(color: SettingsPage.orange, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: attiva
                  ? SettingsPage.green.withValues(alpha: 0.2)
                  : SettingsPage.orange.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              p.stato,
              style: TextStyle(
                color: attiva ? SettingsPage.green : SettingsPage.orange,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ),
          SizedBox(width: 8),
          IconButton(
            onPressed: () async {
              try {
                await repository.deletePrenotazione(p.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Prenotazione eliminata"),
                    backgroundColor: SettingsPage.green,
                  ),
                );
                caricaPrenotazioni(); // Ricarica la lista
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Errore durante l'eliminazione: $e"),
                    backgroundColor: SettingsPage.orange,
                  ),
                );
              }
            },
            icon: Icon(
              Icons.delete_outline,
              color: SettingsPage.orange,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
