// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'index.dart';
import 'prenotazioni.dart';
import 'settings.dart';

class homePagePage extends StatefulWidget {
   static  const Color orange = Color(0xFFFF6B00);
 static  const Color green = Color(0xFF1A7A4A);
 static  const Color black = Color(0xFF0D0D0D);

  @override
  State<homePagePage> createState() => homePagePageState();
}

class homePagePageState extends State<homePagePage> {
int myIndex = 0;
late List<Widget> widgetList;


@override

void initState(){
  super.initState();
   widgetList = [
    IndexPage(),
    PrenotazioniPage(),
    SettingsPage(),
  ];
}


@override
Widget build(BuildContext context) {
  return Scaffold(
    body:  Center(
      child: widgetList[myIndex], 
      ),
    bottomNavigationBar: BottomNavigationBar(
      type: BottomNavigationBarType.shifting,
    //  showSelectedLabels: false,
    showUnselectedLabels: true,
      onTap: (index) {
        setState(() {
          myIndex = index;
        });
      },
      currentIndex: myIndex, 
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home', backgroundColor: homePagePage.orange), // Indice 0
        BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Prenotazioni', backgroundColor: homePagePage.black), // Indice 1
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Dati e Info', backgroundColor: homePagePage.green), // Indice 2
      ],
    ),
   // body: Center(child: Text("Pagina corrente: $myIndex")), 
  );
}
}