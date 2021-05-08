import 'package:easy_pass/model/backend_client.dart';

class Info {
  Info({this.title, this.content});

  int id;
  String title;
  String content;

  Info.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        content = json['content'];

  Map<String, dynamic> toJson() => {
        'title': title,
      };

  Future<BackendResponse> register() async {
    return BackendClient.post('/int/get', {
      'id': id.toString(),
    });
  }
}
