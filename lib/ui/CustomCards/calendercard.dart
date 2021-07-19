import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/models/base_res.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../profile_module/pages/profile_page.dart';
import '../ListCardsUI/calenderItem.dart';

// ignore: must_be_immutable
class TodaysCalenderCard extends StatelessWidget {
  final CommonCardData data;
  BuildContext context;
  List<SubRow> listSubItems = [];
  TextStyleElements styleElements;
  TodaysCalenderCard({Key key, @required this.data,this.styleElements}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    this.context = context;
    listSubItems = data.subRow;
    return TricycleListCard(
      child: Container(
          height: 300.h,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          margin:  EdgeInsets.only(left: 20.w, top: 20.h),
                          child: Text(
                            data.title ?? "",
                            style: styleElements.headline6ThemeScalable(context),
                            textAlign: TextAlign.left,
                          ),
                        )),
                    flex: 3,
                  ),
                  Flexible(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        margin: EdgeInsets.only(right: 20.w, top: 20.h),
                        child: Visibility(
                          visible: data.isShowMore ??= false,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UserProfileCards(
                                      type: "sport",
                                      currentPosition: 2, userId: null, userType: null,
                                    ),
                                  ));
                            },
                            child: Positioned(
                              bottom: 20.h,
                              right: 20.w,
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    width: 77.0.w,
                                    height: 20.0.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(24.0.h),
                                      color:  HexColor(AppColors.appColorGrey50),
                                    ),
                                  ),
                                  Positioned.fill(
                                      child: Align(
                                    alignment: Alignment.center,
                                    child: Text(AppLocalizations.of(context).translate('see_more'),
                                      style: styleElements.bodyText2ThemeScalable(context),
                                      textAlign: TextAlign.center,
                                    ),
                                  ))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    flex: 1,
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  child: ListView.builder(
                    padding: EdgeInsets.all(2.h),
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: listSubItems.length,
                    itemBuilder: (context, index) {
                      return CalenderItem(
                        data: listSubItems[index],
                      );
                    },
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
