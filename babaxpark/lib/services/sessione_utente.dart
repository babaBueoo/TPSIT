class SessioneUtente {
  static final SessioneUtente instance = SessioneUtente.internal();
  factory SessioneUtente() => instance;
  SessioneUtente.internal();

  String? nome;
  String? email;
  String? targa;

  bool get isLoggato => email != null;

  void login(String nomeLog, String emailLog, String targaLog) {
    nome = nomeLog;
    email = emailLog;
    targa = targaLog;
  }

  void logout() {
    nome = null;
    email = null;
    targa = null;
  }
}
