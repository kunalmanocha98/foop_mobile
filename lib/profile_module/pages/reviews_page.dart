import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/searchBox.dart';
import 'package:oho_works_app/models/review_rating_comment/noteslistmodel.dart';
import 'package:oho_works_app/ui/commentItem.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:oho_works_app/components/paginator.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class ReviewsPage extends StatefulWidget {
  String? personName;
  String type;
  int? id;
  String? ownerType;
  int? ownerId;
  Null Function()? callback;
  ReviewsPage(this.personName, this.type, this.id, this.callback);

  @override
  _ReviewsPage createState() =>
      _ReviewsPage(type, id, ownerId, ownerType, callback);
}

class _ReviewsPage extends State<ReviewsPage>  with AutomaticKeepAliveClientMixin<ReviewsPage>{
  String? searchVal;
  String? personName;
  String type;
  int? id;
  String? ownerType;
  int? ownerId;
  Null Function()? callback;
  GlobalKey<PaginatorState> paginatorKey = GlobalKey();
  SharedPreferences? prefs;
  TextStyleElements? styleElements;
  @override
  bool get wantKeepAlive => true;
  void setSharedPreferences() async {
    refresh();
  }

  Future<void> _setPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();

    _setPref();
  }

  void onsearchValueChanged(String text) {
    // print(text);
    searchVal = text;
    refresh();
  }

  refresh() {
    paginatorKey.currentState!.changeState(resetState: true);
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);

    return Container(
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: SearchBox(
                  onvalueChanged: onsearchValueChanged,
                  hintText: AppLocalizations.of(context)!.translate('search'),
                ),
              )
            ];
          },
          body: TricycleListCard(
            child: Paginator.listView(
                key: paginatorKey,
                padding: EdgeInsets.only(top: 16),
                scrollPhysics: BouncingScrollPhysics(),
                pageLoadFuture: fetchListComments,
                pageItemsGetter: CustomPaginator(context).listItemsGetter,
                listItemBuilder: listItemBuilder,
                loadingWidgetBuilder: CustomPaginator(context).loadingWidgetMaker,
                errorWidgetBuilder: CustomPaginator(context).errorWidgetMaker,
                emptyListWidgetBuilder: CustomPaginator(context).emptyListWidgetMaker,
                totalItemsGetter: CustomPaginator(context).totalPagesGetter,
                pageErrorChecker: CustomPaginator(context).pageErrorChecker),
          ),
        ));
  }

  Future<NotesListResponse> fetchListComments(int page) async{
    var body = jsonEncode({
      "note_subject_type": type,
      "note_subject_id": id,
      "page_number": page,
      "page_size": 10
    });
    var res = await Calls().call(body, context, Config.COMMENTS_LIST);
    return NotesListResponse.fromJson(res);
  }

  Widget listItemBuilder(value, int index) {
    NotesListItem item = value;
    return CommentItemCard(
        data: item,
        color:HexColor(AppColors.appColorTransparent),
        ratingCallBack: () {
          /*setState(() {
            item.commRateCount = notesList[index].commRateCount + 1;
          });*/
        });
  }

  _ReviewsPage(
      this.type, this.id, this.ownerId, this.ownerType, this.callback);
}
