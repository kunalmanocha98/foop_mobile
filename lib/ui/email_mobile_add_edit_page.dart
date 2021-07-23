import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/tricycleProgressButton.dart';
import 'package:oho_works_app/models/language_list.dart';
import 'package:oho_works_app/models/settignsView.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/preloadingview.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'add_email_dilog.dart';
import 'delete_contacts.dart';
import 'email_phone_number_verification.dart';

// ignore: must_be_immutable
class AddEditEmailPhonesPage extends StatefulWidget {
  List<EmailContactList>? list;
  bool isEmail;

  @override
  _AddEditEmailPhonesPage createState() =>
      _AddEditEmailPhonesPage(list, isEmail);

  AddEditEmailPhonesPage(this.list, this.isEmail);
}

class _AddEditEmailPhonesPage extends State<AddEditEmailPhonesPage> {
  List<EmailContactList>? list;
  bool isLoading = false;
  bool isEmail;
  late SharedPreferences prefs;
  GlobalKey<TricycleProgressButtonState> progressButtonKey = GlobalKey();

  @override
  initState() {
    super.initState();
    setPrefs();
  }

  late TextStyleElements styleElements;

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: TricycleAppBar().getCustomAppBar(
          context,
          appBarTitle: isEmail
              ? AppLocalizations.of(context)!.translate("email_addresses_title")
              : AppLocalizations.of(context)!.translate("mobile_number_title"),
          onBackButtonPress: () {
            Navigator.pop(context);
          },
          actions: [
            IconButton(
                icon: Icon(
                  Icons.add,
                  size: 30,
                ),
                color: HexColor(AppColors.appColorBlack65),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => AddEmailDilog(
                            callBack: () {
                              fetchSettings();
                            },
                            callBackCancel: () {},
                            isEmail: isEmail,
                          ));
                }),
          ],
        ),
        body: isLoading
            ? PreloadingView(url: "assets/appimages/settings.png")
            : Column(
              children: [
                Visibility(

                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: HexColor(AppColors.appMainColor10),
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(4.0),
                                topLeft: Radius.circular(4.0))),
                        child: Container(
                          margin: const EdgeInsets.all(16),
                          child: Text(
                            isEmail
                                ? AppLocalizations.of(context)!.translate("email_add_des")
                                : AppLocalizations.of(context)!.translate("mobile_add_des"),
                            textAlign: TextAlign.start,
                            style: styleElements
                                .captionThemeScalable(context)
                                .copyWith(color: HexColor(AppColors.appColorBlack85)),
                          ),
                        ),
                      ),
                    )),
                Expanded(
                  child: ListView.builder(
                      padding: EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 8),
                      itemCount: list!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          child: ListTile(
                            tileColor: HexColor(AppColors.listBg),
                            title: Text(list![index].contactDetail ?? "",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: styleElements.subtitle1ThemeScalable(context)),
                            subtitle: InkWell(
                              onTap: () {
                                if (!list![index].isPrimary!)
                                {
                                  if(list![index].isVerified!)
                                  makeContactPrimary(list![index].id);
                                else
                                {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EmailPhoneVerification(
                                              id: list![index].id,
                                              isEmail: isEmail,
                                              contactDetail:
                                              list![index].contactDetail,
                                              callBack: () {
                                                makeContactPrimary(list![index].id);
                                              },
                                            ),
                                      ));
                                }}
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                      list![index].isPrimary!
                                          ? isEmail
                                              ? AppLocalizations.of(context)!
                                                      .translate("primary_email")
                                              : AppLocalizations.of(context)!
                                                  .translate("primary_mobile")
                                          : isEmail
                                              ? AppLocalizations.of(context)!
                                                      .translate("make_primary")
                                              : AppLocalizations.of(context)!
                                                      .translate(
                                                          "make_primary_mobile"),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: styleElements
                                          .captionThemeScalable(context)
                                          .copyWith(
                                              color:
                                                  HexColor(AppColors.appColorBlue))),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      height: 15,
                                      width: 1,
                                      child: Container(
                                        color: HexColor(AppColors.appColorBlack35),
                                      ),
                                    ),
                                  ),
                                  Text(
                                      list![index].isVerified!
                                          ? AppLocalizations.of(context)!
                                                  .translate("verified")
                                          : AppLocalizations.of(context)!
                                                  .translate("un_verified"),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: styleElements
                                          .captionThemeScalable(context)
                                          .copyWith(
                                              color: HexColor(list![index].isVerified!
                                                  ? AppColors.appColorGreen
                                                  : AppColors.appMainColor)))
                                ],
                              ),
                            ),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Visibility(
                                  visible: !list![index].isPrimary!,
                                  child: InkWell(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              DeleteContacts(
                                                callBack: () {
                                                  fetchSettings();
                                                },
                                                callBackCancel: () {},
                                                isEmail: isEmail,
                                                id: list![index].id,
                                                contactDetail:
                                                    list![index].contactDetail,
                                              ));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: SizedBox(
                                        height: 24,
                                        child: Icon(
                                          Icons.close,
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: !list![index].isVerified!,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EmailPhoneVerification(
                                              id: list![index].id,
                                              isEmail: isEmail,
                                              contactDetail:
                                                  list![index].contactDetail,
                                              callBack: () {
                                                fetchSettings();
                                              },
                                            ),
                                          ));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: HexColor(AppColors.appMainColor),
                                          ),
                                          borderRadius:
                                              BorderRadius.all(Radius.circular(20))),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, right: 8.0),
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .translate("verify"),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: styleElements
                                                .captionThemeScalable(context)
                                                .copyWith(
                                                    color: HexColor(
                                                        AppColors.appMainColor))),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
      ),
    );
  }

  _AddEditEmailPhonesPage(this.list, this.isEmail);

  Future<void> setPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  void makeContactPrimary(int? id) async {
    setState(() {
      isLoading = true;
    });

    final body =
        jsonEncode({"id": id, "contact_type": isEmail ? "email" : "mobile"});
    Calls()
        .call(body, context, Config.MAKE_CONTACT_PRIMARY)
        .then((value) async {
      setState(() {
        isLoading = false;
      });

      if (value != null) {
        fetchSettings();
      }
    }).catchError((onError) async {
      ToastBuilder().showToast(
          onError.toString(), context, HexColor(AppColors.information));
      setState(() {
        isLoading = false;
      });
    });
  }

  void fetchSettings() async {
    setState(() {
      isLoading = true;
    });

    final body = jsonEncode({
      "person_id": prefs.getInt("userId"),
    });
    Calls().call(body, context, Config.SETTINGSVIEW).then((value) async {
      setState(() {
        isLoading = false;
      });

      if (value != null) {
        var data = SettingsView.fromJson(value);
        if (this.mounted && data.statusCode == Strings.success_code) {
          setState(() {
            list = isEmail
                ? data.rows!.emailContactList
                : data.rows!.mobileContactList;
          });
        }
      }
    }).catchError((onError) async {
      ToastBuilder().showToast(
          onError.toString(), context, HexColor(AppColors.information));
      setState(() {
        isLoading = false;
      });
    });
  }
}
