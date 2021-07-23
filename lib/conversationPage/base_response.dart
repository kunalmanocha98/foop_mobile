// import 'package:flutter/cupertino.dart';

// import 'dart:convert';

// import 'package:http/http.dart';


class BaseResponse {
  String? statusCode;
  String? message;


  BaseResponse({this.statusCode, this.message, });

  BaseResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;

    return data;
  }
}
