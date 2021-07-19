import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'colors.dart';
import 'hexColors.dart';

// ignore: must_be_immutable
class PreloadingViewHome extends StatelessWidget {
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

  PreloadingViewHome({
    Key key,
    @required this.url,
  }) : super(key: key);

  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: Shimmer.fromColors(
              baseColor: HexColor(AppColors.appColorGrey300),
              highlightColor: HexColor(AppColors.appColorGrey100),
              enabled: enabled,
              child: ListView.builder(
                itemBuilder: (_, __) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child:
                  ListTile(
                      leading: Container(
                        width: 52,
                        height:52,
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
                        height:20,
                        color: HexColor(AppColors.appColorWhite),
                      ) ,
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

                  )

                  ,
                ),
                itemCount: 6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
