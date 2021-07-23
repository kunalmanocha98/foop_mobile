import 'package:oho_works_app/profile_module/pages/network_page.dart';
import 'package:oho_works_app/ui/RoomModule/my_rooms.dart';
import 'package:oho_works_app/ui/postModule/selectedPostListPage.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class UserPopularityCard extends StatelessWidget {
  int? userId;
  String? userName;
  String? userType;
  String textOne;
  String textTwo;
  String textThree;
  String textFour;
  String textFive;
  String textSix;
  String textSeven;
  String textEight;
  int? ownerId;
  String? ownerType;
  Null Function()? callback;
  String? instituteId;
  String? imageurl;

  UserPopularityCard(
      {Key? key,
      required this.textOne,
      required this.textTwo,
      required this.textThree,
      required this.textFour,
      required this.textFive,
      required this.textSix,
      required this.textSeven,
      required this.textEight,
      this.userId,
        this.ownerId,
        this.ownerType,
      this.userName,
        this.imageurl,
      this.instituteId,
      required this.callback,
      this.userType})
      : super(key: key);
  late TextStyleElements styleElements;

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return Container(
      color:  HexColor(AppColors.appColorWhite),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Row(children: <Widget>[
          Expanded(
            child: GestureDetector(
                onTap: () {
                 /* Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CourseDetailPage(
                          id: null,

                          *//* userType: "teacher",*//*
                        ),
                      ));*/
                },
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(2.h),
                        child: Text(
                          textFive,
                          overflow: TextOverflow.ellipsis,
                          style: styleElements
                              .subtitle2ThemeScalable(context)
                              .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: HexColor(AppColors.appColorBlack85)),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.only(bottom: 2.h, left: 2.h, right: 2.h),
                        child: Text(
                          textOne,
                          overflow: TextOverflow.ellipsis,
                          style: styleElements.subtitle2ThemeScalable(context),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                  onTap: () async {
                    var result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NetworkPage(
                              id: userId,
                              type: userType ,
                              currentTab: 1,
                              pageTitle: userName,
                              imageUrl:imageurl,
                              callback: () {
                                callback!();
                              }),
                        ));
                    if (result != null) {
                      update(true);
                    }
                  },
                )),
          ),
          Expanded(
            child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () async {
                  var result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NetworkPage(
                            id: userId,
                            imageUrl: imageurl,
                            type: userType,
                            currentTab: 0,
                            pageTitle: userName,
                            callback: () {
                              callback!();
                            }

                            ),
                      ));
                  if (result != null) {
                    update(true);
                  }
                },
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(2.h),
                      child: Text(
                        textSix,
                        overflow: TextOverflow.ellipsis,
                        style: styleElements
                            .subtitle2ThemeScalable(context)
                            .copyWith(
                                fontWeight: FontWeight.bold,
                                color: HexColor(AppColors.appColorBlack85)),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.only(bottom: 2.h, left: 2.h, right: 2.h),
                      child: Text(
                        textTwo,
                        overflow: TextOverflow.ellipsis,
                        style: styleElements.subtitle2ThemeScalable(context),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                )),
          ),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SelectedFeedListPage(appBarTitle: userName!+"'s Activity",
                          isOthersPostList: true,
                            isFromProfile:false,
                          postOwnerTypeId: userId,
                          postOwnerType: userType == "institution"
                              ? "institution"
                              : "person",)
                      //     PostListPage(
                      //   isOthersPostList: true,
                      //   postOwnerType: userType,
                      //   postOwnerTypeId: userId,
                      // )
                    ));
              },
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(2.h),
                    child: Text(
                      textSeven,
                      overflow: TextOverflow.ellipsis,
                      style: styleElements
                          .subtitle2ThemeScalable(context)
                          .copyWith(
                              fontWeight: FontWeight.bold,
                              color: HexColor(AppColors.appColorBlack85)),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 2.h, left: 2.h, right: 2.h),
                    child: Text(
                      textThree,
                      overflow: TextOverflow.ellipsis,
                      style: styleElements.subtitle2ThemeScalable(context),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyRooms(
                            userId,int.parse(instituteId!),ownerId,userType,ownerType, callback
                          )));
            },
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(2.h),
                  child: Text(
                    textEight,
                    overflow: TextOverflow.ellipsis,
                    style: styleElements
                        .subtitle2ThemeScalable(context)
                        .copyWith(
                            fontWeight: FontWeight.bold, color: HexColor(AppColors.appColorBlack85)),
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 2.h, left: 2.h, right: 2.h),
                  child: Text(
                    textFour,
                    overflow: TextOverflow.ellipsis,
                    style: styleElements.subtitle2ThemeScalable(context),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          )),
        ]),
      ),
    );
  }

  void update(updateFollowers) {
    callback!();
  }
}
