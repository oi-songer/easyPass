import 'dart:convert';
import 'dart:html';

import 'package:easy_pass/model/backend_client.dart';
import 'package:easy_pass/utils/function.dart';

class Template {
  late int templateId;
  late String title;
  late String description;
  late String status;

  Template._fromJson(Map<String, dynamic> dict) {
    templateId = dict['template_id']!;
    title = dict['title']!;
    description = dict['description']!;
    status = dict['status']!;
  }

  static Future<String?> create(String title, String description) async {
    var res = await BackendClient().post("/template/create", {
      "title": title,
      "description": description,
    });
    var data = json.decode(res.body);

    if (res.statusCode != HttpStatus.created) {
      toast(data['message']);
      return null;
    }

    return data['message'];
  }

  static Future<List<Template>?> get(String keywords, String status) async {
    var res = await BackendClient().get("/template/get", {
      "keywords": keywords,
      "status": status,
    });
    var data = json.decode(res.body);

    if (res.statusCode != HttpStatus.ok) {
      toast(data['message']);
      return null;
    }

    List<Template> templateList = [];
    for (var template in data['templates']) {
      templateList.add(Template._fromJson(template));
    }

    return templateList;
  }

  static Future<String?> modify(
      int templateId, String permission, bool optional) async {
    var res = await BackendClient().post("/template/modify", {
      "template_id": templateId,
      "permission": permission,
      "optional": optional,
    });
    var data = json.decode(res.body);

    if (res.statusCode != HttpStatus.created) {
      toast(data['message']);
      return null;
    }

    return data['message'];
  }

  static Future<String?> remove(int templateId) async {
    var res = await BackendClient().post("/template/remove", {
      "template_id": templateId,
    });
    var data = json.decode(res.body);

    if (res.statusCode != HttpStatus.ok) {
      toast(data['message']);
      return null;
    }
    return data['message'];
  }

  static Future<String?> approve(int templateId, String status) async {
    var res = await BackendClient().post(
        '/template/approve',
        {
          "template_id": templateId,
          "status": status,
        },
        useToken: true);
    var data = json.decode(res.body);

    if (res.statusCode != HttpStatus.ok) {
      toast(data['message']);
      return null;
    }
    return data['message'];
  }
}
