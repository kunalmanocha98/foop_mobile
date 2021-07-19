import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/tricycle_buttons.dart';
import 'package:oho_works_app/enums/resolutionenums.dart';
import 'package:oho_works_app/enums/serviceTypeEnums.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/utility_class.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class TricycleRequestCard extends StatefulWidget {
  final String buttonTitle;
  final Function onButtonClickCallback;
  final String imageUrl;
  final bool isContentVisible;
  final bool isDetailPage;

  TricycleRequestCard(
      {this.buttonTitle,
        this.isDetailPage,
        this.onButtonClickCallback,
        this.imageUrl,
        this.isContentVisible});

  @override
  TricycleRequestCardState createState() =>
      TricycleRequestCardState(isContentVisible: isContentVisible);
}

class TricycleRequestCardState extends State<TricycleRequestCard> {
  bool isContentVisible;

  TricycleRequestCardState({this.isContentVisible});

  @override
  Widget build(BuildContext context) {
    Utility().screenUtilInit(context);
    TextStyleElements styleElements = TextStyleElements(context);
    return TricycleCard(
      padding: EdgeInsets.all(0),
      margin: EdgeInsets.only(left: 8,right: 8,top: 8,bottom: 8),
      onTap: (isContentVisible!=null && !isContentVisible)?null:widget.onButtonClickCallback,
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(6.0),
      // ),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
              aspectRatio: (widget.isDetailPage!=null && widget.isDetailPage)?4/3:1,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(
                        Utility().getUrlForImage(widget.imageUrl,
                            RESOLUTION_TYPE.R128, SERVICE_TYPE.PERSON),
                      )),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(6.0),
                      topRight: Radius.circular(6.0)),
                ),
              ),
            ),
            Visibility(
              visible: isContentVisible??=true,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 4, bottom: 0, left: 8, right: 4),
                    child: Text(
                      '********',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: styleElements.headline6ThemeScalable(context),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TricycleElevatedButton(
                        onPressed: widget.onButtonClickCallback,
                        child: Text(
                          widget.buttonTitle,
                          style: styleElements
                              .buttonThemeScalable(context)
                              .copyWith(color: HexColor(AppColors.appColorWhite)),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )

          ],
        ),
      ),
    );

  }
}
