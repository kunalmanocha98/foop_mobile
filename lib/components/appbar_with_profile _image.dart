import 'package:oho_works_app/components/appAvatar.dart';
import 'package:oho_works_app/profile_module/pages/profile_page.dart';
import 'package:oho_works_app/ui/Notification/notification_page.dart';
import 'package:oho_works_app/ui/searchmodule/globalsearchpage.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

// ignore: must_be_immutable
class AppBarWithProfile extends StatelessWidget with PreferredSizeWidget {
  final double appBarHeight = 56.0;
  String? imageUrl;
  String? title;
  int? notificationCount;
  Null Function()? callBack;
  bool? isHomepage;
  Function? backButtonPress;
  bool? isNotificationVisible;
  bool? centerTitle;

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
            centerTitle: centerTitle ??= true,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                (isHomepage != null && !isHomepage!)
                    ? InkWell(
                  onTap: backButtonPress as void Function()?,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.keyboard_backspace_rounded,
                        size: 20,
                        color: HexColor(AppColors.appColorBlack35),
                      ),
                      SizedBox(
                        height: 36,
                        width: 36,
                        child: appAvatar(
                          size: 36,
                          isClickable: false,
                          key: UniqueKey(),
                          imageUrl: imageUrl,
                          isFullUrl: true,
                        ),
                      ),
                    ],
                  ),
                )
                    : GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserProfileCards(
                              userType: "person",
                              userId: null,
                              currentPosition: 1,
                              type: null,
                              callback: () {
                                callBack!();
                              },
                            )));
                  },
                  child: SizedBox(
                    height: 36,
                    width: 36,
                    child: appAvatar(
                      size: 36,
                      key:UniqueKey(),
                      imageUrl: imageUrl,
                      isFullUrl: true,
                      isClickable: false,
                    ),
                  ),
                ),
                Text(
                  title!,
                  style: styleElements.headline6ThemeScalable(context).copyWith(
                      fontWeight: FontWeight.w600, color: HexColor(AppColors.appColorBlack85)),
                  textAlign: TextAlign.center,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Visibility(
                      visible: (isNotificationVisible != null &&
                          isNotificationVisible!),
                      child: Container(
                        child: Stack(
                          children: <Widget>[
                            new IconButton(
                                icon: Icon(
                                  Icons.notifications_none_outlined,
                                  size: 24.0,
                                  color: HexColor(AppColors.appColorBlack65),
                                ),
                                onPressed: () async {

                                  callBack!();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              NotificationsPage(
                                                callback: callBack,
                                              )));
                                }),
                            Visibility(
                              visible: notificationCount != null &&
                                  notificationCount != 0,
                              child: new Positioned(
                                right: 8,
                                top: 8,
                                child: new Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: new BoxDecoration(
                                    color: HexColor(AppColors.appMainColor),
                                    shape: BoxShape.circle,
                                  ),
                                  constraints: BoxConstraints(
                                    minWidth: 18,
                                    minHeight: 18,
                                  ),
                                  child: Center(
                                    child: Text(
                                      notificationCount.toString(),
                                      style: TextStyle(
                                          color: HexColor(AppColors.appColorWhite),
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    // Visibility(
                    //   visible: isNotificationVisible != null &&
                    //       isNotificationVisible,
                    //   child: new IconButton(
                    //     icon: Icon(
                    //       Icons.search,
                    //       size: 24.0,
                    //       color: HexColor(AppColors.appColorBlack65),
                    //     ),
                    //     onPressed: () {},
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: HexColor(AppColors.appColorBackground),
              blurRadius: 15.0,
              offset: Offset(0.0, 0.75))
        ],
        color: HexColor(AppColors.appColorBackground),
      ),
    );
  }

  AppBarWithProfile(
      {Key? key,
        this.imageUrl,
        this.title,
        this.notificationCount,
        this.centerTitle,
        this.callBack,
        this.isHomepage,
        this.backButtonPress,
        this.isNotificationVisible})
      : super(key: key);
}
// ignore: must_be_immutable
class AppBarWithProfileNew extends StatelessWidget with PreferredSizeWidget {
  final double appBarHeight = 56.0;
  String? imageUrl;
  String? title;
  IO.Socket? socket;
  int? notificationCount;
  Null Function()? callBack;
  bool? isHomepage;
  Function? backButtonPress;
  bool? isNotificationVisible;
  bool? centerTitle;
  List<Widget>? actions;
  AppBarWithProfileNew(
      {Key? key,
        this.imageUrl,
        this.title,
        this.notificationCount,
        this.centerTitle,
        this.callBack,
        this.isHomepage,
        this.backButtonPress,
        this.socket,
        this.actions,
        this.isNotificationVisible})
      : super(key: key);

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
            centerTitle: centerTitle ??= true,
            actions: actions,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image(width: 30,height: 30,image: AssetImage('assets/appimages/logo.png'),),
                    SizedBox(width: 4,),
                    Text(title!, style: styleElements.headline6ThemeScalable(context).copyWith(
                          fontWeight: FontWeight.w600, color: HexColor(AppColors.appColorBlack85),fontSize: 24),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                 /*   InkWell(
                      onTap:(){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ChatListsPage(
                                        " ",

                                    )));
                      },
                      child: Container(
                        child: Stack(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Icon(
                                Icons.messenger_outline,
                                size: 24.0,
                                color: HexColor(AppColors.appColorBlack65),
                              ),
                            ),
                            Visibility(

                              child: new Positioned(
                                right: 8,
                                top: 8,
                                child: new Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: new BoxDecoration(
                                    color: HexColor(AppColors.appMainColor),
                                    shape: BoxShape.circle,
                                  ),
                                  constraints: BoxConstraints(
                                    minWidth: 18,
                                    minHeight: 18,
                                  ),
                                  child: Center(
                                    child: Text(
                                      "12",
                                      style: TextStyle(
                                          color: HexColor(AppColors.appColorWhite),
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),*/
                    Visibility(
                      visible: false,
                      child:IconButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                            return GlobalSearchPage();
                          }));
                        },
                        icon: Icon(Icons.search, size: 30.0,
                            color: HexColor(AppColors.appColorBlack65)),
                      )
                    ),
                   /* Visibility(
                      visible: (isNotificationVisible != null &&
                          isNotificationVisible),
                      child: Container(
                        child: Stack(
                          children: <Widget>[
                            IconButton(
                              onPressed: ()async{
                                callBack();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            NotificationsPage(
                                              callback: callBack,
                                            )));
                              },
                              icon: Icon(
                                Icons.notifications_none_outlined,
                                size: 30.0,
                                color: HexColor(AppColors.appColorBlack65),
                              ),
                            ),
                            Visibility(
                              visible: notificationCount != null &&
                                  notificationCount != 0,
                              child: new Positioned(
                                right: 8,
                                top: 8,
                                child: new Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: new BoxDecoration(
                                    color: HexColor(AppColors.appMainColor),
                                    shape: BoxShape.circle,
                                  ),
                                  constraints: BoxConstraints(
                                    minWidth: 18,
                                    minHeight: 18,
                                  ),
                                  child: Center(
                                    child: Text(
                                      notificationCount!=null?notificationCount.toString() ?? "":"0",
                                      style: TextStyle(
                                          color: HexColor(AppColors.appColorWhite),
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),*/
                 /*   GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserProfileCards(
                                  userType: "person",
                                  userId: null,
                                  currentPosition: 1,
                                  type: null,
                                  callback: () {
                                    callBack();
                                  },
                                )));
                      },
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 30,
                          width: 30,
                          child: appAvatar(
                            size: 30,
                            key: UniqueKey(),
                            imageUrl: imageUrl,
                            isFullUrl: true,
                            isClickable: false,
                          ),
                        ),
                      ),
                    ),*/
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: HexColor(AppColors.appColorBackground),
              blurRadius: 15.0,
              offset: Offset(0.0, 0.75))
        ],
        color: HexColor(AppColors.appColorBackground),
      ),
    );
  }


}

// ignore: must_be_immutable
class AppBarWithOnlyTitle extends StatelessWidget with PreferredSizeWidget
{
  final double appBarHeight = 56.0;
  String? title;
  bool isBackButtonVisible;
  Function? backButtonCallback;


  @override
  get preferredSize => Size.fromHeight(appBarHeight);
  late TextStyleElements styleElements;
  List<Widget>? actions;

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
            actionsIconTheme: IconThemeData(
              color: HexColor(AppColors.appColorBlack65)
            ),
            centerTitle: false,
            actions: actions,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Visibility(
                  visible:isBackButtonVisible,
                  child: InkWell(
                    onTap: backButtonCallback as void Function()?,
                    child: Padding(
                      padding:  EdgeInsets.only(right:8.0,left: 8),
                      child: Icon(
                        Icons.keyboard_backspace_rounded,
                        size: 24,
                        color: HexColor(AppColors.appColorBlack35),
                      ),
                    ),
                  ),
                ),
                Image(width: 30,height: 30,image: AssetImage('assets/appimages/logo.png'),),
                SizedBox(width: 4,),
                Text(title!, style: styleElements.headline6ThemeScalable(context).copyWith(
                    fontWeight: FontWeight.w600, color: HexColor(AppColors.appColorBlack85),fontSize: 24),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: HexColor(AppColors.appColorBackground),
              blurRadius: 15.0,
              offset: Offset(0.0, 0.75))
        ],
        color: HexColor(AppColors.appColorBackground),
      ),
    );
  }

  AppBarWithOnlyTitle(
      {Key? key,
        this.title,
        this.actions,
        this.isBackButtonVisible= false,
        this.backButtonCallback
      })
      : super(key: key);
}