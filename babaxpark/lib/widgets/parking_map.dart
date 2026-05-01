import 'package:flutter/material.dart';

class ParkingMapPainter extends CustomPainter {
  int righe = 2;
  int colonne = 7;
  double larghezzaPosto = 40;
  double altezzaPosto = 60;
  double spazioOrizzontale = 10;
  double spazioVerticale = 20;

  @override
  void paint(Canvas canvas, Size size) {
    Paint pennello = Paint();
    pennello.style = PaintingStyle.stroke;
    pennello.strokeWidth = 2;
    pennello.color = Colors.white70;  

    double larghezzaTotale = colonne * larghezzaPosto + (colonne - 1) * spazioOrizzontale;
    double altezzaTotale = righe * altezzaPosto + (righe - 1) * spazioVerticale;
    double inizioX = (size.width - larghezzaTotale) / 2;
    double inizioY = (size.height - altezzaTotale) / 2;

    int numeroPosto = 1;
    for (int riga = 0; riga < righe; riga++) {
      for (int colonna = 0; colonna < colonne; colonna++) {
        double x = inizioX + colonna * (larghezzaPosto + spazioOrizzontale);
        double y = inizioY + riga * (altezzaPosto + spazioVerticale);
        Rect rettangolo = Rect.fromLTWH(x, y, larghezzaPosto, altezzaPosto);
        canvas.drawRect(rettangolo, pennello);

       
        String etichetta = 'A$numeroPosto';
        TextSpan testo = TextSpan(
          style: TextStyle(color: Colors.white, fontSize: 12),
          text: etichetta,
        );
        TextPainter scrittore = TextPainter(
          text: testo,
          textDirection: TextDirection.ltr,
        );
        scrittore.layout();
        double etichetteX = x + (larghezzaPosto - scrittore.width) / 2;
        double etichetteY = y - scrittore.height - 4;
        scrittore.paint(canvas, Offset(etichetteX, etichetteY));
        numeroPosto++;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
