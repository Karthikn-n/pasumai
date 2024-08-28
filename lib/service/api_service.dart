import 'dart:convert';

import 'package:app_3/data/encrypt_ids.dart';
import 'package:http/http.dart' as http;

class ApiService{
  final String baseUrl;

  ApiService(this.baseUrl);

  // GET Method
  Future<http.Response> get(String endPoint) async => await http.get(Uri.parse('$baseUrl$endPoint'));


  // POST Method
  Future<http.Response> post(String endPoint, Map<String, dynamic> body) async {
    final String encodeBody = json.encode(body);
    String encryptedUserData = encryptAES(encodeBody);
    print('Encrypted Data: $encryptedUserData');
    print('URL: $baseUrl$endPoint');
    return await http.post(Uri.parse('$baseUrl$endPoint'), body: {'data': encryptedUserData});
  }  

}

