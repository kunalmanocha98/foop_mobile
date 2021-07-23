import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/tricycle_user_list_tile.dart';
import 'package:oho_works_app/models/post/votesListModels.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/follow_unfollow_block_remove_unblock_button.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:oho_works_app/components/paginator.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class PollsUserList extends StatefulWidget {
  int? sequence;
  String? option;
  int? postId;

  PollsUserList({this.sequence, this.option, this.postId});

  @override
  PollsUserListState createState() =>
      PollsUserListState(sequence: sequence, option: option, postId: postId);
}

class PollsUserListState extends State<PollsUserList> {
  int? sequence;
  String? option;
  int? postId;
  late SharedPreferences preferences;
  TextStyleElements? styleElements;
  List<VotesListItem>? listVotesItem;

  PollsUserListState({this.sequence, this.option, this.postId});

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return TricycleListCard(
      child: Paginator.listView(
          pageLoadFuture: fetchList,
          pageItemsGetter: listItemsGetter,
          listItemBuilder: listItemBuilder,
          loadingWidgetBuilder: CustomPaginator(context).loadingWidgetMaker,
          errorWidgetBuilder: CustomPaginator(context).errorWidgetMaker,
          emptyListWidgetBuilder: CustomPaginator(context).emptyListWidgetMaker,
          totalItemsGetter: CustomPaginator(context).totalPagesGetter,
          pageErrorChecker: CustomPaginator(context).pageErrorChecker),
    );
  }

  List<VotesListItem>? listItemsGetter(PollVotesListResponse? pageData) {
    listVotesItem = pageData!.rows;
    return pageData.rows;
  }

  Future<PollVotesListResponse> fetchList(int page) async {
    preferences = await SharedPreferences.getInstance();
    PollVotesListRequest payload = PollVotesListRequest();
    payload.pageNumber = page;
    payload.pageSize = 20;
    payload.option = option;
    payload.optionSequence = sequence;
    payload.postId = postId;
    payload.objectId = preferences.getInt(Strings.userId);
    payload.objectType = 'person';
    var data = jsonEncode(payload);
    var res = await Calls().call(data, context, Config.POLL_VOTES_LIST);
    return PollVotesListResponse.fromJson(res);
  }

  Widget listItemBuilder(itemData, int index) {
    VotesListItem item = itemData;
    return TricycleUserListTile(
        imageUrl: item.profileImage,
        title: item.name,
        subtitle1: item.subtitle,
        trailingWidget: Visibility(
          visible: !item.isObjectFollowing!,
          child: GenericFollowUnfollowButton(
            actionByObjectType: preferences.getString("ownerType"),
            actionByObjectId: preferences.getInt("userId"),
            actionOnObjectType: item.type,
            actionOnObjectId: item.id,
            engageFlag: AppLocalizations.of(context)!.translate('follow'),
            actionFlag: "F",
            actionDetails: [],
            personName: item.name ?? "",
            callback: (isCallSuccess) {
              if (isCallSuccess) {
                setState(() {
                  listVotesItem![index].isObjectFollowing = true;
                });
              }
            },
          ),
        ));
  }
}
