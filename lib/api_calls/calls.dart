import 'dart:async';
import 'dart:convert';

import 'package:oho_works_app/utils/network_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Calls {
  NetworkUtil _netUtil = new NetworkUtil();
  SharedPreferences prefs;

  final JsonDecoder _decoder = new JsonDecoder();
  Future<dynamic> callWithDeviceInfo(String data, BuildContext context, String url,String deviceInfo) async {
    prefs = await SharedPreferences.getInstance();
    print(data);
    print('Tdeviceinfpppppppppppppppppppppppppppp' + " " + deviceInfo);
    var headers;
    if (prefs.getString("token") != null) {
      headers = {
        "Content-Type": 'application/json',
        "Authorization": 'Token' + " " + prefs.getString("token"),
        "devicedetails": deviceInfo,
      };

      print(url);
    } else {
      headers = {
        "Content-Type": 'application/json',
        "devicedetails": deviceInfo,
      };

    }

    return _netUtil
        .post(context, url, body: data, headers: headers)
        .then((dynamic res) {
      return _decoder.convert(res.toString());
    });
  }
  Future<dynamic> call(String data, BuildContext context, String url,{bool customToken=false ,String token}) async {
    prefs = await SharedPreferences.getInstance();
    var headers;
    if(customToken && token.isNotEmpty){
      headers = {
        "Content-Type": 'application/json',
        "Authorization": token
      };
      print('Token' + " " + prefs.getString("token"));
      print(url);
    }else {
      if (prefs.getString("token") != null) {
        headers = {
          "Content-Type": 'application/json',
          "Authorization": 'Token' + " " + prefs.getString("token")
        };
        print('Token' + " " + prefs.getString("token"));
        print(url);
      } else {
        headers = {
          "Content-Type": 'application/json',
        };
        print('Token' +
            "Nooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo");
      }
    }

    return _netUtil
        .post(context, url, body: data, headers: headers)
        .then((dynamic res) {
      return _decoder.convert(res.toString());
    });
  }
  Future<dynamic> calWithoutToken(String data, BuildContext context, String url) async {
    prefs = await SharedPreferences.getInstance();
    var headers;
    if (prefs.getString("token") != null) {
      headers = {
        "Content-Type": 'application/json',
      };
      print('Token' + " " + prefs.getString("token"));
      print(url);
    } else {
      headers = {
        "Content-Type": 'application/json',
      };
      print('Token' +
          "Nooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo");
    }

    return _netUtil
        .post(context, url, body: data, headers: headers)
        .then((dynamic res) {
      return _decoder.convert(res.toString());
    });
  }

//
// Future<dynamic> createActivityToken(BuildContext context,String activityCode) async{
//   prefs= await SharedPreferences.getInstance();
//   print(data);
//   var headers;
//   if(prefs.getString("token")!=null)
//   {
//     headers = {
//       "Content-Type": 'application/json',
//       "Authorization":  ('Token'+" "+prefs.getString("token"))
//     };
//     print('Token'+" "+prefs.getString("token"));
//     print(url);
//   }
//   else{
//     headers = {
//       "Content-Type": 'application/json',
//
//     };
//     print('Token'+ "Nooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo");
//   }
//
//
//   return _netUtil.post(context,url, body: data,headers:headers).then((dynamic res) {
//     return _decoder.convert(res.toString());
//   });
// }

}
