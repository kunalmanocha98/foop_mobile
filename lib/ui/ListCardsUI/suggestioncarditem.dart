import 'package:oho_works_app/components/tricycle_buttons.dart';
import 'package:oho_works_app/models/base_res.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class SuggestionItemCard extends StatelessWidget {
  SubRow data;
  TextStyleElements styleElements;
  SuggestionItemCard({Key key, @required this.data,this.styleElements}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return Container(
        width: 136.w,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0.w),
          ),
          elevation: 4,
          child: Column(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: 136.w,
                  width: 136.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    image: DecorationImage(
                        fit: BoxFit.fill, image: CachedNetworkImageProvider(data.urlOne)),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(6.0.w),
                        topRight: Radius.circular(6.0.w)),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 2.h, bottom: 0.h, left: 8.w, right: 4.w),
                        child: Text(
                          data.textOne ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: styleElements.subtitle1ThemeScalable(context),
                        ),
                      ),
                    ),
                    Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                            padding: EdgeInsets.only(
                                top: 0.h, bottom: 4.h, left: 8.w, right: 4.w),
                            child: Text(data.textTwo,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: styleElements.bodyText2ThemeScalable(context)))),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: TricycleElevatedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0.w),
                              side: BorderSide(color: HexColor(AppColors.appMainColor))),
                          onPressed: () {},
                          color: HexColor(AppColors.appMainColor),
                          child: Text(AppLocalizations.of(context).translate('follow'),
                            style:
                            styleElements.captionThemeScalable(context).copyWith(fontWeight: FontWeight.bold,color: HexColor(AppColors.appColorWhite)),
                          ),
                        ))
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
