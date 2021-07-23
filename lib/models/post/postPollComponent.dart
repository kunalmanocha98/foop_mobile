import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/models/post/pollRequestResponse.dart';
import 'package:oho_works_app/models/post/postcreate.dart';
import 'package:oho_works_app/models/post/postlist.dart';
import 'package:oho_works_app/ui/postModule/pollVotedUsersListPage.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class PostPollComponent extends StatefulWidget {
  ContentMeta? contentMeta;
  int? postId;
  Function? onVoteCallback;
  bool? isVoted;
  int? postOwnerTypeId;
  SharedPreferences? prefs;

  PostPollComponent(
      {this.contentMeta,
        this.postId,
        this.onVoteCallback,
        this.isVoted,
        this.postOwnerTypeId,
        this.prefs});

  @override
  PostPollComponentState createState() => PostPollComponentState(
      contentMeta: contentMeta,
      postId: postId,
      onVoteCallback: onVoteCallback,
      isVoted: isVoted,
      postOwnerTypeId: postOwnerTypeId,
      prefs: prefs);
}

enum PollLoadingStatus { pollView, loadingView, resultView }

class PostPollComponentState extends State<PostPollComponent> {
  late TextStyleElements styleElements;
  ContentMeta? contentMeta;
  int? postId;
  Function? onVoteCallback;
  bool? isVoted;
  PollLoadingStatus? status;
  int? postOwnerTypeId;
  SharedPreferences? prefs;

  PostPollComponentState(
      {this.contentMeta,
        this.postId,
        this.onVoteCallback,
        this.isVoted,
        this.postOwnerTypeId,
        this.prefs}) {
    if ((isVoted!=null &&isVoted!) || postOwnerTypeId == prefs!.getInt(Strings.userId)) {
      status = PollLoadingStatus.resultView;
    } else {
      status = PollLoadingStatus.pollView;
    }
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 32),
            child: getView()),
        Visibility(
          visible: status == PollLoadingStatus.resultView,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => PollsVotedUserListPage(
                        postId: postId,
                        optionsList: contentMeta!.others!.options,
                      )));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${contentMeta!.others!.totalResponses} voted",
                    style: styleElements.captionThemeScalable(context).copyWith(
                        fontWeight: FontWeight.bold,
                        color: HexColor(AppColors.appMainColor)),
                  ),
                  // Icon(Icons.circle,size: 6,color: HexColor(AppColors.appColorGrey500),),
                  // Text("status",style: styleElements.captionThemeScalable(context).copyWith(
                  //     fontWeight: FontWeight.bold
                  // ),),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget getView() {
    if (status == PollLoadingStatus.pollView) {
      return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount:
        (contentMeta!.others != null && contentMeta!.others!.options != null)
            ? contentMeta!.others!.options!.length
            : 0,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                status = PollLoadingStatus.loadingView;
              });
              createPollRequest(contentMeta!.others!.options![index], index);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    border: Border.all(color: HexColor(AppColors.appMainColor)),
                    borderRadius: BorderRadius.circular(25)),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      contentMeta!.others!.options![index].option!,
                      style: styleElements.subtitle2ThemeScalable(context),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    } else if (status == PollLoadingStatus.resultView) {
      return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: contentMeta!.others!.options!.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    LinearPercentIndicator(
                      linearStrokeCap: LinearStrokeCap.roundAll,
                      animation: true,
                      animationDuration: 900,
                      lineHeight: 36,
                      percent: (contentMeta!.others!.options![index].percentage! / 100),
                      backgroundColor: HexColor(AppColors.pollBackground),
                      progressColor: HexColor(AppColors.appMainColor).withOpacity(0.75),
                      center: Text(
                        contentMeta!.others!.options![index].option!,
                        style: styleElements
                            .subtitle2ThemeScalable(context)
                            .copyWith(color: HexColor(AppColors.appColorWhite)),
                      ),
                    ),
                    Text(
                      '${contentMeta!.others!.options![index].percentage}%',
                      style: styleElements
                          .bodyText2ThemeScalable(context)
                          .copyWith(color: HexColor(AppColors.appColorWhite)),
                    )
                  ],
                ),
              ));
        },
      );
    } else {
      return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: contentMeta!.others!.options!.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.only(
                left: 8.0, right: 8.0, top: 24, bottom: 24),
            child: LinearProgressIndicator(),
          );
        },
      );
    }
  }

  void createPollRequest(Options option, int index) async {
    var prefs = await SharedPreferences.getInstance();
    PollAnswerRequest payload = PollAnswerRequest();
    payload.postId = postId;
    payload.option = option.option;
    payload.optionSequence = option.optionSequence;
    payload.responseById = prefs.getInt(Strings.userId);
    payload.responseByType = 'person';
    var body = jsonEncode(payload);
    Calls().call(body, context, Config.POLL_RESPOND).then((value) {
      setState(() {
        var response = PollVoteResponse.fromJson(value);
        if (response.statusCode == Strings.success_code) {
          contentMeta!.others!.options = response.rows!.options;
          contentMeta!.others!.totalResponses =
              contentMeta!.others!.totalResponses! + 1;
          status = PollLoadingStatus.resultView;
          isVoted = true;
          onVoteCallback!();
        } else {
          ToastBuilder().showToast(
              response.message!, context, HexColor(AppColors.information));
          status = PollLoadingStatus.pollView;
        }
      });
    });
  }
}
