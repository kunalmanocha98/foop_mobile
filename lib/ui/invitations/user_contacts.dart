import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/searchBox.dart';
import 'package:oho_works_app/components/app_buttons.dart';
import 'package:oho_works_app/components/app_user_list_tile.dart';
import 'package:oho_works_app/models/deeplink_response.dart';
import 'package:oho_works_app/models/invite_users_payload.dart';
import 'package:oho_works_app/models/personal_profile.dart';
import 'package:oho_works_app/profile_module/common_cards/testcard.dart';
import 'package:oho_works_app/app_database/data_base_helper.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class UserContacts extends StatefulWidget {
  SharedPreferences? prefs;

  UserContacts({this.prefs});

  @override
  _UserContacts createState() => _UserContacts(prefs: prefs);
}

class _UserContacts extends State<UserContacts> {
  late TextStyleElements styleElements;
  ProgressDialog? pr;
  Persondata? rows;
  var followers = 0;
  var following = 0;
  var roomsCount = 0;
  var postCount = 0;
  bool cb1 = false,
      cb2 = false;
  var list = [];
  int? selectedRadio;
  int totalSelected=0;
  SharedPreferences? prefs;
  final dbHelper = DatabaseHelper.instance;
  _UserContacts({this.prefs});
  List<InvitationRecipientList> invitationRecipientList = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) =>
        getListContacts(null));
  }
  void onsearchValueChanged(String text) {
if(text!=null && text!="")
  getListContacts(text);
else
  getListContacts(null);
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return SafeArea(
      child: Scaffold(
        appBar: appAppBar().getCustomAppBar(context, appBarTitle: 'Select contact',
            onBackButtonPress: ()  {
              Navigator.of(context).pop({'result': "imageUrl"});
            }),
        body: Stack(
          children: [
            NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  SliverToBoxAdapter(
                    child: SearchBox(
                      onvalueChanged: onsearchValueChanged,
                      hintText: AppLocalizations.of(context)!.translate('search'),
                    ),
                  )
                ];
              },
              body:  appListCard(
                child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (BuildContext context, int index) {
                    return  appUserListTile(
                      leadingWidget:CircleAvatar(
                        radius: 24,
                        foregroundColor: HexColor(AppColors.appColorWhite),
                        backgroundColor: HexColor(AppColors.appColorWhite),
                        child: ClipOval(
                          child:
                          Center(
                              child:  Image.asset('assets/appimages/userplaceholder.jpg',)
                          ),
                        ),
                      ),
                      title: list[index].name,
                      trailingWidget: Visibility(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:
                          list[index].isSelected==1? Checkbox(
                            activeColor: Colors
                                .redAccent,
                            value:
                            list[index].isSelected==1?true:false,
                            onChanged:
                                (bool? value) async {
                              var row= list[index];
                              row.isSelected=0;
                              await dbHelper.updateIsSelected(row);
                              setState(()  {
                                list[index].isSelected =value==true?1:0 ;
                                totalSelected=totalSelected-1;



                              });
                            },
                          ):
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () async {
                              list[index].isSelected=1;
                              totalSelected=totalSelected+1;
                              var row= list[index];
                              row.isSelected=1;
                              await dbHelper.updateIsSelected(row);
                              setState(()  {

                              });
                            },
                            child: Text(AppLocalizations.of(context)!.translate("select"),
                              style: styleElements.subtitle2ThemeScalable(context).copyWith(color: HexColor(AppColors.appMainColor)),),
                          ),
                        ),
                      ),
                    )
                    ;
                  },
                ),
              ),
            )
           ,
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 60,
                  color: HexColor(AppColors.appColorWhite),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Visibility(
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                              child:  Text(
                                totalSelected.toString()+' Selected',
                                style: styleElements
                                    .subtitle2ThemeScalable(context)
                                    .copyWith(color: HexColor(AppColors.appMainColor)),
                              ),
                            )),
                      ),
                      Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                            child: appElevatedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: HexColor(AppColors.appMainColor))),
                              onPressed: () async {

                                getList();

                              },
                              color: HexColor(AppColors.appColorWhite),
                              child: Text(
                                AppLocalizations.of(context)!.translate('next'),
                                style: styleElements
                                    .subtitle2ThemeScalable(context)
                                    .copyWith(color: HexColor(AppColors.appMainColor)),
                              ),
                            ),
                          )),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }


  Future<void> getList() async {
    invitationRecipientList = [];
    for (var item in list) {

      if (item != null && item.isSelected==1  && item.mobileNumber!=null) {

        InvitationRecipientList data = InvitationRecipientList();
        data.mobileNumber=item.mobileNumber.trim();
        invitationRecipientList.add(data);
      }

    }
    if (invitationRecipientList != null && invitationRecipientList.isNotEmpty) {
      prefs = await SharedPreferences.getInstance();
      InviteUserPayload payload = InviteUserPayload();
      payload.inviteContextType = 'TR';
      payload.inviteContextTypeId = prefs!.getInt(Strings.userId);
      payload.invitedByType = 'person';
      payload.invitedById = prefs!.getInt(Strings.userId);

      payload.invitationRecipientList = invitationRecipientList;
      uploadData(payload);
    } else {
      ToastBuilder().showToast(
          AppLocalizations.of(context)!
              .translate("select_contact"),
          context,
          HexColor(AppColors.success));
    };
  }

  void uploadData(InviteUserPayload payload) async {
    ProgressDialog progressDialog = ProgressDialog(context);
    progressDialog.show();
    Calls()
        .call(jsonEncode(payload), context, Config.INVITE_USERS)
        .then((value) {
      progressDialog.hide();
      var res = DeeplinkResponse.fromJson(value);
      if (res.statusCode == Strings.success_code) {
        ToastBuilder().showToast(
            res.message??"",
            context,
            HexColor(AppColors.success));
        Navigator.pop(context);
      } else {}
    }).catchError((onError) {
      print(onError);
      progressDialog.hide();
    });
  }
  void getListContacts(String? name) async {
    if(name==null)
    list = await dbHelper.getContactsAll();
    else
      list = await dbHelper.getContactsUsingName(name);
    setState(()  {

    });

    
  }
}
