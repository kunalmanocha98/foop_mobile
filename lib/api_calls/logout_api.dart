import 'dart:async';
import 'dart:convert';

import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/network_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogOutApi {
  NetworkUtil _netUtil = new NetworkUtil();

  final JsonDecoder _decoder = new JsonDecoder();
  SharedPreferences prefs;

  Future<dynamic> logOut(BuildContext context,String deviceInfo) async {
    prefs = await SharedPreferences.getInstance();
    print('token===========' + ('Token' + " " + deviceInfo));
    var headers = {
      "Content-Type": 'application/json',
      "Authorization": ('Token' + " " + prefs.getString("token")),
      "devicedetails": deviceInfo,
    };
    final _url = Config.LOGOUT_API;
    return _netUtil.post(context, _url, headers: headers).then((dynamic res) {
      return _decoder.convert(res.toString());
    });
  }
}
