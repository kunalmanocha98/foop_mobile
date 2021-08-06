import 'dart:convert';
import 'dart:io';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/appProgressButton.dart';
import 'package:oho_works_app/enums/resolutionenums.dart';
import 'package:oho_works_app/enums/serviceTypeEnums.dart';
import 'package:oho_works_app/models/blank_response.dart';
import 'package:oho_works_app/models/drop_down_global.dart';
import 'package:oho_works_app/profile_module/common_cards/testcard.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:oho_works_app/utils/utility_class.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class CreateFacilities extends StatefulWidget {
  String? url;
  String? id;

  CreateFacilities({
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

class _CreateFacility extends State<CreateFacilities> {
  String? url;
  String? id;
  var imageFile;
  String? type;
 late String? imageUrl;
  String? studentType;
  ProgressDialog? pr;
  late SharedPreferences prefs;
 late BuildContext context;
  File? imagePath;
  String? selectPath;
  List<DropDownItem>? items = [];
  int? selectedIndTypeId;
  String? selectedIndType;
  String? selectedIndTypeCode;
  GlobalKey<appProgressButtonState> progressButtonKey = GlobalKey();
  _CreateFacility(String? url, String? id) {
    this.imageUrl = url;
    this.id = id;
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
      "institution_id":prefs.getInt("instituteId") ,
      "facility_name": name,
      "facility_code": selectedIndTypeCode,
      "facility_description": desc,
      "image_url": imageUrl,
      "facility_type_id": selectedId
    });
    progressButtonKey.currentState!.show();
    Calls().call(body, context, Config.CREATE_FACILITY).then((value) async {
      if (value != null) {
        progressButtonKey.currentState!.hide();
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
      progressButtonKey.currentState!.hide();
      ToastBuilder().showToast(onError.toString(), context,HexColor(AppColors.information));
    });
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
  Future<bool>_onBackPressed() {
    Navigator.of(context).pop({'result': imageUrl});
    return new Future(() => false);
  }

  late TextStyleElements styleElements;
  var itemsIndustry = <String>[];
  List<Widget> actions = [];
  final facilityNameCon = TextEditingController();
  final descriptionController = TextEditingController();

  var imageChild;
  @override
  Widget build(BuildContext context) {
    this.context = context;
    styleElements = TextStyleElements(context);
    actions =  [];

    if (imageUrl != null) {
      imageChild = Container(
        child: new FittedBox(
          child: Image(
            image: CachedNetworkImageProvider(Utility().getUrlForImage(imageUrl, RESOLUTION_TYPE.R128, SERVICE_TYPE.INSTITUTION)),
            fit: BoxFit.fill,
          ),
          fit: BoxFit.fill,
        ),
      );
    }
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
          .subtitle1ThemeScalable(context).copyWith(
          color: HexColor(AppColors.appColorBlack65)
      ),
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
    final facType =



    DropdownButtonFormField<dynamic>(
      value: null,
      hint: Text(
        selectedIndType??  AppLocalizations.of(context)!.translate("facility_type"),
        style: styleElements.bodyText2ThemeScalable(context),
      ),
      items: items != null && items!.isNotEmpty ? _getGenderValues() : null,
      onChanged: ( value)  async{
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
          child:
          FadeInImage.assetNetwork(
            placeholder: 'assets/appimages/image_place.png',
            image:Config.BASE_URL + imageUrl!,
            fit: BoxFit.cover,
          )

        ),
      );
    }
    Size screenSize(BuildContext context) {
      return MediaQuery.of(context).size;
    }


    double screenWidth(BuildContext context,
        {double dividedBy = 1, double reducedBy = 0.0}) {
      return (screenSize(context).width - reducedBy) / dividedBy;
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

                  Visibility(

                      child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                              color: HexColor(AppColors.appColorWhite),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      margin: const EdgeInsets.only(left: 16),
                                      height: 60,
                                      color: HexColor(AppColors.appColorWhite),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "",
                                          style: styleElements
                                              .subtitle2ThemeScalable(context)
                                              .copyWith(color: HexColor(AppColors.appMainColor)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 60,
                                    color: HexColor(AppColors.appColorWhite),
                                    child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                              left: 16.0, right: 16.0),
                                          child: appProgressButton(
                                            key: progressButtonKey,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(116.0),
                                                side: BorderSide(
                                                    color: HexColor(AppColors.appMainColor))),
                                            onPressed: () {
                                              createFacility(descriptionController.text, facilityNameCon.text,selectedIndTypeId,selectedIndTypeCode);
                                            },
                                            color: HexColor(AppColors.appColorWhite),
                                            child: Text(AppLocalizations.of(context)!.translate('next'),
                                              style: styleElements
                                                  .subtitle2ThemeScalable(context)
                                                  .copyWith(
                                                  color: HexColor(AppColors.appMainColor)),
                                            ),
                                          ),
                                        )),
                                  )
                                ],
                              ))))
                ],
              )),
            )));
  }
}
