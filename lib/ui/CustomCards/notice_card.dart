import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/tricycleHtmlViewer.dart';
import 'package:oho_works_app/enums/post_enums.dart';
import 'package:oho_works_app/models/base_res.dart';
import 'package:oho_works_app/models/post/postlist.dart';
import 'package:oho_works_app/ui/postModule/selectedPostListPage.dart';
import 'package:oho_works_app/ui/postModule/two_way_scroll_posts.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:html/parser.dart';

import '../postcardDetail.dart';

// ignore: must_be_immutable
class NoticeCards extends StatelessWidget {
  final CommonCardData data;

  String? type;
  String? instituteName;
  String? instituteAddress;
  String? userName;
  BuildContext? context;
  List<Data> list = [];
  TextStyleElements? styleElements;
  String? institutionId;
  Null Function()? callbackPicker;
  int? id;
  VoidCallback? onSeeMoreClicked;
  List<Data>? listSubItems = [];

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

  NoticeCards(
      {Key? key,
        required this.data,
        this.callbackPicker,
        this.styleElements,
        this.type,
        this.id,
        this.userName,
        this.institutionId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    this.context = context;
    styleElements = TextStyleElements(context);
    listSubItems = data.data;
    if (listSubItems!.length <= 1) {
      listSubItems!.add(Data(
          postContent: PostContent(
              specifications: Specifications(color: "#F8D7DA"),
              content: Content(
                  contentMeta: ContentMeta(title: "-", meta: "no more data")))));
    }
    return listSubItems!.isNotEmpty
        ? Container(
        child: Column(
          children: <Widget>[
            Visibility(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            padding: const EdgeInsets.only(
                                left: 16, right: 16, top: 12, bottom: 12),
                            child: Text(
                              type == "QuestionCard"
                                  ? AppLocalizations.of(context)!
                                  .translate("ask_expert")
                                  : AppLocalizations.of(context)!
                                  .translate("notice_board"),
                              style: styleElements!
                                  .headline6ThemeScalable(context)
                                  .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: HexColor(AppColors.appColorBlack85)),
                              textAlign: TextAlign.left,
                            ),
                          )),
                      flex: 3,
                    ),
                    Visibility(
                        child: Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () async {
                                if (type == "QuestionCard")
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => SelectedFeedListPage(
                                        isFromProfile: false,
                                        appBarTitle: AppLocalizations.of(context)!
                                            .translate('ask_expert'),
                                        postType: POST_TYPE.QNA.status,
                                      )));
                                else
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => SelectedFeedListPage(
                                        isFromProfile: false,
                                        appBarTitle: AppLocalizations.of(context)!
                                            .translate('notice_board'),
                                        postRecipientStatus:
                                        POST_RECIPIENT_STATUS.UNREAD.status,
                                        postType: POST_TYPE.NOTICE.status,
                                      )));
                              },
                              child: Container(
                                margin: const EdgeInsets.only(
                                    right: 16, bottom: 16, top: 16),
                                child: Visibility(
                                  /*visible: data.isShowMore ??= false,*/
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: Text(AppLocalizations.of(context)!.translate('see_more'),
                                      style: styleElements!
                                          .subtitle2ThemeScalable(context)
                                          .copyWith(
                                          color: HexColor(AppColors.orangeText)),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              )),
                        ))
                  ],
                )),
            Container(
              height: type == "QuestionCard" ? 180 : 250,
              child: ListView.builder(
                  padding: const EdgeInsets.all(0.0),
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: listSubItems!.length,
                  scrollDirection: Axis.horizontal,
                  dragStartBehavior: DragStartBehavior.start,
                  itemExtent: 0.5.sw,
                  itemBuilder: (context, index) {
                    return TricycleListCard(
                      color: type == "QuestionCard"
                          ? HexColor(AppColors.appColorWhite)
                          : HexColor(listSubItems![index]
                          .postContent!
                          .specifications!
                          .color ??
                          "#F8D7DA"),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) {
                            if(listSubItems![index].postType =='lesson' ) {
                          return NewNewsAndArticleDetailPage(postId: listSubItems![index].postId,);
                            }else{
                            return PostCardDetailPage(postId: listSubItems![index].postId,);
                            }
                        }));
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            child: Padding(
                              padding:
                              const EdgeInsets.only(left: 8.0, top: 8),
                              child: Text(
                                listSubItems![index]
                                    .postContent!
                                    .content!
                                    .contentMeta!
                                    .title
                                    .toString(),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: styleElements!
                                    .subtitle1ThemeScalable(context)
                                    .copyWith(
                                    color: HexColor(AppColors.appColorBlack85),
                                    fontWeight: FontWeight.w700),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          type == "QuestionCard"
                              ? Flexible(
                                child: Container(
                                padding:EdgeInsets.only(top: 4,bottom: 4,left: 8,right: 4),
                                child:Text(
                                  _parseHtmlString(listSubItems![index] != null &&
                                      listSubItems![index].postContent !=
                                          null &&
                                      listSubItems![index]
                                          .postContent!
                                          .content!
                                          .contentMeta !=
                                          null &&
                                      listSubItems![index]
                                          .postContent!
                                          .content!
                                          .contentMeta!
                                          .meta !=
                                          null
                                      ? listSubItems![index]
                                      .postContent!
                                      .content!
                                      .contentMeta!
                                      .meta
                                      : "")
                                  ,
                                  maxLines: 2,
                                  overflow: TextOverflow.fade,
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                )),
                              )
                              : Flexible(
                                child: Container(
                            child: TricycleHtmlViewer(
                                isDetailPage: false,
                                isNewsPage: false,
                                isNoticeCard: true,
                                sourceString: (listSubItems![index].postContent !=
                                        null &&
                                    listSubItems![index]
                                        .postContent!
                                        .content!
                                        .contentMeta !=
                                        null &&
                                    listSubItems![index]
                                        .postContent!
                                        .content!
                                        .contentMeta!
                                        .meta !=
                                        null)
                                    ? listSubItems![index]
                                    .postContent!
                                    .content!
                                    .contentMeta!
                                    .meta
                                    : "",
                            ),
                          ),
                              )
                        ],
                      ),
                    );
                  }),
            ),
          ],
        ))
        : Container();
  }

  String _parseHtmlString(String? htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body!.text).documentElement!.text;
    return parsedString;
  }

  String getData(String meta, bool isDetailPage) {
    if (meta != null) {
      if (!isDetailPage) {
        if (meta.length > 120) {
          return meta.substring(0, 120) + '......';
        } else {
          return meta;
        }
      } else {
        return meta;
      }
    } else {
      return '';
    }
  }
}
