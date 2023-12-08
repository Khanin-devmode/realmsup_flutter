import 'dart:convert';
import 'package:http/http.dart' as http;

class Client {
  String accessToken = '';

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

    final resMap = jsonDecode(res.body);
    accessToken = resMap['access_token'] as String;
    print(accessToken);
  }

  // curl -H "Authorization: Bearer {access_token}" https://us.api.blizzard.com/data/wow/token/?namespace=dynamic-us

  void testCallApi() async {
    final headers = {
      'Authorization': 'Bearer $accessToken',
    };

    final params = {
      'namespace': 'dynamic-us',
    };

    final url = Uri.parse('https://us.api.blizzard.com/data/wow/token/')
        .replace(queryParameters: params);

    final res = await http.get(url, headers: headers);
    final status = res.statusCode;
    if (status != 200) throw Exception('http.get error: statusCode= $status');

    print(res.body);
  }

  void callRealmSearch() async {
    final headers = {
      'Authorization': 'Bearer $accessToken',
    };

    final params = {'namespace': 'dynamic-us', 'status.type': 'UP'};

    final url =
        Uri.parse('https://us.api.blizzard.com/data/wow/search/connected-realm')
            .replace(queryParameters: params);

    final res = await http.get(url, headers: headers);
    final status = res.statusCode;
    if (status != 200) throw Exception('http.get error: statusCode= $status');

    print(res.body);
  }
}
