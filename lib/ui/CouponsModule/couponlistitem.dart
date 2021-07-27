import 'package:oho_works_app/enums/couponenums.dart';
import 'package:oho_works_app/enums/resolutionenums.dart';
import 'package:oho_works_app/enums/serviceTypeEnums.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/utility_class.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


// ignore: must_be_immutable
class CouponListItemCard extends StatelessWidget {
  String? imageUrl;
  String? title;
  int? discount;
  int? rewardPoints;
  String? validTill;
  String? discountType;
  bool? isActive = false;
  bool? isDividerHide = false;
  bool? isCoinsHide;
  late TextStyleElements styleElements;
  double? imageWidth;
  double? imageHeight;

  CouponListItemCard(
      {this.imageUrl,
      this.title,
      this.discount,
      this.discountType,
      this.rewardPoints,
      this.validTill,
      this.isActive,
      this.isDividerHide,
      this.isCoinsHide,
      this.imageWidth,
      this.imageHeight});

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return Container(
      padding: EdgeInsets.all(0),
      // height: (imageHeight > 72) ? 160 : 140,
      child: Stack(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            // alignment: WrapAlignment.start,
            // crossAxisAlignment: WrapCrossAlignment.center,
            // direction: Axis.horizontal,
            children: [
              Container(
                margin:
                    EdgeInsets.only( right: 4),
                width: imageWidth,
                height: imageHeight,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(Utility().getUrlForImage(imageUrl,RESOLUTION_TYPE.R128, SERVICE_TYPE.POST)),
                  ),
                ),
              ),
              Visibility(
                visible: isDividerHide != null ? !isDividerHide! : true,
                child:VerticalDivider(
                  thickness: 2,
                  color: HexColor(AppColors.appColorBlack35),
                  indent: 4,
                  endIndent: 4,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 8.0, bottom: 4.0, right: 4.0, left: 8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // direction: Axis.vertical,
                  // crossAxisAlignment: WrapCrossAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 1.0, bottom: 1.0),
                      child: Text(
                        title!,
                        style: styleElements.headline6ThemeScalable(context),
                      ),
                    ),
                    getPriceWidget(context),
                    Container(
                      width: (imageHeight! > 72) ? 240 : 260,
                      alignment: Alignment.bottomRight,
                      child:Padding(
                        padding: const EdgeInsets.only(top: 4,bottom: 4,right: 8),
                        child: Text(AppLocalizations.of(context)!.translate('valid_until') +"$validTill",
                          style: styleElements.captionThemeScalable(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Visibility(
            visible: isActive != null ? isActive! : false,
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  margin: EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 8),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: HexColor(AppColors.appColorGreenAccent),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
          // Align(
          //   alignment: Alignment.bottomRight,
          //   child: Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: Text(
          //       "Valid unitl $validTill",
          //       style: styleElements.captionThemeScalable(context),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  getPriceWidget(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Visibility(
          visible: discountType == COUPON_DISCOUNT_TYPE.Amount.type,
          child: Text(AppLocalizations.of(context)!.translate('rupee_symbol'),
            style: styleElements.headline6ThemeScalable(context),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 0.0),
          child: Text(
    discount!=null?  discount.toString():"",
            style: styleElements.headline4ThemeScalable(context),
          ),
        ),
        Visibility(
          visible: discountType == COUPON_DISCOUNT_TYPE.Percentage.type,
          child: Padding(
            padding: const EdgeInsets.only(left: 4.0, right: 8.0),
            child: Text("%",
              style: styleElements.headline6ThemeScalable(context),
            ),
          ),
        ),
        Text(
          (isCoinsHide != null && isCoinsHide!)
              ? ""
              : "@$rewardPoints app coins",
          style: styleElements.captionThemeScalable(context),
        )
        // Text(
        //   "Coupon",
        //   style: styleElements.captionThemeScalable(context),
        // ),
      ],
    );
  }
}
