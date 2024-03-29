import 'dart:convert';
import 'dart:math';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/searchBox.dart';
import 'package:oho_works_app/components/app_buttons.dart';
import 'package:oho_works_app/models/RegisterUserAs.dart';
import 'package:oho_works_app/models/register_user_as_response.dart';
import 'package:oho_works_app/models/sections_data.dart';
import 'package:oho_works_app/ui/dialog_page.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/debouncer.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/preloadingview.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'accedemic_selection_page.dart';

// ignore: must_be_immutable
class SelectSectionExpertise extends StatefulWidget {
  RegisterUserAs? registerUserAs;
  int instituteId;
  int? personType;
  bool isVerified;
  bool isAddClass;

  SelectSectionExpertise(this.instituteId, this.registerUserAs, this.isAddClass,
      this.personType, this.isVerified);

  _SelectSectionExpertise createState() => _SelectSectionExpertise(
      instituteId, registerUserAs, isAddClass, isVerified);
}

class _SelectSectionExpertise extends State<SelectSectionExpertise>
    with SingleTickerProviderStateMixin {

  late SharedPreferences prefs;
  RegisterUserAs? registerUserAs;

  String? sectionId;
  String? accedamicId;
  bool isVerified;
  bool isAddClass;
  var pageTitle = "";
  var color1 = HexColor(AppColors.appMainColor);
  int? userId;
  var color2 = HexColor(AppColors.appColorWhite);
  int? instituteId;
  var color3 = HexColor(AppColors.appColorWhite);
  var isCheckedColor = HexColor(AppColors.appColorWhite);
  List<Rows>? listSections = [];
  List<Rows> selectedSection = [];
  List<PersonClasses>? teachingClasses = [];
  var isSearching = false;
  bool _enabled = true;
  String? nextYear;
  String? currentYear;
  String? acedemicYear="";
  final _debouncer = Debouncer(500);
  String type = "";
  late TextStyleElements styleElements;
  PersonClasses? currentSelected;

  late Animation _animation;
  late AnimationController _controller;
  int currentItem=0;
late BuildContext sctx;
  Future<bool> _onBackPressed() {
    Navigator.of(context).pop(true);
    return new Future(() => false);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void setSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    _controller =
        AnimationController(duration: Duration(milliseconds: 400), vsync: this);
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    print(jsonEncode(registerUserAs));
    if (registerUserAs != null) {
      print(jsonEncode(registerUserAs!.personClasses![0]));
      acedemicYear = registerUserAs!.academicYear;
      instituteId = registerUserAs!.institutionId;
      teachingClasses = registerUserAs!.personClasses;
      if (teachingClasses!.isNotEmpty)
        {
          currentSelected = teachingClasses![0];
          WidgetsBinding.instance!.addPostFrameCallback((_) => getRoles(null));
        }
       
    }


    super.initState();
  }

  bool contains(int? id) {
    for (var item in selectedSection) {
      if (item.id == id) return true;
    }
    return false;
  }

  void getRoles(String? searchValue) async {

    final body = jsonEncode({
      "business_id": instituteId,
      "searchVal": searchValue,
      "page_number": 1,
      "class_id":currentSelected!.classId,
      "page_size": 200
    });

    Calls().call(body, context, Config.SECTIONS_LIST).then((value) async {


      if (value != null) {
        var data = SectionData.fromJson(value);


        _enabled = false;
        if (data.rows!.length > 0) {
          if (listSections!.length > 0) {
            {
              for (var i = 0; i < data.rows!.length; i++) {
                if (contains(data.rows![i].id))
                  data.rows![i].isSelected = true;
                else
                  data.rows![i].isSelected = false;
              }
            }
          } else {
            for (var i = 0; i < data.rows!.length; i++) {
              data.rows![i].isSelected = false;
            }
          }
          listSections = data.rows;
          setState(() {

          });
        }
        else
          { Navigator.of(context).pop({'result': 0});}


        isSearching = false;

      } else {
        _enabled = false;
      }
    }).catchError((onError) {
      ToastBuilder().showSnackBar(
          onError.toString(), sctx, HexColor(AppColors.information));

      _enabled = false;
    });
  }

  Widget build(BuildContext context) {
    ScreenUtil.init;

    pageTitle = AppLocalizations.of(context)!.translate("select_section");
    styleElements = TextStyleElements(context);
    return SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: HexColor(AppColors.appColorBackground),
          appBar: appAppBar().getCustomAppBar(context, appBarTitle: pageTitle,
              onBackButtonPress: () {
                _onBackPressed();
              }),
          body:
          new Builder(builder: (BuildContext context) {
            this.sctx = context;
            return new  Container(
                child: Scaffold(
                    backgroundColor: HexColor(AppColors.appColorBackground),
                    body: DefaultTabController(
                      length: 3,
                      child: Scaffold(
                          backgroundColor: HexColor(AppColors.appColorBackground),
                          body: NestedScrollView(
                              headerSliverBuilder: (context, value) {
                                return [
                                  SliverToBoxAdapter(
                                    child: SearchBox(
                                      onvalueChanged: (String value) {
                                        _debouncer.run(() {
                                          setState(() {
                                            isSearching = true;
                                            (value);
                                          });
                                        });
                                      },
                                      progressIndicator: isSearching,
                                      hintText: AppLocalizations.of(context)!.translate('search'),
                                    ),
                                  ),
                                  SliverToBoxAdapter(
                                    child: AnimatedBuilder(
                                      animation: _controller,
                                      builder: (BuildContext context, Widget? child) {
                                        bool isFront = _controller.value < .5;
                                        return InkWell(
                                          onTap: () async {
                                            var result = await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      SelectAcademic(instituteId),
                                                ));

                                            if (result != null) {
                                              setState(() {
                                                acedemicYear = result['result'];
                                                accedamicId = result['result'];
                                                if (acedemicYear != null &&
                                                    registerUserAs != null)
                                                  registerUserAs!.academicYear =
                                                      acedemicYear;
                                              });
                                            }
                                          },
                                          child: Transform(
                                            transform: Matrix4.identity()
                                              ..setEntry(3, 2, 0.002)
                                              ..rotateX(pi * _animation.value +
                                                  (isFront ? 0 : pi)),
                                            alignment: FractionalOffset.center,
                                            child: Container(

                                                child: appListCard(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                      children: <Widget>[
                                                        Visibility(
                                                            child: Container(
                                                              padding:
                                                              const EdgeInsets.all(8),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment.start,
                                                                children: <Widget>[
                                                                  Align(
                                                                      alignment:
                                                                      Alignment.center,
                                                                      child: Column(
                                                                        crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                        mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                        children: <
                                                                            Widget>[
                                                                          Text(AppLocalizations.of(context)!.translate('current_selection'),
                                                                            style: styleElements
                                                                                .subtitle2ThemeScalable(
                                                                                context),
                                                                            textAlign:
                                                                            TextAlign
                                                                                .left,
                                                                          ),
                                                                          Row(children: [
                                                                            Align(
                                                                              alignment:
                                                                              Alignment
                                                                                  .center,
                                                                              child: Text(
                                                                                currentSelected!=null?  currentSelected!.className??"":"",
                                                                                style: styleElements
                                                                                    .bodyText1ThemeScalable(
                                                                                    context)
                                                                                    .copyWith(
                                                                                    color: HexColor(AppColors.appColorBlack85),
                                                                                    fontWeight: FontWeight.bold),
                                                                                textAlign:
                                                                                TextAlign
                                                                                    .left,
                                                                              ),
                                                                            ),
                                                                            Visibility(
                                                                              visible:
                                                                              acedemicYear !=
                                                                                  null,
                                                                              child:
                                                                              Padding(
                                                                                padding: const EdgeInsets
                                                                                    .only(
                                                                                    left:
                                                                                    8.0),
                                                                                child:
                                                                                Align(
                                                                                  alignment:
                                                                                  Alignment.center,
                                                                                  child:
                                                                                  Text(
                                                                                    ("( " + acedemicYear! + " )"),
                                                                                    style:
                                                                                    styleElements.bodyText2ThemeScalable(context),
                                                                                    textAlign:
                                                                                    TextAlign.left,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ])
                                                                        ],
                                                                      )),
                                                                  Spacer(),
                                                                  Align(
                                                                      alignment: Alignment
                                                                          .centerRight,
                                                                      child: Container(
                                                                        margin:
                                                                        const EdgeInsets
                                                                            .all(16),
                                                                        child: Align(
                                                                          alignment: Alignment
                                                                              .centerRight,
                                                                          child: Text(
                                                                            AppLocalizations.of(
                                                                                context)!
                                                                                .translate(
                                                                                "change"),
                                                                            style: styleElements
                                                                                .subtitle1ThemeScalable(
                                                                                context),
                                                                            textAlign:
                                                                            TextAlign
                                                                                .left,
                                                                          ),
                                                                        ),
                                                                      ))
                                                                ],
                                                              ),
                                                            ))
                                                      ],
                                                    ))),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ];
                              },
                              body: Stack(
                                children: <Widget>[
                                  Visibility(
                                    visible: _enabled,
                                    child: PreloadingView(
                                        url: "assets/appimages/classroom.png"),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 65),
                                    child: appListCard(
                                      child: ListView.builder(
                                          padding: EdgeInsets.only(
                                              left: 8, right: 8, bottom: 8, top: 8),
                                          itemCount: listSections!.length,
                                          itemBuilder:
                                              (BuildContext context, int index) {
                                            return GestureDetector(
                                              child: Column(
                                                children: <Widget>[
                                                  Visibility(
                                                      visible: index == 0,
                                                      child: Container(
                                                        width: double.infinity,
                                                        margin: const EdgeInsets.only(
                                                            bottom: 4),
                                                        decoration: BoxDecoration(
                                                            color: HexColor(AppColors.appMainColor33),
                                                            borderRadius: BorderRadius
                                                                .only(
                                                                topRight:
                                                                Radius.circular(
                                                                    4.0),
                                                                topLeft:
                                                                Radius.circular(
                                                                    4.0))),
                                                        child: Container(
                                                          margin:
                                                          const EdgeInsets.all(16),
                                                          child: Text(
                                                            AppLocalizations.of(
                                                                context)!
                                                                .translate(
                                                                "sec_quote"),
                                                            textAlign: TextAlign.center,
                                                            style: styleElements
                                                                .captionThemeScalable(
                                                                context)
                                                                .copyWith(
                                                                color:
                                                                HexColor(AppColors.appColorBlack85)),
                                                          ),
                                                        ),
                                                      )),
                                                  ListTile(
                                                      title: Align(
                                                        alignment: Alignment.centerLeft,
                                                        child: Text(
                                                          listSections![index]
                                                              .sectionName!,
                                                          style: styleElements
                                                              .subtitle1ThemeScalable(
                                                              context),
                                                          textAlign: TextAlign.left,
                                                        ),
                                                      ),
                                                      trailing: Checkbox(
                                                        activeColor:
                                                        HexColor(AppColors.appMainColor),
                                                        value: listSections![index]
                                                            .isSelected,
                                                        onChanged: (val) {
                                                          if (this.mounted) {
                                                            setState(() {
                                                              if (val == true) {
                                                                sectionId = listSections![index].id.toString();

                                                                setState(() {
                                                                  // other roles can only select one class
                                                                  for (int i =
                                                                  0;
                                                                  i < listSections!.length;
                                                                  i++) {
                                                                    if (i == index) {
                                                                      listSections![i].isSelected = true;
                                                                      selectedSection.add(listSections![index]);
                                                                    } else {
                                                                      listSections![i].isSelected =
                                                                      false;
                                                                      removeSelected(
                                                                          listSections![i].id);
                                                                    }
                                                                  }
                                                                });
                                                              } else {
                                                                sectionId = "";

                                                                listSections![index]
                                                                    .isSelected =
                                                                false;
                                                                removeSelected(
                                                                    listSections![
                                                                    index]
                                                                        .id);
                                                                setState(() {

                                                                });
                                                              }
                                                            });
                                                          }
                                                        },
                                                      ))
                                                ],
                                              ),
                                              onTap: () {},
                                            );
                                          }),
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
                                              margin: const EdgeInsets.only(
                                                  left: 16.0, right: 16.0),
                                              child: appElevatedButton(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(18.0),
                                                    side: BorderSide(
                                                        color: HexColor(AppColors.appMainColor))),
                                                onPressed: () async {
                                                  {
                                                    if(selectedSection.length>0)
                                                    {
                                                      int? i=selectedSection[0].id;
                                                      Navigator.of(context).pop({'result': i});

                                                    }
                                                    else
                                                    {
                                                      ToastBuilder().showSnackBar(
                                                          "Please select section",
                                                          sctx,HexColor(AppColors.information));
                                                    }

                                                  }

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
                                      ))
                                ],
                              ))),
                    )));
          })



         ,
        ));
  }

  removeSelected(int? id) {
    for (var i = 0; i < selectedSection.length; i++) {
      if (id == selectedSection[i].id) {
        selectedSection.removeAt(i);
        break;
      }
    }
  }

  void register(int userId) async {

    registerUserAs!.personId = userId;

    registerUserAs!.personClasses = teachingClasses;
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
                      type: type,
                      isVerified: data.rows!.isVerified,
                      title: AppLocalizations.of(context)!.translate('you_are_added_as') + "Alumni ",
                      subtitle: (data.rows!.institutionName != null
                          ? " of " + data.rows!.institutionName!
                          : ""))),
                  (Route<dynamic> route) => false);
        } else
          ToastBuilder().showSnackBar(
              data.message!, sctx, HexColor(AppColors.information));
      }
    }).catchError((onError) {
      ToastBuilder().showSnackBar(
          onError.toString(), sctx, HexColor(AppColors.information));

    });
  }




  _SelectSectionExpertise(this.instituteId, this.registerUserAs, this.isAddClass, this.isVerified);
}
