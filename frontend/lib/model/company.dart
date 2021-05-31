import 'dart:convert';
import 'dart:html';

import 'package:easy_pass/model/backend_client.dart';
import 'package:easy_pass/utils/function.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Company {
  String username;

  Company._create(String username) : username = username;

  static Future<Company?> get() async {
    var res = await BackendClient().post("/company/get", {}, useToken: true);
    var data = json.decode(res.body);

    if (res.statusCode != HttpStatus.ok) {
      toast(data['message']);
      return null;
    }

    var user = Company._create(data['company']['username']);

    return user;
  }

  static Future<String> login(String username, String password) async {
    var res = await BackendClient().post(
        "/company/login",
        {
          "username": username,
          "password": password,
        },
        useToken: false);
    var data = json.decode(res.body);

    if (res.statusCode != HttpStatus.ok) {
      return data['message'];
    }

    // save to shared_prefrences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('companyToken', data['token']);

    return data['message'];
  }

  static Future<String> register(String username, String password) async {
    var res = await BackendClient().post(
        "/company/register",
        {
          "username": username,
          "password": password,
        },
        useToken: false);
    var data = res.body;
    var dic = json.decode(data);

    return dic['message'];
  }

  static Future<bool> check() async {
    var res = await BackendClient().post('/oauth/check', {}, useToken: true);
    var data = json.decode(res.body);

    if (res.statusCode == HttpStatus.ok && data['message'] == 'succeed') {
      return true;
    }
    return false;
  }
}
