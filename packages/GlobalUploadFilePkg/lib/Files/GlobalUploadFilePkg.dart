library global_file_upload_pkg;

import 'dart:io';

import 'package:GlobalUploadFilePkg/NetworkFile/apiCall.dart';
import 'package:GlobalUploadFilePkg/Utils/StringUtils.dart';
import 'package:flutter/material.dart';

class UploadFile {
  File? file;
  BuildContext context;
  String ownerType;
  String ownerId;
  String contextType;
  String? contextId;
  String subContextType;
  String subContextId;
  String baseUrl;
  String? token;
  String? contentType;
  String? mimeType;
  Function(int progress)? onProgressCallback;

  UploadFile(
      {required this.baseUrl,
      required this.context,
      required this.file,
      required this.token,
      required this.ownerType,
      required this.ownerId,
      required this.contextType,
      required this.contextId,
      required this.subContextType,
      required this.subContextId,
      required this.contentType,
      required this.mimeType,
       this.onProgressCallback});

  Future<dynamic> uploadFile() async {
    String url = baseUrl + StringUtils.imageUploadUrl;
print(url);
    ApiCall apiCall = ApiCall();
    return await apiCall.upload(
        context,
        url,
        file!.path,
        token,
        ownerType,
        ownerId,
        contextType,
        contextId,
        subContextType,
        subContextId,
        contentType,
        onProgressCallback,
        mimeType);
  }
}
