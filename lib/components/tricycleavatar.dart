import 'dart:math';

import 'package:oho_works_app/components/commonComponents.dart';
import 'package:oho_works_app/components/tricycle_auto_size_text.dart';
import 'package:oho_works_app/enums/resolutionenums.dart';
import 'package:oho_works_app/enums/serviceTypeEnums.dart';
import 'package:oho_works_app/ui/DpEnlargePage.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/utility_class.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TricycleAvatar extends StatefulWidget {
  double size;
  String imageUrl;
  bool withBorder;
  double borderSize;
  Color borderColor;
  SERVICE_TYPE service_type;
  RESOLUTION_TYPE resolution_type;
  bool isClickable;
  bool isFullUrl;
  bool isFromAsset;
  String placeholderImage;
  bool shouldPrintLog;
  bool withBorderDivider;
  double borderDividersize;
  String name;

  TricycleAvatar(
      {Key key,
        this.size,
        this.borderColor,
        @required this.imageUrl,
        this.service_type,
        this.resolution_type,
        this.isClickable = true,
        this.isFullUrl = false,
        this.isFromAsset = false,
        this.shouldPrintLog = false,
        this.withBorderDivider = false,
        this.borderDividersize,
        this.placeholderImage,
        this.withBorder,
        this.name,
        this.borderSize})
      : super(key: key);

  @override
  TricycleAvatarState createState() =>
      TricycleAvatarState(size: size, imageUrl: imageUrl);
}

class TricycleAvatarState extends State<TricycleAvatar> {
  double size;
  String imageUrl;

  TricycleAvatarState({this.size, this.imageUrl});

  void refresh(String imageUrl) {
    setState(() {
      this.imageUrl = imageUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isClickable
          ? () {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
              return DpEnlargePage(
                imageUrl: imageUrl,
                service_type: widget.service_type,
                isFullUrl: widget.isFullUrl,
                isFromAsset: widget.isFromAsset,
                  name:widget.name
              );
            }));
      }
          : null,
      child: (widget.withBorder != null && widget.withBorder)
          ? Container(
        padding: widget.borderSize != null
            ? EdgeInsets.all(widget.borderSize)
            : EdgeInsets.all(4),
        decoration: BoxDecoration(
            color: widget.borderColor != null
                ? widget.borderColor
                : HexColor(AppColors.appColorWhite),
            shape: BoxShape.circle,
            boxShadow: [CommonComponents().getShadowforBox_01_3()]),
        child: Container(
          padding: (widget.withBorderDivider != null &&
              widget.withBorderDivider)
              ? widget.borderDividersize != null
              ? EdgeInsets.all(widget.borderDividersize)
              : EdgeInsets.all(2)
              : EdgeInsets.all(0),
          decoration: BoxDecoration(
            color: HexColor(AppColors.appColorWhite),
            shape: BoxShape.circle,
          ),
          child: (widget.imageUrl==null && widget.name!=null)?
          _letterAvatar()
              :Container(
            height: size ??= 52,
            width: size ??= 52,
            decoration: BoxDecoration(
                color: HexColor(AppColors.appColorWhite),
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: widget.isFromAsset
                        ? AssetImage(imageUrl)
                        : CachedNetworkImageProvider(
                      widget.isFullUrl
                          ? imageUrl
                          : Utility().getUrlForImage(
                          imageUrl,
                          widget.resolution_type,
                          widget.service_type,
                          shouldprint: widget.shouldPrintLog),
                    ),
                    fit: BoxFit.cover)),
          ),
        ),
      )
          :(widget.imageUrl==null && widget.name!=null)?
          _letterAvatar()
      :Container(
        height: size ??= 52,
        width: size ??= 52,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
                image: widget.isFromAsset
                    ? AssetImage(imageUrl)
                    : CachedNetworkImageProvider(widget.isFullUrl
                    ? imageUrl
                    : Utility().getUrlForImage(imageUrl,
                    widget.resolution_type, widget.service_type,
                    shouldprint: widget.shouldPrintLog)),
                fit: BoxFit.cover)),
      ),
    );
  }

  Widget _letterAvatar(){
    return  Container(
      height: size ??= 52,
      width: size ??= 52,
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: AppColors.colorsList[Random().nextInt( AppColors.colorsList.length)],
          shape: BoxShape.circle,),
      child: Center(
        child: TricycleAutoSizeText(
         widget.name[0],
         style: TextStyleElements(context).headline1ThemeScalable(context).copyWith(
           fontWeight: FontWeight.normal,
           color: HexColor(AppColors.appColorBlack65)
         ),
        ),
      ),
    );
  }
}
