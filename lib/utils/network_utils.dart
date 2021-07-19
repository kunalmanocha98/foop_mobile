import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'app_localization.dart';
import 'colors.dart';

class NetworkUtil {
  // next three lines makes this class a Singleton
  static NetworkUtil _instance = new NetworkUtil.internal();
  BuildContext context;
  SharedPreferences prefs;

  NetworkUtil.internal();

  factory NetworkUtil() => _instance;

  final JsonDecoder _decoder = new JsonDecoder();

  Future<dynamic> get(String url) async {
    return http
        .get(Uri.parse(url))
        .then((http.Response response) {
          final String res = response.body;
          final int statusCode = response.statusCode;
          if (statusCode < 200 || statusCode >= 400 || json == null) {
            throw new Exception(_decoder.convert(res)['error']['message']);
          }
          return res;
        })
        .catchError((onError) {
          if (onError.toString().toLowerCase().contains("socket"))
            throw new Exception("Server timeout");
          else
            throw new Exception(
                onError.toString().replaceAll("Exception:", ""));
        })
        .timeout(Duration(seconds: 10))
        .catchError((onError) {
          if (onError.toString().toLowerCase().contains("timeout"))
            throw new Exception("Server timeout");
          else
            throw new Exception(
                onError.toString().replaceAll("Exception:", ""));
        });
  }

  Future<dynamic> post(BuildContext context, String url,
      {Map headers, body, encoding}) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        this.context = context;
        log('###########################net post...body....$body');
        return http
            .post(Uri.parse(url), body: body, headers: headers, encoding: encoding)
            .then((http.Response response) async {
          final String res = response.body;

          log('res#######################################$res');
          final int statusCode = response.statusCode;
          final body = jsonDecode(response.body);
          String stCode=  body["statusCode"];
          if (body["detail"] != null && body["detail"] == "Invalid token.") {
            prefs = await SharedPreferences.getInstance();
            ToastBuilder().showToast(
                AppLocalizations.of(context).translate("session_expire"),
                context,
                HexColor(AppColors.information));
            prefs.clear();

            SchedulerBinding.instance.addPostFrameCallback((_) {
              Navigator.pushNamedAndRemoveUntil(
                  context, "/login", (r) => false);
            });
          }
          else if (stCode!=null && stCode.startsWith("F"))
            { throw new Exception("Something is wrong !! please try later");}
          else if (statusCode < 200 || json == null) {

            throw new Exception(_decoder.convert(res)['error']['message']);
          } else if (statusCode >= 400 || json == null) {
            throw new Exception("Something Went Wrong!!");
          }
          return res;
        }).catchError((onError) {

          print("errooorrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr"+onError.toString());
          if (onError.toString().toLowerCase().contains("timeout"))
            throw new Exception("Server timeout");
          else
            throw new Exception("Something Went Wrong!!");
        });
      }
    } on SocketException catch (_) {
      ToastBuilder().showToast(
          AppLocalizations.of(context).translate("no_internet"),
          context,
          HexColor(AppColors.information));
      throw new Exception(
          AppLocalizations.of(context).translate("no_internet"));
    }
  }
}
