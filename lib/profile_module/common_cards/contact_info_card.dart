import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/conversationPage/custom_web_view.dart';
import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/models/base_res.dart';
import 'package:oho_works_app/profile_module/pages/directions.dart';
import 'package:oho_works_app/services/call_email_.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class ContactInfoCard extends StatelessWidget {
  final CommonCardData data;
  TextStyleElements? styleElements;
  SharedPreferences? prefs;
  final CallsAndMessagesService? _service = locator<CallsAndMessagesService>();

  Size displaySize(BuildContext context) {
    debugPrint('Size = ' + MediaQuery.of(context).size.toString());
    return MediaQuery.of(context).size;
  }

  double displayHeight(BuildContext context) {
    debugPrint('Height = ' + displaySize(context).height.toString());
    return displaySize(context).height;
  }

  double displayWidth(BuildContext context) {
    debugPrint('Width = ' + displaySize(context).width.toString());
    return displaySize(context).width;
  }

  Widget _simplePopup() => PopupMenuButton<int>(
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 1,
            child: Text(AppLocalizations.of(context)!.translate('add_contact')),
          ),
        ],
        onSelected: (value) async {},
        icon: Icon(
          Icons.more_horiz,
          size: 30,
          color: HexColor(AppColors.appColorBlack85),
        ),
      );

  ContactInfoCard({Key? key, required this.data, this.styleElements})
      : super(key: key);

  setprefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    setprefs();
    return appListCard(
        child: Column(
      children: <Widget>[
        Visibility(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 16.0.h,
                          right: 16.h,
                          top: 12.h,
                          bottom: 30.h),
                      child: Text(AppLocalizations.of(context)!.translate('contact'),
                        style: styleElements!
                            .headline6ThemeScalable(context)
                            .copyWith(
                                fontWeight: FontWeight.bold,
                                color: HexColor(AppColors.appColorBlack85)),
                        textAlign: TextAlign.left,
                      ),
                    )),
                flex: 3,
              ),
              Visibility(
                  visible: false,
                  child: Flexible(
                    child: Padding(
                        padding: EdgeInsets.only(right: 8.h, bottom: 30.h),
                        child: Align(
                            alignment: Alignment.topRight,
                            child: _simplePopup())),
                    flex: 1,
                  )),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 21),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 2),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Icon(
                    Icons.location_on_outlined,
                    color: HexColor(AppColors.appColorGrey500),
                    size: 24,
                  ),
                ),
              ),
              Expanded(
                  child: Container(
                      margin: const EdgeInsets.only(right: 21, left: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              child: Text(
                                data.textOne ?? "",
                                style: styleElements!
                                    .subtitle1ThemeScalable(context)
                                    .copyWith(fontWeight: FontWeight.w600),
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Container(
                              margin: const EdgeInsets.only(top: 8),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  child: Text(
                                    data.textTwo ?? "",
                                    style: styleElements!
                                        .captionThemeScalable(context),
                                    textAlign: TextAlign.left,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              )),
                        ],
                      ))),
              Visibility(
                visible: data.lat!=null,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                      margin:
                          const EdgeInsets.only(left: 8, right: 46, top: 8.0),
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: HexColor(AppColors.appColorBackground)),
                      child: Align(
                        alignment: Alignment.center,
                        child: IconButton(
                          onPressed: () async {
                            prefs = await SharedPreferences.getInstance();
                            if (data.lon != null) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MapPage(
                                        ),
                                  ));
                            }
                          },
                          icon: Icon(
                            Icons.directions_outlined,
                            color: HexColor(AppColors.appColorGrey500),
                            size: 22,
                          ),
                        ),
                      )),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 17, bottom: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin:
                    const EdgeInsets.only(left: 10, right: 10, top: 8.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                      margin: const EdgeInsets.only(
                          left: 8, right: 8, top: 8.0),
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: HexColor(AppColors.appColorBackground)),
                      child: IconButton(
                        onPressed: () {
                          if (data.textFour != null && data.textFour != "")
                            _service!.call(data.textFour ?? "");
                          else
                            ToastBuilder().showToast(
                                AppLocalizations.of(context)!
                                    .translate("no_telephone"),
                                context,
                                HexColor(AppColors.information));
                        },
                        icon: Icon(
                          Icons.phone_outlined,
                          color: HexColor(AppColors.appColorGrey500),
                          size: 22,
                        ),
                      )),
                ),
              ),
              Container(
                margin:
                    const EdgeInsets.only(left: 10, right: 10, top: 8.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                      margin: const EdgeInsets.only(
                          left: 8, right: 8, top: 8.0),
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: HexColor(AppColors.appColorBackground)),
                      child: IconButton(
                        onPressed: () {
                          if (data.textTen != null && data.textTen != "")
                            _service!.call(data.textTen ?? "");
                          else
                            ToastBuilder().showToast(
                                AppLocalizations.of(context)!
                                    .translate("no_mobile_number"),
                                context,
                                HexColor(AppColors.information));
                        },
                        icon: Icon(
                          Icons.phone_android,
                          color: HexColor(AppColors.appColorGrey500),
                          size: 22,
                        ),
                      )),
                ),
              ),
              Container(
                margin:
                    const EdgeInsets.only(left: 10, right: 10, top: 8.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                      margin: const EdgeInsets.only(
                          left: 8, right: 8, top: 8.0),
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: HexColor(AppColors.appColorBackground)),
                      child: IconButton(
                        onPressed: () {
                          if (data.textSix != null && data.textSix != "")
                            _service!.sendEmail(data.textSix ?? "");
                          else
                            ToastBuilder().showToast(
                                AppLocalizations.of(context)!
                                    .translate("no_email_found"),
                                context,
                                HexColor(AppColors.information));
                        },
                        icon: Icon(
                          Icons.contact_mail_outlined,
                          color: HexColor(AppColors.appColorGrey500),
                          size: 22,
                        ),
                      )),
                ),
              ),
              Container(
                margin:
                    const EdgeInsets.only(left: 10, right: 10, top: 8.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                      margin: const EdgeInsets.only(
                          left: 8, right: 8, top: 8.0),
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: HexColor(AppColors.appColorBackground)),
                      child: IconButton(
                        onPressed: () {
                          if (data.textSix != null && data.textSix != "")
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CustomWebView(
                                        selectedUrl:
                                        data.textEight??
                                                "")));
                          else
                            ToastBuilder().showToast(
                                AppLocalizations.of(context)!
                                    .translate("no_school_site"),
                                context,
                                HexColor(AppColors.information));
                        },
                        icon: Icon(
                          Icons.language_outlined,
                          color: HexColor(AppColors.appColorGrey500),
                          size: 22,
                        ),
                      )),
                ),
              ),
            ],
          ),
        )
      ],
    ));
  }
}
