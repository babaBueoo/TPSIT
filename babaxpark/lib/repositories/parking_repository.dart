import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import '../models/veicolo.dart';
import '../models/prenotazione.dart';
import '../services/api_service.dart';
import '../database/database_helper.dart';

class ParkingRepository {
  final ApiService apiService = ApiService();
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  Future<bool> hasConnection() async {
    return await InternetConnection().hasInternetAccess;
  }

  // --- VEICOLI ---
  Future<List<Veicolo>> getVeicoli() async {
    if (await hasConnection()) {
      try {
        final veicoli = await apiService.getVeicoli();
        // Sincronizza cache locale
        await dbHelper.clearVeicoli();
        for (var v in veicoli) {
          await dbHelper.insertVeicolo(v);
        }
        return veicoli;
      } catch (e) {
        // caricamennto dati da database locale in caso di errore API
        return await dbHelper.getAllVeicoli();
      }
    } else {
      return await dbHelper.getAllVeicoli();
    }
  }

  Future<Veicolo> createVeicolo(Veicolo veicolo) async {
    if (await hasConnection()) {
      final createdVeicolo = await apiService.createVeicolo(veicolo);
      await dbHelper.insertVeicolo(createdVeicolo);
      return createdVeicolo;
    } else {
      throw Exception('Operazione bloccata: impossibile creare un veicolo offline.');
    }
  }

  // --- PRENOTAZIONI ---
  Future<List<Prenotazione>> getPrenotazioni() async {
    if (await hasConnection()) {
      try {
        final prenotazioni = await apiService.getPrenotazioni();
        // Sincronizza cache locale
        await dbHelper.clearPrenotazioni();
        for (var p in prenotazioni) {
          await dbHelper.insertPrenotazione(p);
        }
        return await dbHelper.getPrenotazioni();
      } catch (e) {
        // caricamennto dati da database locale in caso di errore API
        return await dbHelper.getPrenotazioni();
      }
    } else {
      
      return await dbHelper.getPrenotazioni();
    }
  }

  Future<Prenotazione> createPrenotazione(Prenotazione prenotazione) async {
    if (await hasConnection()) {
      final createdPrenotazione = await apiService.createPrenotazione(prenotazione);
      await dbHelper.insertPrenotazione(createdPrenotazione);
      return createdPrenotazione;
    } else {
      throw Exception('Operazione bloccata: impossibile creare una prenotazione offline.');
    }
  }

  Future<void> deletePrenotazione(String id) async {
    if (await hasConnection()) {
      try {
        await apiService.deletePrenotazione(id);
      } catch (e) {

      }
      await dbHelper.deletePrenotazione(id);
    } else {
      throw Exception('Operazione bloccata: impossibile cancellare una prenotazione offline.');
    }
  }
}
