import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'colors.dart';
import 'hexColors.dart';

// ignore: must_be_immutable
class PreloadingView extends StatelessWidget {
  bool enabled = true;
  String url;

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

  PreloadingView({
    Key? key,
    required this.url,
  }) : super(key: key);

  Widget build(BuildContext context) {
    return Container(
      height: 6,
      margin: const EdgeInsets.all(16),
      child:  Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Shimmer.fromColors(
            baseColor: HexColor(AppColors.appColorGrey300),
            highlightColor: HexColor(AppColors.appColorGrey100),
            enabled: enabled,
            child: ListView.builder(
              shrinkWrap: true,
              itemBuilder: (_, __) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child:
                ListTile(
                    leading: Container(
                      width: 52.0,
                      height: 52.0,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(url),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title:   Container(
                      width: double.infinity,
                      height: 8.0,
                      color: HexColor(AppColors.appColorWhite),
                    ),
                    subtitle:  Container(
                      width: double.infinity,
                      height: 8.0,
                      color: HexColor(AppColors.appColorWhite),
                    ),
                    trailing:   Container(
                      width: 40.0,
                      height: 8.0,
                      color: HexColor(AppColors.appColorWhite),
                    )
                ),
              ),
              itemCount: 6,
            ),
          ),
        ],
      ),
    );
  }
}


class PreloadingViewParagraph extends StatelessWidget {

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

  PreloadingViewParagraph({
    Key? key,
  }) : super(key: key);

  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Shimmer.fromColors(
        baseColor: HexColor(AppColors.appColorGrey300),
        highlightColor: HexColor(AppColors.appColorGrey100),
        enabled: true,
        child:Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(top:4,bottom: 4),
              width: double.infinity,
              height: 16.0,
              color: HexColor(AppColors.appColorWhite),
            ),
            Container(
              margin: EdgeInsets.only(top:4,bottom: 4),
              width: double.infinity,
              height: 16.0,
              color: HexColor(AppColors.appColorWhite),
            ),
            Container(
              margin: EdgeInsets.only(top:4,bottom: 4),
              width: double.infinity,
              height: 16.0,
              color: HexColor(AppColors.appColorWhite),
            )
          ],
        )
      ),
    );
  }
}

class PreLoadingShimmerCard extends StatelessWidget {

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

  PreLoadingShimmerCard({
    Key? key,
  }) : super(key: key);

  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Shimmer.fromColors(
          baseColor: HexColor(AppColors.appColorGrey300),
          highlightColor: HexColor(AppColors.appColorGrey100),
          enabled: true,
          child:Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  ClipOval(child: Container(
                    color: HexColor(AppColors.appColorWhite),
                    height: 64,
                    width: 64,
                  ))
                ],
              ),
              Expanded(
                child: Padding(
                  padding:  EdgeInsets.only(left:16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top:4,bottom: 4),
                        width: double.infinity,
                        height: 16.0,
                        color: HexColor(AppColors.appColorWhite),
                      ),
                      Container(
                        margin: EdgeInsets.only(top:4,bottom: 4),
                        width: double.infinity,
                        height: 16.0,
                        color: HexColor(AppColors.appColorWhite),
                      ),
                      Container(
                        margin: EdgeInsets.only(top:4,bottom: 4),
                        width: double.infinity,
                        height: 16.0,
                        color: HexColor(AppColors.appColorWhite),
                      ),
                      Container(
                        margin: EdgeInsets.only(top:4,bottom: 4),
                        width: double.infinity,
                        height: 16.0,
                        color: HexColor(AppColors.appColorWhite),
                      ),
                      Container(
                        margin: EdgeInsets.only(top:4,bottom: 4),
                        width: double.infinity,
                        height: 16.0,
                        color: HexColor(AppColors.appColorWhite),
                      ),
                      Container(
                        margin: EdgeInsets.only(top:4,bottom: 4),
                        width: double.infinity,
                        height: 16.0,
                        color: HexColor(AppColors.appColorWhite),
                      )
                    ],
                  ),
                ),
              ),
            ],
          )
      ),
    );
  }
}

