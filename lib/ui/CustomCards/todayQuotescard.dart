import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/models/base_res.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



// ignore: must_be_immutable
class TodaysQouteCard extends StatelessWidget {
  final CommonCardData data;
  BuildContext context;
  List<Data> listSubItems = [];
  TextStyleElements styleElements;
  bool isProfile;
  String instituteId;
  Null Function() callbackPicker;
  int id;
  String personType;

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

  TodaysQouteCard({
    Key key,
    @required this.data,
    this.instituteId,
    this.isProfile,
    this.id,
    this.personType,
    this.callbackPicker,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    this.context = context;
    styleElements = TextStyleElements(context);
    listSubItems = data.data;
    return TricycleListCard(
      child: ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.all(0.0),
          physics: NeverScrollableScrollPhysics(),
          itemCount: listSubItems.length,
          itemBuilder: (context, index) {
            return GestureDetector(
                onTap: () {

                },
                child:Card(
                  margin: const EdgeInsets.all(0.0),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0,right: 8.0,top: 4.0,bottom: 4.0),
                    child:  Row(
                      children: [
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.all(16.h),
                            child: Container(
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Icon(
                                      Icons.format_quote,
                                      size: 24.h,
                                    ),
                                  ),
                                  Align(
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
                                      child: Text(
                                        listSubItems[index].quoteText??"",
                                        style: styleElements.subtitle1ThemeScalable(context).copyWith(fontStyle:FontStyle.italic),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      listSubItems[index].quotedByName??"",
                                      style: styleElements.bodyText1ThemeScalable(context),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Icon(
                                      Icons.format_quote,
                                      size: 24.h,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          flex: 1,
                        ),
                        Flexible(
                          child: Container(
                            child: FittedBox(
                              fit: BoxFit.fill,
                              child: Image(
                                fit: BoxFit.fill,
                                image: CachedNetworkImageProvider(Config.BASE_URL+ listSubItems[index].quoteImageThumbnailUrl??""),
                              ),
                            ),
                          ),
                          flex: 1,
                        )
                      ],
                    ),
                  )
                  ,
                ));
          }),
    );
  }


}


