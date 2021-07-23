import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
// import 'package:multipart_request/multipart_request.dart';

class NetworkUtils {
  static NetworkUtils _instance = new NetworkUtils.internal();
  BuildContext? context;

  NetworkUtils.internal();

  factory NetworkUtils() => _instance;

  // final JsonDecoder _decoder = new JsonDecoder();

  Future<dynamic> upload(
      BuildContext context,
      String url,
      String? token,
      String filePath,
      String ownerType,
      String ownerId,
      String contextType,
      String? contextId,
      String subContextType,
      String subContextId,
      String? contentType,
      Function(int progress)? onProgressCallback,
      String? mimeType) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        this.context = context;

        final httpClient = HttpClient();

        final req = await httpClient.postUrl(Uri.parse(url));

        int byteCount = 0;

        var request = http.MultipartRequest('POST', Uri.parse(url));
        request.files.add(await http.MultipartFile.fromPath('attachment', filePath, contentType: MediaType(contentType!, mimeType!)));

        print("content Type -"+contentType+"  mimeType - "+mimeType);
        print(token);
        print("MediaUpload - Url -"+url);

        request.fields["owner_type"] = ownerType;
        request.fields["owner_id"] = ownerId;
        request.fields["context_type"] = contextType;
        request.fields["context_id"] = contextId!;
        request.fields["sub_context_type"] = subContextType;
        request.fields["sub_context_id"] = subContextId;

        print("MediaUpload - files -"+ request.fields.toString());

        var msStream = request.finalize();

        var totalByteLength = request.contentLength;

        req.contentLength = totalByteLength;

        // var headers = {"Authorization": ('Token' + " " + token)};
        // request.headers.addAll(headers);
        // request.headers.addAll(headers);

        req.headers.set(
            HttpHeaders.contentTypeHeader, request.headers[HttpHeaders.contentTypeHeader]!);
        req.headers.add('Authorization', ('Token' + " " + token!));


        Stream<List<int>> streamUpload = msStream.transform(
          new StreamTransformer.fromHandlers(
            handleData: (data, sink) {
              sink.add(data);

              byteCount += data.length;

              var pr = byteCount/totalByteLength;
              // print("progress -- ${(pr*100).toInt()}%");
              if(onProgressCallback!=null) {
                onProgressCallback((pr * 100).toInt());
              }
              // if (onUploadProgress != null) {
              //   onUploadProgress(byteCount, totalByteLength);
              //   // CALL STATUS CALLBACK;
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
        await req.addStream(streamUpload);
        final httpResponse = await req.close();
        // final int statusCode = httpResponse.statusCode;
        // if (statusCode < 200 || statusCode >= 400 || json == null) {
        // }
        return await readResponseAsString(httpResponse);





        // return await request.send().then((response) {
        //
        //   final int statusCode = response.statusCode;
        //   if (statusCode < 200 || statusCode >= 400 || json == null) {
        //     print(response.reasonPhrase);
        //     throw new Exception(
        //         _decoder.convert(response.reasonPhrase)['error']['message']);
        //   }
        //   // print(response.stream.bytesToString());
        //
        //   // response.stream.transform(utf8.decoder).listen((value) {
        //   //     print("utf"+value);
        //   // });
        //   // print(response.stream.bytesToString());
        //
        //   return response.stream.bytesToString();
        // }).catchError((onError) {
        //   print(onError.toString());
        //   if (onError.toString().toLowerCase().contains("timeout"))
        //     throw new Exception("Server timeout");
        //   else
        //     throw new Exception(
        //         onError.toString().replaceAll("Exception:", ""));
        // });
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
