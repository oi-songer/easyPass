import 'dart:convert';
import 'dart:html';

import 'package:easy_pass/model/backend_client.dart';
import 'package:easy_pass/utils/function.dart';

class Requirement {
  late int requirementId;
  late int templateId;
  late int companyId;
  late String permission;
  late bool optional;

  static Future<String?> create(
      int templateId, String permission, bool optional) async {
    var res = await BackendClient().post("/requirement/create", {
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

  static Future<String?> modify(
      int templateId, String permission, bool optional) async {
    var res = await BackendClient().post("/requirement/modify", {
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

  static Future<String?> remove(int requirementId) async {
    var res = await BackendClient().post("/requirement/remove", {
      "template_id": requirementId,
    });
    var data = json.decode(res.body);

    if (res.statusCode != HttpStatus.ok) {
      toast(data['message']);
      return null;
    }
    return data['message'];
  }
}
