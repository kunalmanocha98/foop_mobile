
import 'package:oho_works_app/models/base_res.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:random_color/random_color.dart';

import 'overlaped_circular_images.dart';

// ignore: must_be_immutable
class ClubDetailCard extends StatelessWidget {
  final CommonCardData data;

  String? instituteName;
  String? instituteAddress;
  BuildContext? context;
  bool? isProfile;
  String? instituteId;
  Null Function()? callbackPicker;
  List<SubRow>? list = [];
  late TextStyleElements styleElements;
  int? id;
  String? personType;

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

  ClubDetailCard(
      {Key? key,
        required this.data,
        this.instituteId,
        this.isProfile,
        this.id,this.personType,
        this.callbackPicker,})
      : super(key: key);
  RandomColor _randomColor = RandomColor();
  String? type;

  @override
  Widget build(BuildContext context) {
    list = data.subRow;
    if (data.title == "Language")
      type = "Languages";
    else
      type = "Skill";
    styleElements = TextStyleElements(context);
    this.context = context;
    return Container(
      child: ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.all(0.0),
          physics: NeverScrollableScrollPhysics(),
          itemCount: list!.length,
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
                      borderRadius:
                      BorderRadius.all(Radius.circular(8.0)),
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
                      child: Padding(
                          padding: EdgeInsets.all(16.0.h),
                          child: Row(
                            children: [
                              SizedBox(
                                height: 60,
                                width: 60,
                                child: Card(
                                  child: Image(
                                    image: CachedNetworkImageProvider(
                                        list![index].imageUrl ??
                                            ""),
                                    fit: BoxFit.contain,
                                    width: 60,
                                    height: 60,
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                    left: 12, right: 12),
                                child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          list![index].textOne ??=
                                          "",
                                          style: styleElements
                                              .headline6ThemeScalable(
                                              context)
                                              .copyWith(
                                              color: HexColor(AppColors.appColorWhite)),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      Visibility(
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              list![index]
                                                  .chairperson !=
                                                  null
                                                  ? ("Chairperson : " +
                                                  list![index]
                                                      .chairperson!)
                                                  : "",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: styleElements
                                                  .captionThemeScalable(
                                                  context)
                                                  .copyWith(
                                                  color: HexColor(AppColors.appColorWhite)),
                                              textAlign: TextAlign.left,
                                            ),
                                          )),
                                      Container(
                                        child: Row(
                                          children: <Widget>[
                                            OverlappedImages(
                                                list![index]
                                                    .images),
                                            Container(
                                              margin:
                                              const EdgeInsets.only(
                                                  left: 16),
                                              child: Flexible(
                                                child: Text(
                                                  list![index]
                                                      .totalCount ??= "",
                                                  style: styleElements
                                                      .captionThemeScalable(
                                                      context)
                                                      .copyWith(
                                                      color: Colors
                                                          .white),
                                                  textAlign:
                                                  TextAlign.left,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ]),
                              )
                            ],
                          )),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }

  String getExpertise(List<String> list) {
    return  list.join(',');
  }


}
