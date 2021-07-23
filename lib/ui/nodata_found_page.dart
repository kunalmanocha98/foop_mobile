import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NoDataFoundPage extends StatelessWidget {
   NoDataFoundPage(
      {Key? key,
      this.image,
      this.type,
      this.startGradientColor,
      this.endGradientColor,
      this.subText,
      this.desc})
      : super(key: key);

  final String? image;
  final type;
  final Color? startGradientColor;
  final Color? endGradientColor;
  final String? subText;
  final String? desc;
  late TextStyleElements styleElements;

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return Container(
        alignment: Alignment.topCenter,
        decoration: BoxDecoration(color: HexColor(AppColors.appColorWhite)),
        child: ListView(
          children: <Widget>[
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(top: 80),
                    alignment: Alignment.center,
                    height: 200,
                    width: 200,
                    child: Center(),
                    /* add child content here */
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        left: 16, bottom: 12, top: 12, right: 16),
                    alignment: Alignment(0, -0.76),
                    child: Text(
                      desc!,
                      style: styleElements.headline5ThemeScalable(context),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  // TextStyle buildTextStyle(double size) {
  //   return TextStyle(
  //     fontSize: size,
  //     fontWeight: FontWeight.w900,
  //     height: 0.5,
  //   );
  // }
}
