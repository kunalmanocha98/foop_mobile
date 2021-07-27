import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/paginator.dart';
import 'package:oho_works_app/components/appProgressButton.dart';
import 'package:oho_works_app/e_learning_module/model/learner_list_response.dart';
import 'package:oho_works_app/models/e_learning/topic_list.dart';
import 'package:oho_works_app/models/post/postcreate.dart';
import 'package:oho_works_app/models/post/postreceiver.dart';
import 'package:oho_works_app/ui/postrecieverlistpage.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class LearnerCategoryPage extends StatefulWidget {
  final TopicListItem? topicListItem;

  final PostReceiverListItem? selectedReceiverData;
  final Function? callBack;
  final List<PostCreatePayload?>? list;

  const LearnerCategoryPage(
      {Key? key,
      this.topicListItem,
      this.list,
      this.selectedReceiverData,
      this.callBack})
      : super(key: key);

  _LearnerCategoryListResponse createState() => _LearnerCategoryListResponse(
      list: list, selectedReceiverData: selectedReceiverData);
}

class _LearnerCategoryListResponse extends State<LearnerCategoryPage> {
  late BuildContext context;
  late TextStyleElements styleElements;
  String? searchVal;
  GlobalKey<appProgressButtonState> progressButtonKey = GlobalKey();
  GlobalKey<appProgressButtonState> progressButtonKeyNext = GlobalKey();
  GlobalKey<PaginatorState> paginatorKey = GlobalKey();
  List<LearnerListItem> recList = [];
  List<LearnerListItem> selectedItems = [];
   List<PostCreatePayload?>? list;
  PostReceiverListItem? selectedReceiverData;

  _LearnerCategoryListResponse({this.list, this.selectedReceiverData});

  @override
  void initState() {
    super.initState();
  }

  refresh() {
    paginatorKey.currentState!.changeState(resetState: true);
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    this.context = context;

    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: appAppBar().getCustomAppBar(
            context,
            appBarTitle: AppLocalizations.of(context)!.translate('select_type'),
            actions: [
              Padding(
                padding:
                    const EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0),
                child: InkWell(
                  onTap: () async {


                    for(int i=0;i<widget.list!.length;i++)
                    {
                      widget.list![i]!.learnerItem =  getSelectedLearnerItem();
                    }
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return PostReceiverListPage(
                        list: widget.list,
                        callBack:(){Navigator.of(context).pop();
                        if(widget.callBack!=null)
                          widget.callBack!();
                        },
                        selectedReceiverData: selectedReceiverData,
                      );
                    }));
                  },
                  child: Text(
                    AppLocalizations.of(context)!.translate('next'),
                    style: styleElements
                        .subtitle2ThemeScalable(context)
                        .copyWith(color: HexColor(AppColors.appMainColor)),
                  ),
                ),
              ),
            ],
            onBackButtonPress: () {
              Navigator.pop(context);
            },
          ),
          body: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left :16.0,bottom: 8.0),
                    child: Text(
                      widget.list![0]!=null &&widget.list![0]!.lessonTopic!=null&& widget.list![0]!.lessonTopic!.title!=null ?widget.list![0]!.lessonTopic!.title!:  AppLocalizations.of(context)!.translate('Topic_type'),
                      style: styleElements
                          .headline6ThemeScalable(context)
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Container(
                        child: Container(
                            child: appCard(
                      child: Paginator.listView(
                          key: paginatorKey,
                          pageLoadFuture: fetchList,
                          pageItemsGetter: listItemsGetter,
                          listItemBuilder: listItemBuilder,
                          loadingWidgetBuilder:
                              CustomPaginator(context).loadingWidgetMaker,
                          errorWidgetBuilder:
                              CustomPaginator(context).errorWidgetMaker,
                          emptyListWidgetBuilder:
                              CustomPaginator(context).emptyListWidgetMaker,
                          totalItemsGetter:
                              CustomPaginator(context).totalPagesGetter,
                          pageErrorChecker:
                              CustomPaginator(context).pageErrorChecker),
                    ))),
                  ),
                ],
              )
            ],
          )),
    );
  }

  List<LearnerListItem>? listItemsGetter(LearnerCategoryListResponse? response) {
    recList.addAll(response!.rows!);

    return response.rows;
  }

  Widget listItemBuilder(value, int index) {
    LearnerListItem item = value;
    return Visibility(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        child: ListTile(
          tileColor: HexColor(AppColors.listBg),
          title: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              item.learnerCategoryName ?? "",
              style: styleElements.subtitle1ThemeScalable(context),
              textAlign: TextAlign.left,
            ),
          ),
          trailing: Checkbox(
              value: item.isSelected ??= false,
              onChanged: (value) {
                changeSelection(value, item, index);
              }),
        ),
        onTap: () async {},
      ),
    );
  }

  void changeSelection(bool? value, LearnerListItem item, int index) {
    setState(() {
      recList[index].isSelected = value;
    });
  }

  List<LearnerListItem> getSelectedLearnerItem() {
    for (var item in recList) {
      if (item.isSelected!) selectedItems.add(item);
    }
    return selectedItems;
  }

  Future<LearnerCategoryListResponse> fetchList(int page) async {
    var body = jsonEncode({
      "searchVal": searchVal,
      "page_number": page,
      "page_size": 10,
      "learner_category_type": widget.topicListItem!.topicCode!.toLowerCase()
    });
    var res = await Calls().call(body, context, Config.LEARNER_TYPE_LIST);
    var model = LearnerCategoryListResponse.fromJson(res);
    return model;
  }
}
