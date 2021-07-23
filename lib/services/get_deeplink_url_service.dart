import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/models/create_deeplink.dart';
import 'package:oho_works_app/models/deeplink_response.dart';
import 'package:oho_works_app/profile_module/common_cards/testcard.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:share_plus/share_plus.dart';
class CreateDeeplink {
  void getDeeplink(String deepLinkType,String ownerId,int? userId,String shareType,BuildContext context) async {

    ProgressDialog progressDialog=ProgressDialog(context);

    CreateUrlPayload createUrlPayload = CreateUrlPayload();
    createUrlPayload.deepLinkType =deepLinkType;
    createUrlPayload.shareById = ownerId;
    createUrlPayload.shareItemId = userId;
    createUrlPayload.shareMedium = "";
    createUrlPayload.shareItemType= shareType;
    Calls()
        .call(jsonEncode(createUrlPayload), context,
        Config.SHARE_URL)
        .then((value) {
      progressDialog.hide();
      var res = DeeplinkResponse.fromJson(value);
      if (res.statusCode == Strings.success_code) {
        if(res.rows!=null && res.rows!.shortUrl!=null) {
          if(res.rows!.shareContentMessage!=null){
            StringBuffer buffer = StringBuffer();
            buffer.writeAll([res.rows!.shareContentMessage,"\n\n",res.rows!.shortUrl]);
            Share.share(buffer.toString());
          }else {
            Share.share(res.rows!.shortUrl!);
          }
        }
      } else {

      }
    }).catchError((onError) {
      print(onError);
      progressDialog.hide();
    });
  }
}
