import 'dart:io';
import '../models/veicolo.dart';
import '../models/prenotazione.dart';
import '../services/api_service.dart';
import '../database/database_helper.dart';

class ParkingRepository {
  final ApiService apiService = ApiService();
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  // --- VEICOLI ---
  Future<List<Veicolo>> getVeicoli() async {
    try {
<<<<<<< HEAD
      List<Veicolo> veicoli = await apiService.getVeicoli();
      // sincfonizza chace locale
      await dbHelper.clearVeicoli();
      for (Veicolo v in veicoli) {
=======
      final veicoli = await apiService.getVeicoli();
      // sincfonizza chace locale
      await dbHelper.clearVeicoli();
      for (var v in veicoli) {
>>>>>>> b8ba313a6d59e3e2d64a3bfc97d3c3019fcbf917
        await dbHelper.insertVeicolo(v);
      }
      return veicoli;
    } catch (e) {
     //offline o errore server
      return await dbHelper.getAllVeicoli();
    }
  }

  Future<Veicolo> createVeicolo(Veicolo veicolo) async {
    try {
<<<<<<< HEAD
      Veicolo createdVeicolo = await apiService.createVeicolo(veicolo);
=======
      final createdVeicolo = await apiService.createVeicolo(veicolo);
>>>>>>> b8ba313a6d59e3e2d64a3bfc97d3c3019fcbf917
      await dbHelper.insertVeicolo(createdVeicolo);
      return createdVeicolo;
    } on SocketException {
      throw Exception('Operazione bloccata: impossibile creare un veicolo offline.');
    }
  }

  // --- PRENOTAZIONI ---
  Future<List<Prenotazione>> getPrenotazioni() async {
    try {
<<<<<<< HEAD
      List<Prenotazione> prenotazioni = await apiService.getPrenotazioni();
      // wincronizza cache locale
      await dbHelper.clearPrenotazioni();
      for (Prenotazione p in prenotazioni) {
=======
      final prenotazioni = await apiService.getPrenotazioni();
      // wincronizza cache locale
      await dbHelper.clearPrenotazioni();
      for (var p in prenotazioni) {
>>>>>>> b8ba313a6d59e3e2d64a3bfc97d3c3019fcbf917
        await dbHelper.insertPrenotazione(p);
      }
      return await dbHelper.getPrenotazioni();
    } catch (e) {
      // offline o errore server
      return await dbHelper.getPrenotazioni();
    }
  }

  Future<Prenotazione> createPrenotazione(Prenotazione prenotazione) async {
    try {
<<<<<<< HEAD
      Prenotazione createdPrenotazione = await apiService.createPrenotazione(prenotazione);
=======
      final createdPrenotazione = await apiService.createPrenotazione(prenotazione);
>>>>>>> b8ba313a6d59e3e2d64a3bfc97d3c3019fcbf917
      await dbHelper.insertPrenotazione(createdPrenotazione);
      return createdPrenotazione;
    } on SocketException {
      throw Exception('Operazione bloccata: impossibile creare una prenotazione offline.');
    }
  }

  Future<void> deletePrenotazione(String id) async {
    try {
      await apiService.deletePrenotazione(id);
      await dbHelper.deletePrenotazione(id);
    } on SocketException {
      throw Exception('Operazione bloccata: impossibile cancellare una prenotazione offline.');
    }
  }
}
