import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiRepository {
  final url = 'http://192.168.100.32:3000';

  Future<dynamic> refreshToken() async {
    var prefs = await SharedPreferences.getInstance();

    assert(prefs.containsKey('user'));

    var user = json.decode(prefs.getString('user')!);

    print(user);

    var res = await http.get(
      Uri.parse('$url/auth/refresh'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${user['refresh_token']}'
      },
    );

    if (res.statusCode == 200) {
      var body = json.decode(res.body);

      print(body);
    } else {
      var body = json.decode(res.body);

      print(body);
      return {
        ...json.decode(res.body) as Map,
      };
    }
  }

  Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      var res = await http.post(
        Uri.parse('$url/auth/signin'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'user': {
            'email': email,
            'password': password,
          },
        }),
      );

      return {
        ...json.decode(res.body),
        'statusCode': res.statusCode,
      };
    } on http.ClientException catch (e) {
      return {
        'message': e.message,
        'statusCode': 500,
      };
    } on Exception catch (e) {
      return {
        'message': e.toString(),
        'statusCode': 500,
      };
    }
  }

  Future<Map<String, dynamic>> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    try {
      var res = await http.post(
        Uri.parse('$url/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'user': {
            'first_name': firstName,
            'last_name': lastName,
            'email': email,
            'password': password,
          },
        }),
      );

      return {...json.decode(res.body)};
    } on http.ClientException catch (e) {
      print(e);
      return {
        'message': e.message,
      };
    } on Exception catch (e) {
      print(e);
      return {
        'message': e.toString(),
      };
    }
  }
}
