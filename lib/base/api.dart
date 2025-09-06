import 'dart:convert';

import 'package:abstrak/main.dart';
import 'package:abstrak/model/auth_model.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ApiMethod { GET, POST, MULTIPART }

class ApiConnection {
  Future<Response?> apiCall({
    required ApiMethod method,
    required String path,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    const _baseUrl = "https://api.captive.my.id/api/v1/";
    if (path.startsWith('/')) {
      path = path.replaceFirst('/', '');
    }

    var url = _baseUrl + path;

    Uri uri = Uri.parse(url);

    Response? response;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('refreshToken') ?? '';
    String expiredToken = prefs.getString('expiredToken') ?? '';

    if (shouldRefreshToken(expiredToken)) {
      final res = await http.post(
        Uri.parse(_baseUrl + 'user/refresh-token'),
        body: {
          'refresh_token': token,
        },
      );

      if (res.statusCode == 200) {
        AuthModel auth = AuthModel.fromJson(jsonDecode(res.body));
        await prefs.setString('token', auth.token?.accessToken ?? '');
        await prefs.setString('refreshToken', auth.token?.refreshToken ?? '');
        await prefs.setString('expiredToken', auth.token?.expiresIn ?? '');
      } else {
        // If refresh token fails, clear stored tokens
        await prefs.remove('token');
        await prefs.remove('refreshToken');
        await prefs.remove('expiredToken');
        authNotifier.auth.value = null;
      }
    }

    if (method == ApiMethod.GET) {
      response = await http.get(uri, headers: headers);
    }

    if (method == ApiMethod.POST) {
      response = await http.post(uri, body: body, headers: headers);
    }

    if (method == ApiMethod.MULTIPART) {
      var request = http.MultipartRequest('POST', uri);
      if (headers != null) {
        request.headers.addAll(headers);
      }
      if (body != null) {
        body.forEach((key, value) {
          if (value is http.MultipartFile) {
            request.files.add(value);
          } else if (value is String) {
            request.fields[key] = value;
          }
        });
      }
      var streamedResponse = await request.send();
      response = await http.Response.fromStream(streamedResponse);
    }

    if (response != null) {
      if (response.statusCode < 200 || response.statusCode > 400) {
        return null;
      }
    }

    return response;
  }

  bool shouldRefreshToken(String expirationString) {
    if (expirationString.isEmpty) return false;
    // Parse string to DateTime
    final expiration = DateTime.parse(expirationString);

    // Subtract 5 minutes from expiration
    final refreshThreshold = expiration.subtract(const Duration(minutes: 5));

    // Check if current time is after threshold
    return DateTime.now().isAfter(refreshThreshold);
  }
}
