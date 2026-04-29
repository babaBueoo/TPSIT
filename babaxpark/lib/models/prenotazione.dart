class Prenotazione {
  final String id;
  final String targa;
  final int idPosto;
  final String dataInizio;
  final String dataFine;
  final String stato;

  Prenotazione({
    required this.id,
    required this.targa,
    required this.idPosto,
    required this.dataInizio,
    required this.dataFine,
    required this.stato,
  });

  factory Prenotazione.fromJson(Map<String, dynamic> json) {
    return Prenotazione(
      id: json['id'].toString(),
      targa: json['targa'] as String,
      idPosto: json['id_posto'] is int 
          ? json['id_posto'] as int 
          : int.parse(json['id_posto'].toString()),
      dataInizio: json['data_inizio'] as String,
      dataFine: json['data_fine'] as String,
      stato: json['stato'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'targa': targa,
      'id_posto': idPosto,
      'data_inizio': dataInizio,
      'data_fine': dataFine,
      'stato': stato,
    };
  }
}
