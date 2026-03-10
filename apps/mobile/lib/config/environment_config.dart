class EnvironmentConfig {
  // TRUE = Conecta al servidor Real (IP del Linux Server o Dominio)
  // FALSE = Conecta al Emulador de Android (10.0.2.2)
  static const bool isProduction = false;

  static const String devUrl = 'http://10.0.2.2:3000';
  
  // IP local del servidor Linux
  static const String prodUrl = 'http://192.168.1.74';

  static String get baseUrl => isProduction ? prodUrl : devUrl;
}
