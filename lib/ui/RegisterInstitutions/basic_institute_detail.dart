import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/tricycle_buttons.dart';
import 'package:oho_works_app/models/drop_down_global.dart';
import 'package:oho_works_app/models/others_name.dart';
import 'package:oho_works_app/models/post/keywordsList.dart';
import 'package:oho_works_app/ui/RegisterInstitutions/institutePhotoPage.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/basicInstituteData.dart';

class BasicInstituteDetails extends StatefulWidget {
  @override
  _BasicInstituteDetails createState() => new _BasicInstituteDetails();
}

class _BasicInstituteDetails extends State<BasicInstituteDetails>
    with SingleTickerProviderStateMixin {
  String? facebookId;
  String? googleSignInId;
  String? userName;
  String? imageUrl;
  var range = <String>[];
  var rangeStudent = <String>[];

  var instituteTypelist = <String?>[];
  var instCategory = <String?>[];
  bool isTermAndConditionAccepted = false;
  String email = "";
  bool isGoogleOrFacebookDataReceived = false;
  double startPos = -1.0;
  double endPos = 1.0;
  Curve curve = Curves.elasticOut;
  final emailController = TextEditingController();
  final otherName = TextEditingController();
  final instituteNameC = TextEditingController();
  final username = TextEditingController();
  final passwordTextController = TextEditingController();
  final mobileController = TextEditingController();
  final dobController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final genderController = TextEditingController();
  final descriptionController = TextEditingController();
  late BuildContext context;
  late TextStyleElements styleElements;

  late TextStyleElements tsE;
  String? selectInstCategory;
  String? selectInstType;
  String? selectStRange;
  String? selectTecRange;
  int? selectedEpoch;
  var mapIntType = HashMap<String?, String?>();
  var mapCategory = HashMap<String?, String?>();
  late SharedPreferences prefs;
  bool? isSelect1=false;
  bool? isSelect2=false;
  TextEditingController typeAheadControllerHashTag =TextEditingController();
  List<String> _listOfHashTags = [];
  @override
  void initState() {
    super.initState();
    getInstituteType();
    getRelationType();
  }

  String quotesCharacterLength = "0";

  @override
  Widget build(BuildContext context) {
    this.context = context;
    styleElements = TextStyleElements(context);

    List<DropdownMenuItem> instituteType = [];
    List<DropdownMenuItem> relationType = [];


    _getInstituteType() {
      for (int i = 0; i < instituteTypelist.length; i++) {
        instituteType.add(DropdownMenuItem(
          child: Text(
            instituteTypelist[i]!,
            style: styleElements.bodyText2ThemeScalable(context),
          ),
          value: instituteTypelist[i],
        ));
      }
      return instituteType;
    }

    _getRelationtype() {
      for (int i = 0; i < instCategory.length; i++) {
        relationType.add(DropdownMenuItem(
          child: Text(
            instCategory[i]!,
            style: styleElements.bodyText2ThemeScalable(context),
          ),
          value: instCategory[i],
        ));
      }
      return relationType;
    }

    final description = TextField(
      controller: descriptionController,
      textCapitalization: TextCapitalization.words,
      keyboardType: TextInputType.name,

      maxLines: null,
      onChanged: (text) {
        setState(() {
          quotesCharacterLength = text.length.toString();
        });
      },
      inputFormatters: [
        new LengthLimitingTextInputFormatter(300),
      ],
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
          contentPadding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
          hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color: HexColor(AppColors.appColorBlack35)),
          hintText: AppLocalizations.of(context)!.translate('write_about_inst')),
    );
    tsE = TextStyleElements(context);

    final instituteName = TextField(
      obscureText: false,
      controller: instituteNameC,
      keyboardType: TextInputType.name,
      textCapitalization: TextCapitalization.words,

      style: tsE.subtitle1ThemeScalable(context).copyWith(
          color: HexColor(AppColors.appColorBlack65)
      ),

      scrollPadding: EdgeInsets.all(20.0.w),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0.w, 15.0.h, 20.0.w, 15.0.h),
          hintText: AppLocalizations.of(context)!.translate('name_of_entity'),
          hintStyle: tsE.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35)).copyWith(color: HexColor(AppColors.appColorBlack35)),

          border: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 0.0.h,
            ),
          )),
    );


    final otherNameIn = Padding(
        padding: EdgeInsets.only(bottom: 4),
        child: Column(
          children: [
            Visibility(
                visible: _listOfHashTags.length>0,
                child: Container(
                  height: 50,
                  padding: EdgeInsets.only(top: 8,bottom: 8,left:8 ,right: 8),
                  alignment: Alignment.centerLeft,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: _listOfHashTags.length,
                    padding: EdgeInsets.only(left: 8,right: 8),
                    itemBuilder: (BuildContext context, int index) {
                      return Flexible(
                        child: Chip(
                          label: Text(_listOfHashTags[index]),
                          padding: EdgeInsets.all(8),
                          onDeleted: (){
                            setState(() {
                              _listOfHashTags.removeAt(index);
                            });
                          },
                        ),
                      );
                    },),
                )
            ),
            TypeAheadField(
              suggestionsCallback: (String pattern) async{
                if(pattern.isNotEmpty) {
                  KeywordListRequest payload = KeywordListRequest();
                  payload.searchVal = pattern;
                  payload.pageSize = 20;
                  payload.pageNumber = 1;
                  var res = await Calls().call(
                      jsonEncode(payload), context, Config.OTHERS_NAME_SCHOOL);
                  if(OthersName
                      .fromJson(res)
                      .rows!.length>0) {
                    return OthersName
                        .fromJson(res)
                        .rows!;
                  }else{
                    return null;
                  }
                }else{
                  return null;
                }
              } as FutureOr<Iterable<String>> Function(String),
              itemBuilder: ( context,  itemData) {
                itemData as String;
                return ListTile(
                  title: Text(AppLocalizations.of(context)!.translate('hash')+itemData, style: styleElements.subtitle1ThemeScalable(context),),
                );
              },
              onSuggestionSelected: ( suggestion) {
                suggestion as String;
                typeAheadControllerHashTag.text ="";
                setState(() {
                  _listOfHashTags.add(suggestion);
                });
                // widget.hashTagCallback(suggestion.display);
              },
              direction: AxisDirection.up,
              textFieldConfiguration: TextFieldConfiguration(
                autofocus: true,
                onSubmitted: (value){
                  typeAheadControllerHashTag.text ="";
                  setState(() {
                    _listOfHashTags.add(value);
                  });
                  // widget.hashTagCallback(value);
                },
                style: styleElements.subtitle1ThemeScalable(context).copyWith(
                    color: HexColor(AppColors.appColorBlack65)
                ),
                controller: typeAheadControllerHashTag,
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("",style: styleElements.headline6ThemeScalable(context),),
                  ),
                  contentPadding: EdgeInsets.only(top:16,left: 16,right: 16),
                  hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35)),
                  hintText: AppLocalizations.of(context)!.translate('other_name'),
                ),
              ),
            ),
          ],
        )
    );
    final institute = DropdownButtonFormField<dynamic>(
      value: null,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0.w, 15.0.h, 2.0.w, 15.0.h)),
      hint: Padding(
        padding: const EdgeInsets.only(left: 0),
        child: Text(
          selectInstType ?? AppLocalizations.of(context)!.translate("entity_type"),
          style: styleElements.bodyText2ThemeScalable(context),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      items: _getInstituteType(),
      onChanged: (value) {
        value as DropdownMenuItem;
        setState(() {
          selectInstType = (value) as String?;
        });
        FocusScope.of(context).requestFocus(new FocusNode());
      },
    );
    final relation = DropdownButtonFormField<dynamic>(
      value: null,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0.w, 15.0.h, 2.0.w, 15.0.h)),
      hint: Padding(
        padding: const EdgeInsets.only(left: 0),
        child: Text(
          selectInstCategory ??
              AppLocalizations.of(context)!.translate("entity_category"),
          style: styleElements.bodyText2ThemeScalable(context),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      items: _getRelationtype(),
      onChanged: (value) {
        value as DropdownMenuItem;
        setState(() {
          selectInstCategory = (value) as String?;

        });
        FocusScope.of(context).requestFocus(new FocusNode());
      },
    );

    return new WillPopScope(
      onWillPop: _onBackPressed,
      child: SafeArea(
          child: Scaffold(
               resizeToAvoidBottomInset: false,
              appBar: TricycleAppBar().getCustomAppBar(
                context,
                appBarTitle: 'Register institute',
                onBackButtonPress: () {
                  Navigator.pop(context);
                },
              ),
              body:
                Stack(
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
                                      child: Text(AppLocalizations.of(context)!.translate('basic'),    style: tsE.headline6ThemeScalable(context).copyWith(fontWeight: FontWeight.bold),),
                                    )),
                                Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          left: 8.w, right: 8.w, bottom: 8.h),
                                      child: instituteName,
                                    )),

                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                      padding: EdgeInsets.only(
                                          left: 8.w, right: 8.w, bottom: 8.h),
                                      child: relation),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                      padding: EdgeInsets.only(
                                          left: 8.w, right: 8.w, bottom: 8.h),
                                      child: institute),
                                ),
                                Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          left: 8.w, right: 8.w, bottom: 8.h),
                                      child: otherNameIn,
                                    )),
                                Container(
                                    height: 150,
                                    margin: const EdgeInsets.only(
                                        left: 16.0, right: 16.0),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: HexColor(AppColors.appColorGrey500),
                                        ),
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(8))),
                                    child: description),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        left: 16, right: 16, bottom: 4.0),
                                    child: Text(
                                      quotesCharacterLength + "/300",
                                      style: styleElements
                                          .captionThemeScalable(context),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [

                                    Checkbox(value: isSelect1, onChanged: (val){

                                      setState(() {
                                        isSelect1=val;
                                      });
                                    }),

                                    Expanded(
                                      child:  Align(
                                          alignment: Alignment.center,
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                left: 8.w, right: 8.w, bottom: 8.h),
                                            child: Text(AppLocalizations.of(context)!
                                                .translate("inst1")),
                                          )),
                                    ),
                                  ],
                                ),

                                Row(
                                  children: [

                                    Checkbox(value: isSelect2, onChanged: (val){

                                      setState(() {
                                        isSelect2=val;
                                      });
                                    }),

                                    Expanded(
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                left: 8.w, right: 8.w, bottom: 8.h),
                                            child: Text(AppLocalizations.of(context)!
                                                .translate("inst2")),
                                          )),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )),
                    ),
                    Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: GestureDetector(
                          child: Container(
                            height: 60,
                            color: HexColor(AppColors.appColorWhite),
                            child: Align(
                                alignment: Alignment.centerRight,
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment
                                      .spaceBetween,
                                  children: <Widget>[
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Visibility(
                                        visible: false,
                                        child: Container(
                                          margin:
                                          const EdgeInsets.only(
                                              left: 16.0,
                                              right: 16.0),
                                          child: TricycleElevatedButton(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius
                                                    .circular(
                                                    18.0),
                                                side: BorderSide(
                                                    color: Colors
                                                        .redAccent)),
                                            onPressed: () async {

                                            },
                                            color: Colors
                                                .white,
                                            child: Text(
                                                AppLocalizations.of(
                                                    context)!
                                                    .translate(
                                                    "next"),
                                                style: styleElements
                                                    .buttonThemeScalable(
                                                    context)
                                                    .copyWith(
                                                    color:  Colors
                                                        .redAccent)),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Visibility(
                                        child: Container(
                                          margin:
                                          const EdgeInsets.only(
                                              left: 16.0,
                                              right: 16.0),
                                          child: TricycleElevatedButton(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius
                                                    .circular(
                                                    18.0),
                                                side: BorderSide(
                                                    color: Colors
                                                        .redAccent)),
                                            onPressed: () async {

                                              submit(context);
                                            },
                                            color: Colors
                                                .white,
                                            child: Text(
                                                AppLocalizations.of(
                                                    context)!
                                                    .translate(
                                                    "next"),
                                                style: styleElements
                                                    .buttonThemeScalable(
                                                    context)
                                                    .copyWith(
                                                    color:  Colors
                                                        .redAccent)),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                )),
                          ),
                        ))
                  ],
                
              ))),
    );
  }

  // ignore: missing_return
  Future<bool> _onBackPressed() {
    Navigator.of(context).pop(true);
    return new Future(() => false);
  }

  void submit(BuildContext ctx) async {
    if(isSelect2! && isSelect1!){
      if (instituteNameC.text.trim().isNotEmpty) {
        if (selectInstType !=null) {
          if (selectInstCategory != null) {
            {
              {
                {
                  var cat;
                  var type;
                  mapCategory.forEach((key, value) {
                    if(key==selectInstCategory)
                      cat=value;

                  });
                  mapIntType.forEach((key, value) {
                    if(key==selectInstType)
                      type=value;

                  });
                  prefs = await SharedPreferences.getInstance();
                  BasicData basicData = new BasicData();
                  basicData.name=instituteNameC.text.toString();
                  basicData.description=descriptionController.text.toString();
                  basicData.inst_cat_code=cat;
                  basicData.entity_type_code=type;
                  basicData.listOfNames=_listOfHashTags;
                  prefs.setString("instName", instituteNameC.text.toString());
                  print(jsonEncode(basicData));
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>InstitutePhotoPage(basicData: basicData)));
                }
              }
            }
          }
          else {
            ToastBuilder().showToast(
                "Please select institute category",
                context,
                HexColor(AppColors.information));
          }
        } else
          ToastBuilder().showToast(
              "Please select institute type",
              context,
              HexColor(AppColors.information));
      } else
        ToastBuilder().showToast(
            "Institute name required",
            context,
            HexColor(AppColors.information));
    }
    else
      ToastBuilder().showToast(
          AppLocalizations.of(context)!.translate("tick_check_box"),
          context,
          HexColor(AppColors.information));
  }



  void getInstituteType() async {
    final body = jsonEncode({
      "search_val": "",
      "dictonary_type_id": "entity_type",
      "page_number": 1,
      "page_size": 115
    });
    Calls().call(body, context, Config.DROP_DOWN_GLOBAL).then((value) async {
      if (value != null) {
        var data = DropDownCommon.fromJson(value);

        for (var item in data.rows!) {
          instituteTypelist.add(item.description);
          mapIntType.putIfAbsent(item.description,() =>item.code);
        }
        setState(() {});
      }
    }).catchError((onError) {
      ToastBuilder().showToast(
          onError.toString(), context, HexColor(AppColors.information));
    });
  }

  void getRelationType() async {
    final body = jsonEncode({
      "search_val": "",
      "dictonary_type_id": "inst_cat",
      "page_number": 1,
      "page_size": 115
    });
    Calls().call(body, context, Config.DROP_DOWN_GLOBAL).then((value) async {
      if (value != null) {
        var data = DropDownCommon.fromJson(value);
        for (var item in data.rows!) {
          instCategory.add(item.description);
          mapCategory.putIfAbsent(item.description,() =>item.code);
        }
        setState(() {});
      }
    }).catchError((onError) {
      ToastBuilder().showToast(
          onError.toString(), context, HexColor(AppColors.information));
    });
  }
}
