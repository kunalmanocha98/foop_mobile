import 'package:oho_works_app/models/base_res.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:random_color/random_color.dart';

import 'overlaped_circular_images.dart';

// ignore: must_be_immutable
class SportsCardDetail extends StatelessWidget {
  final CommonCardData data;
  BuildContext context;
  List<SubRow> listSubItems = [];
  TextStyleElements styleElements;
  bool isProfile;
  String instituteId;
  Null Function() callbackPicker;

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

  SportsCardDetail({Key key, @required this.data,this.styleElements, this.instituteId,
    this.isProfile,
    this.callbackPicker}) : super(key: key);
  RandomColor _randomColor = RandomColor();
  @override
  Widget build(BuildContext context) {
    this.context = context;
    styleElements = TextStyleElements(context);
    listSubItems = data.subRow;
    return Container(
        margin:  EdgeInsets.only(left: 8.0.h,right: 8.0.h, top: 4.0.h, bottom: 4.0.h),
        child:   ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(0.0),
            physics: NeverScrollableScrollPhysics(),
            itemCount: listSubItems.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  /*    Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CommonDetailPage(
                                id: "",
                              ),
                            ));*/
                },
                child: Stack(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(left: 14, right: 14,top: 4,bottom: 4),
                      decoration: new BoxDecoration(
                        borderRadius: BorderRadius.all(
                            Radius.circular(8.0)),


                        gradient: new LinearGradient(
                            colors: [
                              _randomColor.randomColor(),
                              _randomColor.randomColor(),
                            ],
                            begin: const FractionalOffset(0.0, 0.0),
                            end: const FractionalOffset(1.0, 0.0),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp),
                      ),
                      child: Card(
                        color: HexColor(AppColors.appColorTransparent),
                        margin: EdgeInsets.zero,
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),

                        child:
                        Padding(
                            padding:  EdgeInsets.all(16.0.h),
                            child: Column(children: <Widget>[
                              Align(
                                alignment: Alignment.topLeft,
                                child:Text(
                                  listSubItems[index].textOne ??= "",
                                  style: styleElements.headline6ThemeScalable(context).copyWith(color: HexColor(AppColors.appColorWhite)),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child:  Text(
                                  listSubItems[index].textEight ??= "",
                                  style: styleElements.overlineThemeScalable(context).copyWith(color: HexColor(AppColors.appColorWhite)),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 12,),
                                child:  Row(
                                  children: <Widget>[
                                    OverlappedImages( listSubItems[index].images),

                                    Container(
                                      margin: const EdgeInsets.only(left: 16),
                                      child: Flexible(
                                        child: Text(
                                          listSubItems[index].totalCount ??=
                                          "",
                                          style: styleElements.captionThemeScalable(context).copyWith(color: HexColor(AppColors.appColorWhite)),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),)

                                  ],
                                ),
                              )

                            ]))
                        ,

                      ),
                    ),

                  ],
                ),
              );
            }),);
  }
}
