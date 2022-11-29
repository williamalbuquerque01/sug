import 'package:http/http.dart';
import 'package:requests/requests.dart';
import 'package:html/parser.dart';
import 'package:sug/consts.dart';

class EmployeesService {
  Future<String> getPage(page, filter) async {
    Response response;
    if (filter) {
      response = await Requests.post(
        '${WebConstants.baseUrl}${WebConstants.employees}&pagina=${page}',
        headers: WebConstants.headers,
        body: {
          'op': WebConstants.op,
          'MontaSql': 1
        },
        bodyEncoding: RequestBodyEncoding.FormURLEncoded
      );
    } else {
      response = await Requests.get(
        '${WebConstants.baseUrl}${WebConstants.employees}&pagina=${page}',
        headers: WebConstants.headers,
      );
    }
    if (response.statusCode == 200) return response.content();
    return '';
  }

  Future<List> list() async {
    List columns;
    List lines;
    List data = [];
    var pages = [await getPage(1, true)];
    var document = parse(pages[0]);
    List links = document.querySelectorAll('.page-link');
    int num_pages = links.length > 2 ? links.length - 2 : 1;

    for (int i=2; i <= num_pages; i++) {
      pages.addAll([await getPage(i, false)]);
    }

    for (int i=0; i < num_pages; i++) {
      document = parse(pages[i]);
      lines = document.querySelectorAll('tr');
      lines.removeAt(0);
      for (int j=0; j < lines.length; j++) {
        columns = lines[j].querySelectorAll('td');
        // Código, Matrícula, Nome, Status, Emprego
        if (columns[7].text == 'A') {
          data.addAll([{
            'code': columns[0].text,
            'registration': columns[1].text,
            'name': columns[2].text,
            'status': columns[7].text,
            'role': columns[10].text
          }]);
        }
      }
    }
    return data;
  }
}