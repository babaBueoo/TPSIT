import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/veicolo.dart';
import '../models/prenotazione.dart';
import 'package:bcrypt/bcrypt.dart';

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:3000';

  // --- API VEICOLI ---
  Future<List<Veicolo>> getVeicoli() async {
    final response = await http.get(Uri.parse('$baseUrl/veicoli'));
    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return body.map((json) => Veicolo.fromJson(json)).toList();
    } else {
      throw Exception('non carica Veicoli');
    }
  }

  Future<Veicolo> createVeicolo(Veicolo veicolo) async {
    final response = await http.post(
      Uri.parse('$baseUrl/veicoli'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(veicolo.toJson()),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Veicolo.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('non crea Veicolo');
    }
  }

  Future<void> updateVeicolo(Veicolo veicolo) async {
    final response = await http.put(
      Uri.parse('$baseUrl/veicoli/${veicolo.targa}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(veicolo.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('fallito upload veicolo');
    }
  }

  Future<void> deleteVeicolo(String targa) async {
    final response = await http.delete(Uri.parse('$baseUrl/veicoli/$targa'));
    if (response.statusCode != 200) {
      throw Exception('non cancella Veicolo');
    }
  }

  // --- API UTENTI ---
  Future<void> registraUtente(Map<String, dynamic> dati) async {
    final response = await http.post(
      Uri.parse('$baseUrl/utenti'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(dati),
    );
    if (response.statusCode != 201) throw Exception('Errore registrazione');
  }

  Future<List<Map<String, dynamic>>> getUtenti() async {
    final response = await http.get(Uri.parse('$baseUrl/utenti'));
    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return body.cast<Map<String, dynamic>>();
    } else {
      throw Exception('non carica utenti');
    }
  }

  Future<void> updateUtente(String id, Map<String, dynamic> dati) async {
    final response = await http.put(
      Uri.parse('$baseUrl/utenti/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(dati),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update utente');
    }
  }

  Future<void> deleteUtente(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/utenti/$id'));
    if (response.statusCode != 200) {
      throw Exception('non cancella utente');
    }
  }

  Future<Map<String, dynamic>?> login(String email, String password) async {
    final response = await http.get(Uri.parse('$baseUrl/utenti?email=$email'));
    if (response.statusCode == 200) {
      final List<dynamic> utenti = jsonDecode(response.body);
      if (utenti.isNotEmpty) {
        final utente = utenti.first;
        try {
          if (BCrypt.checkpw(password, utente['password'])) {
            return utente;
          }
        } catch (e) {
          // account vecchio
          // if (password == utente['password']) {
          //   return utente;
          // }
        }
      }
    }
    return null;
  }

  // --- API PRENOTAZIONI ---
  Future<List<Prenotazione>> getPrenotazioni() async {
    final response = await http.get(Uri.parse('$baseUrl/prenotazioni'));
    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return body.map((json) => Prenotazione.fromJson(json)).toList();
    } else {
      throw Exception('non carica prenotazioni');
    }
  }

  Future<Prenotazione> createPrenotazione(Prenotazione prenotazione) async {
    final response = await http.post(
      Uri.parse('$baseUrl/prenotazioni'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(prenotazione.toJson()),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Prenotazione.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('non crea prenotazione');
    }
  }

  Future<void> updatePrenotazione(Prenotazione prenotazione) async {
    final response = await http.put(
      Uri.parse('$baseUrl/prenotazioni/${prenotazione.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(prenotazione.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('non aggiorna prenotazione');
    }
  }

  Future<void> deletePrenotazione(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/prenotazioni/$id'));
    if (response.statusCode != 200) {
      throw Exception('non cancella prenotazione');
    }
  }
}
