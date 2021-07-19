import 'dart:async';
import 'dart:convert';

import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/network_utils.dart';
import 'package:flutter/cupertino.dart';

class SignUpApi {
  NetworkUtil _netUtil = new NetworkUtil();

  final JsonDecoder _decoder = new JsonDecoder();

  Future<dynamic> signUp(String data, BuildContext context) async {
    print(data);
    var headers = {
      "Content-Type": 'application/json',

    };

    final _url = Config.REGISTER_USER;
    print(_url);
    return _netUtil
        .post(context, _url, body: data, headers: headers)
        .then((dynamic res) {
      return _decoder.convert(res.toString());
    });
  }

  Future<dynamic> activate(String data, BuildContext context,String deviceInfo) async {
    print(data);
    var headers = {
      "Content-Type": 'application/json',
      "devicedetails": deviceInfo,
    };
    final _url = Config.ACTIVATE_REGISTRATION;
    print (_url);
    print (data);
    return _netUtil
        .post(context, _url, body: data, headers: headers)
        .then((dynamic res) {
      return _decoder.convert(res.toString());
    });
  }
}
