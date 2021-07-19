import 'dart:convert';

import 'package:GlobalUploadFilePkg/Enums/contexttype.dart';
import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/tricycleavatar.dart';
import 'package:oho_works_app/enums/post_enums.dart';
import 'package:oho_works_app/enums/resolutionenums.dart';
import 'package:oho_works_app/enums/serviceTypeEnums.dart';
import 'package:oho_works_app/models/post/postcreate.dart';
import 'package:oho_works_app/models/post/postlist.dart';
import 'package:oho_works_app/models/post/updaterecipientlist.dart';
import 'package:oho_works_app/profile_module/pages/profile_page.dart';
import 'package:oho_works_app/ui/dialogs/delete_confirmation_dilog.dart';
import 'package:oho_works_app/ui/report_abuse.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/follow_unfollow_block_remove_unblock_button.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class PostCardHeader extends StatefulWidget {
  PostListItem postListItem;
  Function(bool) onFollowCallback;
  SharedPreferences prefs;
  Function hidePostCallback;
  Function deletePostCallback;
  bool isDarkTheme;
  bool isFollowing;
  Function onBackPressed;
  bool isBackButtonVisible;
  bool isNewsPage;
  Function topicsPageCallback;
  Color color;
  bool isLesson;
  Function editCallback;


  PostCardHeader(
      {Key key,
        @required this.postListItem,
        this.prefs,
        this.onFollowCallback,
        this.hidePostCallback,
        this.deletePostCallback,
        this.isDarkTheme,
        this.isBackButtonVisible,
        this.onBackPressed,
        this.isNewsPage,
        this.topicsPageCallback,
        this.color,
        this.isLesson = false,
        this.editCallback,
        this.isFollowing})
      : super(key: key);

  @override
  PostCardHeaderState createState() => PostCardHeaderState(
      postListItem: postListItem,
      prefs: prefs,
      onFollowCallback: onFollowCallback,
      hidePostCallback: hidePostCallback,
      deletePostCallback: deletePostCallback,
      isDarkTheme: isDarkTheme,
      isBackButtonVisible: isBackButtonVisible,
      onBackPressed: onBackPressed,
      isNewsPage:isNewsPage,
      topicsPageCallback:topicsPageCallback,
      isFollowing: isFollowing);
}

class PostCardHeaderState extends State<PostCardHeader> {
  Header headerData;
  PostListItem postListItem;
  SharedPreferences prefs;
  Function(bool) onFollowCallback;
  Function hidePostCallback;
  Function deletePostCallback;
  bool isDarkTheme;
  Function onBackPressed;
  bool isBackButtonVisible;
  bool isFollowing;
  bool isNewsPage;
  Function topicsPageCallback;

  PostCardHeaderState(
      {@required this.postListItem,
        this.prefs,
        this.onFollowCallback,
        this.hidePostCallback,
        this.deletePostCallback,
        this.isDarkTheme,
        this.isBackButtonVisible,
        this.onBackPressed,
        this.isNewsPage,
        this.topicsPageCallback,
        this.isFollowing}) {
    this.headerData =
    postListItem != null ? postListItem.postContent.header : Header();
    isDarkTheme ??= false;
  }
  void clear() {
    setState(() {
      postListItem = null;
      headerData= null;
    });
  }

  void update(
      {PostListItem postListItem,
        SharedPreferences prefs,
        Function(bool) onFollowCallback,
        Function hidePostCallback,
        Function deletePostCallback,
        bool isDarkTheme,
        bool isBackButtonVisible,
        Function onBackPressed,
        bool isFollowing,
        bool isNewsPage,
        Function topicsPageCallback}) {
    setState(() {
    this.postListItem = postListItem ?? this.postListItem;
    this.prefs = prefs?? this.prefs;
    this.onFollowCallback = onFollowCallback ?? this.onFollowCallback;
    this.hidePostCallback = hidePostCallback ?? this.hidePostCallback;
    this.deletePostCallback = deletePostCallback ?? this.deletePostCallback;
    this.isDarkTheme = isDarkTheme ?? this.isDarkTheme;
    this.isBackButtonVisible = isBackButtonVisible ?? this.isBackButtonVisible;
    this.onBackPressed = onBackPressed ?? this.onBackPressed;
    this.isFollowing = isFollowing ?? this.isFollowing;
    this.headerData =   postListItem != null ? postListItem.postContent.header : this.headerData;
    this.isNewsPage = isNewsPage ?? this.isNewsPage;
    this.topicsPageCallback = topicsPageCallback ?? this.topicsPageCallback;

    });
  }

  TextStyleElements styleElements;

  Widget _simplePopup() {
    // var name = headerData.title;
    return PopupMenuButton<String>(
      padding: EdgeInsets.only(right: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      itemBuilder: (context) => getItems(headerData.title),
      onSelected: (value) {
        switch (value) {
          case 'delete':
            {


              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return DeleteConfirmationDilog(
                      showCancelButton: true,
                      // note: model.androidNotes,
                      note: AppLocalizations.of(context).translate("delete_confirmation"),
                      cancelButton: () {
                       Navigator.pop(context);
                      },
                      updateButton: () {
                        deletepost();
                      },
                    );
                  });

              break;
            }
          case 'edit':
            {
              widget.editCallback();
              break;
            }
          case 'hide':
            {
              hidepost();
              break;
            }
          case 'unfollow':
            {
              unfollowAction();
              break;
            }
          case 'block':
            {
              blockAction();
              break;
            }
          case 'topic':{
            topicsPageCallback();
            break;
          }
          case 'report':
            {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ReportAbuse(
                    contextId: postListItem.postId,
                    contextType: CONTEXTTYPE_ENUM.FEED.type,
                  )));
              break;
            }
        }
      },
      icon: Icon(
        Icons.more_vert,
        color: isDarkTheme ? HexColor(AppColors.appColorWhite) : HexColor(AppColors.appColorBlack65),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    print("refreshing post card header");
    return Container(
      color: widget.color,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Visibility(
            visible: isBackButtonVisible ??= false,
            child: IconButton(
              onPressed: onBackPressed,
              icon: isDarkTheme
                  ? Icon(
                Icons.keyboard_backspace_rounded,
                size: 20,
                color: HexColor(AppColors.appColorWhite),
                // add custom icons also
              )
                  : Icon(
                Icons.keyboard_backspace_rounded,
                size: 20,
                // add custom icons also
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: TricycleAvatar(
              key: UniqueKey(),
              resolution_type: RESOLUTION_TYPE.R64,
              service_type: SERVICE_TYPE.PERSON,
              imageUrl: headerData!=null?headerData.avatar:"",
              size: 48,
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                int ownerId = prefs!=null?prefs.getInt(Strings.userId):0;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserProfileCards(
                          userType: postListItem!=null?postListItem.postOwnerTypeId == ownerId
                              ? "person"
                              : postListItem.postOwnerType == "person"
                              ? "thirdPerson"
                              : "institution":"",
                          userId: postListItem!=null?postListItem.postOwnerTypeId != ownerId
                              ? postListItem.postOwnerTypeId
                              : null:null,
                          callback: () {},
                          currentPosition: 1,
                          type: null,
                        )));
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            headerData!=null?headerData.title ??= "":"",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: styleElements
                                .subtitle1ThemeScalable(context)
                                .copyWith(
                                color: isDarkTheme
                                    ? HexColor(AppColors.appColorWhite)
                                    : HexColor(AppColors.appColorBlack85)),
                          ),
                        ),
                        Visibility(
                          visible: postListItem!=null?postListItem.postContent.header.isVerified ??
                              false:false,
                          child: Padding(
                            padding: const EdgeInsets.only(top:4.0,left:8,right:8),
                            child: SizedBox(
                              height: 16,
                              width: 16,
                              child: Container(
                                child: Image(
                                  image:
                                  AssetImage('assets/appimages/check.png'),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Text(
                      headerData!=null?headerData.subtitle1 ??= "":"",
                      style: styleElements
                          .captionThemeScalable(context)
                          .copyWith(
                          color: (isDarkTheme ??= false)
                              ? HexColor(AppColors.appColorWhite)
                              : HexColor(AppColors.appColorBlack35)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              ),
            ),
          ),
          Visibility(
            visible: postListItem!=null? (postListItem.postOwnerTypeId != (prefs!=null?prefs.get(Strings.userId):0) && !(isFollowing ??= false)):false,
            child: GenericFollowUnfollowButton(
              actionByObjectType: "person",
              actionByObjectId: prefs!=null?prefs.getInt(Strings.userId):0,
              actionOnObjectType: postListItem!=null?postListItem.postOwnerType:"",
              actionOnObjectId: postListItem!=null?postListItem.postOwnerTypeId:0,
              engageFlag: "Follow",
              actionFlag: "F",
              isRoundedButton: false,
              actionDetails: [""],
              personName: prefs!=null?prefs.getString(Strings.userName):"",
              clicked: () {
                setState(() {
                  isFollowing = true;
                  onFollowCallback(true);
                });
              },
              callback: (isCallSuccess) {},
            ),
          ),
          // TricycleTextButton(onPressed: (){},
          //     shape: RoundedRectangleBorder(side: BorderSide(color: HexColor(AppColors.appColorWhite))),
          //     child: Text('Action',style: styleElements.captionThemeScalable(context).copyWith(color:HexColor(AppColors.appMainColor)),)),
          Visibility(
            visible: true,
            child: _simplePopup(),
            // (headerData.action!=null && headerData.action.length>0),
            // child:prefs.getInt(Strings.id)==postListItem.postOwnerTypeId?  _simplePopup() :_simplePopup2()
          ),
        ],
      ),
    );
  }

  void unfollowAction() async {
    GenericFollowUnfollowButtonState().followUnfollowBlock(
        "person",
        prefs.getInt(Strings.userId),
        postListItem.postOwnerType,
        postListItem.postOwnerTypeId,
        "U",
        [""],
            (isSuccess) {},
        context);
    setState(() {
      isFollowing = false;
      onFollowCallback(false);
    });
  }

  void blockAction() async {
    GenericFollowUnfollowButtonState().followUnfollowBlock(
        "person",
        prefs.getInt(Strings.userId),
        postListItem.postOwnerType,
        postListItem.postOwnerTypeId,
        "B",
        [""], (isSuccess) {
      if (isSuccess) {}
    }, context);
  }

  void hidepost() {
    PostRecipientUpdatePayload payload = PostRecipientUpdatePayload();
    payload.postId = postListItem.postId;
    payload.postRecipientStatus = POST_RECIPIENT_STATUS.HIDDEN.status;
    payload.isBookmarked = false;
    var body = jsonEncode(payload);
    Calls().call(body, context, Config.UPDATE_RECIPIENT_LIST).then((value) {
      PostCreateResponse res = PostCreateResponse.fromJson(value);
      if (res.statusCode == Strings.success_code) {
        hidePostCallback();
   /*     ToastBuilder()
            .showToast(res.message, context, HexColor(AppColors.information));*/
      } else {
        ToastBuilder()
            .showToast(res.message, context, HexColor(AppColors.information));
      }
    }).catchError((onError) {
      print(onError);
    });
    // payload.postKeywords = postListItem.postContent.extra;
  }

  void deletepost() {
    PostCreatePayload payload = PostCreatePayload();
    payload.postId = postListItem.postId;
    payload.id = postListItem.postId;
    payload.postOwnerType = postListItem.postOwnerType;
    payload.postOwnerTypeId= postListItem.postOwnerTypeId;
    payload.postStatus = 'deleted';
    payload.postCreatedById=postListItem.postOwnerTypeId;
    payload.postType = postListItem.postType;
    payload.postCategory="normal";
    payload.postRecipientDetails=[];
    payload.postRecipientType=[];
    var body = jsonEncode(payload);
    Calls().call(body, context, Config.UPDATE_POST).then((value) {
      PostCreateResponse res = PostCreateResponse.fromJson(value);
      if (res.statusCode == Strings.success_code) {
        deletePostCallback();
      } else {
        ToastBuilder()
            .showToast(res.message, context, HexColor(AppColors.information));
      }
    }).catchError((onError) {
      print(onError);
    });
    // payload.postKeywords = postListItem.postContent.extra;
  }

  List<PopupMenuEntry<String>> getItems(String name) {
    List<PopupMenuEntry<String>> popupmenuList = [];
    if(isNewsPage!=null && isNewsPage){
      popupmenuList.add(
        PopupMenuItem(
          value: 'topic',
          child: Text(AppLocalizations.of(context).translate('select_topics'),
          ),
        ),
      );
    }
    if (postListItem.postOwnerTypeId == (prefs!=null?prefs.getInt(Strings.userId):0)) {
      popupmenuList.add(
        PopupMenuItem(
          value: 'delete',
          child: Text(AppLocalizations.of(context).translate('delete_post'),
          ),
        ),
      );
      if(widget.isLesson) {
        popupmenuList.add(
          PopupMenuItem(
            value: 'edit',
            child: Text(AppLocalizations.of(context).translate('edit'),
            ),
          ),
        );
      }
    } else {
      popupmenuList.add(
        PopupMenuItem(
          value: 'hide',
          child: Text(AppLocalizations.of(context).translate('hide_post'),
          ),
        ),
      );
      if (isFollowing ??= false) {
        popupmenuList.add(
          PopupMenuItem(
            value: 'unfollow',
            child: Text(AppLocalizations.of(context).translate('unfollo')+ " $name",
            ),
          ),
        );
      }
      popupmenuList.add(
        PopupMenuItem(
          value: 'block',
          child: Text(AppLocalizations.of(context).translate('block')+ " $name",
          ),
        ),
      );

      popupmenuList.add(
        PopupMenuItem(
          value: 'report',
          child: Text(AppLocalizations.of(context).translate('report_content'),
          ),
        ),
      );
    }
    return popupmenuList;
  }


}
