import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/models/base_res.dart';
import 'package:oho_works_app/profile_module/pages/profile_page.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class MediumEducationcard extends StatelessWidget {
  final CommonCardData data;
  final String instId;
  int id;
  String personType;
  TextStyleElements styleElements;
  Size displaySize(BuildContext context) {
    debugPrint('Size = ' + MediaQuery.of(context).size.toString());
    return MediaQuery.of(context).size;
  }

  double displayHeight(BuildContext context) {
    debugPrint('Height = ' + displaySize(context).height.toString());
    return displaySize(context).height;
  }

  double displayWidth(BuildContext context) {
    debugPrint('Width = ' + displaySize(context).width.toString());
    return displaySize(context).width;
  }

  MediumEducationcard({Key key, @required this.data,this.styleElements,this.instId,this.id,this.personType}) : super(key: key);
  List<SubRow> list = [];
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    list=data.subRow;
    return TricycleListCard(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        padding: const EdgeInsets.only(left: 16, right: 16,top:12,bottom:12),
                        child: Text(
                          data.title ?? "",
                          style: styleElements.headline6ThemeScalable(context).copyWith(fontWeight: FontWeight.bold,color: HexColor(AppColors.appColorBlack85)),
                          textAlign: TextAlign.left,
                        ),
                      )),
                  flex: 3,
                ),

              ],
            ),
            Container(
              margin: const EdgeInsets.only(left: 5, right: 5,bottom: 20),
              child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [


                  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Visibility(
                        visible: list!=null && list.length>0,
                        child: Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                margin: const EdgeInsets.only(left: 16, top: 20),
                                child: Text(
                                  list!=null && list.length>0 ? list[0].textOne ??= "":"",
                                  style: styleElements.subtitle2ThemeScalable(context),
                                  textAlign: TextAlign.left,
                                ),
                              )),
                          Visibility(
                            visible: false,
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 16, top: 8, right: 16),
                                  child: Text(
                                    list!=null && list.length>0 ?   list[0].textTwo ??= "":"",
                                    style: styleElements.bodyText1ThemeScalable(context).copyWith(fontWeight: FontWeight.w600),
                                    textAlign: TextAlign.left,
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ))
                    ,


                    Visibility(
                        visible: list!=null && list.length>1,
                        child:  Expanded(
                      child:
                      Container(
                        margin: const EdgeInsets.only(left: 30),
                        child:   Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 20, top: 20, right: 20),
                                  child: Text(
                                    (list!=null && list.length>1) ? list[1].textOne ??= "":"",
                                    style: styleElements.subtitle2ThemeScalable(context),
                                    textAlign: TextAlign.right,
                                  ),
                                )),
                            Visibility(
                              visible: false,
                              child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        left: 20, top: 8, right: 20),
                                    child: Text(
                                      (list!=null && list.length>1) ?  list[1].textTwo ??= "":"",
                                      style: styleElements.bodyText1ThemeScalable(context).copyWith(fontWeight: FontWeight.w600),
                                      textAlign: TextAlign.left,
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      )
                      ,
                    ))
                  ],
                ),


                ],

              )
              ,
            ),
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () async {
                    var result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserProfileCards(
                            type: "medium",
                            currentPosition: 2,
                           userId: id,
                            userType: personType,
                          ),
                        ));
                    if (result != null && result['result'] == "update") {

                    }
                  },
                  child: Container(
                    margin:
                    EdgeInsets.only(right: 20.h, top: 20.h, bottom: 20.h),
                    child: Visibility(
                      visible: data.isShowMore ??= false,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Text(AppLocalizations.of(context).translate('see_more'),
                          style: styleElements.subtitle2ThemeScalable(context),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  )),
            ),
          ],
        ));
  }
}
