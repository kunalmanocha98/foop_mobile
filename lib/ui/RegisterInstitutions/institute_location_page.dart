import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/conversationPage/base_response.dart';
import 'package:oho_works_app/models/CalenderModule/event_create_models.dart';
import 'package:oho_works_app/models/language_list.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'confirm_details_institute.dart';
import 'country_page.dart';
import 'models/countries.dart';
import 'models/institute_location.dart';
import 'models/states.dart';

// ignore: must_be_immutable
class InstituteLocationAddressPage extends StatefulWidget {
  int? instId;
  bool isEvent;
  EventLocation? offlineLocation;

  InstituteLocationAddressPage(this.instId,{this.isEvent=false,this.offlineLocation});

  @override
  _InstituteLocationAddressPage createState() =>
      new _InstituteLocationAddressPage(instId,isEvent: isEvent,offlineLocation: offlineLocation);
}

class _InstituteLocationAddressPage extends State<InstituteLocationAddressPage>
    with SingleTickerProviderStateMixin {
  String? facebookId;
  String? googleSignInId;
  String? userName;
  String? imageUrl;
  bool? isEvent;
  var range = <String>[];
  var rangeStudent = <String>[];

  var instituteTypelist = <String>[];
  var relationship = <String?>[];
  var mapCountry = HashMap<String, String>();
  var mapState = HashMap<String?, String?>();
  bool isTermAndConditionAccepted = false;
  String email = "";
  bool isGoogleOrFacebookDataReceived = false;
  double startPos = -1.0;
  double endPos = 1.0;
  Curve curve = Curves.elasticOut;
  final cityMapController = TextEditingController();
  final pinController = TextEditingController();
  final addController = TextEditingController();
  final fromMapController = TextEditingController();
 late BuildContext context;
  late TextStyleElements styleElements;

   bool isLoading=false;
  String? selectState;

  String? selectCountry = "Country";

  String? selectStRange;

  String? selectTecRange;
  int? selectedEpoch;
  int? instId;
  late SharedPreferences prefs;
  EventLocation? offlineLocation;


  _InstituteLocationAddressPage(this.instId, {this.isEvent,this.offlineLocation});

  @override
  void initState() {
    if(offlineLocation!=null){
      cityMapController.text = offlineLocation!.address!.city!;
      pinController.text = offlineLocation!.address!.pincode!;
      addController.text = offlineLocation!.address!.address!;
    }
    super.initState();
    getInstituteType();
    setSharedPreferences();
  }
  void setSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();


  }
  String quotesCharacterLength = "0";

  @override
  Widget build(BuildContext context) {
    this.context = context;
    styleElements = TextStyleElements(context);

    List<DropdownMenuItem> relationType = [];


    _getRelationtype() {
      for (int i = 0; i < relationship.length; i++) {
        relationType.add(DropdownMenuItem(
          child: Text(
            relationship[i]!,
            style: styleElements.bodyText2ThemeScalable(context),
          ),
          value: relationship[i],
        ));
      }
      return relationType;
    }

    final pinZIp = Form(
        child: TextFormField(
      style: styleElements.subtitle1ThemeScalable(context).copyWith(
          color: HexColor(AppColors.appColorBlack65)
      ),
      onSaved: (String? value) {},
      controller: pinController,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0.w, 15.0.h, 20.0.w, 15.0.h),
          hintText: AppLocalizations.of(context)!.translate('pin_zip'),
          hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35)),
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 0.0.h,
            ),
          )),
    ));
    final cityTown = Form(
        child: TextFormField(
      style: styleElements.subtitle1ThemeScalable(context).copyWith(
          color: HexColor(AppColors.appColorBlack65)
      ),
      onSaved: (String? value) {},
      controller: cityMapController,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0.w, 15.0.h, 20.0.w, 15.0.h),
          hintText: AppLocalizations.of(context)!.translate('city_town'),
          hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35)),
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 0.0.h,
            ),
          )),
    ));
    final address = TextFormField(
      controller: addController,
      textCapitalization: TextCapitalization.words,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      onChanged: (text) {
        setState(() {
          quotesCharacterLength = text.length.toString();
        });
      },
      inputFormatters: [
        new LengthLimitingTextInputFormatter(200),
      ],
      style: styleElements
          .subtitle1ThemeScalable(context).copyWith(
          color: HexColor(AppColors.appColorBlack65)),
      scrollPadding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
          hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35)),
          hintText: AppLocalizations.of(context)!.translate('address')),
    );
    styleElements = TextStyleElements(context);


    final country = GestureDetector(
      onTap: () async {
        var result = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => CountryPage()));

        if (result != null) {
          LanguageItem languageItem = result["result"] as LanguageItem;
          selectCountry = languageItem.languageName;
          setState(() {});
          getRelationType(languageItem.languageCode);
        }
      },
      child: Container(
        color: HexColor(AppColors.appColorWhite),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 22),
              child: Text(
                selectCountry!,
                style: styleElements
                    .bodyText2ThemeScalable(context)
                    .copyWith(color: HexColor(AppColors.appColorBlack65)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Divider(
                color: HexColor(AppColors.appColorGrey500),
                thickness: 1,
              ),
            )
          ],
        ),
      ),
    )

        /*DropdownButtonFormField(
      value: null,
      isExpanded: true,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0.w, 15.0.h, 2.0.w, 15.0.h)),
      hint: Padding(
        padding: const EdgeInsets.only(left: 0),
        child: Text(
          selectCountry ?? "Country",
          style: styleElements.bodyText2ThemeScalable(context),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      items: _getInstituteType(),
      onChanged: (value) {
        setState(() {
          selectCountry = value ?? selectCountry;
          getCountryCode(selectCountry);
        });
      },
    )*/
        ;

    final state = DropdownButtonFormField<dynamic>(
      value: null,
      isExpanded: true,

      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0.w, 15.0.h, 2.0.w, 15.0.h)),
      hint: Padding(
        padding: const EdgeInsets.only(left: 0),
        child: Text(
          selectState ?? "State",
          style: styleElements.bodyText2ThemeScalable(context),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      items: _getRelationtype(),
      onChanged: (value) {
        value as DropdownMenuItem;
        setState(() {
          selectState = (value) as String?;
        });
      },
    );

    return new WillPopScope(
      onWillPop:isEvent!?()async{return new Future(() => false);}:_onBackPressed,
      child: SafeArea(
          child: Scaffold(
              // resizeToAvoidBottomInset: false,
              appBar: TricycleAppBar().getCustomAppBar(context,
                  appBarTitle: isEvent! ?
                  AppLocalizations.of(context)!.translate('register_institute'):
                  AppLocalizations.of(context)!.translate('select_location'),
                  isIconVisible:isEvent,
                  actions: [

                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: (){

                          submit(context);

                        },
                        child: Row(
                          children: [
                            Text(AppLocalizations.of(context)!.translate('next'), style:styleElements.subtitle2ThemeScalable(context).copyWith(color: HexColor(AppColors.appMainColor)),),
                            Visibility(
                              visible: isLoading,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: SizedBox(
                                  height: 15,
                                  width: 15,
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],


                  onBackButtonPress: () {
                 Navigator.pop(context);
                  }



              ),
              body: Stack(
                children: [
                  SingleChildScrollView(
                    child: Visibility(
                        visible: !isGoogleOrFacebookDataReceived,
                        child: TricycleCard(
                          child: Column(
                            children: <Widget>[
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        left: 8.w, right: 8.w, bottom: 8.h),
                                    child: Text(AppLocalizations.of(context)!.translate('location'),
                                      style: styleElements
                                          .headline6ThemeScalable(context)
                                          .copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                  )),
                              /*  Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        left: 8.w, right: 8.w, bottom: 8.h),
                                    child: selectMap,
                                  )),*/
                              Container(
                                  height: 150,
                                  margin: const EdgeInsets.only(
                                      left: 8.0, right: 8.0),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: HexColor(AppColors.appColorGrey500),
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8))),
                                  child: address),
                              Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        left: 8.w, right: 8.w, bottom: 8.h),
                                    child: country,
                                  )),
                              Visibility(
                                visible: selectCountry != null &&
                                    selectCountry != "Country",
                                child: Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          left: 8.w, right: 8.w, bottom: 8.h),
                                      child: state,
                                    )),
                              ),
                              Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        left: 8.w, right: 8.w, bottom: 8.h),
                                    child: cityTown,
                                  )),
                              Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        left: 8.w, right: 8.w, bottom: 8.h),
                                    child: pinZIp,
                                  )),
                            ],
                          ),
                        )),
                  ),

                ],
              ))),
    );
  }

  // ignore: missing_return
  Future<bool> _onBackPressed() {
    return new Future(() => false);
  }

  void getInstituteType() async {
    prefs = await SharedPreferences.getInstance();
    Calls().calWithoutToken("", context, Config.COUNTRIES).then((value) async {
      if (value != null) {
        var data = Country.fromJson(value);

        for (var item in data.rows!) {
          instituteTypelist.add(item[1].toString());

          mapCountry.putIfAbsent(item[1].toString(), () => item[0].toString());
        }
        setState(() {});
      }
    }).catchError((onError) {
      ToastBuilder().showToast(
          onError.toString(), context, HexColor(AppColors.information));
    });
  }

  void getRelationType(String? code) async {
    if (code != null) {
      final body = jsonEncode({
        "country": code,
      });
      Calls().calWithoutToken(body, context, Config.STATES).then((value) async {
        if (value != null) {
          var data = States.fromJson(value);
          for (var item in data.rows!) {
            relationship.add(item.name);
            mapState.putIfAbsent(item.name, () => item.code);
          }
          setState(() {});
        }
      }).catchError((onError) {
        ToastBuilder().showToast(
            onError.toString(), context, HexColor(AppColors.information));
      });
    }
  }

  void submit(BuildContext ctx) async {
    setState(() {
      isLoading=true;
    });
    if (selectCountry!=null && selectCountry!.isNotEmpty)
    {
        if (selectState!=null && selectState!.isNotEmpty)
        {
          if (pinController.text.trim().isNotEmpty) {
            if (cityMapController.text.trim().isNotEmpty) {
              {
                var country;
                var state;
                mapCountry.forEach((key, value) {
                  if (key == selectCountry) country = value;
                });
                mapState.forEach((key, value) {
                  if (key == selectState) state = value;
                });

                if(!isEvent!) {
                  InstituteLocationDetail instituteContactDetail = InstituteLocationDetail();
                  instituteContactDetail.institutionId = instId;
                  instituteContactDetail.address = addController.text;
                  instituteContactDetail.country = country;
                  instituteContactDetail.state = state;
                  instituteContactDetail.postalCode = pinController.text;
                  instituteContactDetail.city = cityMapController.text;
                  prefs.setString(Strings.registeredInstituteLocation,
                      cityMapController.text);
                  print(jsonEncode(instituteContactDetail));

                  Calls()
                      .call(jsonEncode(instituteContactDetail), context,
                      Config.INSTITUTE_ADDRESS)
                      .then((value) async {
                    setState(() {
                      isLoading = false;
                    });
                    if (value != null) {
                      var data = BaseResponse.fromJson(value);
                      if (data.statusCode == Strings.success_code) {
                        prefs.setString("create_institute", "ConfirmDetails");
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ConfirmDetails(instId: instId,
                                        fromPage: "registration")));
                      }
                    }
                  }).catchError((onError) {
                    setState(() {
                      isLoading = false;
                    });
                    ToastBuilder().showToast(
                        onError.toString(), context,
                        HexColor(AppColors.information));
                  });
                }else{
                  var location = EventLocation(
                      type: 'offline',
                      address: Address(
                          address: addController.text,
                          city:  cityMapController.text,
                          state: state,
                          country: country,
                          pincode: pinController.text,
                      )
                  );
                  Navigator.pop(context,location);
                }
              }
            } else {
              setState(() {
                isLoading=false;
              });

              ToastBuilder().showToast(
                  AppLocalizations.of(context)!.translate("city_req"),
                  context,
                  HexColor(AppColors.information));
            }
          } else {
            setState(() {
              isLoading=false;
            });

            ToastBuilder().showToast(
                AppLocalizations.of(context)!.translate("pin_code_req"),
                context,
                HexColor(AppColors.information));
          }
        }
        else {
          setState(() {
            isLoading=false;
          });

          ToastBuilder().showToast(
              AppLocalizations.of(context)!.translate("state_req"),
              context,
              HexColor(AppColors.information));
        }
      }
    else{
      setState(() {
        isLoading=false;
      });

      ToastBuilder().showToast(
          AppLocalizations.of(context)!.translate("country_req"),
          context,
          HexColor(AppColors.information));
    }


  }
}
