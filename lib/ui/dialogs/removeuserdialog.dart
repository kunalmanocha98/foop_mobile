import 'package:oho_works_app/components/app_buttons.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RemoveUserDialog extends StatefulWidget {
  @override
  _RemoveUserDialog createState() => _RemoveUserDialog();
}

class _RemoveUserDialog extends State<RemoveUserDialog> {
  late TextStyleElements styleElements;

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Container(
        margin: EdgeInsets.only(top: 24),
        height: 520,
        child: Column(
          children: [
            Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: CachedNetworkImageProvider("https://picsum.photos/200/300"))),
            ),
            Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16, top: 16),
                  child: Text(
                    AppLocalizations.of(context)!.translate("remove_user_title"),
                    style: styleElements.headline5ThemeScalable(context),
                  ),
                )),
            Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: const EdgeInsets.all(16),
                  child: Text(
                    AppLocalizations.of(context)!.translate("remove_user_des"),
                    style: styleElements.bodyText1ThemeScalable(context),
                  ),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8),
                  child: appElevatedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        side: BorderSide(color: HexColor(AppColors.appMainColor))),
                    onPressed: () {},
                    color: HexColor(AppColors.appColorWhite),
                    child: Text(AppLocalizations.of(context)!.translate('cancel'),
                      style:styleElements.subtitle1ThemeScalable(context).copyWith(
                        color: HexColor(AppColors.appMainColor)
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: appElevatedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        side: BorderSide(color: HexColor(AppColors.appMainColor))),
                    onPressed: () {},
                    color: HexColor(AppColors.appMainColor),
                    child: Text(AppLocalizations.of(context)!.translate('ok'),
                      style: styleElements.subtitle1ThemeScalable(context),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
