import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/tricycle_buttons.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/material.dart';

class InviteMembersPage extends StatefulWidget {
  @override
  _InviteMembersPage createState() => _InviteMembersPage();
}

class _InviteMembersPage extends State<InviteMembersPage> {

  late TextStyleElements styleElements;

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar:TricycleAppBar().getCustomAppBar(context,
            appBarTitle:  AppLocalizations.of(context)!.translate("invite_members"),
            onBackButtonPress: (){
          Navigator.pop(context);
            }),
        body: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Card(
                    elevation: 8,
                    child: ListTile(
                      title: Text(AppLocalizations.of(context)!.translate('see_more'),
                        style: styleElements.subtitle1ThemeScalable(context),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios_sharp,
                        color: HexColor(AppColors.appColorBlack85),
                        size: 18,
                      ),
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(AppLocalizations.of(context)!.translate('invite_member_des'),
                      style: styleElements.bodyText2ThemeScalable(context),
                    ))
              ],
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 60,
                  color: HexColor(AppColors.appColorWhite),
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                        child: TricycleElevatedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(
                                  color: HexColor(AppColors.appMainColor))),
                          onPressed: () {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => RoomDetailsPage(value)));
                          },
                          color: HexColor(AppColors.appColorWhite),
                          child: Text(
                              AppLocalizations.of(context)!.translate('done'),
                              style: styleElements.bodyText2ThemeScalable(context).copyWith(
                                color:  HexColor(AppColors.appMainColor),
                              )),
                        ),
                      )),
                )),
          ],
        ),
      ),
    );
  }
}
