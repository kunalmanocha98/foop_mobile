import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/app_buttons.dart';
import 'package:oho_works_app/components/appAvatar.dart';
import 'package:oho_works_app/enums/resolutionenums.dart';
import 'package:oho_works_app/enums/serviceTypeEnums.dart';
import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/models/Notifications/notificationsmodels.dart';
import 'package:oho_works_app/models/deeplinking_payload.dart';
import 'package:oho_works_app/models/notification_count_response.dart';
import 'package:oho_works_app/services/navigation_service.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/utility_class.dart';
import 'package:flutter/material.dart';
import 'package:oho_works_app/components/paginator.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class NotificationsPage extends StatefulWidget {
  Null Function()? callback;

  @override
  NotificationsPageState createState() => NotificationsPageState(callback);

  NotificationsPage({
    Key? key,
    required this.callback,
  }) : super(key: key);
}

class NotificationsPageState extends State<NotificationsPage> {
  GlobalKey<PaginatorState> paginatorKey = GlobalKey();
  late TextStyleElements styleElements;
  SharedPreferences? prefs;
  Null Function()? callback;
  List<NotificationItem> notificationItemList = [];

  @override
  void initState() {
    updateCount();
    super.initState();
  }

  Future<Null> refreshList() async {
    paginatorKey.currentState!.changeState(resetState: true);
    await new Future.delayed(new Duration(seconds: 2));

    return null;
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return SafeArea(
      child: Scaffold(
        appBar: appAppBar().getCustomAppBar(context,
            appBarTitle: AppLocalizations.of(context)!.translate('notification'),
            onBackButtonPress: () {
              Navigator.pop(context);
            }),
        body: RefreshIndicator(
          onRefresh: refreshList,
          child: Paginator.listView(
            key: paginatorKey,
            pageLoadFuture: fetchlist,
            pageItemsGetter: listItemsGetter,
            listItemBuilder: listItemGetter,
            loadingWidgetBuilder: CustomPaginator(context).loadingWidgetMaker,
            errorWidgetBuilder: CustomPaginator(context).blank,
            emptyListWidgetBuilder:
            CustomPaginator(context).emptyListWidgetMaker,
            totalItemsGetter: totalPagesGetter,
            pageErrorChecker: CustomPaginator(context).pageErrorChecker,
          ),
        ),
      ),
    );
  }

  void updateCount() async {
    prefs ??= await SharedPreferences.getInstance();
    final body =
    jsonEncode({"personId": prefs!.getInt("userId"), "type": "bell"});
    Calls().call(body, context, Config.UPDATE_COUNT).then((value) {
      var res = NotificationCountResponse.fromJson(value);
      if (res.statusCode == Strings.success_code) {
        callback!();
      } else {}
    }).catchError((onError) {
      print(onError);
    });
  }

  void getNotificationCount(pid) async {
    prefs ??= await SharedPreferences.getInstance();
    final body = jsonEncode(
        {"personId": prefs!.getInt("userId"), "pid": pid, "type": "read"});
    Calls().call(body, context, Config.UPDATE_COUNT).then((value) {
      var res = NotificationCountResponse.fromJson(value);
      if (res.statusCode == Strings.success_code) {
        callback!();
      } else {}
    }).catchError((onError) {
      print(onError);
    });
  }

  Future<NotificationListResponse> fetchlist(int page) async {
    prefs ??= await SharedPreferences.getInstance();
    NotificationListRequest payload = NotificationListRequest();
    payload.personId = prefs!.getInt(Strings.userId).toString();
    payload.pageSize = 5;
    payload.pageNumber = page;
    var res = await Calls()
        .call(jsonEncode(payload), context, Config.GETBELLNOTIFICATIONS);

    return NotificationListResponse.fromJson(res);
  }

  List<NotificationItem>? listItemsGetter(NotificationListResponse? pageData) {
    notificationItemList.addAll(pageData!.rows!);
    return pageData.rows;
  }

  Widget listItemGetter(itemData, int index) {
    NotificationItem item = itemData;
    return InkWell(
      onTap: () {
        var uri = Uri.parse(item.notificationMobileDeepLink!);
        print("deeplink-" + item.notificationMobileDeepLink!);
        if (uri.pathSegments.isNotEmpty && uri.pathSegments.length > 0) {
          switch (uri.pathSegments[0]) {
            case "person":
              handleProfilePageDeepLinking(
                  uri.pathSegments, prefs, context, item.pid);
              break;
            case "feed":
              handlePostDeepLink(uri.pathSegments, prefs, context, item.pid,int.parse(uri.pathSegments[2]),uri.pathSegments[0]);
              break;
            case "buddy":
              handleBuddyDeepLink(uri.pathSegments, prefs, context, item.pid,
                  item.notificationActorImage);
              break;
            case "cal":
              handleEventDeepLink(uri.pathSegments, prefs, context, item.pid,
                  item.notificationActorImage);
              break;
            case "birthday":
              handleMessages("notification",  uri.pathSegments[1], context,);
              break;
            case "en-in":
             {

               switch (uri.pathSegments[1]) {
                 case "person":
                   handleProfilePageDeepLinking(
                       uri.pathSegments, prefs, context, item.pid);
                   break;
                 case "feed":
                   handlePostDeepLink(uri.pathSegments, prefs, context, item.pid,int.parse(uri.pathSegments[3]),uri.pathSegments[1]);
                   break;
                 case "buddy":
                   handleBuddyDeepLink(uri.pathSegments, prefs, context, item.pid,
                       item.notificationActorImage);
                   break;
                 case "cal":
                   handleEventDeepLink(uri.pathSegments, prefs, context, item.pid,
                       item.notificationActorImage);
                   break;
                 case "birthday":
                   handleMessages("notification",  uri.pathSegments[1], context,);
                   break;

               }
             }
              break;
          }
        }
        setState(() {
          notificationItemList[index].isRead = 'Y';
        });
      },
      child: ListTile(
        leading: appAvatar(
          service_type: SERVICE_TYPE.PERSON,
          resolution_type: RESOLUTION_TYPE.R64,
          imageUrl: item.notificationActorImage,
          size: 36,
        ),
        title: Text(
          item.notificationText!,
          style: styleElements
              .subtitle2ThemeScalable(context)
              .copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Text(
                Utility().getDateFormat(
                    "dd MMM yyyy,hh:mm",
                    DateTime.fromMillisecondsSinceEpoch(
                        int.parse(item.notificationDate!))),
                style: styleElements.captionThemeScalable(context),
              ),
            ),
            Visibility(
              visible: isBuddyVerification(item.notificationMobileDeepLink!),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  appTextButton(
                    onPressed: () {},
                    shape: RoundedRectangleBorder(),
                    child: Text(
                      AppLocalizations.of(context)!.translate('ignore'),
                      style: styleElements
                          .captionThemeScalable(context)
                          .copyWith(color: HexColor(AppColors.appMainColor)),
                    ),
                  ),
                  appTextButton(
                    onPressed: () {
                      var uri = Uri.parse(item.notificationMobileDeepLink!);
                      handleBuddyDeepLink(uri.pathSegments, prefs, context, item.pid,
                          item.notificationActorImage);
                    },
                    shape: RoundedRectangleBorder(),
                    child: Text(
                      AppLocalizations.of(context)!.translate('verify'),
                      style: styleElements
                          .captionThemeScalable(context)
                          .copyWith(color: HexColor(AppColors.appMainColor)),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        trailing: Visibility(
          visible: item.isRead == 'N',
          child: Container(
            height: 12,
            width: 12,
            decoration: BoxDecoration(
              color: HexColor(AppColors.appMainColor),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }

  void handlePostDeepLink(List<String> list, SharedPreferences? prefs,
      BuildContext context, String? pid,int postId,String type) {
    getNotificationCount(pid);
    DeepLinkingPayload deepLinkingPayload = DeepLinkingPayload();
   deepLinkingPayload.postId = postId;
   deepLinkingPayload.userType = type;
    locator<NavigationService>()
        .navigateTo("/postDetailPage", deepLinkingPayload, context);
  }

  void handleBuddyDeepLink(List<String> list, SharedPreferences? prefs,
      BuildContext context, String? pid, String? profileImage) {
    getNotificationCount(pid);
    DeepLinkingPayload deepLinkingPayload = DeepLinkingPayload();
    deepLinkingPayload.institutionUserId = int.parse(list[1]);
    deepLinkingPayload.institutionId = int.parse(list[2]);
    deepLinkingPayload.personId = int.parse(list[3]);
    deepLinkingPayload.profileImage = profileImage;
    locator<NavigationService>()
        .navigateTo("/BuddyApproval", deepLinkingPayload, context);
  }
  void handleEventDeepLink(List<String> list, SharedPreferences? prefs,
      BuildContext context, String? pid, String? profileImage) {
    getNotificationCount(pid);
    DeepLinkingPayload deepLinkingPayload = DeepLinkingPayload();
    deepLinkingPayload.postId = int.parse(list[1]);
    locator<NavigationService>()
        .navigateTo("/event_detail", deepLinkingPayload, context);
  }

  void handleProfilePageDeepLinking(List<String> list, SharedPreferences? prefs,
      BuildContext context, String? pid) {
    getNotificationCount(pid);
    DeepLinkingPayload deepLinkingPayload = DeepLinkingPayload();
    if (list.length > 3) deepLinkingPayload.userId = int.parse(list[3]);
    if (list.length > 1) deepLinkingPayload.userType = list[0];
    locator<NavigationService>()
        .navigateTo("/profile", deepLinkingPayload, context);
  }
  void handleMessages(String type, String id, BuildContext context) {
    DeepLinkingPayload deepLinkingPayload = DeepLinkingPayload();
    deepLinkingPayload.id = id;
    deepLinkingPayload.type = "notification";
    locator<NavigationService>()
        .navigateTo("/ChatHistoryPage", deepLinkingPayload, context);
  }
  int? totalPagesGetter(NotificationListResponse pageData) {
    return pageData.total;
  }

  NotificationsPageState(this.callback);

  bool isBuddyVerification(String url) {
    var uri = Uri.parse(url);
    if (uri.pathSegments.isNotEmpty && uri.pathSegments.length > 0) {
      if(uri.pathSegments[0] == 'buddy'){
        return true;
      }else{
        return false;
      }
    }else{
      return false;
    }

  }
}
