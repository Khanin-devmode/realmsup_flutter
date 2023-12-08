import 'dart:convert';
import 'package:http/http.dart' as http;

//Ref curl request
// curl -X POST "{{baseURL}}/api/auth/login" -H "accept: application/json" -H "Content-Type: application/json-patch+json" -d "{ \"nick\": \"string"\", \"password\": \"string\"}"

// curl -u {client_id}:{client_secret} -d grant_type=client_credentials https://oauth.battle.net/token

// Future<Map<String, dynamic>> postRequest(String nick, String password) async {
//   // todo - fix baseUrl
//   Uri url = Uri.parse('{{baseURL}}/api/auth/login');
//   var body = json.encode({
//     'nick': nick,
//     'password': password,
//   });

//   print('Body: $body');

//   var response = await http.post(
//     url,
//     headers: {
//       'accept': 'application/json',
//       'Content-Type': 'application/json-patch+json',
//     },
//     body: body,
//   );

//   // todo - handle non-200 status code, etc

//   return json.decode(response.body);
// }

void getAccessCode() async {
  const clientId = '743e4becd032416b8baf7a2366f4d0ed';
  const clientSecret = 'KRHK62grnG0a8e2swGbOaJi1FkjRDr0f';
  final authorization =
      'Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}';

  final headers = {
    'Content-Type': 'application/x-www-form-urlencoded',
    'Authorization': authorization,
  };

  final data = {
    'grant_type': 'client_credentials',
  };

  final url = Uri.parse('https://oauth.battle.net/token');
  final res = await http.post(url, headers: headers, body: data);
  final status = res.statusCode;
  if (status != 200) throw Exception('http.post error: statusCode= $status');

  print(res.body);
}
