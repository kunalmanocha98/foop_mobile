import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/models/base_res.dart';
import 'package:oho_works_app/profile_module/pages/profile_page.dart';
import 'package:oho_works_app/ui/commentItem.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// ignore: must_be_immutable
class JournalCard extends StatelessWidget {
  final CommonCardData data;
  BuildContext context;
  List<SubRow> listSubItems = [];
  TextStyleElements styleElements;
  // Widget _simplePopup() => PopupMenuButton<int>(
  //       itemBuilder: (context) => [
  //         PopupMenuItem(
  //           value: 1,
  //           child: Text("Add Sports"),
  //         ),
  //       ],
  //       onSelected: (value) {
  //         // if(data.title??""=="Sports & Fitness")
  //         // {
  //         Navigator.push(context,
  //             MaterialPageRoute(builder: (context) => SportsClubListPage()));
  //         // }
  //         // else{
  //         //   Navigator.push(
  //         //       context,
  //         //       MaterialPageRoute(
  //         //         builder: (context) => EditWork(
  //         //
  //         //         ),
  //         //       ));
  //         // }
  //       },
  //       icon: Icon(
  //         Icons.more_horiz,
  //         size: 30,
  //         color: HexColor(AppColors.appColorBlack85),
  //       ),
  //     );

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

  JournalCard({Key key, @required this.data,this.styleElements}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    this.context = context;
    listSubItems = data.subRow;
    styleElements = TextStyleElements(context);
    return TricycleListCard(
        child: Column(
          children: <Widget>[
            Row(
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
                // Flexible(
                //   child: Align(
                //       alignment: Alignment.topRight,
                //       child: _simplePopup()),
                //   flex: 1,),
              ],
            ),
            ConstrainedBox(
              constraints: new BoxConstraints(
                minHeight: 120.0,
                maxHeight: 350.0,
              ),
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: listSubItems.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: () {},
                        child: CommentItemCard(
                          data: null,
                        ));
                  }),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                margin:
                    const EdgeInsets.only(right: 20, top: 20, bottom: 20),
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
                      bottom: 20,
                      right: 20,
                      child: Stack(
                        children: <Widget>[
                          Container(
                            width: 77.0,
                            height: 20.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24.0),
                              color:  HexColor(AppColors.appColorGrey50),
                            ),
                          ),
                          Positioned.fill(
                              child: Align(
                            alignment: Alignment.center,
                            child: Text(AppLocalizations.of(context).translate('see_more'),
                              style: styleElements.subtitle1ThemeScalable(context),
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
          ],
        ));
  }
}
