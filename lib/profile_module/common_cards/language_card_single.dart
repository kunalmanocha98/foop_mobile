import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/models/base_res.dart';
import 'package:oho_works_app/profile_module/pages/edit_language-page.dart';
import 'package:oho_works_app/ui/rate_dialog.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class LanguageCardSingle extends StatelessWidget {
  final CommonCardData data;
  BuildContext context;
  TextStyleElements styleElements;
  Widget _simplePopup() => PopupMenuButton<int>(
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 1,
            child: Text(
                AppLocalizations.of(context).translate('add_new_language')),
          ),
        ],
        onSelected: (value) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditLanguage("Languages",instId,false,null),
              ));
        },
        icon: Icon(
          Icons.more_horiz,
          size: 30,
          color: HexColor(AppColors.appColorBlack85),
        ),
      );

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
String instId;
  LanguageCardSingle({Key key, @required this.data,this.styleElements,this.instId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    this.context = context;
    styleElements = TextStyleElements(context);
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) => RateDialog(
                type: "", title: AppLocalizations.of(context).translate('select_proficiency'), subtitle: ""));
      },
      child: TricycleListCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Visibility(
              visible: data.title ?? "" != null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          padding: const EdgeInsets.only(left: 16, right: 16,top:12,bottom:12),
                          child: Text(
                            data.title ?? "",
                            style: styleElements.headline6ThemeScalable(context),
                            textAlign: TextAlign.left,
                          ),
                        )),
                    flex: 3,
                  ),
                  Flexible(
                    child: _simplePopup(),
                    flex: 1,
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: ListTile(
                title: Text(data.textOne),
                subtitle: Text(data.textTwo),
                trailing: Icon(
                  Icons.star_border,
                  color: HexColor(AppColors.appMainColor),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
