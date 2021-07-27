import 'dart:io';

import 'package:oho_works_app/components/app_buttons.dart';
import 'package:oho_works_app/models/personal_profile.dart';
import 'package:oho_works_app/profile_module/common_cards/testcard.dart';
import 'package:oho_works_app/profile_module/pages/basic_profile.dart';
import 'package:oho_works_app/ui/qr_code_page.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/follow_unfollow_block_remove_unblock_button.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class UserNameWithImageCard extends StatelessWidget {
  final userNameTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  BuildContext? context;
  ProgressDialog? pr;
  SharedPreferences? prefs;
  String? title;
  String? subtitle;
  bool isFollow;
  String imageUrl;
  bool? isPersonProfile;
  Function? onClickProfile;
  int? thirdPersonId;
  int? userId;
  Persondata? personData;
  Null Function() callbackPicker;
  Null Function()? clicked;
  late TextStyleElements styleElements;
  String? instId;
  String? userType;
  String? ownerTye;
  String? imagePath;
  bool? isUserVerified;
  bool isFromProfile;
  bool showQr;
  bool? showProgress;
  int? progress;

  UserNameWithImageCard(
      {Key? key,
        this.personData,
        required this.title,
        required this.subtitle,
        required this.isFollow,
        required this.imageUrl,
        required this.callbackPicker,
        this.onClickProfile,
        this.thirdPersonId,
        this.userId,
        this.userType,
        this.ownerTye,
        this.clicked,
        this.isUserVerified,
        this.instId,
        this.imagePath,
        this.showProgress,
        this.progress,
        this.isFromProfile= false,
        this.showQr = false,
        this.isPersonProfile})
      : super(key: key);

  void setSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    ScreenUtil.init;
    setSharedPreferences();
    styleElements = TextStyleElements(context);




    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        GestureDetector(
          onTap: onClickProfile as void Function()?,
          child: Container(
            margin: EdgeInsets.all(16.h),
            height: 60.w,
            width: 60.w,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: CircleAvatar(
                    radius: 52,
                    foregroundColor: HexColor(AppColors.appColorWhite),
                    backgroundColor: HexColor(AppColors.appColorWhite),
                    child: ClipOval(
                      child: imagePath != null
                          ? new Image.file(
                        File(imagePath!),
                        fit: BoxFit.fill,
                      )
                          : imageUrl != null && imageUrl != ""
                          ? CachedNetworkImage(
                        imageUrl: imageUrl,
                        placeholder: (context, url) => Center(
                            child: SizedBox(
                              height: 20,
                              width: 20,
                            )),
                        errorWidget: (context, url, error) =>
                            Icon(Icons.error),
                        fit: BoxFit.cover,
                      )
                          : Container(
                        child: Image(
                            image: AssetImage(
                                'assets/appimages/userplaceholder.jpg')),
                      ),
                    ),
                  ),
                ),
                Visibility(
                    visible: userType == "person",
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        padding: EdgeInsets.all(4.h),
                        decoration: BoxDecoration(
                            color: HexColor(AppColors.appColorWhite), shape: BoxShape.circle),
                        child: Icon(
                          Icons.edit,
                          size: 12,
                          color: HexColor(AppColors.appColorBlack65),
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: isFromProfile?null:onClickProfile as void Function()?,
            child: Container(
              margin: EdgeInsets.only(right: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                title!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: styleElements
                                    .headline6ThemeScalable(context)
                                    .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: HexColor(AppColors.appColorBlack85)),
                              ),
                            ),
                            Visibility(
                              visible: isUserVerified!,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: Container(
                                    child: Image(
                                      image: AssetImage('assets/appimages/check.png'),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        )),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: null,
                    child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(subtitle ?? "",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: styleElements
                                      .captionThemeScalable(context)),
                            )
                          ],
                        )),
                  ),
                  Visibility(
                    visible: showProgress ?? false,
                    child: Padding(
                      padding: const EdgeInsets.only(top:4.0,bottom: 4.0),
                      child: Row(
                        children: [
                          Text("$progress%",style: styleElements.bodyText1ThemeScalable(context).copyWith(
                              fontWeight: FontWeight.bold
                          ),),
                          Flexible(
                            child: LinearPercentIndicator(
                              linearStrokeCap: LinearStrokeCap.roundAll,
                              animation: true,
                              animationDuration: 900,
                              lineHeight: 12,
                              percent: progress!=null?(progress!.toDouble()/100):0.0,
                              backgroundColor: HexColor(AppColors.pollBackground),
                              progressColor: HexColor(AppColors.appMainColor).withOpacity(0.75),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !isFromProfile,
                    child: Text(AppLocalizations.of(context)!.translate('view_profile'),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: styleElements.captionThemeScalable(context).
                        copyWith(
                            color: HexColor(AppColors.appColorBlue),
                            decoration: TextDecoration.underline)
                    ),
                  ),
                  SizedBox(height: 4,)
                ],
              ),
            ),
          ),
        ),
        Visibility(
          visible: !showQr,
          child: Container(
            margin: EdgeInsets.only(right: 16.h),
            child: userType == "person"
                ? appElevatedButton(
                onPressed: () async {
                  if (userType == "person") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                BasicInfo(personData, callbackPicker)));
                  }


                },
                color:  HexColor(AppColors.appMainColor),
                child: isPersonProfile!
                    ? Text(
                  AppLocalizations.of(context)!.translate('edit'),
                  style: styleElements
                      .subtitle2ThemeScalable(context)
                      .copyWith(color: HexColor(AppColors.appColorWhite)),
                )
                    : "" as Widget?)
                : Align(
              alignment: Alignment.centerRight,
              child: GenericFollowUnfollowButton(
                textColor: HexColor(AppColors.appColorWhite),
                backGroundColor: HexColor(AppColors.appMainColor),
                actionByObjectType: ownerTye,
                actionByObjectId: userId,
                actionOnObjectType:
                userType == "institution" ? "institution" : "person",
                actionOnObjectId: thirdPersonId,
                engageFlag: isFollow
                    ? AppLocalizations.of(context)!.translate('unfollow')
                    : AppLocalizations.of(context)!.translate('follow'),
                actionFlag: isFollow ? "U" : "F",
                actionDetails: [],
                personName: "",
                clicked: () {
                  if (clicked != null) clicked!();
                },
                callback: (isCallSuccess) {
                  if(callbackPicker!=null)
                    callbackPicker();
                },
              ),
            ),
          ),
        ),
        showQr?Visibility(
          visible: showQr,
          child:GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder:(BuildContext context){
                return QrCodePage(qrCodeData: subtitle,);
              }));
            },
            child: Padding(
              padding: const EdgeInsets.only(right:24.0),
              child: BarcodeWidget(
                barcode: Barcode.qrCode(
                  errorCorrectLevel: BarcodeQRCorrectionLevel.high,
                ),
                data: subtitle!,
                width: 36,
                height: 36,
              ),
            ),
          ),
        ):Container()
      ],
    );
  }
}
