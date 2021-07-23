import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/api_calls/logout_api.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/home/home.dart';
import 'package:oho_works_app/models/common_response.dart';
import 'package:oho_works_app/models/invitationlink_response.dart';
import 'package:oho_works_app/models/menu/menulistmodels.dart';
import 'package:oho_works_app/models/personal_profile.dart';
import 'package:oho_works_app/profile_module/common_cards/testcard.dart';
import 'package:oho_works_app/tri_cycle_database/data_base_helper.dart';
import 'package:oho_works_app/ui/invitations/parent_invite_page.dart';
import 'package:oho_works_app/ui/invitations/user_contacts.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'invite_classmates_teacher.dart';

// ignore: must_be_immutable
class InvitationPage extends StatefulWidget {
  SharedPreferences? prefs;

  InvitationPage({this.prefs});

  @override
  _InvitationPage createState() => _InvitationPage(prefs: prefs);
}

class _InvitationPage extends State<InvitationPage> {
  late TextStyleElements styleElements;
  ProgressDialog? pr;
  Persondata? rows;
  var followers = 0;
  var following = 0;
  var roomsCount = 0;
  var postCount = 0;
  String? deepLink ;
  String? invitationText ;
  bool cb1 = false, cb2 = false;
  List<MenuListItem>? menuList = [];
  int? selectedRadio;
  SharedPreferences? prefs;
  final dbHelper = DatabaseHelper.instance;
  _InvitationPage({this.prefs});

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: HexColor(AppColors.appColorTransparent),
        statusBarIconBrightness: Brightness.dark));
    WidgetsBinding.instance!.addPostFrameCallback((_) => fetchMenuListData());
    getDeepLink();
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return SafeArea(
      child: Scaffold(
        appBar: TricycleAppBar().getCustomAppBar(context, appBarTitle: 'Invite',
            onBackButtonPress: () {
          Navigator.pop(context);
        }),
        body: Container(
          margin: EdgeInsets.only(top: 8),
          child: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
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
                            child: Image(
                                image: AssetImage(
                                    'assets/appimages/Teacher-pana.png')),
                          ),
                        ),
                        Container(
                            child: Text(
                          AppLocalizations.of(context)!.translate("invite_friend"),
                          style: styleElements.headline6ThemeScalable(context),
                        )),
                        Container(
                            child: Text(
                          AppLocalizations.of(context)!.translate("earn_coins"),
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
              itemCount: menuList!.length,
              itemBuilder: (BuildContext context, int index) {
                return menuList![index].tag == "text"
                    ? Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 16.0, top: 16),
                  child: Text(
                    menuList![index].title!,
                    style: styleElements.captionThemeScalable(context),
                  ),
                )
                    :
                menuList![index].code == "copylink"?
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: HexColor(AppColors.appColorGrey500),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(8))
                      ),
                      child: InkWell(
                          onTap: () {
                            menuitemClick(menuList![index].code);
                          },
                          child:  (Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: deepLink!=null? ListTile(
                              title: Text(
                                deepLink!,
                                style: styleElements
                                    .subtitle1ThemeScalable(context),
                              ),
                              trailing: Visibility(
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .translate("copy"),
                                  style: styleElements
                                      .subtitle1ThemeScalable(context)
                                      .copyWith(color: HexColor(AppColors.appColorBlue)),
                                ),
                              ),
                            ):Center(
                              child: SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: CircularProgressIndicator()),
                            ),
                          ))

                      )
                  ),
                ):
                TricycleCard(
                  padding: EdgeInsets.all(0),
                  margin: menuList![index].code == "copylink"
                      ? const EdgeInsets.only(
                      left: 8, right: 8, top: 16)
                      : const EdgeInsets.only(
                      left: 8, right: 8, top: 0.5),
                  child: InkWell(
                    onTap: () {
                      if(menuList![index].code!=null)
                      menuitemClick(menuList![index].code);
                    },
                    child: menuList![index].code == "copylink"
                        ? (Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(
                          deepLink!,
                          style: styleElements
                              .subtitle1ThemeScalable(context),
                        ),
                        trailing: Visibility(
                          child: Text(
                            AppLocalizations.of(context)!
                                .translate("copy"),
                            style: styleElements
                                .subtitle1ThemeScalable(context)
                                .copyWith(color: HexColor(AppColors.appColorBlue)),
                          ),
                        ),
                      ),
                    ))
                        : ListTile(
                      leading: menuList![index].tag == "icon"
                          ? (menuList![index].imageUrl == "phone"
                          ? Icon(Icons.import_contacts)
                          : Icon(Icons.share))
                          : Container(
                          height: 24,
                          width: 24,
                          child: Image(
                            image: AssetImage(
                                menuList![index].imageUrl!),
                          )),
                      title: Text(
                        menuList![index].title!,
                        style: styleElements
                            .subtitle1ThemeScalable(context),
                      ),
                      trailing: Visibility(
                        child: Icon(Icons.keyboard_arrow_right),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void logout() async {
    // ProgressDialog pr = ToastBuilder().setProgressDialog(context);
    // await pr.show();
    LogOutApi().logOut(context,"").then((value) async {
      // await pr.hide();
      if (value != null) {
        prefs = await SharedPreferences.getInstance();
        var data = CommonBasicResponse.fromJson(value);
        ToastBuilder()
            .showToast(data.message!, context, HexColor(AppColors.success));
        prefs!.clear();
        prefs!.setBool("isLogout", true);
       
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Home()),
            (Route<dynamic> route) => false);
      }
    }).catchError((onError) async {
      ToastBuilder().showToast(
          onError.toString(), context, HexColor(AppColors.information));
      // await pr.hide();
    });
    /*    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SelectLanguage(true),
        ));*/
  }

  Future<void> menuitemClick(String? code) async {
    switch (code) {
      case 'Whatsapp':
        {
          StringBuffer buffer = StringBuffer();
          buffer.writeAll([invitationText??"","\n\n",deepLink??""]);
          Share.share(buffer.toString());
          break;
        }
      case 'link':
        {

          StringBuffer buffer = StringBuffer();
          buffer.writeAll([invitationText??"","\n\n",deepLink??""]);
          Share.share(buffer.toString());
          break;
        }
      case 'copylink':
        {
          Clipboard.setData(new ClipboardData(text: deepLink));
          ToastBuilder().showToast(
             "Copied", context, HexColor(AppColors.information));
          break;
        }
      case 'inviteTeachers':
        {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InviteTeachersClassMates(),
              ));
          break;
        }
      case 'phonebook':
        {
       var result= await   Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserContacts(),
              ));

       if(result!=null)
         {
           await dbHelper.updateIsSelectedAll();
         }
          break;
        }
      case 'inviteParent':
        {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InviteParent(),
              ));
          break;
        }
    }
  }

  getDeepLink() async {
    prefs = await SharedPreferences.getInstance();
    // ProgressDialog progressDialog = ProgressDialog(context);

    Calls()
        .call(
            jsonEncode({
              "invitation_link_type": prefs!.getString("ownerType"),
              "invitation_link_type_id": prefs!.getInt("userId")

            }),
            context,
            Config.INVITATION_LINK)
        .then((value) {

      var res = InvitationResponse.fromJson(value);
      if (res.statusCode == Strings.success_code) {
        if (res.rows != null && res.rows!.invitationLink != null)
          {
            setState(() {
              deepLink = res.rows!.invitationLink;
              invitationText=res.rows!.invitationText;
            });
          }

      } else {}
    }).catchError((onError) {
      print(onError);

    });
  }

  void fetchMenuListData() async {
    var res = await rootBundle.loadString('assets/invite.json');
    final Map? parsed = json.decode(res);
    setState(() {
      menuList = MenuListResponse.fromJson(parsed as Map<String, dynamic>).rows;
    });
  }
}
