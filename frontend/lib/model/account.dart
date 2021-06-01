import 'dart:convert';
import 'dart:html';

import 'package:easy_pass/model/backend_client.dart';

class Account {
  late int accountId;
  late int userId;
  late int companyId;
  late String companyName;
  late String companyDescription;

  Account._fromJson(Map<String, dynamic> dict) {
    accountId = dict['account_id'];
    userId = dict['user_id'];
    companyId = dict['company_id'];
    companyName = dict['company_name'];
    companyDescription = dict['company_description'];
  }

  static Future<List<Account>?> get() async {
    var res = await BackendClient().get("/account/get", {});
    var data = json.decode(res.body);

    if (res.statusCode != HttpStatus.ok) {
      return data['message'];
    }

    List<Account> accountList = [];
    for (var account in data['accounts']) {
      accountList.add(Account._fromJson(account));
    }

    return accountList;
  }
}
