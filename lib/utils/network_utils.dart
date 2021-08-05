import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_localization.dart';
import 'colors.dart';
import 'imagepickerAndCropper.dart';

class NetworkUtil {
  // next three lines makes this class a Singleton
  static NetworkUtil _instance = new NetworkUtil.internal();
  BuildContext? context;
  late SharedPreferences prefs;

  NetworkUtil.internal();

  factory NetworkUtil() => _instance;

  final JsonDecoder _decoder = new JsonDecoder();

  Future<dynamic> get(String url) async {
    return http
        .get(Uri.parse(url))
        .then((http.Response response) {
          final String res = response.body;
          final int statusCode = response.statusCode;
          if (statusCode < 200 || statusCode >= 400) {
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

  Future<dynamic> post(BuildContext? context, String url,
      {Map? headers, body, encoding}) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        this.context = context;
        log('###########################net post...body....$body');
        return http
            .post(Uri.parse(url), body: body, headers: headers as Map<String, String>?, encoding: encoding)
            .then((http.Response response) async {


          final String res = response.body;

          log('res#######################################$res');
          final int statusCode = response.statusCode;
          final body = jsonDecode(response.body);
          String? stCode=  body["statusCode"];
          if (body["detail"] != null && body["detail"] == "Invalid token.") {
            prefs = await SharedPreferences.getInstance();
            ToastBuilder().showToast(
                AppLocalizations.of(context!)!.translate("session_expire"),
                context,
                HexColor(AppColors.information));
            prefs.clear();

            SchedulerBinding.instance!.addPostFrameCallback((_) {
              Navigator.pushNamedAndRemoveUntil(
                  context, "/login", (r) => false);
            });
          }
          else if (stCode!=null && stCode.startsWith("F"))
            { throw new Exception("Something is wrong !! please try later");}
          else if (statusCode < 200) {

            throw new Exception(_decoder.convert(res)['error']['message']);
          } else if (statusCode >= 400) {
            throw new Exception("Something Went Wrong!!");
          }
          return res;
        }).catchError((onError) {

          print(onError.toString());
          if (onError.toString().toLowerCase().contains("timeout"))
            throw new Exception("Server timeout");
          else
            throw new Exception("Something Went Wrong!!");
        });
      }
    } on SocketException catch (_) {
      ToastBuilder().showToast(
          AppLocalizations.of(context!)!.translate("no_internet"),
          context,
          HexColor(AppColors.information));
      throw new Exception(
          AppLocalizations.of(context)!.translate("no_internet"));
    }
  }
  Future<dynamic> multipartRequest( String url, List<File> files,Map<String, String> fields, String token,String emailToken ,{Map? headers, body, encoding}) async{
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        this.context = context;

        final httpClient = HttpClient();

        final req = await httpClient.postUrl(Uri.parse(url));
        // int byteCount = 0;

        var request = http.MultipartRequest('POST', Uri.parse(url));
        if(files.isNotEmpty) {
          for (File filePath in files) {
            var contentType = ImagePickerAndCropperUtil().getMimeandContentType(filePath.path);
            request.files.add(await http.MultipartFile.fromPath(
                'attachment', filePath.path,
                contentType: MediaType(contentType[1], contentType[0])));
          }
        }

        request.fields.addAll(fields);

        // // print("content Type -"+contentType+"  mimeType - "+mimeType);
        // // print(token);
        // // print("MediaUpload - Url -"+url);
        //
        // request.fields["username"] = ownerType;
        // request.fields["from_address"] = ownerId;
        // request.fields["to_addresses"] = contextType;
        // request.fields["cc_addresses"] = contextId;
        // request.fields["bcc_addresses"] = subContextType;
        // request.fields["sub_context_id"] = subContextId;


        print("MediaUpload - files -"+ request.fields.toString());

        var msStream = request.finalize();

        var totalByteLength = request.contentLength;

        req.contentLength = totalByteLength;

        req.headers.set(HttpHeaders.contentTypeHeader, request.headers[HttpHeaders.contentTypeHeader]!);
        req.headers.add('Authorization', ('Token' + " " + token));
        req.headers.add('EmailAuthorization', ('Token' + " " +emailToken));


        Stream<List<int>> streamUpload = msStream.transform(
          new StreamTransformer.fromHandlers(
            handleData: (data, sink) {
              sink.add(data);

              // byteCount += data.length;

              // var pr = byteCount/totalByteLength;
              // print("progress -- ${(pr*100).toInt()}%");
              // if(onProgressCallback!=null) {
              //   onProgressCallback((pr * 100).toInt());
              // }
            },
            handleError: (error, stack, sink) {
              throw error;
            },
            handleDone: (sink) {
              sink.close();
              // UPLOAD DONE;
            },
          ),
        );
        log(token);
        log(url);
        log(request.files.toString());
        log(request.fields.toString());
        await req.addStream(streamUpload);
        final httpResponse = await req.close();
        var res = await readResponseAsString(httpResponse);
        log(res);
        return res;

      }
    } on SocketException catch (_) {
      Fluttertoast.showToast(
          msg: "No Internet",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.lightGreen,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
  static Future<String> readResponseAsString(HttpClientResponse response) {
    var completer = new Completer<String>();
    var contents = new StringBuffer();
    response.transform(utf8.decoder).listen((String data) {
      contents.write(data);
    }, onDone: () => completer.complete(contents.toString()));
    return completer.future;
  }
}
