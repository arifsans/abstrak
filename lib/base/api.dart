import 'package:http/http.dart' as http;
import 'package:http/http.dart';

enum ApiMethod { GET, POST }

class ApiConnection {
  Future<Response?> apiCall({
    required ApiMethod method,
    required String path,
    Map<String, dynamic>? body,
  }) async {
    const _baseUrl = "https://api.captive.my.id/api/v1/";
    if (path.startsWith('/')) {
      path = path.replaceFirst('/', '');
    }

    var url = _baseUrl + path;

    Uri uri = Uri.parse(url);

    Response? response;

    if (method == ApiMethod.GET) {
      response = await http.get(uri);
    }

    if (method == ApiMethod.POST) {
      response = await http.post(uri, body: body);
    }

    if (response != null) {
      if (response.statusCode < 200 || response.statusCode > 400) {
        return null;
      }
    }

    return response;
  }
}
