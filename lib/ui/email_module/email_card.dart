import 'dart:math';

import 'package:oho_works_app/components/commonComponents.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/tricycleHtmlViewer.dart';
import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/models/email_module/email_list_modules.dart';
import 'package:oho_works_app/ui/email_module/email_detail_page.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'email_header.dart';

class TricycleEmailCard extends StatefulWidget {
  final bool isDetailPage;
  final EmailListItem? emailItem;

  TricycleEmailCard({this.isDetailPage= false,this.emailItem});

  @override
  _TricycleEmailCard createState() =>
      _TricycleEmailCard(isDetailPage: isDetailPage,emailItem: emailItem);
}

class _TricycleEmailCard extends State<TricycleEmailCard> {
  SharedPreferences? prefs = locator<SharedPreferences>();
  late TextStyleElements styleElements;
  bool? isDetailPage;
  EmailListItem? emailItem;

  _TricycleEmailCard({this.isDetailPage,this.emailItem});

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return TricycleCard(
      padding: EdgeInsets.only(top:8),
      onTap: widget.isDetailPage?null:() {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
              return EmailDetailPage(
                subject:emailItem!.subject
              );
            }));
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EmailCardHeader(
            emailItem : emailItem,
          ),
          Padding(
            padding: EdgeInsets.only(left:20.0,right: 16,top:8,bottom: 8),
            child: Row(
              children: [
                Container(
                  height: 12,
                  width: 12,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: HexColor(AppColors.appMainColor)),
                ),
                Spacer(),
                Padding(
                  padding: EdgeInsets.only(left: 8.0, bottom: 0, top: 4),
                  child: Text(
                    timeago.format(DateTime.fromMillisecondsSinceEpoch(emailItem!.date!)),
                    style: styleElements
                        .captionThemeScalable(context)
                        .copyWith(
                        fontSize: 10,
                        color: HexColor(AppColors.appColorBlack35)),
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: false,
            child: Padding(
              padding: EdgeInsets.only(left:8.0,right: 16,top:0,bottom: 0),
              child: Container(
                height: 88,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      height: 72,
                      width: 72,
                      margin: EdgeInsets.all(8),
                      color: Colors.primaries[
                      Random().nextInt(Colors.primaries.length)],
                    );
                  },
                ),
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: widget.isDetailPage,
                  child: EmailSideMenu()),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 12, right: 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          emailItem!.subject!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: styleElements
                              .subtitle1ThemeScalable(context)
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 0.0, bottom: 6),
                        child: Row(
                          children: [
                            Visibility(
                              visible: false,
                              child: Container(
                                height: 36,
                                width: 36,
                                margin: EdgeInsets.only(right: 0),
                                color: Colors.primaries[
                                Random().nextInt(Colors.primaries.length)],
                              ),
                            ),
                            Expanded(
                              child: TricycleHtmlViewer(
                                isDetailPage: widget.isDetailPage,
                               sourceString: emailItem!.text,
                                isEmail: true,
                              ),
                            ),
                            // Expanded(
                            //   child: Text(,
                            //     style: styleElements.bodyText2ThemeScalable(context),
                            //     maxLines: widget.isDetailPage?null:2,
                            //     overflow: widget.isDetailPage?null:TextOverflow.ellipsis,
                            //   ),
                            // )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          EmailCardFooter()
        ],
      ),
    );
  }
}

class EmailSideMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 4),
      decoration: BoxDecoration(
        color: HexColor(AppColors.appColorWhite),
        boxShadow: [
          CommonComponents().getShadowforBoxSideCard()
        ],
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(12),
            bottomRight: Radius.circular(12)),
      ),
      child: Column(
        children: [
          Visibility(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.0),
              child: IconButton(
                icon: Icon(
                  Icons.play_circle_outline_rounded,
                  color: HexColor(AppColors.appColorBlack35),
                ),
                onPressed: () {},
              ),
            ),
          ),
          Visibility(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.0),
              child: IconButton(
                icon: Icon(
                  Icons.g_translate_rounded,
                  color: HexColor(AppColors.appColorBlack35),
                ),
                onPressed: () {},
              ),
            ),
          ),
          Visibility(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.0),
              child: IconButton(
                icon: Icon(
                  Icons.search,
                  color: HexColor(AppColors.appColorBlack35),
                ),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
