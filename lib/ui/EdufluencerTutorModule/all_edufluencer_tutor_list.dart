import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/tricycle_buttons.dart';
import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/models/Edufluencer_Tutor_modles/edufluencer_list.dart';
import 'package:oho_works_app/ui/EdufluencerTutorModule/become_edufluencer_tutor_page.dart';
import 'package:oho_works_app/ui/EdufluencerTutorModule/edufluencer_tutor_card.dart';
import 'package:oho_works_app/ui/dialogs/dialog_sendmessage_edufluencer_tutor.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/follow_unfollow_block_remove_unblock_button.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:oho_works_app/components/paginator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllEdufluencerAndTutors extends StatefulWidget {
  final edufluencer_type? type;
  final String? listType;
  final bool? isEdufluencer;

  AllEdufluencerAndTutors({this.type,this.listType,this.isEdufluencer});

  @override
  AllEdufluencerAndTutorsState createState() => AllEdufluencerAndTutorsState();
}

class AllEdufluencerAndTutorsState extends State<AllEdufluencerAndTutors> {
  BuildContext? sctx;
  late TextStyleElements styleElements;
  SharedPreferences? prefs = locator<SharedPreferences>();

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return Builder(
      builder: (BuildContext context) {
        this.sctx = context;
        if(widget.listType == 'all') {
          return NestedScrollView(
              headerSliverBuilder: (BuildContext context,
                  bool innerBoxIsScrolled) {
                return [
                  SliverToBoxAdapter(
                    child: TricycleListCard(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/appimages/buddy.png',
                            height: 120,
                            width: 120,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(widget.type == edufluencer_type.E ?
                            AppLocalizations.of(context)!.translate(
                                'edufluencer_note')
                                : AppLocalizations.of(context)!.translate(
                                'tutor_note')
                              , style: styleElements.subtitle1ThemeScalable(
                                  context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // (widget.isEdufluencer)?
                  //     SliverToBoxAdapter(child: Container(),) :
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            top: 8,
                            bottom: 8,
                          ),
                          child: TricycleTextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return BecomeEdufluencerTutorForm(
                                        type: widget.type,
                                      );
                                    }),
                              );
                            },
                            color: HexColor(AppColors.appMainColor),
                            child: Text(
                              AppLocalizations.of(context)!.translate(
                                  widget.type == edufluencer_type.E
                                      ? 'become_edufluencer'
                                      : "become_tutor"),
                              style: styleElements
                                  .captionThemeScalable(context)
                                  .copyWith(
                                  color: HexColor(AppColors.appColorWhite)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ];
              },
              body: getBody()
          );
        }else{
          return getBody();
        }
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
        .call(jsonEncode(payload), context, Config.EDUFLUENCER_TUTOR_LIST);
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
        bookingStatus:item.bookingStatus,
      followButtonCallback: () {
        GenericFollowUnfollowButtonState().followUnfollowBlock(
            "person",
            prefs!.getInt(Strings.userId),
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
            return EdufluencerTutorDialog(userId: prefs!.getInt(Strings.userId).toString(),
            userName: prefs!.getString(Strings.userName),
              edufluncerItem:item,
            );
          },
        );
      },
    );
  }
}
