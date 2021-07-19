import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/tricycle_buttons.dart';
import 'package:oho_works_app/mixins/editProfileMixin.dart';
import 'package:oho_works_app/models/deeplink_response.dart';
import 'package:oho_works_app/models/invite_users_payload.dart';
import 'package:oho_works_app/models/personal_profile.dart';
import 'package:oho_works_app/profile_module/common_cards/testcard.dart';
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
class InviteTeachersClassMates extends StatefulWidget {




  @override
  _InviteTeachersClassMates createState() =>
      _InviteTeachersClassMates();
}

class _InviteTeachersClassMates extends State<InviteTeachersClassMates> {
  TextStyleElements styleElements;
  ProgressDialog pr;
  Persondata rows;
  var followers = 0;
  var following = 0;
  var roomsCount = 0;
  var postCount = 0;
  bool cb1 = false, cb2 = false;
  List<String> list = [];
  int selectedRadio;
  SharedPreferences prefs;
  List<InvitationRecipientList> invitationRecipientList = [];



  @override
  void initState() {
    super.initState();
    list.add("");

  }



  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);

    return Scaffold(
      appBar: TricycleAppBar().getCustomAppBar(context,
          appBarTitle: AppLocalizations.of(context).translate("invite_teacher"),
          onBackButtonPress: () {
        Navigator.pop(context);
      }),
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 8),
            child: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 200,
                            width: double.infinity,
                            child: Container(
                              child:
                              new Image.asset('assets/appimages/Teacher-pana.png',width:200,height:200),
                            ),
                          ),
                          Container(
                              child: Text(
                            AppLocalizations.of(context)
                                .translate("invite_calssmates_friends"),
                            style:
                                styleElements.headline6ThemeScalable(context),
                          )),
                          Container(
                              child: Text(
                            AppLocalizations.of(context)
                                .translate("earn_coins"),
                            style: styleElements
                                .headline6ThemeScalable(context)
                                .copyWith(fontWeight: FontWeight.bold),
                          ))
                        ],
                      ),
                    ),
                  ),
                ];
              },
              body: ListView.builder(
                itemCount: list.length,
                padding: EdgeInsets.only(bottom: 60),
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AddNewField(
                          list[index],
                            "Email or Phone number *",
                          callBck: (String data) {
                            setState(() {
                              if (data.isNotEmpty)
                                list[index] = data;
                              else
                                list[index] = "";
                            });
                          },
                        ),
                      ),
                      trailing: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          if (index == list.length - 1) {
                            if (list[index] == "") {
                              if (list.length > 1) {
                                list.removeAt(index);
                              }
                            } else {
                              list.add("");
                            }
                            setState(() {});
                          }
                        },
                        child: list[index] == ""
                            ? Icon(Icons.remove_circle_outline)
                            : Icon(Icons.add_circle_outline),
                      ),
                    ),
                  );
                },
              ),
            ),
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
                            side: BorderSide(color: HexColor(AppColors.appMainColor))),
                        onPressed: () async {
                          var l=getList();
                          if (l != null && l.isNotEmpty) {
                            prefs = await SharedPreferences.getInstance();
                            InviteUserPayload payload = InviteUserPayload();
                            payload.inviteContextType = 'TR';
                            payload.inviteContextTypeId = prefs.getInt(Strings.userId);
                            payload.invitedById = prefs.getInt("userId");
                            payload.invitedByType =
                                prefs.getString("ownerType");
                            payload.invitationRecipientList = l;
                            uploadData(payload);
                          } else {
                            ToastBuilder().showToast(
                                AppLocalizations.of(context)
                                    .translate("minimum_data_enter"),
                                context,
                                HexColor(AppColors.success));
                          }
                          ;
                        },
                        color: HexColor(AppColors.appColorWhite),
                        child: Text(AppLocalizations.of(context).translate('invite'),
                          style: styleElements
                              .subtitle2ThemeScalable(context)
                              .copyWith(color: HexColor(AppColors.appMainColor)),
                        ),
                      ),
                    )),
              ))
        ],
      ),
    );
  }

  // ignore: missing_return
  List<InvitationRecipientList> getList() {
    invitationRecipientList = [];
    for (var item in list) {
     if (item != null && item != "") {
       InvitationRecipientList data = InvitationRecipientList();
        if (EditProfileMixins().validateEmail(item) == null) {
          data.emailId = item;
          invitationRecipientList.add(data);
        } else {
          data.mobileNumber = item;
          invitationRecipientList.add(data);
        }
      }

    }
    return invitationRecipientList;
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    // ignore: deprecated_member_use
    return double.parse(s, (e) => null) != null;
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
}

class AddNewField extends StatefulWidget {
  final String data;
  final String hint;
  final Null Function(String data) callBck;

  AddNewField(this.data,this.hint, {this.callBck}) ;

  @override
  _AddNewField createState() => _AddNewField(data,hint,callBck);
}

class _AddNewField extends State<AddNewField> {
  TextEditingController _nameController;
  final String data;
  final String hint;
  final Null Function(String data) callBck;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var styleElements = TextStyleElements(context);
    return SizedBox(
      child: TextFormField(
        controller: _nameController,
        style: styleElements.subtitle1ThemeScalable(context).copyWith(
            color: HexColor(AppColors.appColorBlack65)
        ),
        onChanged: (v) {
          callBck(v);
        },
        decoration: InputDecoration(
            hintText: AppLocalizations.of(context).translate('email_phone'),
          hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35))
        ),
        validator: (data) {
          if (data.trim().isEmpty) return hint;
          return null;
        },
      ),
    );
  }

  _AddNewField(this.data, this.hint,this.callBck);
}
