import 'package:oho_works_app/components/tricycleavatar.dart';
import 'package:oho_works_app/enums/resolutionenums.dart';
import 'package:oho_works_app/enums/serviceTypeEnums.dart';
import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QrCodePage extends StatelessWidget {
  final String? qrCodeData;
  final SharedPreferences? prefs = locator<SharedPreferences>();

  QrCodePage({this.qrCodeData});

  @override
  Widget build(BuildContext context) {
    TextStyleElements styleElements = TextStyleElements(context);
    String roleName = '';
    String instituteName = '';
    try {
      roleName = prefs!.getStringList(Strings.roleTypeList)![0];
      instituteName = prefs!.getStringList(Strings.institutionNameList)![0];
    } catch (onError) {
      print(onError);
    }
    return SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              IconButton(
                  icon: Icon(
                    Icons.keyboard_backspace_rounded,
                    size: 20,
                    color: HexColor(AppColors.appColorBlack65),
                    // add custom icons also
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 80,
                      ),
                      TricycleAvatar(
                        imageUrl: prefs!.getString(Strings.profileImage),
                        service_type: SERVICE_TYPE.PERSON,
                        resolution_type: RESOLUTION_TYPE.R256,
                        size: 120,
                        withBorder: true,
                        isClickable: false,
                        borderSize: 6,
                        borderColor: HexColor(AppColors.appColorWhite),
                      ),
                      Text(
                        prefs!.getString(Strings.userName)!,
                        style: styleElements
                            .headline6ThemeScalable(context)
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        roleName + ', ' + instituteName,
                        style: styleElements.captionThemeScalable(context),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BarcodeWidget(
                        barcode: Barcode.qrCode(
                          errorCorrectLevel: BarcodeQRCorrectionLevel.high,
                        ),
                        data: qrCodeData!,
                        width: 200,
                        height: 200,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        qrCodeData!,
                        style: styleElements.bodyText1ThemeScalable(context),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        AppLocalizations.of(context)!.translate('show_this_scanner'),
                        style: styleElements.subtitle2ThemeScalable(context),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.translate('powered_by'),
                        style: styleElements.subtitle2ThemeScalable(context),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image(
                            width: 30,
                            height: 30,
                            image: AssetImage('assets/appimages/logo.png'),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            AppLocalizations.of(context)!.translate('app_name'),
                            style: styleElements.headline6ThemeScalable(context).copyWith(
                                fontWeight: FontWeight.w600,
                                color: HexColor(AppColors.appColorBlack85),
                                fontSize: 24),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      Text(
                        AppLocalizations.of(context)!.translate('logo_slogan'),
                        style: styleElements.subtitle2ThemeScalable(context),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ));
  }
}
