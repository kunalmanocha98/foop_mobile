import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/models/Edufluencer_Tutor_modles/edufluencer_list.dart';
import 'package:oho_works_app/ui/EdufluencerTutorModule/become_edufluencer_tutor_page.dart';
import 'package:oho_works_app/ui/EdufluencerTutorModule/edufluencer_tutor_card.dart';
import 'package:oho_works_app/ui/dialogs/dialog_sendmessage_edufluencer_tutor.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/follow_unfollow_block_remove_unblock_button.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:oho_works_app/components/paginator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EdufluencerTutorStudents extends StatefulWidget {
  final edufluencer_type type;
  final String listType;
  final bool isEdufluencer;

  EdufluencerTutorStudents({this.type,this.listType,this.isEdufluencer});

  @override
  EdufluencerTutorStudentsState createState() => EdufluencerTutorStudentsState();
}

class EdufluencerTutorStudentsState extends State<EdufluencerTutorStudents> {
  BuildContext sctx;
  TextStyleElements styleElements;
  SharedPreferences prefs = locator<SharedPreferences>();

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return Builder(
      builder: (BuildContext context) {
        this.sctx = context;
          return getBody();
      },
    );
  }
  Widget getBody(){
    return Paginator<EdufluenerListResponse>.listView(
        pageLoadFuture: fetch,
        pageItemsGetter: CustomPaginator(context).listItemsGetter,
        listItemBuilder: listItemBuilder,
        loadingWidgetBuilder: CustomPaginator(context).loadingWidgetMaker,
        errorWidgetBuilder: CustomPaginator(context).errorWidgetMaker,
        emptyListWidgetBuilder:
        CustomPaginator(context).emptyListWidgetMaker,
        totalItemsGetter: CustomPaginator(context).totalPagesGetter,
        pageErrorChecker: CustomPaginator(context).pageErrorChecker);
  }

  Future<EdufluenerListResponse> fetch(int page) async {
    EdufluenerListRequest payload = EdufluenerListRequest();
    payload.pageSize = 10;
    payload.pageNumber = page;
    payload.listType = widget.listType;
    payload.edufluencerType = widget.type.type;
    var res = await Calls()
        .call(jsonEncode(payload), context, Config.EDUFLUENCER_TUTOR_STUDENT_LIST);
    return EdufluenerListResponse.fromJson(res);
  }

  Widget listItemBuilder(itemData, int index) {
    EdufluencerListItem item = itemData;
    return EdufluencerTutorCard(
      imageUrl: item.profileImage,
      type: widget.type,
      rating: item.rating,
      subjectList: item.subjectsList,
      isfollowing: item.isFollowing,
      name: item.name,
      title: item.edufluencerTitle,
      designation: item.edufluencerCurrentPosition,
      description: item.edufluencerBio,
      borderColorForImage: HexColor(AppColors.appMainColor),
      skillsList: item.skillsList,
      classList: item.classesList,
      followButtonCallback: () {
        GenericFollowUnfollowButtonState().followUnfollowBlock(
            "person",
            prefs.getInt(Strings.userId),
            'person',
            item.personId,
            "F",
            [""],
                (isSuccess) {},
            context);
        setState(() {
          item.isFollowing = true;
        });
      },
      messageButtonCallback: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return EdufluencerTutorDialog(userId: prefs.getInt(Strings.userId).toString(),
                userName: prefs.getString(Strings.userName));
          },
        );
      },
    );
  }
}
