import 'dart:async';
import 'dart:convert';

import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/network_utils.dart';
import 'package:flutter/cupertino.dart';

class LoginApis {
  final NetworkUtil _netUtil =  NetworkUtil();
  final JsonDecoder _decoder =  JsonDecoder();

  Future<dynamic> loginApi(String data, BuildContext context,String deviceInfo) async {
    print(data);
    var headers = {
      "Content-Type": 'application/json',
      "devicedetails": deviceInfo,
    };
    final _url = Config.LOGIN_API;
    print(deviceInfo);
    print(_url);
    return _netUtil
        .post(context, _url, body: data, headers: headers)
        .then((dynamic res) {
      return _decoder.convert(res.toString());
    });
  }
}
