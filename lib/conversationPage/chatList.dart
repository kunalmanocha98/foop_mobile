// import 'dart:io';
import 'dart:convert';

import 'package:oho_works_app/api_calls/logout_api.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/models/common_response.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatListPage extends StatefulWidget {
  StateChatList createState() => StateChatList();
}

class StateChatList extends State<ChatListPage> {

  late SharedPreferences prefs;
  TextStyleElements? styleElements;

  void logout() async {

    LogOutApi().logOut(context,"").then((value) async {

      if (value != null) {
        prefs = await SharedPreferences.getInstance();
        var data = CommonBasicResponse.fromJson(value);
        ToastBuilder().showToast(data.message!, context,HexColor(AppColors.information));
        prefs.clear();
        Navigator.pushNamedAndRemoveUntil(context, "/", (r) => false);
      }
    }).catchError((onError) async {
      ToastBuilder().showToast(onError.toString(), context,HexColor(AppColors.information));

    });
  }

  @override
  void initState() {
    super.initState();
  }

  StateChatList();

  final body = jsonEncode({
    "conversationOwnerId": '1580807502972',
    "conversationOwnerType": 'personal',
    "businessId": '145274578',
    "registeredUserId": '145274578',
    "pageNo": 0,
    "pageNumber": 1,
    "pageSize": 5
  });

  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);

    ScreenUtil.init;

    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        // ignore: missing_return,
        _onBackPressed();
        return new Future(() => false);
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: HexColor(AppColors.appColorBackground),
          appBar: TricycleAppBar().getCustomAppBarWithSearch(
              context,
              appBarTitle: 'Chat',
              onBackButtonPress: (){_onBackPressed();},
              onSearchValueChanged: (value){},
              actions: <Widget>[
                Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: GestureDetector(
                        onTap: () {},
                        child: IconButton(
                          icon: Image.asset(
                            'assets/appimages/logout.png',
                            width: 15,
                            height: 15,
                          ),
                          tooltip: 'Log Out',
                          onPressed: () {
                            logout();
                          },
                        ))),
              ]),
          body: Container(
              /*  child: FutureBuilder<dynamic>(
                future: ConversationsApi().getConversationsList(body, context),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    // print(_name(snapshot.data[0]));

                    return ListView.builder(
                        padding: EdgeInsets.all(8),
                        itemCount: snapshot.data["rows"].length,
                        itemBuilder: (BuildContext context, int index) {
                          print(snapshot.data["rows"][index]["conversationName"]);
                          return GestureDetector(
                            child: Card(
                                child: Column(
                              children: <Widget>[
                                Align(
                                    alignment: Alignment.topRight,
                                    child: Container(
                                      margin:
                                          const EdgeInsets.only(top: 4, right: 8),
                                      child: AppLocalizations.of(context).translate('sunday'),
                                        style: TextStyle(
                                          fontFamily: 'Source Sans Pro',
                                          fontSize: ScreenUtil().setSp(28,
                                              ),
                                          color: const Color(0x59000000),
                                        ),
                                      ),
                                    )),
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 16, right: 16, bottom: 16),
                                  child: Row(
                                    children: <Widget>[
                                      Align(
                                          alignment: Alignment.centerLeft,
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        UserProfile(
                                                      id: "",
                                                    ),
                                                  ));
                                            },
                                            child: Container(
                                              width: 52.0,
                                              height: 52.0,
                                              margin:
                                                  const EdgeInsets.only(right: 8),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.elliptical(
                                                        26.0, 26.0)),
                                                image: DecorationImage(
                                                  image: CachedNetworkImageProvider(snapshot
                                                          .data["rows"][index][
                                                      "conversationImageThumbnail"]),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          )),
                                      Expanded(
                                        child: Column(
                                          children: <Widget>[
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                snapshot.data["rows"][index]
                                                    ["conversationName"],
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: 'Source Sans Pro',
                                                  fontSize: ScreenUtil().setSp(46,
                                                      ),
                                                  color: HexColor(AppColors.appColorBlack85),
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                snapshot.data["rows"][index]
                                                    ["lastMessage"],
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: 'Source Sans Pro',
                                                  fontSize: ScreenUtil().setSp(40,
                                                      ),
                                                  color: HexColor(AppColors.appColorBlack35),
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.center,
                                        child: Stack(
                                          children: <Widget>[
                                            Container(
                                              width: 20.0,
                                              height: 20.0,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(4.0),
                                                color: const HexColor(AppColors.appMainColor),
                                              ),
                                            ),
                                            Positioned.fill(
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  snapshot.data["rows"][index]
                                                          ["unreadCount"]
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontFamily: 'Source Sans Pro',
                                                    fontSize: 10,
                                                    color:
                                                        const HexColor(AppColors.appColorWhite),
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            )),
                            onTap: () {
                              print("Tapped");
                              Navigator.pushNamed(context, '/conversationPage');
                            },
                          );
                        });
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                }),*/
              ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text(
                AppLocalizations.of(context)!.translate('are_you_sure')),
            content: new Text(
                AppLocalizations.of(context)!.translate('exit_tricycle')),
            actions: <Widget>[
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: Text(
                    AppLocalizations.of(context)!.translate('no').toUpperCase()),
              ),
              SizedBox(height: 16),
              new GestureDetector(
                onTap: () {
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                },
                child: Text(AppLocalizations.of(context)!
                    .translate('yes')
                    .toUpperCase()),
              ),
            ],
          ),
        ).then((value) => value as bool) ;

  }
}
