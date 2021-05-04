import 'package:easyPass/model/backend_client.dart';

class User {
  User({this.username, this.password});

  String username;
  String password;

  Future<BackendResponse> login() async {
    return BackendClient.post({
      'username': username,
      'password': password,
    });
  }
}
