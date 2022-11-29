import 'package:requests/requests.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:sug/consts.dart';

class LoginService {
  static Future<bool> authenticate(String cpf, String password) async {
      //String hostname = Requests.getHostname(WebConstants.baseUrl);
      //var cookieJar = await Requests.getStoredCookies(hostname);
      final step1 = await Requests.post(
          '${WebConstants.baseUrl}${WebConstants.authStep1}',
          headers: WebConstants.headers,
          body: {
            'cpf': cpf
          },
          bodyEncoding: RequestBodyEncoding.FormURLEncoded
      );
      if (step1.statusCode == 200) {
        Document document = parse(step1.content());
        final registration = document.querySelectorAll('#matricula')[0].attributes['value'].toString();
        final step2 = await Requests.post(
            WebConstants.baseUrl + WebConstants.authStep2,
            headers: WebConstants.headers,
            body: {
              'matricula': registration,
              'username': cpf,
              'password': password,
            },
            bodyEncoding: RequestBodyEncoding.FormURLEncoded
        );
        if (step2.statusCode == 200) {
          document = parse(step2.content());
          if (document.querySelectorAll('.erro').isEmpty) return true;
        }
      }
      return false;
  }
}