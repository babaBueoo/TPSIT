class Veicolo {
  final String targa;

  Veicolo({
    required this.targa,
  });

  factory Veicolo.fromJson(Map<String, dynamic> json) {
    return Veicolo(
      targa: json['targa'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'targa': targa,
    };
  }
}
