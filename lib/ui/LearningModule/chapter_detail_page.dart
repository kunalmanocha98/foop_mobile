import 'package:oho_works_app/components/postcardactionbuttons.dart';
import 'package:oho_works_app/components/postcardheader.dart';
import 'package:oho_works_app/components/postcardmedia.dart';
import 'package:oho_works_app/components/tricycle_buttons.dart';
import 'package:oho_works_app/components/tricycle_user_images_list.dart';
import 'package:oho_works_app/e_learning_module/ui/lessons_page.dart';
import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/models/post/postcreate.dart';
import 'package:oho_works_app/models/post/postlist.dart';
import 'package:oho_works_app/profile_module/pages/profile_page.dart';
import 'package:oho_works_app/ui/CalenderModule/create_event_page.dart';
import 'package:oho_works_app/ui/RoomModule/rooms_listing.dart';
import 'package:oho_works_app/ui/dialogs/dialog_audio_post.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChapterDetailPage extends StatefulWidget {
  final   PostListItem item;

  const ChapterDetailPage({Key key, this.item}) : super(key: key);
  @override
  ChapterDetailPageState createState() => ChapterDetailPageState();
}

class ChapterDetailPageState extends State<ChapterDetailPage> {
  SharedPreferences prefs = locator<SharedPreferences>();
  TextStyleElements styleElements;
  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding:  EdgeInsets.only(top:8.0,bottom:8.0),
                child: PostCardHeader(
                  key: UniqueKey(),
                  prefs: prefs,
                  postListItem: widget.item,
                  isLesson:true,
                  onFollowCallback:null,
                  isBackButtonVisible: false,
                  onBackPressed: null,
                  hidePostCallback: null,
                  deletePostCallback: null,
                  isFollowing: getIsFollowing(),
                  isDarkTheme: false,
                  editCallback: null,
                ),
              ),
              PostCardMedia(
                isLearningPage:false,
                postType:'general',
                isFilterPage:false,
                fullPage: false,
                pagePosition: 0,
                isNewsPage: true,
                onlyHorizontalList: false,
                onPositionChange: (p) {

                },
                isFullImageUrl: true,
                mediaList: List<Media>.generate(5,(int index){
                  return Media(
                    mediaType: 'image',
                    mediaUrl: "https://i.pinimg.com/564x/2f/67/16/2f6716cf33aff2bec88296e8d213011b.jpg"
                  );
                }),

              ),
              Padding(
                padding:  EdgeInsets.only(top:8.0),
                child: Text(widget.item.chapterItem!=null ?widget.item.chapterItem.chapterName:"",
                style: styleElements.headline6ThemeScalable(context).
                  copyWith(color: HexColor(AppColors.appColorBlack85,),
                fontWeight: FontWeight.bold),),
              ),
              Padding(
                padding:  EdgeInsets.only(top:8.0,left:8,right:8,bottom: 4),
                child: Text(widget.item.lessonListItem!=null?widget.item.lessonListItem.lessonName:"",
                style: styleElements.subtitle1ThemeScalable(context).
                  copyWith(fontWeight: FontWeight.bold),),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${4.0} ',
                    style: styleElements
                        .subtitle1ThemeScalable(context)
                        .copyWith(
                        color: HexColor(AppColors.appMainColor),
                        fontWeight: FontWeight.bold),
                  ),
                  Visibility(
                    visible: true,
                    child: RatingBar(
                      initialRating: 4.0,
                      ignoreGestures: true,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemSize: 15.0,
                      itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                      ratingWidget: RatingWidget(
                        empty: Icon(
                          Icons.star_outline,
                          color: HexColor(AppColors.appMainColor),
                        ),
                        half: Icon(
                          Icons.star_half_outlined,
                          color: HexColor(AppColors.appMainColor),
                        ),
                        full: Icon(
                          Icons.star_outlined,
                          color: HexColor(AppColors.appMainColor),
                        ),
                      ),
                      onRatingUpdate: (rating) {
                        print(rating);
                      },
                    ),
                  ),
                  Visibility(
                    visible: true,
                    child: Padding(
                      padding: EdgeInsets.only(left: 8, right: 8),
                      child: Container(
                        width: 1,
                        height: 16,
                        color: HexColor(AppColors.appColorBlack35),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: true,
                    child: Padding(
                      padding: EdgeInsets.only(top: 4, left: 2),
                      child: Container(
                        child: RoomButtons(context: context).moderatorImage,
                      ),
                    ),
                  )
                ],
              ),
              Text(widget.item.lessonTopic!=null?widget.item.lessonTopic.topic.topicName:"",
              style:styleElements.bodyText2ThemeScalable(context)),
              Text(widget.item.classesList!=null && widget.item.classesList.isNotEmpty ?widget.item.classesList[0].className:"",
              style: styleElements.bodyText2ThemeScalable(context),),
              Container(
                margin: EdgeInsets.only(top:12,bottom: 12,left: 12,right: 12),
                height: 1,
                width: double.infinity,
                color: HexColor(AppColors.appColorBlack35),
              ),
              Padding(
                padding:  EdgeInsets.only(left:12.0,right:12),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('EN',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: styleElements.subtitle1ThemeScalable(context).copyWith(
                                fontWeight: FontWeight.bold
                            ),),
                          SizedBox(height: 4,),
                          Text('Language',
                          style: styleElements.captionThemeScalable(context),)
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('CBSE',
                            overflow: TextOverflow.ellipsis,
                            style: styleElements.subtitle1ThemeScalable(context).copyWith(
                                fontWeight: FontWeight.bold
                            ),),
                          SizedBox(height: 4,),
                          Text('Board',
                            style: styleElements.captionThemeScalable(context),)
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('BTECH',
                            overflow: TextOverflow.ellipsis,
                            style: styleElements.subtitle1ThemeScalable(context).copyWith(
                                fontWeight: FontWeight.bold
                            ),),
                          SizedBox(height: 4,),
                          Text('Program',
                            style: styleElements.captionThemeScalable(context),)
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('1Year',
                            overflow: TextOverflow.ellipsis,
                            style: styleElements.subtitle1ThemeScalable(context).copyWith(
                                fontWeight: FontWeight.bold
                            ),),
                          SizedBox(height: 4,),
                          Text('Class',
                            style: styleElements.captionThemeScalable(context),)
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Quantum Physics',
                            overflow: TextOverflow.ellipsis,
                            style: styleElements.subtitle1ThemeScalable(context).copyWith(
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          SizedBox(height: 4,),
                          Text('Subject',
                            style: styleElements.captionThemeScalable(context),)
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: 1,
                margin: EdgeInsets.only(top:12,bottom: 12,left: 12,right: 12),
                width: double.infinity,
                color: HexColor(AppColors.appColorBlack35),
              ),
              Padding(
                padding: EdgeInsets.only(top:8),
                child: TricycleUserImageList(
                  listOfImages: List<String>.generate(8,(int index){
                    return prefs.getString(Strings.profileImage);
                  }),
                ),
              ),
              Text('4 Lessons',
              style: styleElements.headline6ThemeScalable(context),),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Far far away, behind the word mountains, far from the countries Vokalia and Consonantia, there live the blind texts. Separated they live in',
                maxLines: 3,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: styleElements.bodyText2ThemeScalable(context),),
              )
            ],
          ),
        ),
        bottomNavigationBar: Container(
          height:100,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PostCardActionButtons(),
              Row(
                children: [
                  SizedBox(width: 24,),
                  TricycleTextButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(
                            builder: (BuildContext context) {
                              return UserProfileCards(
                                userType: 'person',
                                userId:prefs.getInt(Strings.userId),
                                callback: () {},
                                currentPosition: 2,
                                type: 'learning',
                              );
                            },
                        ),
                        );
                      },
                      child: Text("More from author",
                      style: styleElements.captionThemeScalable(context).
                        copyWith(
                        color: HexColor(AppColors.appMainColor)
                      ),)
                  ),
                  Spacer(),
                  TricycleTextButton(
                      onPressed: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                              return CreateLessonsPage(
                                chapterId: widget.item.chapterItem.id,
                                chapterName: widget.item.chapterItem.chapterName,
                                isEdit:false,
                                createLessonData: PostCreatePayload(
                                    postId:widget.item.postId ,
                                    id:widget.item.postId,
                                    postStatus: "posted",
                                    contentMeta:ContentMetaCreate(),
                                    chapterItem: widget.item.chapterItem,
                                    lessonTopic: widget.item.lessonTopic,
                                    lessonListItem: widget.item.lessonListItem,
                                    affiliatedList: widget.item.affiliatedList,
                                    classesList: widget.item.classesList,
                                    disciplineList: widget.item.disciplineList,
                                    learnerItem: widget.item.learnerItem,
                                    programmesList: widget.item.programmesList,
                                    subjectsList: widget.item.subjectsList),
                              );
                            }));
                      },
                      color: HexColor(AppColors.appMainColor),
                      child: Text("Learn",
                        style: styleElements.captionThemeScalable(context).
                        copyWith(
                            color: HexColor(AppColors.appColorWhite)
                        ),)
                  ),
                  SizedBox(width: 24,),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  bool getIsFollowing() {
    bool isFollowed;
    for (var i in widget.item.postContent.header.action) {
      if (i.type == 'is_followed') {
        isFollowed = i.value;
        break;
      }
    }
    return isFollowed ??= false;
  }
  void onTalkCallback(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AudioPostDialog(
              title: widget.item.postContent.content.contentMeta.title,
              okCallback: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                      return CreateEventPage(
                        type: 'talk',
                        standardEventId: 5,
                        title: widget.item
                            .postContent
                            .content
                            .contentMeta
                            .title,
                      );
                    }));
              },
              cancelCallback: () {});
        });
  }

  void removeFromList(int index) {
    setState(() {
      print("remove");
      // lessonsList.removeAt(index);
      // totalItems = totalItems - 1;
    });
  }


}
