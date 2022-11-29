class WebConstants {
  static String baseUrl = 'https://sigurh.cps.sp.gov.br';
  static String authStep1 = '/index.php?pg=Login111';
  static String authStep2 = '/index.php?pg=Login113';
  static String employees = '/?pg=DsrIndex&PgDsr=CadastroComplementoListaCompleto';
  static const String appName = 'SISTEMA';
  static const String op = '131';
  static Map<String, String> headers = {
    'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36'
  };
}

