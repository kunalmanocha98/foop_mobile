import 'dart:async';
import 'dart:convert';

import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/network_utils.dart';
import 'package:flutter/cupertino.dart';

class RecoverPasswordApis {
  NetworkUtil _netUtil = new NetworkUtil();

  final JsonDecoder _decoder = new JsonDecoder();

  Future<dynamic> recoverPassword(String data, BuildContext context) async {
    print(data);
    var headers = {
      "Content-Type": 'application/json',
    };
    final _url = Config.RECOVER_PASSWORD;
    return _netUtil
        .post(context, _url, body: data, headers: headers)
        .then((dynamic res) {
      return _decoder.convert(res.toString());
    });
  }

  Future<dynamic> recoverPasswordOtp(BuildContext? context, String data) async {
    print(data);
    var headers = {
      "Content-Type": 'application/json',
    };
    final _url = Config.RECOVER_PASSWORD_OTP;
    return _netUtil
        .post(context, _url, body: data, headers: headers)
        .then((dynamic res) {
      return _decoder.convert(res.toString());
    });
  }

  Future<dynamic> resendOtp(BuildContext context, String data) async {
    print(data);
    final headers = {
      "Content-Type": 'application/json',
    };
    final _url = Config.RESEND_OTP;
    return _netUtil
        .post(context, _url, body: data, headers: headers)
        .then((dynamic res) {
      return _decoder.convert(res.toString());
    });
  }

  Future<dynamic> resetPassword(String data, BuildContext context) async {
    print(data);
    var headers = {
      "Content-Type": 'application/json',
    };
    final _url = Config.RESET_PASSWORD;
    return _netUtil
        .post(context, _url, body: data, headers: headers)
        .then((dynamic res) {
      return _decoder.convert(res.toString());
    });
  }
}
