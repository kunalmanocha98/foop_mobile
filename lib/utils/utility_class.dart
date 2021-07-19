import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/conversationPage/custom_web_view.dart';
import 'package:oho_works_app/enums/resolutionenums.dart';
import 'package:oho_works_app/enums/serviceTypeEnums.dart';
import 'package:oho_works_app/models/translate_model.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/network_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;

class Utility {
  Future<void> getFormattedDate(
      BuildContext context, DateTime date, String localeType) async {
    await initializeDateFormatting(localeType, null);
    var formatter = DateFormat.yMMMd(localeType);
    print(formatter.locale);
    return formatter.format(date);
  }
  String toCamelCase(String text) {
    if (text.length <= 1) return text.toUpperCase();
    var words = text.split(' ');
    var capitalized = words.map((word) {
      var first = word.substring(0, 1).toUpperCase();
      var rest = word.substring(1);
      return '$first$rest';
    });
    return capitalized.join(' ');
  }
  getCurrency(BuildContext context, num value) {
    Locale locale = Localizations.localeOf(context);
    var format = NumberFormat.simpleCurrency(locale: locale.toString());
    print("CURRENCY SYMBOL ${format.currencySymbol}");
    print("CURRENCY NAME ${format.currencyName}");
    return (NumberFormat.simpleCurrency(locale: format.locale).format(value));
  }

  getNumberBasedOnLocale(BuildContext context, num value) {
    Locale locale = Localizations.localeOf(context);
    var format = NumberFormat.simpleCurrency(locale: locale.toString());
    final oCcy = new NumberFormat("#,##0.00", format.locale);
    return oCcy.format(num);
  }

  String getCompatNumber(number) {
    return NumberFormat.compact().format(number);
  }

  String getDateFormat(String pattern, DateTime date) {
    var formatter = DateFormat(pattern);
    return formatter.format(date);
  }


  Future<bool> recognizeFace(File f) async {
    // return true;
    final faceDetector = GoogleMlKit.vision.faceDetector();
    print("**** REACHED HEREEEEEEELLLLLLLLL******");
    // final FaceDetector faceDetector = FirebaseVision.instance.faceDetector();
    // FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(f);
    final inputImage = InputImage.fromFile(f);
    print("**** REACHED HEREEEEEEE******");
    final List<Face> faces = await faceDetector.processImage(inputImage);
    print("**** REACHED HERE******");
    if(faces!=null && faces.isNotEmpty && faces.length>0)
      return true;
    else
      return false;
  }

  Future<void> writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return new File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  void screenUtilInit(BuildContext context){
    ScreenUtil.init(BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width,
        maxHeight: MediaQuery.of(context).size.height),designSize: Size(375, 812));
  }

  Future<bool> refreshList(BuildContext context) async {
    var body = jsonEncode({});
    await Calls().call(body, context, Config.REFRESH_LIST);
    return true;
  }

  String getUrlForImage(String url, RESOLUTION_TYPE resolution,SERVICE_TYPE service_type, {bool shouldprint =false} ){
    String imageName;
    if(url!=null) {
      var s = url.split('/');
      imageName = s[s.length - 1];
    }
    var queryParameters = {'name': imageName, 'resolution': resolution.type, 'service_type': service_type.type};
    var uri = Uri.https(Config.BASE_URL_WITHOUT_HTTP,Config.DYNAMIC_IMAGE_URL, queryParameters).toString();
    if(shouldprint) print("imageUrl------------------------------------------$uri");
    return uri;
  }


  String matchLinkRegex(String text){
     var regex = new RegExp(r"((https?:www\.)|(https?:\/\/)|(www\.))?[\w\-?=%.][-a-zA-Z0-9@:%.\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%\+.~#?&\/=]*)?");
     if(regex.hasMatch(text)) {
       var matchRegex = regex.firstMatch(text);
       return text.substring(matchRegex.start, matchRegex.end);
     }else{
       return "";
     }
  }

  int  getWordsCountFromRegex(String str){
    var regex = new RegExp(r"\w+");
    return regex.allMatches(str).length;
  }

  void openWebView(BuildContext context, String webLink) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return CustomWebView(selectedUrl: webLink,);
    }));
  }

  bool checkFileMimeType(String mimeType){
    return (mimeType == 'pdf'
        ||mimeType == 'ppt'
        ||mimeType == 'pptx'
        ||mimeType == 'docx'
        ||mimeType == 'doc'
        ||mimeType == 'jpg'
        ||mimeType == 'png'
        ||mimeType == 'jpeg'
        ||mimeType == 'mp4'
        ||mimeType == 'xlsx'
        ||mimeType == 'xls');
  }

  String getExtension(BuildContext context,String path, [int level = 1]){
    print('Extension+++'+p.context.extension(path, level).substring(1));
    return p.context.extension(path, level).substring(1);
  }

  String getFirstName(String title) {
    var str = title.split(' ');
    return str[0]??="";
  }

  int getTotalMinutes(int totalMinutes,DateTime enterTime){
    var dateNow = DateTime.now();
    var diff = dateNow.difference(enterTime).inMinutes;
    print(diff+totalMinutes);
    return diff+totalMinutes;
  }

  Future<String> translate(BuildContext context, String source, String input_lan_code, String output_lan_code, String type) async{
    final API_KEY = "AIzaSyDH4xJWHt-0rn6waxCUOtBvljw1jb5w4Kc";
    var authority ="translation.googleapis.com";
    var unencodedPath = "/language/translate/v2";
    var queryParams = {
      "source":input_lan_code,
      "target":output_lan_code,
      "format":type,
      "key":API_KEY,
      "q":source,
    };
    var uri = Uri.https(authority, unencodedPath ,queryParams);
    print(uri.toString());
    var value  = await NetworkUtil().post(context, uri.toString(),headers: null, body: null,encoding: null);
    var val = JsonDecoder().convert(value);
    var response  = TranslateResponse.fromJson(val);
    return response.data.translations[0].translatedText;
  }
}
