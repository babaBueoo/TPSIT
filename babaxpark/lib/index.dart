// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'homePage.dart';
import 'services/api_service.dart';

class IndexPage extends StatefulWidget {
  static const Color orange = Color(0xFFFF6B00);
  static const Color green = Color(0xFF1A7A4A);
  static const Color black = Color(0xFF0D0D0D);

  @override
  State<IndexPage> createState() => IndexPageState();
}

class IndexPageState extends State<IndexPage> {
  bool? serverOnline; // null = controllo in corso

  @override
  void initState() {
    super.initState();
    controllaServer();
  }

  Future<void> controllaServer() async {
    setState(() {
      serverOnline = null; // mostra caricamento
    });
    try {
      final risposta = await http
          .get(Uri.parse(ApiService.baseUrl))
          .timeout(Duration(seconds: 4));
      setState(() {
        serverOnline = risposta.statusCode == 200;
      });
    } catch (e) {
      setState(() {
        serverOnline = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: IndexPage.black,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 16),

              // Indicatore stato server
              GestureDetector(
                onTap: controllaServer,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: serverOnline == null
                          ? Colors.white24
                          : serverOnline!
                          ? IndexPage.green.withValues(alpha: 0.5)
                          : Colors.red.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Pallino colorato
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: serverOnline == null
                              ? Colors.white38
                              : serverOnline!
                              ? IndexPage.green
                              : Colors.red,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        serverOnline == null
                            ? "Controllo server..."
                            : serverOnline!
                            ? "Server online"
                            : "Server offline",
                        style: TextStyle(
                          color: serverOnline == null
                              ? Colors.white38
                              : serverOnline!
                              ? IndexPage.green
                              : Colors.red,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.refresh, size: 14, color: Colors.white38),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              // titolo
              Text(
                "Parcheja\nfasìe,\ndove ti vol.",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  height: 1.15,
                ),
              ),

              SizedBox(height: 16),

              // sottotitolo
              Text(
                "El to posto te speta, date na mosa e toilo",
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 16,
                  height: 1.6,
                ),
              ),

              SizedBox(height: 30),

              Container(
                width: double.infinity, // espansione massima in larghezza
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    // top: BorderSide(color: green),
                    color: IndexPage.green.withValues(alpha: 0.4),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    featureRow(
                      Icons.bolt,
                      "Prenotasion imediata",
                      "Toi queo che ti vol con un fià de tap",
                    ),
                    SizedBox(height: 16),
                    featureRow(
                      Icons.location_on,
                      "Posision agevoe",
                      "El parchejo se trova a do pasi dae fermate dei imbarcaderi e bus",
                    ),
                    SizedBox(height: 16),
                    featureRow(
                      Icons.discount,
                      "BabaxPark x Venezia FC",
                      "Co na prenotasion te ghe diritto a na mesa pinta gratis al baretto deo stadio!",
                    ),
                  ],
                ),
              ),
              Spacer(),

              // SizedBox(height: 30),
              // Bottone Prenota
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Vai alla tab Prenotazioni (indice 1)
                    final homeState = context
                        .findAncestorStateOfType<homePagePageState>();
                    if (homeState != null) {
                      homeState.setState(() {
                        homeState.myIndex = 1;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: IndexPage.orange,
                    padding: EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    "Prenota ora",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget featureRow(IconData icon, String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: IndexPage.green.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: IndexPage.green, size: 20),
        ),
        SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(color: Colors.white38, fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
