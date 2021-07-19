import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/models/base_res.dart';
import 'package:oho_works_app/profile_module/pages/general_skills_edit_page.dart';
import 'package:oho_works_app/ui/rate_dialog.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'overlaped_circular_images.dart';

// ignore: must_be_immutable
class SkillsCard extends StatelessWidget {
  final CommonCardData data;
  BuildContext context;
  TextStyleElements styleElements;
  Widget _simplePopup() => PopupMenuButton<int>(
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 1,
            child:
                Text(AppLocalizations.of(context).translate('add_new_skills')),
          ),
        ],
        onSelected: (value) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GeneralSkillsEditPage(),
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

  SkillsCard({Key key, @required this.data,this.styleElements}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    this.context = context;
    styleElements = TextStyleElements(context);
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) =>
                RateDialog(type: "", title: AppLocalizations.of(context).translate('rate_skill'), subtitle: ""));
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
                            style: styleElements.headline5ThemeScalable(context),
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
              alignment: Alignment.topLeft,
              child: Container(
                margin: const EdgeInsets.only(
                    left: 16, right: 16, top: 16, bottom: 6),
                child: Text(
                  data.textOne ?? "",
                  style: styleElements.subtitle1ThemeScalable(context),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 16, right: 16),
              child: Row(
                children: <Widget>[
                  Container(
                    child: Text("",
                      style: styleElements.bodyText2ThemeScalable(context),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  RatingBar(
                    initialRating: 3,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemSize: 12.0,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    ratingWidget: RatingWidget(
                      empty: Icon(
                        Icons.star_outline,
                        color: HexColor(AppColors.appMainColor),
                      ),
                      half:  Icon(
                        Icons.star_half_outlined,
                        color: HexColor(AppColors.appMainColor),
                      ),
                      full:  Icon(
                        Icons.star_outlined,
                        color: HexColor(AppColors.appMainColor),
                      ),
                    ),
                    onRatingUpdate: (rating) {
                      print(rating);
                    },
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                  left: 16, right: 16, top: 16, bottom: 16),
              child: Row(
                children: <Widget>[
                  OverlappedImages(null),
                  Text("",
                    style: styleElements.bodyText1ThemeScalable(context),
                    textAlign: TextAlign.left,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
