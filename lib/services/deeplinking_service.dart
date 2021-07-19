import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/models/base_res.dart';
import 'package:oho_works_app/models/deeplinking_payload.dart';
import 'package:oho_works_app/services/navigation_service.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DynamicLinkService {
  final NavigationService _navigationService = locator<NavigationService>();


  void handleDynamicLinks(BuildContext context, SharedPreferences prefs) async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
          _handleDeepLink(dynamicLink, prefs, context);

        }, onError: (OnLinkErrorException e) async {

    });

    final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.getInitialLink();
    if(data!=null)
    {
      _handleDeepLink(data, prefs, context);

    }

  }

  void _handleDeepLink(PendingDynamicLinkData data, SharedPreferences prefs,
      BuildContext context) {
    final Uri deepLink = data?.link;
    if (deepLink != null) {

     saveUserResponseOnCLik(deepLink.pathSegments,context,deepLink.toString());
      if (deepLink.pathSegments.isNotEmpty &&
          deepLink.pathSegments.length > 0) {
        switch (deepLink.pathSegments[0]) {
          case "en-in":
            switch (deepLink.pathSegments[1]) {
              case "person":
                handleProfilePageDeepLinking(deepLink.pathSegments, prefs, context,true);
                break;
              case "institution":
                handleProfilePageDeepLinking(deepLink.pathSegments, prefs, context,true);
                break;
              case "feed":
                handlePostDeepLink(deepLink.pathSegments, prefs, context,true);
                break;
              case "room":
                handleRoom(deepLink.pathSegments, prefs, context,true);
                break;

            }
            break;

          case "person":
            handleProfilePageDeepLinking(deepLink.pathSegments, prefs, context,false);
            break;
          case "institution":
            handleProfilePageDeepLinking(deepLink.pathSegments, prefs, context,false);
            break;
          case "feed":
            handlePostDeepLink(deepLink.pathSegments, prefs, context,false);
            break;
          case "room":
            handleRoom(deepLink.pathSegments, prefs, context,false);
            break;
          case "cal":
            handleEvent(deepLink.pathSegments, prefs, context,false);
            break;

        }
      }
    }
  }

  void handleProfilePageDeepLinking(
      List<String> list, SharedPreferences prefs, BuildContext context,bool isEnIn) {
    DeepLinkingPayload deepLinkingPayload = DeepLinkingPayload();
    if(isEnIn)
      {
        if (list.length > 3) deepLinkingPayload.userId = int.parse(list[3]);
        if (list.length > 1) deepLinkingPayload.userType = list[0];
      }
   else
     {
       if (list.length > 3) deepLinkingPayload.userId = int.parse(list[3]);
       if (list.length > 1) deepLinkingPayload.userType = list[0];
     }
    _navigationService.navigateTo("/profile", deepLinkingPayload,context);
  }

  void handlePostDeepLink(
      List<String> list, SharedPreferences prefs, BuildContext context,bool isEnIn) {
    DeepLinkingPayload deepLinkingPayload = DeepLinkingPayload();
    if(isEnIn)
      {  if (list.length > 3) deepLinkingPayload.postId = int.parse(list[3]);
      if (list.length > 1) deepLinkingPayload.userType = list[0];}
    else{
      if (list.length > 2) deepLinkingPayload.postId = int.parse(list[2]);
      if (list.length > 1) deepLinkingPayload.userType = list[0];
    }

    _navigationService.navigateTo("/postDetailPage", deepLinkingPayload,context);
  }
  void handleRoom(
      List<String> list, SharedPreferences prefs, BuildContext context,bool isEnIn) {
    DeepLinkingPayload deepLinkingPayload = DeepLinkingPayload();
    if (list.length > 3) deepLinkingPayload.postId = int.parse(list[3]);
    if (list.length > 1) deepLinkingPayload.userType = list[1];
    _navigationService.navigateTo("/room_detail", deepLinkingPayload,context);
  }
  void handleEvent(
      List<String> list, SharedPreferences prefs, BuildContext context,bool isEnIn) {
    DeepLinkingPayload deepLinkingPayload = DeepLinkingPayload();
    if (list.length > 3) deepLinkingPayload.postId = int.parse(list[1]);
    if (list.length > 1) deepLinkingPayload.userType = list[1];
    _navigationService.navigateTo("/event_detail", deepLinkingPayload,context);
  }
  void saveUserResponseOnCLik( List<String> list,  BuildContext context,String url) async {
    SharedPreferences prefs=await SharedPreferences.getInstance();
    final body = jsonEncode(
        {"unique_share_url":url,
          "response_by_person_id":prefs.getInt("userId")}
    );

    Calls().call(body, context, Config.SAVE_DEEP_LINK_RESPONSE).then((value) {
      var res = BaseResponses.fromJson(value);
      if (res.statusCode == Strings.success_code) {

      } else {

      }
    }).catchError((onError) {

      print(onError);

    });
  }
}
