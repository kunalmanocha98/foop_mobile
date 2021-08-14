import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/conversationPage/base_response.dart';
import 'package:oho_works_app/models/CalenderModule/event_create_models.dart';
import 'package:oho_works_app/models/RegisterUserAs.dart';
import 'package:oho_works_app/models/base_res.dart';
import 'package:oho_works_app/models/business_response_detail.dart';
import 'package:oho_works_app/models/language_list.dart';
import 'package:oho_works_app/models/location_reponse_data.dart';
import 'package:oho_works_app/models/register_user_as_response.dart';
import 'package:oho_works_app/profile_module/pages/directions.dart';
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

import '../dialog_page.dart';
import 'basic_institute_detail.dart';
import 'confirm_details_institute.dart';
import 'country_page.dart';
import 'models/countries.dart';
import 'models/institute_location.dart';
import 'models/states.dart';

// ignore: must_be_immutable
class InstituteLocationAddressPage extends StatefulWidget {
  int? instId;
  bool isEvent;
  Function ? callBack;
  EventLocation? offlineLocation;
bool isEdit;
  final Function? refreshCallback;
  BusinessData? data;
  InstituteLocationAddressPage({this.instId,this.isEvent=false,this.offlineLocation,this.isEdit=false,this.callBack,this.data,this.refreshCallback});

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
  TextEditingController controller2 = TextEditingController();
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
  var country;
  var state;
  String? selectCountry = "Select Country";

  String? selectStRange;

  String? selectTecRange;
  int? selectedEpoch;
  int? instId;
  late SharedPreferences prefs;
  EventLocation? offlineLocation;


  _InstituteLocationAddressPage(this.instId, {this.isEvent=false,this.offlineLocation});

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
    getEditData();
    WidgetsBinding.instance!.addPostFrameCallback((_) =>


        getDataLocation());
  }


 void  getEditData()
  {
    if(widget.data!=null)
      {
        if(widget.data!.businessAddressCountry!=null)
          {
            selectCountry=widget.data!.businessAddressCountry!;
            country=widget.data!.businessAddressCountry!;
          }

        if(widget.data!.businessAddressRegion!=null)
        {selectState=widget.data!.businessAddressRegion!;
          state=widget.data!.businessAddressRegion!;
        }



      }

  }
  void setSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();


  }
  String quotesCharacterLength = "0";
  String addresses="address";
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
            hintText: AppLocalizations.of(context)!.translate('pin_zip'),

            contentPadding: EdgeInsets.only(
                left: 12, top: 16, bottom: 8),
            border: UnderlineInputBorder(
                borderRadius:
                BorderRadius.circular(12)),
            floatingLabelBehavior:
            FloatingLabelBehavior.auto,
            labelText:
            AppLocalizations.of(context)!.translate('pin_zip'),),


    ));
    final cityTown = Form(
        child: TextFormField(
      style: styleElements.subtitle1ThemeScalable(context).copyWith(
          color: HexColor(AppColors.appColorBlack65)
      ),
      onSaved: (String? value) {},
      controller: cityMapController,


          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.translate('city_town'),

            contentPadding: EdgeInsets.only(
                left: 12, top: 16, bottom: 8),
            border: UnderlineInputBorder(
                borderRadius:
                BorderRadius.circular(12)),
            floatingLabelBehavior:
            FloatingLabelBehavior.auto,
            labelText:
            AppLocalizations.of(context)!.translate('city_town'),),

    ));

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
          setState(() {
            selectState=null;
          });
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

        setState(() {
          selectState = value;
        });
      },
    );

    return new WillPopScope(
      onWillPop:isEvent!?()async{return new Future(() => false);}:_onBackPressed,
      child: SafeArea(
          child: Scaffold(
              // resizeToAvoidBottomInset: false,
              appBar: appAppBar().getCustomAppBar(context,
                  appBarTitle: isEvent! ?
                  AppLocalizations.of(context)!.translate('register__entity'):
                  AppLocalizations.of(context)!.translate('reg_bus'),
                  isIconVisible:isEvent!||widget.isEdit,
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
                        child: appCard(
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
                              Stack(
                                children: [Container(
                                    height: 150,
                                    width: double.infinity,
                                    margin: const EdgeInsets.only(
                                        left: 8.0, right: 8.0),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: HexColor(AppColors.appColorGrey500),
                                        ),
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(8))),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: TextField(
                                        controller: controller2,
                                        onChanged: (value) {
                                        },
                                        maxLines: 3,
                                        style: styleElements
                                            .subtitle2ThemeScalable(context)
                                        ,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
hintText: addresses,
                                          hintStyle:  styleElements
                                              .subtitle2ThemeScalable(context)
                                          ,

                                        ),
                                      ),
                                    )),
                                  Container(
                                    height: 160,
                                    width: double.infinity,
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: FloatingActionButton(
                                          backgroundColor: HexColor(AppColors.appMainColor),
                                          child: Icon(Icons.location_on_outlined),

                                          onPressed: () async {
                                            var result=await   Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => MapPage(
                                                  ),
                                                ));

                                            if (result != null) {
                                              if (result["address"] != null)
                                                controller2.text = result["address"];

                                              setState(() {});
                                            }
                                          }),
                                    ),
                                  ),
                                ],
                              ),
                              Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        left: 8.w, right: 8.w, bottom: 8.h),
                                    child: country,
                                  )),
                              Visibility(
                                visible: selectCountry != null &&
                                    selectCountry != "Select Country",
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
          relationship.clear();
          mapState.clear();
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


  getDataLocation() async {
    var body = jsonEncode({"business_id": instId});

    if(widget.isEdit)
    {
      Calls().call(body, context, Config.LOCATION_DETAILS).then((value) {
        var res = LocationDetailsResponse.fromJson(value);
        if (res.statusCode == Strings.success_code) {
          if (res.rows != null && res.rows!.isNotEmpty) {
            if (res.rows![0].country != null) {
              getRelationType(res.rows![0].country);
            }

            if (res.rows![0].streetAddress != null)
              controller2.text = res.rows![0].streetAddress!;

            if (res.rows![0].postalCode != null)
              pinController.text = res.rows![0].postalCode!;

            if (res.rows![0].city != null)
              cityMapController.text = res.rows![0].city!;

            setState(() {});
          }
        }
      });
    }
  }

  void submit(BuildContext ctx) async {
    setState(() {
      isLoading=true;
    });
    if (selectCountry!=null && selectCountry!.isNotEmpty)

    if (selectCountry!=null && selectCountry!.isNotEmpty)
    {
        if (selectState!=null && selectState!.isNotEmpty)
        {
          if (pinController.text.trim().isNotEmpty) {
            if (cityMapController.text.trim().isNotEmpty) {
              {

                mapCountry.forEach((key, value) {
                  if (key == selectCountry) country = value;
                });
                mapState.forEach((key, value) {
                  if (key == selectState) state = value;
                });

                if(!isEvent!) {
                  InstituteLocationDetail instituteContactDetail = InstituteLocationDetail();
                  instituteContactDetail.institutionId = instId;
                  instituteContactDetail.address = controller2.text;
                  instituteContactDetail.country = country;
                  instituteContactDetail.state = state;
                  instituteContactDetail.postalCode = pinController.text;
                  instituteContactDetail.city = cityMapController.text;
                  prefs.setString(Strings.registeredInstituteLocation,
                      cityMapController.text);
                  print(jsonEncode(instituteContactDetail));

                  Calls()
                      .call(jsonEncode(instituteContactDetail), context,
                     widget.isEdit?Config.EDIT_LOCATION: Config.INSTITUTE_ADDRESS)
                      .then((value) async {
                    setState(() {
                      isLoading = false;
                    });
                    if (value != null) {
                      var data = BaseResponse.fromJson(value);
                      if (data.statusCode == Strings.success_code) {

                        if(widget.refreshCallback!=null)
                          widget.refreshCallback!();
                        if(!widget.isEdit) {
                        prefs.setString("create_entity", "created");

register();


                      }
                        else
                          {


                              Navigator.pop(context);
                              if(widget.callBack!=null)
                                widget.callBack!();


                          }
                      /*  Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ConfirmDetails(instId: instId,
                                        fromPage: "registration")));*/
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

  void register() async {

    RegisterUserAs registerUserAs =RegisterUserAs();

    registerUserAs.personId = prefs.getInt(Strings.userId);
    registerUserAs.institutionId = instId;
    final body = jsonEncode(registerUserAs);

    Calls().call(body, context, Config.REGISTER_USER_AS).then((value) async {
      if (value != null) {
        var data = RegisterUserAsResponse.fromJson(value);
        print(data.toString());
        if (data.statusCode == "S10001") {
          prefs.setBool("isProfileCreated", true);

          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => DilaogPage(
                      type: "admin",
                      isVerified: true,
                      title: AppLocalizations.of(context)!
                          .translate('you_are_added_as') +
                          "Employee  of",
                      subtitle: (data.rows!.institutionName!))),
                  (Route<dynamic> route) => false);
        } else
          ToastBuilder().showToast(
              data.message!, context, HexColor(AppColors.information));
      }
    }).catchError((onError) async {
      ToastBuilder().showToast(
          onError.toString(), context, HexColor(AppColors.information));
    });

  }
}
