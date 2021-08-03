
import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/app_chat_footer.dart';
import 'package:oho_works_app/components/paginator.dart';
import 'package:oho_works_app/generic_libraries/generic_comment_review_feedback.dart';
import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/models/review_rating_comment/noteslistmodel.dart';
import 'package:oho_works_app/ui/commentItem.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'order_detail_page.dart';

class PaymentNotesSheet extends StatefulWidget {
  final int? postId;

  PaymentNotesSheet({this.postId});

  @override
  _PaymentNotesSheet createState() => _PaymentNotesSheet();
}

class _PaymentNotesSheet extends State<PaymentNotesSheet> {
  SharedPreferences? prefs = locator<SharedPreferences>();
  GlobalKey<PaginatorState> paginatorKey = GlobalKey();
  GlobalKey<appChatFooterState> chatFooterKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var styleElements = TextStyleElements(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(right:16.0,top:8),
              child: Text(
                AppLocalizations.of(context)!.translate(''),
                style: styleElements
                    .headline6ThemeScalable(context)
                    .copyWith(fontWeight: FontWeight.bold,color: HexColor(AppColors.appMainColor)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                AppLocalizations.of(context)!.translate('payment_notes'),
                style: styleElements
                    .headline6ThemeScalable(context)
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderDetailPage(
                          selectedTab:0,
                          type: "person", standardEventId: 2,
                        ),
                      ));
                },
                child: Text(
                  AppLocalizations.of(context)!.translate('next'),
                  style: styleElements
                      .headline6ThemeScalable(context)
                      .copyWith(fontWeight: FontWeight.bold,color: HexColor(AppColors.appMainColor)),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.45,
          child: Paginator<NotesListResponse>.listView(
            padding: EdgeInsets.only(top: 16, left: 16, right: 16),
            key: paginatorKey,
            pageLoadFuture: fetchData,
            shrinkWrap: true,
            pageItemsGetter: CustomPaginator(context).listItemsGetter,
            listItemBuilder: listItemBuilder,
            loadingWidgetBuilder: CustomPaginator(context).loadingWidgetMaker,
            errorWidgetBuilder: CustomPaginator(context).errorWidgetMaker,
            emptyListWidgetBuilder:
            CustomPaginator(context).emptyListWidgetMaker,
            totalItemsGetter: CustomPaginator(context).totalPagesGetter,
            pageErrorChecker: CustomPaginator(context).pageErrorChecker,
          ),
        ),
        appChatFooter(
          chatFooterKey,
          isShowAddIcon: false,
          hintText: AppLocalizations.of(context)!.translate('enter_comment'),
          onValueRecieved: (value) {
            submitComment(value!);
            // chatFooterKey.currentState.clearData();
            // addNote(value);
          },
        ),
        SizedBox(
          height: MediaQuery.of(context).viewInsets.bottom,
        )
      ],
    );
  }

  Future<NotesListResponse> fetchData(int page) async {
    var body = jsonEncode({
      "note_subject_type": "post",
      "note_subject_id": widget.postId,
      "page_number": page,
      "page_size": 10
    });
    var res = await Calls().call(body, context, Config.COMMENTS_LIST);
    return NotesListResponse.fromJson(res);
  }

  Widget listItemBuilder(itemData, int index) {
    NotesListItem item = itemData;
    return CommentItemCard(
        data: item,
        ratingCallBack: () {
          setState(() {
            // notesList[index].commRateCount =
            //     notesList[index].commRateCount + 1;
          });
        });
  }

  void submitComment(String value) async {
    prefs = await SharedPreferences.getInstance();
    var body = jsonEncode({
      "note_type": "comment",
      "note_created_by_type": "person",
      "note_created_by_id": prefs!.getInt(Strings.userId),
      "note_subject_type": "post",
      "note_subject_id": widget.postId,
      "note_content": value,
      "note_format": ["T"],
      "note_status": "A",
      "has_attachment": false,
      "make_anonymous": false,
      // "rating_subject_type":"post",
      // "rating_subject_id":postData.postId,
      // "rating_context_type":"person",
      // "rating_context_id":prefs.getInt(Strings.id),
      // "rating_given_by_id":prefs.getInt(Strings.id),
      // "rating_given":"5"
    });
    GenericCommentReviewFeedback(context, body)
        .apiCallCreate()
        .then((isSuccess) {
      print(isSuccess);
      if (isSuccess) {
        Timer(Duration(milliseconds: 500), () {
          refresh();
        });
        // refresh();
        // chatFooterKey.currentState.clearData();
      }
    });
  }

  refresh() {
    chatFooterKey.currentState!.clearData();
    paginatorKey.currentState!.changeState(resetState: true);
  }
}