import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/enums/resolutionenums.dart';
import 'package:oho_works_app/enums/serviceTypeEnums.dart';
import 'package:oho_works_app/models/blank_response.dart';
import 'package:oho_works_app/models/drop_down_global.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:oho_works_app/utils/utility_class.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class CreateFacility extends StatefulWidget {
  String url;
  String id;

  CreateFacility({
    Key? key,
    required this.url,
    required this.id,
  }) : super(key: key);

  @override
  _CreateFacility createState() => _CreateFacility(
        url,
        id,
      );
}

BuildContext? context;
var imageChild;

class _CreateFacility extends State<CreateFacility> {
  var imageFile;
  String? type;
  String id;
  String imageUrl;
  String? studentType;

  late SharedPreferences prefs;
 late BuildContext context;
  File? imagePath;
  String? selectPath;
  List<DropDownItem>? items = [];
  int? selectedIndTypeId;
  String? selectedIndType;
  String? selectedIndTypeCode;

  Size screenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  double screenHeight(BuildContext context,
      {double dividedBy = 1, double reducedBy = 0.0}) {
    return (screenSize(context).height - reducedBy) / dividedBy;
  }

  double screenWidth(BuildContext context,
      {double dividedBy = 1, double reducedBy = 0.0}) {
    return (screenSize(context).width - reducedBy) / dividedBy;
  }

  double screenHeightExcludingToolbar(BuildContext context,
      {double dividedBy = 1}) {
    return screenHeight(context,
        dividedBy: dividedBy, reducedBy: kToolbarHeight);
  }

  @override
  void initState() {
    setSharedPreferences();
    getTypes();
    super.initState();
  }

  void setSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  // ignore: missing_return
  Future<bool> _onBackPressed() {
    Navigator.of(context).pop({'result': imageUrl});

    return new Future(() => false);
  }

  late TextStyleElements styleElements;
  var itemsIndustry = <String>[];
  List<Widget> actions = [];
  final facilityNameCon = TextEditingController();
  final descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    this.context = context;
    styleElements = TextStyleElements(context);
    actions =  [];

    actions.add(ActionWidget(
      onCountSelected: () {
        print("ttttttttttttttttttttttttttttttttttttttttt");
        createFacility(descriptionController.text, facilityNameCon.text,selectedIndTypeId,selectedIndTypeCode);
      },
    ));

    List<DropdownMenuItem> _genderValues = [];
    _getGenderValues() {
      for (int i = 0; i < items!.length; i++) {
        _genderValues.add(DropdownMenuItem(
          child: Text(
            items![i].description!,
            style: styleElements.bodyText2ThemeScalable(context),
          ),
          value: items![i],
        ));
      }
      return _genderValues;
    }

    final description = TextField(
      controller: descriptionController,
      textCapitalization: TextCapitalization.words,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      style: styleElements
          .bodyText2ThemeScalable(context)
          .copyWith(color: HexColor(AppColors.appColorBlack85)),
      scrollPadding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: EdgeInsets.fromLTRB(8.0, 0.0, 20.0, 0.0),
          hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35)),
          hintText:
              AppLocalizations.of(context)!.translate("describe_facility")),
    );
    final facilityName = TextField(
      controller: facilityNameCon,
      keyboardType: TextInputType.text,
      style: styleElements
          .subtitle1ThemeScalable(context).copyWith(
          color: HexColor(AppColors.appColorBlack65)
      ),
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
          hintText: AppLocalizations.of(context)!.translate('facility_name'),
          hintStyle: styleElements
              .bodyText2ThemeScalable(context)
              .copyWith(fontSize: 14.sp,
          color: HexColor(AppColors.appColorBlack35)),
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 0.h,
            ),
          )),
    );
    final facType = DropdownButtonFormField<dynamic>(
      value: null,
      hint: Text(
        selectedIndType??  AppLocalizations.of(context)!.translate("facility_type"),
        style: styleElements.bodyText2ThemeScalable(context),
      ),
      items: items != null && items!.isNotEmpty ? _getGenderValues() : null,
      onChanged: (value) {
        value as DropDownItem;
       setState(() {
          selectedIndTypeId = value.facilityTypeId ?? selectedIndTypeId;
          selectedIndType = value.description ?? selectedIndType;
          selectedIndTypeCode=value.code ?? selectedIndTypeCode;
        });
      },
    );

    this.context = context;
    if (imageUrl != null) {
      imageChild = Container(
        child: new FittedBox(
          child: CachedNetworkImage(
            imageUrl: Utility().getUrlForImage(imageUrl, RESOLUTION_TYPE.R64, SERVICE_TYPE.SUBJECT),
            fit: BoxFit.fill,
          ),
          fit: BoxFit.fill,
        ),
      );
    }

    return new WillPopScope(
        onWillPop: _onBackPressed,
        child:


        SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: true,
              backgroundColor: HexColor(AppColors.appColorBackground),
              appBar: appAppBar().getCustomAppBar(context,
                  appBarTitle: AppLocalizations.of(context)!.translate('create'),
                  actions: actions, onBackButtonPress: () {
                _onBackPressed();
              }),
              body:  SingleChildScrollView( child:Column(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: screenWidth(context),
                          width: screenWidth(context),
                          child: imageChild,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: 8.0.h, right: 8.0.h, top: 4.0.h, bottom: 2.0.h),
                    child: Column(
                      children: [
                        Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0, top: 8.0),
                                child: Text(AppLocalizations.of(context)!.translate('facility_name'),
                                  style: styleElements
                                      .bodyText2ThemeScalable(context)
                                      .copyWith(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 8.0, left: 8.0, right: 8.0),
                                child: facilityName,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: 8.0.h, right: 8.0.h, top: 2.0.h, bottom: 2.0.h),
                    child: Column(
                      children: [
                        Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0, top: 8.0),
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .translate("facility_type"),
                                  style: styleElements
                                      .bodyText2ThemeScalable(context)
                                      .copyWith(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0, bottom: 8.0),
                                child: facType,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: 8.0.h, right: 8.0.h, top: 2.0.h, bottom: 2.0.h),
                    child: Column(
                      children: [
                        Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .translate("description"),
                                  style: styleElements
                                      .bodyText2ThemeScalable(context)
                                      .copyWith(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                  height: 100,
                                  margin: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: HexColor(AppColors.appColorGrey500),
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8))),
                                  child: description),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        )));
  }

  void getTypes() async {
    final body = jsonEncode({
      "searchVal": "",
    });
    Calls()
        .call(body, context, Config.DROP_DOWN_FACILITIES_TYPE)
        .then((value) async {
      if (value != null) {
        var data = DropDownCommon.fromJson(value);

        items = data.rows;
        setState(() {});
      }
    }).catchError((onError) {
      ToastBuilder().showToast(onError.toString(), context,HexColor(AppColors.information));
    });
  }

  void createFacility(String desc, String name,int? selectedId,String? selectedIndTypeCode) async {

    final body = jsonEncode({
      "institution_id": prefs.getInt(Strings.instituteId),
      "facility_name": name,
      "facility_code": selectedIndTypeCode,
      "facility_description": desc,
      "image_url": imageUrl,
      "facility_type_id": selectedId
    });

    Calls().call(body, context, Config.CREATE_FACILITY).then((value) async {
      if (value != null) {

        var data = BlankResponse.fromJson(value);
        if (data != null && data.statusCode == 'S10001') {
          Navigator.of(context).pop({'result': "imageUrl"});
        }
        else
          {
            ToastBuilder().showToast(data.message??"", context,HexColor(AppColors.information));

          }

      }
    }).catchError((onError) async {

      ToastBuilder().showToast(onError.toString(), context,HexColor(AppColors.information));
    });
  }

  _CreateFacility( this.imageUrl,this.id,);
}

Widget widget(BuildContext context, TextStyleElements styleElements,
    Function onclick) {
  return GestureDetector(
    onTap: () {
      onclick();
    },
    child: Row(
      children: [
        Text(
          AppLocalizations.of(context)!.translate("next"),
          style: styleElements.bodyText2ThemeScalable(context).copyWith(
              color: HexColor(AppColors.appMainColor),
              fontSize: 14.sp,
              fontWeight: FontWeight.bold),
        ),
        Icon(
          Icons.keyboard_arrow_right,
          color: HexColor(AppColors.appMainColor),
        )
      ],
    ),
  );
}

// ignore: must_be_immutable
class ActionWidget extends StatelessWidget {
  final VoidCallback? onCountSelected;

  ActionWidget({this.onCountSelected});

  late TextStyleElements styleElements;

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        onCountSelected!();
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Text(
              AppLocalizations.of(context)!.translate("next"),
              style: styleElements.bodyText2ThemeScalable(context).copyWith(
                  color: HexColor(AppColors.appMainColor),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold),
            ),
            Icon(
              Icons.keyboard_arrow_right,
              color: HexColor(AppColors.appMainColor),
            )
          ],
        ),
      ),
    );
  }
}
