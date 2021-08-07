import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/models/base_res.dart';
import 'package:oho_works_app/profile_module/pages/expertise_classes.dart';
import 'package:oho_works_app/profile_module/pages/profile_page.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';

import 'overlaped_circular_images.dart';

// ignore: must_be_immutable
class ClassesAndBranches extends StatelessWidget {
  final CommonCardData data;
  int? id;
  final  String? institutionId;
  String? instituteName;
  String? instituteAddress;
  BuildContext? context;
  String? type;

  List<SubRow>? list = [];
  TextStyleElements? styleElements;
  Null Function()? callbackPicker;



  VoidCallback? onSeeMoreClicked;

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

  ClassesAndBranches(
      {Key? key,
        required this.data,
        required this.callbackPicker,
        this.styleElements,
        this.id,this.type,
        this.institutionId})
      : super(key: key);
  RandomColor _randomColor = RandomColor();

  @override
  Widget build(BuildContext context) {
    list = data.subRow;
    styleElements = TextStyleElements(context);
    this.context = context;
    return appListCard(
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
                    visible: type=="person",
                    child:   Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Align(
                            alignment: Alignment.topRight,
                            child:  GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () async {

                                var result =
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ExpertiseSelectClass(
                                        int.parse(institutionId!),
                                        null,
                                        true,
                                        0,
                                        callbackPicker,
                                        false,


                                      ),
                                    ));


                                if (result != null && result['result'] == "success") {
                                  var result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UserProfileCards(
                                          userId: id,
                                          userType: type,
                                          type: "class",
                                          currentPosition: 2,
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

            list!=null &&  list!.isNotEmpty?Container(
                margin: const EdgeInsets.only(left: 12, right: 12, top: 8),
                child: GridView.count(
                    padding: EdgeInsets.all(0.0),
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 2 / 2.2,
                    shrinkWrap: true,
                    children: list!.map((SubRow data) {
                      return GestureDetector(
                        onTap: () {

                        },
                        child: Stack(
                          children: <Widget>[
                            Container(
                              height: 200,
                              child: Card(
                                child: Stack(
                                  children: <Widget>[
                                    Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Container(
                                          decoration: BoxDecoration(
                                            color: _randomColor
                                                .randomColor(),
                                            borderRadius:
                                            BorderRadius.only(
                                                topLeft: const Radius
                                                    .circular(8.0),
                                                topRight: const Radius
                                                    .circular(8.0)),
                                          ),
                                          height: 50,
                                          child: Center(
                                            child: Text(
                                              data.textOne ?? "",
                                              maxLines: 2,
                                              overflow:
                                              TextOverflow.ellipsis,
                                              softWrap: false,
                                              style: styleElements!
                                                  .subtitle2ThemeScalable(
                                                  context)
                                                  .copyWith(
                                                  color:
                                                  HexColor(AppColors.appColorWhite),
                                                  fontWeight:
                                                  FontWeight
                                                      .w600),
                                              textAlign:
                                              TextAlign.center,
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Padding(
                                            padding:
                                            const EdgeInsets.only(
                                                left: 16.0,
                                                right: 16.0,
                                                top: 16.0),
                                            child: Text(
                                              data.textTwo ??= "",
                                              maxLines: 2,
                                              overflow:
                                              TextOverflow.ellipsis,
                                              softWrap: false,
                                              style: styleElements!
                                                  .subtitle2ThemeScalable(
                                                  context),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Padding(
                                            padding:
                                            const EdgeInsets.only(
                                                left: 16.0,
                                                right: 16.0,
                                                top: 4.0),
                                            child: Text(
                                              data.textThree ??= "",
                                              maxLines: 2,
                                              overflow:
                                              TextOverflow.ellipsis,
                                              softWrap: false,
                                              style: styleElements!
                                                  .captionThemeScalable(
                                                  context),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 50,
                                          child: Align(
                                            alignment:
                                            Alignment.topLeft,
                                            child: Padding(
                                              padding:
                                              const EdgeInsets.only(
                                                left: 16.0,
                                                right: 16.0,
                                              ),
                                              child: Row(
                                                children: <Widget>[
                                                  Expanded(
                                                      child: OverlappedImages(
                                                          data.images)),
                                                  Flexible(
                                                      child: Text(
                                                        data.totalCount ??=
                                                        "",
                                                        maxLines: 2,
                                                        overflow:
                                                        TextOverflow
                                                            .ellipsis,
                                                        softWrap: false,
                                                        style: styleElements!
                                                            .captionThemeScalable(
                                                            context),
                                                        textAlign:
                                                        TextAlign.left,
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),

                          ],
                        ),
                      );
                    }).toList())):
            GestureDetector(
              onTap: () async {


              },
              child:  Container(
                height: 150,
                width: 200,
                margin: const EdgeInsets.only(bottom: 20,top: 20),
                alignment: Alignment.topCenter,
                decoration: BoxDecoration(color: HexColor(AppColors.appColorWhite),),
                child: CustomPaginator(context).emptyListWidgetMaker(null),
              ),
            ),


            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                  onTap: () async {

                    var result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserProfileCards(
                            userId: id,
                            userType: type,
                            type: "class",
                            currentPosition: 2,
                          ),
                        ));
                    if (result != null && result['result'] == "update") {
                      callbackPicker!();
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 16, bottom: 16),
                    child: Visibility(
                      visible: list!=null && list!.isNotEmpty,
                      child: Align
                        (
                        alignment:  Alignment.bottomRight,
                        child: Text(AppLocalizations.of(context)!.translate('see_more'),
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
