import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/models/base_res.dart';
import 'package:oho_works_app/profile_module/pages/profile_page.dart';
import 'package:oho_works_app/ui/add_subject_select_screen.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'overlaped_circular_images.dart';
// ignore: must_be_immutable
class SubjectsCard extends StatelessWidget {
  final CommonCardData data;
  List<SubRow>? listSubItems = [];
  BuildContext? context;
final String? instId;
  int? id;
  String? personType;
  late SharedPreferences prefs;
  TextStyleElements? styleElements;
  Null Function()? callbackPicker;
  Size displaySize(BuildContext context) {
    debugPrint('Size = ' + MediaQuery.of(context).size.toString());
    return MediaQuery.of(context).size;
  }


  RandomColor _randomColor = RandomColor();

  double displayHeight(BuildContext context) {
    debugPrint('Height = ' + displaySize(context).height.toString());
    return displaySize(context).height;
  }

  double displayWidth(BuildContext context) {
    debugPrint('Width = ' + displaySize(context).width.toString());
    return displaySize(context).width;
  }

  SubjectsCard({Key? key, required this.data,this.styleElements,this.callbackPicker,this.instId,this.id,this.personType}) : super(key: key);
  void setSharedPreferences() async {
    prefs = await 
    SharedPreferences.getInstance();
   
  }
  @override
  Widget build(BuildContext context) {
    listSubItems = data.subRow;
    styleElements = TextStyleElements(context);
    setSharedPreferences();
    this.context = context;
    return TricycleListCard(
        child: Column(
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
                      style: styleElements!.headline6ThemeScalable(context).copyWith(fontWeight: FontWeight.bold,color: HexColor(AppColors.appColorBlack85)),

                      textAlign: TextAlign.left,
                    ),
                  )),
              flex: 3,
            ),
            Visibility(
                visible: personType=="person",
                child:   Flexible(
              child:  Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                    alignment: Alignment.topRight,
                    child:  GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () async {
                        var result = await  Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddSelectSubject(
                                  prefs.getInt("instituteId"),
                                  false,null

                              ),
                            ));

                        if (result != null && result['result'] == "success") {
                          var result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserProfileCards(
                                  type: "subject",
                                  currentPosition: 2,
                                  userId: id,
                                  userType: personType,

                                ),
                              ));
                          if (result != null && result['result'] == "update") {
                            callbackPicker!();
                          }

                        }

                      },
                      child: Icon(
                        Icons.add,
                        size: 30,
                        color: HexColor(AppColors.appColorBlack85),
                      ),
                    )),
              ),
              flex: 1,
            ))
          ,
          ],
        ),

        listSubItems!=null && listSubItems!.isNotEmpty?Container(
            margin: const EdgeInsets.only(left: 12, right: 12, top: 8),
            child: GridView.count(
                padding: EdgeInsets.all(0.0),
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 2 / 1.5,
                shrinkWrap: true,
                children: listSubItems!.map((SubRow data) {
                  return GestureDetector(
                    onTap: () {
                      /*  Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ParticularSubject(
                                    type: data.textOne ?? "",
                                    currentPosition: 1,
                                    *//* type: "teacher",*//*
                                  ),
                                ));*/
                    },
                    child: Stack(
                      children: <Widget>[
                        Container(
                          height: 140,
                          child: Card(
                            semanticContainer: true,
                            clipBehavior:
                            Clip.antiAliasWithSaveLayer,
                            child: Container(
                              color: _randomColor.randomColor(),
                              child: Container(

                                  color: HexColor(AppColors.appColorTransparent),
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                        const EdgeInsets
                                            .only(left: 8,top: 8),
                                        child: Row(
                                          children: <Widget>[
                                            data.urlOne!=null &&  data.urlOne!="" ? Container(
                                              width: 20,
                                              height: 20,
                                              decoration:
                                              BoxDecoration(
                                                shape: BoxShape
                                                    .circle,
                                                image: DecorationImage(
                                                    image: CachedNetworkImageProvider(
                                                        data.urlOne ??=
                                                        ""),
                                                    fit: BoxFit
                                                        .fill),
                                              ),
                                            ):Container(),
                                            Flexible(
                                              child: Padding(
                                                  padding:
                                                  const EdgeInsets
                                                      .only(
                                                    left: 8.0,
                                                    right:
                                                    16.0,
                                                  ),
                                                  child: Text(
                                                    data.textOne ??=
                                                    "",
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: styleElements!.subtitle2ThemeScalable(context).copyWith(color: HexColor(AppColors.appColorWhite),fontWeight: FontWeight.w600),
                                                    textAlign:
                                                    TextAlign
                                                        .left,
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ),

                                      Align(
                                        alignment: Alignment.center,
                                        child:  Padding(
                                          padding: const EdgeInsets.only(left: 8,top: 8),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Expanded(
                                                  child:
                                                  OverlappedImages( data.images)),
                                              Expanded (
                                                  child:
                                                  Text(
                                                    data.textTwo ??= "",
                                                    maxLines: 3,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: styleElements!.captionThemeScalable(context).copyWith(color: HexColor(AppColors.appColorWhite)),
                                                    textAlign: TextAlign.left,
                                                  ))
                                            ],
                                          ),
                                        ),
                                      )
                                      ,
                                    ],
                                  )),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(10.0),
                            ),
                            elevation: 5,
                            margin: EdgeInsets.all(8),
                          ),
                        ),

                      ],
                    ),
                  );
                }).toList())):
        GestureDetector(
          onTap: () async {
            var result = await  Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddSelectSubject(
                      prefs.getInt("instituteId"),false,null

                  ),
                ));

            if (result != null && result['result'] == "success") {

              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserProfileCards(type: "subject",
                        userType: personType,
                        userId: id,
                        currentPosition: 2),
                  ));


            }

          },
          child:  Container(
              height: 150,
              width: 200,
              margin: const EdgeInsets.only(bottom: 20,top: 20),
              alignment: Alignment.topCenter,
              decoration: BoxDecoration(color: HexColor(AppColors.appColorWhite),),
              child:CustomPaginator(context).emptyListWidgetMaker(null)),
        ),


        Align(
          alignment: Alignment.topRight,
          child: GestureDetector(
              onTap: () async {
                var result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserProfileCards(
                        currentPosition: 2,
                        userId: id,
                        userType: personType,
                        type: "subject",
                      ),
                    ));
                if (result != null && result['result'] == "update") {
                  callbackPicker!();
                }
              },
              child: Container(
                margin: const EdgeInsets.only(right: 16, bottom: 16),
                child: Visibility(
                  visible: listSubItems!=null && listSubItems!.isNotEmpty,
                  child: Align
                    (
                    alignment:  Alignment.bottomRight,
                    child:Text(AppLocalizations.of(context)!.translate('see_more'),
                      style: styleElements!.subtitle2ThemeScalable(context),
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
