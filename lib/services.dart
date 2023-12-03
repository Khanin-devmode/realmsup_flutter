import 'dart:convert';
import 'package:http/http.dart' as http;

//Ref curl request
// curl -X POST "{{baseURL}}/api/auth/login" -H "accept: application/json" -H "Content-Type: application/json-patch+json" -d "{ \"nick\": \"string"\", \"password\": \"string\"}"

Future<Map<String, dynamic>> postRequest(String nick, String password) async {
  // todo - fix baseUrl
  Uri url = Uri.parse('{{baseURL}}/api/auth/login');
  var body = json.encode({
    'nick': nick,
    'password': password,
  });

  print('Body: $body');

  var response = await http.post(
    url,
    headers: {
      'accept': 'application/json',
      'Content-Type': 'application/json-patch+json',
    },
    body: body,
  );

  // todo - handle non-200 status code, etc

  return json.decode(response.body);
}
