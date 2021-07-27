import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/enums/post_enums.dart';
import 'package:oho_works_app/enums/resolutionenums.dart';
import 'package:oho_works_app/enums/serviceTypeEnums.dart';
import 'package:oho_works_app/models/base_res.dart';
import 'package:oho_works_app/ui/postModule/CampusNewsListPage.dart';
import 'package:oho_works_app/ui/postModule/selectedPostListPage.dart';
import 'package:oho_works_app/ui/postModule/two_way_scroll_posts.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/utility_class.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable


import '../postcardDetail.dart';

// ignore: must_be_immutable
class NewsCard extends StatelessWidget {
  final CommonCardData data;
  late BuildContext context;
  List<Data>? listSubItems = [];
  late TextStyleElements styleElements;
  bool? isProfile;
  String? instituteId;
  Null Function()? callbackPicker;
  int? id;
  String? personType;
  String? type;

  Size displaySize(BuildContext context) {
    debugPrint('Size = ' + MediaQuery
        .of(context)
        .size
        .toString());
    return MediaQuery
        .of(context)
        .size;
  }

  double displayHeight(BuildContext context) {
    debugPrint('Height = ' + displaySize(context).height.toString());
    return displaySize(context).height;
  }

  double displayWidth(BuildContext context) {
    debugPrint('Width = ' + displaySize(context).width.toString());
    return displaySize(context).width;
  }

  NewsCard({
    Key? key,
    required this.data,
    this.instituteId,
    this.isProfile,
    this.id,
    this.personType,
    this.callbackPicker,
    this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    this.context = context;
    styleElements = TextStyleElements(context);
    listSubItems = data.data;
    return Column(
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
                          getTitle(),
                          style: styleElements
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
                          onTap: () async {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) {
                                  if(type=='blog') {
                                    return SelectedFeedListPage(
                                      isFromProfile: false,
                                      appBarTitle: getTitle(),
                                      postRecipientStatus:
                                      POST_RECIPIENT_STATUS.UNREAD.status,
                                      postType: type == 'blog' ? POST_TYPE.BLOG
                                          .status : POST_TYPE.NEWS.status,);
                                  }else{
                                    return CampusNewsListPage();
                                  }
                                }));
                          },
                          child: Container(
                            margin:
                            const EdgeInsets.only(
                                right: 16, bottom: 16, top: 16),
                            child: Visibility(
                              /*visible: data.isShowMore ??= false,*/
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: Text(AppLocalizations.of(context)!
                                    .translate('see_more'),
                                  style: styleElements
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
        appListCard(
          child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.only(bottom: 16.0),
              physics: NeverScrollableScrollPhysics(),
              itemCount: listSubItems!.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) {
                            if (data.data![index].postType == 'lesson' ) {
                              return NewNewsAndArticleDetailPage(
                                postId: data.data![index].postId,);
                            } else {
                              return PostCardDetailPage(
                                postId: data.data![index].postId,);
                            }
                          }
                          )
                      );
                    },
                    child: Padding(
                        padding: EdgeInsets.only(
                            left: 8.0.h, right: 16.0.h, top: 8.0.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            (type == 'blog') ?
                            Container(
                              width: 68,
                              height: 68,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: ((data.data![index].postContent!
                                          .content!.media!.isNotEmpty &&
                                          data.data![index].postContent!.content!
                                              .media![0].mediaType ==
                                              "image")
                                          ? CachedNetworkImageProvider(
                                        Utility().getUrlForImage(
                                            data.data![index].postContent!.content!
                                                .media![0].mediaUrl,
                                            RESOLUTION_TYPE.R64,
                                            SERVICE_TYPE.POST),
                                      )
                                          : AssetImage(
                                          'assets/appimages/image_place.png')) as ImageProvider<Object>
                                  )
                              ),
                            ) : Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(
                                    left: 12, right: 12),
                                child: Align(
                                    alignment: Alignment.topLeft,
                                    child:
                                    Text(data.data![index].postContent!.content!
                                        .contentMeta!.title ??
                                        "",
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: styleElements
                                            .bodyText1ThemeScalable(
                                            context)
                                            .copyWith(
                                            color: Colors
                                                .black87,
                                            fontWeight: FontWeight.bold)

                                    )) /*Html(
                                data: getData(
                                    data.data[index].postContent.content
                                            .contentMeta.meta ??
                                        "",
                                    false),
                                style: {
                                  "body": Style(
                                    fontSize: FontSize(20.0),
                                  ),
                                },
                              )*/,
                              ),
                            ),
                            (type == 'blog') ?
                            Flexible(
                              child: Container(
                                margin: const EdgeInsets.only(
                                    left: 12, right: 12),
                                child: Align(
                                    alignment: Alignment.topLeft,
                                    child:
                                    Text(data.data![index].postContent!.content!
                                        .contentMeta!.title ??
                                        "",
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: styleElements
                                            .bodyText1ThemeScalable(
                                            context)
                                            .copyWith(
                                            color: Colors
                                                .black87,
                                            fontWeight: FontWeight.bold)

                                    )) /*Html(
                                data: getData(
                                    data.data[index].postContent.content
                                            .contentMeta.meta ??
                                        "",
                                    false),
                                style: {
                                  "body": Style(
                                    fontSize: FontSize(20.0),
                                  ),
                                },
                              )*/,
                              ),
                            ) : Container(
                              width: 68,
                              height: 68,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: ((data.data![index].postContent!
                                          .content!.media!.isNotEmpty &&
                                          data.data![index].postContent!.content!
                                              .media![0].mediaType ==
                                              "image")
                                          ? CachedNetworkImageProvider(
                                        Utility().getUrlForImage(
                                            data.data![index].postContent!.content!
                                                .media![0].mediaUrl,
                                            RESOLUTION_TYPE.R64,
                                            SERVICE_TYPE.POST),
                                      )
                                          : AssetImage(
                                          'assets/appimages/image_place.png')) as ImageProvider<Object>
                                  )
                              ),
                            ),

                          ],
                        )));
              }),
        ),

      ],
    );
  }

  String getTitle() {
    if (type == 'news') {
      return AppLocalizations.of(context)!.translate('news');
    } else {
      return AppLocalizations.of(context)!.translate('article');
    }
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
