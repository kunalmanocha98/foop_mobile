import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/app_account_detail_add.dart';
import 'package:oho_works_app/components/app_user_list_tile.dart';
import 'package:oho_works_app/enums/DictionaryType.dart';
import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/login_signup_module/changepassword.dart';
import 'package:oho_works_app/models/disctionarylist.dart';
import 'package:oho_works_app/models/email_module/domain_create.dart';
import 'package:oho_works_app/models/language_list.dart';
import 'package:oho_works_app/models/personal_profile.dart';
import 'package:oho_works_app/models/settignsView.dart';
import 'package:oho_works_app/ui/dateAndTimeSelections.dart';
import 'package:oho_works_app/ui/language_update.dart';
import 'package:oho_works_app/ui/privacysettings.dart';
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

import 'Settings/institute_admin_list.dart';
import 'blockeduserslist.dart';
import 'email_mobile_add_edit_page.dart';
import 'email_module/email_login_page.dart';
import 'email_module/email_user_listing.dart';
import 'email_module/manage_domain_page.dart';
import 'email_module/professional_email_page.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPage createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  late TextStyleElements styleElements;
  SharedPreferences? prefs = locator<SharedPreferences>();
  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    var data = Persondata.fromJson(jsonDecode(prefs!.getString(Strings.basicData)!));
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: appAppBar().getCustomAppBar(context,
            appBarTitle: AppLocalizations.of(context)!.translate("settings"),
            onBackButtonPress: () {
          Navigator.pop(context);
        }),
        body: Stack(
          children: [
            Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AccountSettings(),
                        ));
                  },
                  child: Card(
                      elevation: 0,
                      margin:
                          EdgeInsets.only(left: 4, right: 4, top: 1, bottom: 1),
                      child: Padding(
                        padding: EdgeInsets.only(top: 8, bottom: 8, left: 8),
                        child: ListTile(
                          title: Text(
                            AppLocalizations.of(context)!
                                .translate("account_settings"),
                            style:
                                styleElements.subtitle1ThemeScalable(context),
                          ),
                        ),
                      )),
                ),
                InkWell(
                  onTap: () {
                    if (prefs!.containsKey(Strings.mailUsername)) {
                      showManageEmailSheet(
                          data.permissions!.any((element) {
                            return element.roleCode == 'ADMIN';
                          })
                      );
                    } else {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                            return EmailLoginPage(
                              onlyLogin: true,
                            );
                          })).then((value) {
                        if (value != null && value) {
                          showManageEmailSheet(
                              data.permissions!.any((element) {
                                return element.roleCode == 'ADMIN';
                              })
                          );
                        }
                      });
                    }
                  },
                  child: Card(
                      elevation: 0,
                      margin:
                      EdgeInsets.only(left: 4, right: 4, top: 1, bottom: 1),
                      child: Padding(
                        padding: EdgeInsets.only(top: 8, bottom: 8, left: 8),
                        child: ListTile(
                          title: Text(
                            AppLocalizations.of(context)!
                                .translate("manage_professional"),
                            style:
                            styleElements.subtitle1ThemeScalable(context),
                          ),
                        ),
                      )),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChangePassword(),
                        ));
                  },
                  child: Card(
                    elevation: 0,
                    margin: EdgeInsets.only(left: 4, right: 4, bottom: 1),
                    child: Padding(
                      padding: EdgeInsets.only(top: 8, bottom: 8, left: 8),
                      child: ListTile(
                        title: Text(
                          AppLocalizations.of(context)!
                              .translate("change_password"),
                          style: styleElements.subtitle1ThemeScalable(context),
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PrivacySettings(),
                        ));
                  },
                  child: Card(
                    elevation: 0,
                    margin: EdgeInsets.only(left: 4, right: 4, bottom: 1),
                    child: Padding(
                      padding: EdgeInsets.only(top: 8, bottom: 8, left: 8),
                      child: ListTile(
                        title: Text(
                          AppLocalizations.of(context)!
                              .translate("privacy_settings"),
                          style: styleElements.subtitle1ThemeScalable(context),
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlockedUsersList(),
                        ));
                  },
                  child: Card(
                    elevation: 0,
                    margin: EdgeInsets.only(left: 4, right: 4, bottom: 1),
                    child: Padding(
                      padding: EdgeInsets.only(top: 8, bottom: 8, left: 8),
                      child: ListTile(
                        title: Text(
                            AppLocalizations.of(context)!
                                .translate("blocked_user"),
                            style:
                                styleElements.subtitle1ThemeScalable(context)),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddAccountDetails(),
                        ));
                  },
                  child: Card(
                    elevation: 0,
                    margin: EdgeInsets.only(left: 4, right: 4, bottom: 1),
                    child: Padding(
                      padding: EdgeInsets.only(top: 8, bottom: 8, left: 8),
                      child: ListTile(
                        title: Text(
                            AppLocalizations.of(context)!
                                .translate("account_details"),
                            style:
                            styleElements.subtitle1ThemeScalable(context)),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: data.permissions!.any((element) {return element.roleCode == 'ADMIN';}),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InstituteAdminListPage(),
                          ));
                    },
                    child: Card(
                      elevation: 0,
                      margin: EdgeInsets.only(left:4,right: 4,bottom: 1),
                      child: Padding(
                        padding: EdgeInsets.only(top: 8, bottom: 8, left: 8),
                        child: ListTile(
                          title: Text(
                              AppLocalizations.of(context)!
                                  .translate("entity_admins"),
                              style: styleElements.subtitle1ThemeScalable(context)),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
  void showManageEmailSheet(bool isAdmin) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12))),
        builder: (BuildContext context) {
          return ManageEmailAccountSheet(isAdmin);
        });
  }
}
class ManageEmailAccountSheet extends StatelessWidget {
  final bool isAdmin;
  ManageEmailAccountSheet(this.isAdmin);
  final SharedPreferences prefs = locator<SharedPreferences>();

  @override
  Widget build(BuildContext context) {
    var prefs = locator<SharedPreferences>();
    var styleElements = TextStyleElements(context);
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding:
            EdgeInsets.only(top: 12.0, bottom: 16, left: 12, right: 12),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      AppLocalizations.of(context)!.translate('manage_account'),
                      style: styleElements
                          .headlinecustomThemeScalable(context)
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.close,
                          size: 28,
                          color: HexColor(AppColors.appColorBlack65),
                        )))
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16, right: 8, left: 8, bottom: 16),
            child: appUserListTile(
              imageUrl: prefs.getString(Strings.profileImage),
              title: prefs.getString(Strings.userName),
              subtitle1: prefs.getString(Strings.mailUsername),
            ),
          ),
          InkWell(
            onTap: () {
              manageyouraccount(context);
            },
            child: ListTile(
              title: Text(
                AppLocalizations.of(context)!.translate('manage_your_account'),
                style: styleElements
                    .subtitle1ThemeScalable(context)
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                AppLocalizations.of(context)!
                    .translate('manage_your_account_des'),
                style: styleElements.bodyText2ThemeScalable(context),
              ),
            ),
          ),
          Visibility(
            visible: isAdmin,
            child: InkWell(
              onTap: () {
                openUserListingPage(context);
              },
              child: ListTile(
                title: Text(
                  AppLocalizations.of(context)!.translate('manage_user_account'),
                  style: styleElements
                      .subtitle1ThemeScalable(context)
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  AppLocalizations.of(context)!
                      .translate('manage_user_account_des'),
                  style: styleElements.bodyText2ThemeScalable(context),
                ),
              ),
            ),
          ),
          Visibility(
            visible: isAdmin,
            child: InkWell(
              onTap: () {
                openManageUserListingPage(context);
              },
              child: ListTile(
                title: Text(
                  AppLocalizations.of(context)!.translate('manage_domain_name'),
                  style: styleElements
                      .subtitle1ThemeScalable(context)
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  AppLocalizations.of(context)!
                      .translate('manage_domain_name_des'),
                  style: styleElements.bodyText2ThemeScalable(context),
                ),
              ),
            ),
          ),
          Visibility(
            visible: false,
            child: InkWell(
              onTap: () {},
              child: ListTile(
                title: Text(
                  AppLocalizations.of(context)!.translate('manage_subscription'),
                  style: styleElements
                      .subtitle1ThemeScalable(context)
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  AppLocalizations.of(context)!
                      .translate('manage_subscription_des'),
                  style: styleElements.bodyText2ThemeScalable(context),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 24,
          )
        ],
      ),
    );
  }

  void openUserListingPage(BuildContext context) async {
    DomainCreateRequest payload = DomainCreateRequest();
    payload.ownerType = prefs.getString(Strings.ownerType)!;
    payload.ownerId = prefs.getInt(Strings.userId)!;
    var value = await Calls().call(
        jsonEncode(payload), context, Config.EMAIL_DOMAIN_LIST,
        isMailToken: true);
    var res = DomainListResponse.fromJson(value);
    if (res.rows!.length > 0) {
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
            return EmailUsersPage();
          }));
    } else {
      openManageUserListingPage(context);
    }
  }

  void openManageUserListingPage(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return ManageDomainPage();
    }));
  }

  void manageyouraccount(BuildContext context) async {
    DomainCreateRequest payload = DomainCreateRequest();
    payload.ownerType = prefs.getString(Strings.ownerType)!;
    payload.ownerId = prefs.getInt(Strings.userId)!;
    var value = await Calls().call(
        jsonEncode(payload), context, Config.EMAIL_DOMAIN_LIST,
        isMailToken: true);
    var res = DomainListResponse.fromJson(value);
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return ProfessionalEmailActionPage(
        haveDomain: res.rows!.length > 0,
        isAdmin: isAdmin,
      );
    }));
  }
}

class AccountSettings extends StatefulWidget {
  @override
  _AccountSettings createState() => _AccountSettings();
}

class _AccountSettings extends State<AccountSettings> {
  SettingsView? settingsView;
  late SharedPreferences prefs;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    setPrefs();
  }

  Future<void> setPrefs() async {
    prefs = await SharedPreferences.getInstance();
    WidgetsBinding.instance!.addPostFrameCallback((_) => fetchSettings());
  }

  String setLanguage(List<LanguageItem> contentLanguage) {
    var s = StringBuffer();
    for (int i = 0; i < contentLanguage.length; i++) {
      s.write(contentLanguage[i].languageName);
      if (i != (contentLanguage.length - 1)) {
        s.write(",");
      }
    }
    return s.toString();
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
            settingsView = data;
          });
        } else {
          ToastBuilder().showToast(
              data.message!, context, HexColor(AppColors.information));
          Navigator.pop(context);
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

  void refresh() async {
    final body = jsonEncode({
      "person_id": prefs.getInt("userId"),
    });
    Calls().call(body, context, Config.SETTINGSVIEW).then((value) async {
      if (value != null) {
        var data = SettingsView.fromJson(value);
        if (this.mounted && data.statusCode == Strings.success_code) {
          setState(() {
            settingsView = data;
          });
        }
      }
    }).catchError((onError) {
      ToastBuilder().showToast(
          onError.toString(), context, HexColor(AppColors.information));
    });
  }

  late TextStyleElements styleElements;

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appAppBar().getCustomAppBar(context,
          appBarTitle: AppLocalizations.of(context)!
              .translate("account_settings"), onBackButtonPress: () {
        Navigator.pop(context);
      }),
      body: isLoading
          ? PreloadingView(url: "assets/appimages/settings.png")
          : Stack(
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UpdateLanguagePage(
                                        true, settingsView!.rows!.id,false)))
                            .then((value) => refresh());
                      },
                      child: Card(
                        elevation: 0,
                        margin: EdgeInsets.only(left: 4, right: 4, bottom: 1),
                        child: ListTile(
                          title: Text(
                            settingsView != null
                                ? settingsView!.rows!.language!.languageNameLocal!
                                : "",
                            style:
                                styleElements.subtitle1ThemeScalable(context),
                          ),
                          subtitle: Text(
                            AppLocalizations.of(context)!
                                .translate("app_lang_des"),
                            style: styleElements.captionThemeScalable(context),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UpdateLanguagePage(
                                        false, settingsView!.rows!.id,false)))
                            .then((value) => refresh());
                      },
                      child: Card(
                        elevation: 0,
                        margin: EdgeInsets.only(left: 4, right: 4, bottom: 1),
                        child: ListTile(
                          title: Text(
                            settingsView != null
                                ? setLanguage(settingsView!.rows!.contentLanguage!)
                                : "",
                            style:
                                styleElements.subtitle1ThemeScalable(context),
                          ),
                          subtitle: Text(
                            AppLocalizations.of(context)!
                                .translate("content_lang_des"),
                            style: styleElements.captionThemeScalable(context),
                          ),
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UpdateLanguagePage(
                                        true, settingsView!.rows!.id,true)))
                            .then((value) => refresh());
                      },
                      child: Card(
                        elevation: 0,
                        margin: EdgeInsets.only(left: 4, right: 4, bottom: 1),
                        child: ListTile(
                          title: Text(
                            settingsView != null && settingsView!.rows!=null &&
                                    settingsView!.rows!.transLateLanguage != null && settingsView!.rows!.transLateLanguage!.name!=null
                                ? settingsView!
                                    .rows!.transLateLanguage!.name!
                                : AppLocalizations.of(context)!
                                    .translate("select_translation_language"),
                            style:
                                styleElements.subtitle1ThemeScalable(context),
                          ),
                          subtitle: Text(
                            AppLocalizations.of(context)!
                                .translate("translation_language"),
                            style: styleElements.captionThemeScalable(context),
                          ),
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DateSelectionPage(
                                        settingsView!.rows!.id)))
                            .then((value) => refresh());
                      },
                      child: Card(
                        elevation: 0,
                        margin: EdgeInsets.only(left: 4, right: 4, bottom: 1),
                        child: ListTile(
                          title: Text(
                            settingsView != null
                                ? settingsView!.rows!.dateFormat!
                                : "",
                            style:
                                styleElements.subtitle1ThemeScalable(context),
                          ),
                          subtitle: Text(
                            AppLocalizations.of(context)!
                                .translate("date_format"),
                            style: styleElements.captionThemeScalable(context),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TimeSelectionPage(
                                        settingsView!.rows!.id)))
                            .then((value) => refresh());
                      },
                      child: Card(
                        elevation: 0,
                        margin: EdgeInsets.only(left: 4, right: 4, bottom: 1),
                        child: ListTile(
                          title: Text(
                            settingsView != null
                                ? settingsView!.rows!.timeFormat!
                                : "",
                            style:
                                styleElements.subtitle1ThemeScalable(context),
                          ),
                          subtitle: Text(
                            AppLocalizations.of(context)!
                                .translate("time_format"),
                            style: styleElements.captionThemeScalable(context),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddEditEmailPhonesPage(
                                    settingsView!.rows!.emailContactList,
                                    true))).then((value) => refresh());
                      },
                      child: Card(
                        elevation: 0,
                        margin: EdgeInsets.only(left: 4, right: 4, bottom: 1),
                        child: ListTile(
                          title: Text(
                            AppLocalizations.of(context)!
                                .translate("email_addresses"),
                            style:
                                styleElements.subtitle1ThemeScalable(context),
                          ),
                          subtitle: Text(
                            AppLocalizations.of(context)!
                                .translate("add_remove_email"),
                            style: styleElements.captionThemeScalable(context),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddEditEmailPhonesPage(
                                    settingsView!.rows!.mobileContactList,
                                    false))).then((value) => refresh());
                      },
                      child: Card(
                        elevation: 0,
                        margin: EdgeInsets.only(left: 4, right: 4, bottom: 1),
                        child: ListTile(
                          title: Text(
                            AppLocalizations.of(context)!
                                .translate("phone_numbers"),
                            style:
                                styleElements.subtitle1ThemeScalable(context),
                          ),
                          subtitle: Text(
                            AppLocalizations.of(context)!
                                .translate("add_remove_mobile"),
                            style: styleElements.captionThemeScalable(context),
                          ),
                        ),
                      ),
                    ),
                    /* GestureDetector(
                onTap: () {
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CurrencyFormatSelection()))
                      .then((value) => refresh());
                },
                child: Card(
                  child: ListTile(
                    title: Text(
                      settingsView != null && settingsView.rows!=null && settingsView.rows.currency!=null
                          ? settingsView.rows.currency.code
                          : "",
                      style: styleElements.subtitle1ThemeScalable(context),
                    ),
                    subtitle: Text(
                      AppLocalizations.of(context).translate("your_currency"),
                      style: styleElements.captionThemeScalable(context),
                    ),
                  ),
                ),
              ),*/
                    // GestureDetector(
                    //   child: Card(child: ListTile(
                    //     title: Text(AppLocalizations.of(context).translate("change_password"),
                    //       style: TextStyle(
                    //         fontFamily: 'Source Sans Pro',
                    //         fontSize: 18,
                    //         color: HexColor(AppColors.appColorBlack),
                    //         fontWeight: FontWeight.w500,
                    //       ),),
                    //     subtitle: Text(AppLocalizations.of(context).translate("change_password_des")),
                    //   ),
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
    );
  }
}

class PrivacySettings extends StatefulWidget {
  @override
  _PrivacySettings createState() => _PrivacySettings();
}

class _PrivacySettings extends State<PrivacySettings> {
  PrivacySettingsView? settingsView;
  late SharedPreferences prefs;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    setPrefs();
  }

  Future<void> setPrefs() async {
    prefs = await SharedPreferences.getInstance();
    WidgetsBinding.instance!.addPostFrameCallback((_) => fetchSettings());
  }

  String setTitle(List<DictionaryListItem> dictionaryList) {
    var s = StringBuffer();
    for (int i = 0; i < dictionaryList.length; i++) {
      s.write(dictionaryList[i].description);
      if (i != (dictionaryList.length - 1)) {
        s.write(",");
      }
    }
    return s.toString();
  }

  void fetchSettings() async {
    setState(() {
      isLoading = true;
    });

    final body = jsonEncode({
      "person_id": prefs.getInt("userId"),
    });
    Calls().call(body, context, Config.PRIVACYSETTINGSVIEW).then((value) async {
      setState(() {
        isLoading = false;
      });

      if (value != null) {
        var data = PrivacySettingsView.fromJson(value);
        if (this.mounted && data.statusCode == Strings.success_code) {
          setState(() {
            settingsView = data;
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

  void refresh() async {
    final body = jsonEncode({
      "person_id": prefs.getInt("userId"),
    });
    Calls().call(body, context, Config.PRIVACYSETTINGSVIEW).then((value) async {
      if (value != null) {
        var data = PrivacySettingsView.fromJson(value);
        if (this.mounted && data.statusCode == Strings.success_code) {
          setState(() {
            settingsView = data;
          });
        }
      }
    }).catchError((onError) {
      ToastBuilder().showToast(
          onError.toString(), context, HexColor(AppColors.information));
    });
  }

  late TextStyleElements styleElements;

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appAppBar().getCustomAppBar(context,
          appBarTitle: AppLocalizations.of(context)!
              .translate("privacy_settings"), onBackButtonPress: () {
        Navigator.pop(context);
      }),
      body: Stack(
        children: [
          isLoading
              ? PreloadingView(url: "assets/appimages/settings.png")
              : Column(
                  children: [

                    Card(
                      elevation: 0,
                      margin: EdgeInsets.only(left: 4, right: 4, bottom: 1),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PrivacySettingsPage(
                                      DictionaryType.profile_visible_to.name,
                                      settingsView!.rows!
                                          .id))).then((value) => refresh());
                        },
                        child: ListTile(
                          title: Text(
                            settingsView != null
                                ? setTitle(settingsView!.rows!.profileVisibleTo!)
                                : "",
                            style:
                                styleElements.subtitle1ThemeScalable(context),
                          ),
                          subtitle: Text(
                            AppLocalizations.of(context)!
                                .translate("who_can_view_profile"),
                            style: styleElements.captionThemeScalable(context),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
