import 'dart:convert';
import 'dart:html';

import 'package:easy_pass/model/backend_client.dart';
import 'package:easy_pass/utils/function.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  String username;
  String email;

  User._create(String username, String email)
      : username = username,
        email = email;

  static Future<User?> get() async {
    var res = await BackendClient().post("/user/get", {}, useToken: true);
    var data = json.decode(res.body);

    if (res.statusCode != HttpStatus.ok) {
      toast(data['message']);
      return null;
    }

    var user = User._create(data['user']['username'], data['user']['email']);

    return user;
  }

  static Future<String> login(String username, String password) async {
    var res = await BackendClient().post(
        "/user/login",
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
    prefs.setString('userToken', data['token']);

    return data['message'];
  }

  static Future<String> register(
      String username, String password, String email) async {
    var res = await BackendClient().post(
        "/user/register",
        {
          "username": username,
          "password": password,
          "email": email,
        },
        useToken: false);
    var data = res.body;
    var dic = json.decode(data);

    return dic['message'];
  }

  static Future<String?> modifyPassword(
      String oldPassword, String newPassword) async {
    var res = await BackendClient().post('/user/modify_password', {
      "old_password": oldPassword,
      "new_password": newPassword,
    });
    Map<String, dynamic> data = json.decode(res.body);

    if (res.statusCode != HttpStatus.ok) {
      toast(data['message']);
      return null;
    }

    return data['message'];
  }

  // TODO modify user info

  static Future<bool> check() async {
    var res = await BackendClient().post('/oauth/check', {}, useToken: true);
    var data = json.decode(res.body);

    if (res.statusCode == HttpStatus.ok && data['message'] == 'succeed') {
      return true;
    }
    return false;
  }
}
