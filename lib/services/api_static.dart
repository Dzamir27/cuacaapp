import 'package:http/http.dart' as http;

class ApiStatic {
  final String _url = "https://ibnux.github.io/BMKG-importer/";

  getDataCuaca(apiUrl) async {
    var fullUrl = _url + apiUrl;
    return await http.get(Uri.parse(fullUrl), headers: _setHeaders());
  }

  _setHeaders() =>
      {'Content-type': 'application/json', 'Accept': 'application/json'};
}
