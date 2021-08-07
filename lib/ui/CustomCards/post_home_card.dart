import 'package:oho_works_app/components/postcard.dart';
import 'package:oho_works_app/enums/create_deeplink.dart';
import 'package:oho_works_app/enums/share_item_type.dart';
import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/ui/postModule/two_way_scroll_posts.dart';
import 'package:oho_works_app/models/base_res.dart';
import 'package:oho_works_app/models/post/postlist.dart';
import 'package:oho_works_app/services/get_deeplink_url_service.dart';
import 'package:oho_works_app/ui/CalenderModule/create_event_page.dart';
import 'package:oho_works_app/ui/dialogs/dialog_audio_post.dart';
import 'package:oho_works_app/ui/postcardDetail.dart';
import 'package:oho_works_app/ui/postcreatepage.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostHomeCard extends StatelessWidget {
  final CommonCardData data;
  final Null Function()? callbackPicker;

  PostHomeCard({required this.data, this.callbackPicker});

  @override
  Widget build(BuildContext context) {
    return PostCard(
      data: data,
      callbackPicker: callbackPicker,
    );
  }
}

class PostCard extends StatefulWidget {
  final CommonCardData data;
  final Null Function()? callbackPicker;

  PostCard({Key? key, required this.data, this.callbackPicker})
      : super(key: key);

  @override
  _PostHomeCard createState() => _PostHomeCard(data);
}

class _PostHomeCard extends State<PostCard> {
  TextStyleElements? styleElements;
  List<PostListItem> postList = [];
  SharedPreferences? prefs = locator<SharedPreferences>();
  final CreateDeeplink? createDeeplink = locator<CreateDeeplink>();

  _PostHomeCard(CommonCardData data) {
    for (Data data in data.data!) {
      postList.add(PostListItem.fromJson(data.toJson()));
    }
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return Container(
      margin: EdgeInsets.only(top: 4),
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: postList.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    if(postList[index].postType =='lesson' ) {
                      return NewNewsAndArticleDetailPage(postData: postList[index]);
                    }else{
                      return PostCardDetailPage(postData: postList[index],);
                    }
                  }
              ));
            },
            child: appPostCard(
                key: UniqueKey(),
                preferences: prefs,
                cardData: postList[index],
                isFilterPage: false,
                isDetailPage: false,
                download: () {
                  Navigator.pop(context);
                },
                sharecallBack: () async {
                  SharedPreferences prefs =
                  await SharedPreferences.getInstance();
                  createDeeplink!.getDeeplink(
                      SHAREITEMTYPE.DETAIL.type,
                      prefs.getInt("userId").toString(),
                      postList[index].postId,
                      DEEPLINKTYPE.POST.type,
                      context);
                },
                ratingCallback: () {
                  for (var i in postList[index].postContent!.header!.action!) {
                    if (i.type == 'is_rated') {
                      i.value = true;
                    }
                  }
                },
                bookmarkCallback: (isBookmarked) {
                  postList[index].isBookmarked = isBookmarked;
                },
                commentCallback: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        if(postList[index].postType =='lesson' ) {
                          return NewNewsAndArticleDetailPage(postData: postList[index]);
                        }else{
                          return PostCardDetailPage(postData: postList[index],);
                        }
                      }
                      ));
                },
                onFollowCallback: (isFollow) {
                  setState(() {
                    print("follow");
                    var desiredList = postList.where((element) {
                      return element.postOwnerTypeId ==
                          postList[index].postOwnerTypeId;
                    });
                    for (var i in desiredList) {
                      for (var j in i.postContent!.header!.action!) {
                        if (j.type == 'is_followed') {
                          j.value = isFollow;
                        }
                      }
                    }
                  });
                },
                hidePostCallback: () {},
                deletePostCallback: () {},
                onTalkCallback: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AudioPostDialog(
                            title: postList[index]
                                .postContent!
                                .content!
                                .contentMeta!
                                .title,
                            okCallback: () {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return CreateEventPage(
                                      type: 'talk',
                                      standardEventId: 5,
                                      title: postList[index]
                                          .postContent!
                                          .content!
                                          .contentMeta!
                                          .title,
                                    );
                                  }));
                            },
                            cancelCallback: () {});
                      });
                },
                onSubmitAnswer: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PostCreatePage(
                        type: 'submit_assign',
                        question: postList[index]
                            .postContent!
                            .content!
                            .contentMeta!
                            .title,
                        postId: postList[index].postId,
                        prefs: prefs,
                      ))).then((value){
                        if(value!=null){
                          if(value){
                            setState(() {
                              postList[index].isVoted = true;
                            });
                          }
                        }
                  });
                },
                onAnswerClickCallback: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PostCreatePage(
                        type: 'answer',
                        question: postList[index]
                            .postContent!
                            .content!
                            .contentMeta!
                            .title,
                        postId: postList[index].postId,
                        prefs: prefs,
                      )));
                },
                onVoteCallback: () {
                  postList[index].isVoted = true;
                }),
          );
        },
      ),
    );
  }
}
