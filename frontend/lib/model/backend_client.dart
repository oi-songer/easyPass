import 'dart:convert';
import 'dart:html';
import 'package:http/http.dart' as http;

// import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';

const String ApiUrl = 'http://121.5.160.8:5000/';

class BackendClient {
  static BackendClient _instance = BackendClient._internal();
  factory BackendClient() => _instance;

  late http.Client client;

  BackendClient._internal() {
    client = http.Client();
  }

  Future<http.Response> post(String path, Map<String, dynamic> body,
      {bool useToken = true}) async {
    var url = Uri.parse(ApiUrl + path);
    Map<String, String> headers = Map<String, String>.from(
        {"Content-Type": "application/json; charset=UTF-8"});
    if (useToken) {
      // TODO
    }

    var response =
        await http.post(url, body: jsonEncode(body), headers: headers);
    print('!Response status: ${response.statusCode}');
    print('!Response body: ${response.body}');

    return response;
  }
}
