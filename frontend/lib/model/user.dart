import 'package:easy_pass/model/backend_client.dart';

class User {
  User({this.username, this.password});

  String username;
  String password;

  User.fromJson(Map<String, dynamic> json) : username = json['username'];

  Map<String, dynamic> toJson() => {
        'username': username,
      };

  Future<BackendResponse> login() async {
    return BackendClient.post({
      'username': username,
      'password': password,
    });
  }
}
