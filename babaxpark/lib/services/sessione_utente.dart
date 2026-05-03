class SessioneUtente {
  static final SessioneUtente instance = SessioneUtente.internal();
  factory SessioneUtente() => instance;
  SessioneUtente.internal();

  String? nome;
  String? email;

  bool get isLoggato => email != null;

  void login(String nomeLog, String emailLog) {
    nome = nomeLog;
    email = emailLog;
  }

  void logout() {
    nome = null;
    email = null;
  }
}
