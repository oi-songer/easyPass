import 'dart:convert';
import 'dart:html';

import 'package:easy_pass/model/backend_client.dart';
import 'package:easy_pass/utils/function.dart';

class Info {
  late int infoId;
  late String title;
  late String modifyTime;
  String? content;
  String? createTime;
  int? templateId;

  Info._fromJson(Map<String, dynamic> dict) {
    title = dict['title']!;
    infoId = dict['info_id']!;
    modifyTime = dict['modify_time']!;
    createTime = dict['create_time'];
    content = dict['content'];
    templateId = dict['template_id'];
  }

  static Future<List<Info>?> get(String keywords, String filterMethod) async {
    var res = await BackendClient().get("/info/get", {
      "keywords": keywords,
      "filter_method": filterMethod,
    });
    var data = json.decode(res.body);

    if (res.statusCode != HttpStatus.ok) {
      toast(data['message']);
      return null;
    }

    List<Info> infoList = [];
    for (var info in data['infos']) {
      infoList.add(Info._fromJson(info));
    }

    return infoList;
  }

  static Future<Info?> getDetail(int infoId) async {
    var res = await BackendClient().get("/info/get_detail", {
      "info_id": infoId,
    });
    var data = json.decode(res.body);

    if (res.statusCode != HttpStatus.ok) {
      toast(data['message']);
      return null;
    }

    var info = Info._fromJson(data['info']);
    return info;
  }

  static Future<String?> create(int templateId, String content) async {
    var res = await BackendClient().post("/info/create", {
      "template_id": templateId,
      "content": content,
    });
    var data = json.decode(res.body);

    if (res.statusCode != HttpStatus.created) {
      toast(data['message']);
      return null;
    }

    return data['message'];
  }

  static Future<String?> modify(int infoId, String content) async {
    var res = await BackendClient().post("/info/modify", {
      "info_id": infoId,
      "content": content,
    });
    var data = json.decode(res.body);

    if (res.statusCode != HttpStatus.created) {
      toast(data['message']);
      return null;
    }

    return data['message'];
  }

  static Future<String?> drop(int infoId) async {
    var res = await BackendClient().post("/info/drop", {
      "info_id": infoId,
    });
    var data = json.decode(res.body);

    if (res.statusCode != HttpStatus.ok) {
      toast(data['message']);
      return null;
    }
    return data['message'];
  }
}
