import 'package:oho_works_app/components/searchBox.dart';
import 'package:oho_works_app/profile_module/pages/profile_page.dart';
import 'package:oho_works_app/ui/RoomModule/room_detail_page.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class AppBarWithProfileChat extends StatelessWidget with PreferredSizeWidget {
  final double appBarHeight = 56.0;
  String? imageUrl;
  String? title;
  String? status;
  String? userType;
  int? userId;
  bool? isGroupConversation;
  int? notificationCount;
  Null Function()? callBack;
  Null Function(String value)? onSearch;
  Null Function(String value)? onItemSelect;
  Function? onCallCallback;
  Function? onVideoCallback;
  bool? isHomepage;
  Function? backButtonPress;
  bool? isNotificationVisible;
  bool? isSearch = false;
  int? roomId;
  String? roomName;
  bool? showCallbuttons;

  @override
  get preferredSize => Size.fromHeight(appBarHeight);
  late TextStyleElements styleElements;

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            iconTheme: IconThemeData(
              color:
              HexColor(AppColors.primaryTextColor), //change your color here
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                InkWell(
                  onTap: backButtonPress as void Function()?,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: callBack,
                        child: Icon(
                          Icons.keyboard_backspace_rounded,
                          size: 20.0.h,
                          // add custom icons also
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 36,
                          width: 36,
                          child: CircleAvatar(
                            radius: 36,
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.white,
                            child: ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: imageUrl!,
                                placeholder: (context, url) => Center(
                                    child: Image.asset(
                                      'assets/appimages/userplaceholder.jpg',
                                    )),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: isSearch!
                      ? SearchBox(
                    onvalueChanged: (String value) {
                      onSearch!(value);
                    },
                    hintText:
                    AppLocalizations.of(context)!.translate("search"),
                  )
                      : GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      isGroupConversation!
                          ? Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RoomDetailPage(
                                  null,
                                  null,
                                  null,
                                  null,
                                  null,
                                  roomId,
                                  roomName)))
                          : Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserProfileCards(
                                userType:
                                userType == "institution"
                                    ? "institution"
                                    : "thirdPerson",
                                userId: userId,
                                callback: () {
                                  callBack!();
                                },
                                currentPosition: 1,
                                type: null,
                              )));
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title ?? "",
                          style: title != null
                              ? styleElements
                              .subtitle1ThemeScalable(context)
                              .copyWith(fontWeight: FontWeight.w600)
                              : styleElements
                              .headline5ThemeScalable(context),
                        ),
                        Text(status ?? "",
                            style: styleElements
                                .captionThemeScalable(context)),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: showCallbuttons!,
                  child: Container(
                    child: Stack(
                      children: <Widget>[
                        new IconButton(
                            icon: Icon(
                              Icons.call_outlined,
                              size: 24.0,
                              color: Colors.black54,
                            ),
                            onPressed: onCallCallback as void Function()?,
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: showCallbuttons!,
                  child: Container(
                    child: Stack(
                      children: <Widget>[
                        new IconButton(
                            icon: Icon(
                              Icons.videocam_outlined,
                              size: 24.0,
                              color: Colors.black54,
                            ),
                            onPressed: onVideoCallback as void Function()?,
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                    child: popItem(Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.more_vert,
                        size: 24.0,
                        color: Colors.black54,
                      ),
                    ))),
              ],
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: HexColor("#f3f2f2"),
              blurRadius: 15.0,
              offset: Offset(0.0, 0.75))
        ],
        color: HexColor("#f3f2f2"),
      ),
    );
  }

  Widget popItem(Widget item) {
    return !isGroupConversation!
        ? PopupMenuButton<String>(
        onSelected: (String value) {
          onItemSelect!(value);
        },
        child: item,
        itemBuilder: (context) => [
          PopupMenuItem(
              value: "Search Chat",
              child: Row(
                children: <Widget>[
                  Text(AppLocalizations.of(context)!
                      .translate("search_chat"))
                ],
              )),
          PopupMenuItem(
              value: "Block",
              child: Row(
                children: <Widget>[
                  Text(AppLocalizations.of(context)!.translate("block"))
                ],
              ))
        ])
        : PopupMenuButton<String>(
        onSelected: (String value) {
          onItemSelect!(value);
        },
        child: item,
        itemBuilder: (context) => [
          PopupMenuItem(
              value: "Search Chat",
              child: Row(
                children: <Widget>[
                  Text(AppLocalizations.of(context)!
                      .translate("search_chat"))
                ],
              )),
        ]);
  }

  AppBarWithProfileChat(
      {Key? key,
        this.imageUrl,
        this.title,
        this.notificationCount,
        this.callBack,
        this.isHomepage,
        this.backButtonPress,
        this.isNotificationVisible,
        this.status,
        this.userId,
        this.userType,
        this.onSearch,
        this.onItemSelect,
        this.isSearch,
        this.roomId,
        this.roomName,
        this.onCallCallback,
        this.onVideoCallback,
        this.showCallbuttons,
        this.isGroupConversation})
      : super(key: key);
}
