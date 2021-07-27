import 'package:oho_works_app/components/appAvatar.dart';
import 'package:oho_works_app/enums/resolutionenums.dart';
import 'package:oho_works_app/enums/serviceTypeEnums.dart';
import 'package:oho_works_app/ui/RoomModule/rooms_listing.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class appUserListTile extends StatelessWidget {
  final bool isOnline;
  final String? superScriptText;
  final String? title;
  final String? subtitle1;
  final String? subtitle2;
  final bool isVerified;
  final String? imageUrl;
  final bool isPerson;
  final bool isFullImageUrl;
  final bool showRating;
  final double rating;
  final bool isModerator;
  final bool showCount;
  final bool showAvatar;
  final int count;
  final Widget? trailingWidget;
  final Function? onPressed;
  final SERVICE_TYPE? service_type;
  final Widget? subtitleWidget;
  final Widget? titleWidget;
  final Widget? leadingWidget;
  final Widget? iconWidget;
  final BoxDecoration?  decoration;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
final Function(int? )? callBack;
final Widget? trailWidget;
final int? userId;
  appUserListTile({
    this.superScriptText,
    this.iconWidget,
    this.callBack,
    this.userId,
    this.trailWidget,
    this.isOnline = false,
    this.isVerified = false,
    this.title ="",
    this.subtitle1,
    this.subtitle2,
    this.imageUrl,
    this.isPerson = true,
    this.isFullImageUrl = false,
    this.showRating = false,
    this.isModerator = false,
    this.rating = 0.0,
    this.showCount = false,
    this.showAvatar = true,
    this.onPressed,
    this.count =0,
    this.service_type,
    this.trailingWidget,
    this.subtitleWidget,
    this.titleWidget,
    this.leadingWidget,
    this.decoration,
    this.padding,
    this.margin
  });

  @override
  Widget build(BuildContext context) {
    var styleElements = TextStyleElements(context);
    return InkWell(
      onTap: (){
        if(callBack!=null) {callBack!(userId);}
        if(onPressed!=null) {onPressed!();}
      },
      child: Container(
        decoration: decoration,
        margin: margin ?? EdgeInsets.all(0),
        padding: padding ?? EdgeInsets.only(top: 4, bottom: 4, left: 4, right: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [


            _getSuperScript(context,styleElements),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                iconWidget!=null ?iconWidget!: _getAvatar(context, styleElements),


                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 16.0, right: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _getTitle(context, styleElements),
                        _getSubtitle(context,styleElements),
                        Row(
                          children: [
                            _ratingWidget(context, styleElements),
                            _dividerWidget,
                            Visibility(
                              visible: isModerator,
                                child: RoomButtons(context: context).moderatorImage),
                            _dividerWidget,
                            (subtitle2!=null && subtitle2!.isNotEmpty)?Flexible(
                              child: Text(
                                subtitle2!,
                                style: styleElements
                                    .bodyText2ThemeScalable(context)
                                    .copyWith(fontSize: 14),
                              ),
                            ):Container()
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                showCount?_countWidget(context, styleElements):
                (trailingWidget!=null)?trailingWidget!:Container()


              ],
            ),
          ],
        ),
      ),
    );
  }
  Widget _getSuperScript(BuildContext context, TextStyleElements styleElements){
    return  (superScriptText!=null && superScriptText!.isNotEmpty)?Row(
      children: [
        Spacer(),
        Text(
          superScriptText!,
          style: styleElements.bodyText2ThemeScalable(context).copyWith(
              color: HexColor(AppColors.appColorBlack35), fontSize: 12),
        )
      ],
    ):Container();
  }
  Widget _getTitle(BuildContext context, TextStyleElements styleElements){
    return  Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Text(
            title!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: styleElements
                .subtitle1ThemeScalable(context)
                .copyWith(
                color:
                HexColor(AppColors.appColorBlack85)),
          ),
        ),
        Visibility(
          visible: isVerified,
          child: Padding(
            padding: EdgeInsets.only(top: 4.0),
            child: RoomButtons(context: context).verifiedImage,
          ),
        )
      ],
    );
  }
  Widget _getSubtitle(BuildContext context, TextStyleElements styleElements){
    return (subtitle1!=null && subtitle1!.isNotEmpty)?Text(
      subtitle1!,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: styleElements
          .bodyText2ThemeScalable(context)
          .copyWith(
          color: HexColor(AppColors.appColorBlack35)),
    ):   new Opacity(opacity: 0.0,child: Container());
  }
  Widget _getAvatar(BuildContext context, TextStyleElements styleElements) {
    return SizedBox(
      height: 52,
      width: 52,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: appAvatar(
              size: 52,
              isFullUrl: isFullImageUrl,
              imageUrl: imageUrl,
              service_type: isPerson?SERVICE_TYPE.PERSON: SERVICE_TYPE.INSTITUTION,
              resolution_type: RESOLUTION_TYPE.R64,
            ),
          ),
          Visibility(
            visible: isOnline,
            child: Align(
                alignment: Alignment.bottomRight,
                child: ClipOval(
                  child: Container(
                    height: 12,
                    width: 12,
                    color: HexColor(AppColors.appColorGreen),
                  ),
                )),
          ),
        ],
      ),
    );
  }

  Widget _countWidget(BuildContext context, TextStyleElements styleElements) {
    String c;
    if(count>100){
      c = '99+';
    }else{
      c= '$count';
    }
    return Container(
      margin: EdgeInsets.only(top: 4),
      decoration: BoxDecoration(
        color: HexColor(AppColors.appMainColor),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
        child: Text(
          c,
          style: styleElements.captionThemeScalable(context).copyWith(
              color: HexColor(AppColors.appColorWhite),
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget get _dividerWidget => Container(
    margin: EdgeInsets.only(left: 4, right: 4),
    color: HexColor(AppColors.appColorBlack35),
    height: 12,
    width: 0,
  );
  Widget _ratingWidget(BuildContext context, TextStyleElements styleElements) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Visibility(
          visible: showRating,
          child: Text(
            '$rating',
            style: styleElements.bodyText2ThemeScalable(context).copyWith(
                color: HexColor(AppColors.appColorBlack35),
                fontWeight: FontWeight.bold,
                fontSize: 14),
          ),
        ),
        Visibility(
          visible: showRating,
          child: RatingBar(
            initialRating: rating,
            ignoreGestures: true,
            direction: Axis.horizontal,
            allowHalfRating: false,
            itemCount: 5,
            itemSize: 12.0,
            itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
            ratingWidget: RatingWidget(
              empty: Icon(
                Icons.star_outline,
                color: HexColor(AppColors.appColorBlack35),
              ),
              half: Icon(
                Icons.star_half_outlined,
                color: HexColor(AppColors.appColorBlack35),
              ),
              full: Icon(
                Icons.star_outlined,
                color: HexColor(AppColors.appColorBlack35),
              ),
            ),
            onRatingUpdate: (rating) {
              print(rating);
            },
          ),
        ),
      ],
    );
  }
}
