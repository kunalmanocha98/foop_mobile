import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/appProgressButton.dart';
import 'package:oho_works_app/models/RegisterUserAs.dart';
import 'package:oho_works_app/models/institution_classes.dart';
import 'package:oho_works_app/models/register_user_as_response.dart';
import 'package:oho_works_app/ui/dialog_page.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: must_be_immutable
class VerifyChild extends StatefulWidget {
  RegisterUserAs? registerUserAs;
  int instituteId;

  VerifyChild(this.instituteId, this.registerUserAs);

  _VerifyChild createState() => _VerifyChild(instituteId, registerUserAs);
}

class _VerifyChild extends State<VerifyChild>
    with SingleTickerProviderStateMixin {

  late SharedPreferences prefs;
  late TextStyleElements styleElements;
  CupertinoDatePicker? cupertinoDatePicker;
  RegisterUserAs? registerUserAs;
  var pageTitle = "";
  var color1 = HexColor(AppColors.appMainColor);
  int? userId;
  var color2 = HexColor(AppColors.appColorWhite);
  int instituteId;
  var color3 = HexColor(AppColors.appColorWhite);
  var isCheckedColor = HexColor(AppColors.appColorWhite);
  List<InstituteClass> listClasses = [];
  List<int> teachingClasses = [];
  var isSearching = false;

  // bool _enabled = true;
  late String previousYear;
  late String currentYear;
  String? acedemicYear;
  String type = "parent";
  int selectedEpoch = 0;
  String selectedDate = "Date Of Birth*";
  GlobalKey<appProgressButtonState> progressButtonKey = GlobalKey();

  @override
  void initState() {
    setSharedPreferences();
    final DateFormat formatter = DateFormat('yyyy');
    /*  var newDate = new DateTime(DateTime.now().year - 1, DateTime.now().month, DateTime.now().day);
     previousYear = formatter.format(newDate);*/
    final DateTime now = DateTime.now();
    currentYear = formatter.format(now);
    previousYear = (int.parse(currentYear) - 1).toString();
    acedemicYear = previousYear + "-" + currentYear;



    super.initState();
  }


 late BuildContext sctx;
  Widget build(BuildContext context) {
    ScreenUtil.init;
    styleElements=TextStyleElements(context);
    return SafeArea(child: Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: HexColor(AppColors.appColorBackground),
      appBar: OhoAppBar().getCustomAppBar(context,
          appBarTitle: "", onBackButtonPress: () {
            _onBackPressed();
          }),
      body: NestedScrollView(
          headerSliverBuilder: (context, value) {
            return [
              SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.all(50),
                    child: Text(pageTitle,
                      textAlign: TextAlign.center,
                      style: styleElements.headline5ThemeScalable(context),),
                  )),
            ];
          },
          body:
          new Builder(builder: (BuildContext context) {
            this.sctx = context;
            final dob = GestureDetector(
                onTap: () {
                  _selectDate(context);
                },
                child: Container(
                    padding: EdgeInsets.all(16.h),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          //
                          color: HexColor(AppColors.appColorGrey500),
                          width: 1.0.w,
                        ),
                      ), // set border width
                    ),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          selectedDate!="Date Of Birth*"?  DateFormat('dd-MM-yyyy')
                              .format(DateTime.parse(selectedDate)):"Date Of Birth*",
                          textAlign: TextAlign.left,
                          style: styleElements.bodyText2ThemeScalable(context).copyWith(fontSize: 14.sp),
                        ))));
            return new  Stack(
              children: <Widget>[
                Container(
                    child: Scaffold(
                        resizeToAvoidBottomInset: false,
                        backgroundColor: HexColor(AppColors.appColorBackground),

                        body: Container(
                          margin: const EdgeInsets.only(bottom: 70),
                          child: ListView(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                  child: Container(
                                      child: Image(
                                        image: AssetImage('assets/appimages/bod.png'),
                                        fit: BoxFit.contain,
                                        width: 100,
                                        height: 100,
                                      )),
                                ),
                              ),
                              Container(
                                color: HexColor(AppColors.appColorBackground),
                                margin: const EdgeInsets.all(8),
                                child: Card(
                                    child: Column(
                                      children: <Widget>[
                                        Align(
                                            alignment: Alignment.topLeft,
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                  left: 20, top: 20),
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                    .translate("dob"),
                                                style: styleElements.subtitle1ThemeScalable(context),
                                                textAlign: TextAlign.left,
                                              ),
                                            )),
                                        Align(
                                            alignment: Alignment.topLeft,
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                  left: 20, top: 20),
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                    .translate("dob_child"),
                                                style: styleElements.subtitle2ThemeScalable(context),
                                                textAlign: TextAlign.left,
                                              ),
                                            )),
                                        Align(
                                            alignment: Alignment.center,
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  left: 8.w, right: 8.w, top: 12.h,bottom: 8.h),
                                              child: dob,
                                            )),
                                      ],
                                    )),
                              ),
                            ],
                          ),
                        ))),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 60,
                      color: HexColor(AppColors.appColorWhite),
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            margin:
                            const EdgeInsets.only(left: 16.0, right: 16.0),
                            child: appProgressButton(
                              key:progressButtonKey,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: HexColor(AppColors.appMainColor))),
                              onPressed: () {
                                if (selectedDate != "")
                                  register(prefs.getInt("userId"));
                              },
                              color: HexColor(AppColors.appColorWhite),
                              child: Text(
                                AppLocalizations.of(context)!.translate('next'),
                                style: styleElements.subtitle2ThemeScalable(context).copyWith(color: HexColor(AppColors.appMainColor)),),
                            ),
                          )),
                    ))
              ],
            );
          })


         ),
    )) ;
  }
  Future<bool> _onBackPressed() {
    Navigator.of(context).pop(true);
    return new Future(() => false);
  }

  void setSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> _selectDate(BuildContext context) async {
    var newDate;

    newDate = new DateTime(DateTime.now().year - 4, DateTime.now().month, DateTime.now().day);


    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: newDate,
        firstDate: DateTime(1900),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: HexColor(AppColors.appColorBlack),
              accentColor: HexColor(AppColors.appColorBlack),
              colorScheme: ColorScheme.dark(
                primary: HexColor(AppColors.appColorBlack),
                onPrimary: HexColor(AppColors.appColorWhite),
                surface: HexColor(AppColors.appColorWhite),
                onSurface: HexColor(AppColors.appColorBlack),
              ),
              buttonTheme: ButtonThemeData(
                  textTheme: ButtonTextTheme.primary
              ),
            ),
            child: child!,
          );
        },
        lastDate: newDate);
    if (picked != null)
      setState(() {
        selectedEpoch = picked.millisecondsSinceEpoch;
        selectedDate = DateFormat('yyyy-MM-dd').format(picked);
      });
  }
  void register(int? userId) async {
    registerUserAs!.dateOfBirth = selectedDate;
    registerUserAs!.personId = userId;
    print(teachingClasses.toString() +
        "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
    progressButtonKey.currentState!.show();
    final body = jsonEncode(registerUserAs);

    Calls().call(body, context, Config.REGISTER_USER_AS).then((value) async {
      if (value != null) {
        progressButtonKey.currentState!.hide();
        var data = RegisterUserAsResponse.fromJson(value);
        print(data.toString());
        if (data.statusCode == "S10001") {
          prefs.setBool("isProfileCreated", true);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => DilaogPage(      type: type,
                      isVerified:data.rows!.isVerified,
                      title:AppLocalizations.of(context)!.translate('you_are_added_as')+ type,
                      subtitle: type == "parent"
                          ? ((data.rows!.studentName != null
                          ? " of " + data.rows!.studentName!
                          : "") +
                          (data.rows!.institutionName != null
                              ? " of " + data.rows!.institutionName!
                              : ""))
                          : (data.rows!.institutionName != null
                          ? " of " + data.rows!.institutionName!
                          : ""))),
                  (Route<dynamic> route) => false);



        } else
          ToastBuilder().showSnackBar(data.message!, sctx,HexColor(AppColors.information));
      }
    }).catchError((onError) async {
      ToastBuilder().showSnackBar(onError.toString(), sctx,HexColor(AppColors.information));
      progressButtonKey.currentState!.hide();
    });
  }


  _VerifyChild(this.instituteId, this.registerUserAs);
}
