import 'dart:convert';

import 'package:GlobalUploadFilePkg/NetworkFile/NetworkUtils.dart';
import 'package:flutter/widgets.dart';

class ApiCall {
  NetworkUtils _netUtil = new NetworkUtils();
  final JsonDecoder _decoder = new JsonDecoder();

  Future<dynamic> upload(
      BuildContext context,
      String url,
      String filePath,
      String? token,
      String ownerType,
      String ownerId,
      String contextType,
      String? contextId,
      String subContextType,
      String subContextId,
      String? contentType,
      Function(int progress)? onProgressCallback,
      String? mimeType) async {
    return _netUtil
        .upload(context, url, token, filePath, ownerType, ownerId, contextType,
            contextId, subContextType, subContextId, contentType, onProgressCallback,mimeType)
        .then((dynamic res) {
      return _decoder.convert(res.toString());
    });
  }
}
