import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/tricycle_buttons.dart';
import 'package:oho_works_app/components/tricycle_user_list_tile.dart';
import 'package:oho_works_app/models/post/post_sub_type_list.dart';
import 'package:oho_works_app/models/post/postcreate.dart';
import 'package:oho_works_app/models/post/postreceiver.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/material.dart';
import 'package:oho_works_app/components/paginator.dart';

import '../postrecieverlistpage.dart';

// ignore: must_be_immutable
class CampusNewsHelperPages extends StatefulWidget {
  final CAMPUS_NEWS_TYPE campus_news_type;
  List<PostSubTypeListItem> selectedList;
  PostCreatePayload postCreatePayload;
  PostReceiverListItem selectedReceiverData;
  Function callBack;
  CampusNewsHelperPages(this.campus_news_type,{this.selectedList,this.postCreatePayload,@required this.selectedReceiverData,this.callBack});

  @override
  _CampusNewsHelperPages createState() => _CampusNewsHelperPages(list: selectedList);
}
enum CAMPUS_NEWS_TYPE {
  assure,
  help,
  topics
}

class _CampusNewsHelperPages extends State<CampusNewsHelperPages> {
  TextStyleElements styleElements;
  List<PostSubTypeListItem> postSubTypeList =[];
  List<PostSubTypeListItem> selectedList;
  bool confirmation_first= false;
  bool confirmation_second = false;

  _CampusNewsHelperPages({List<PostSubTypeListItem> list}){
    if(list==null){
      selectedList = [];
    }else{
      selectedList =list ;
    }
  }
  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return SafeArea(
        child: Scaffold(
          appBar: TricycleAppBar().getCustomAppBar(
              context,
              appBarTitle: getAppBarTitle(),
              actions: (widget.campus_news_type==CAMPUS_NEWS_TYPE.assure || widget.campus_news_type==CAMPUS_NEWS_TYPE.topics)?[
                TricycleTextButton(
                onPressed:() {
                  if(widget.campus_news_type==CAMPUS_NEWS_TYPE.assure) {
                    if(confirmation_first && confirmation_second) {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                          builder: (context) =>
                              PostReceiverListPage(
                                callBack: widget.callBack,
                                  payload: widget.postCreatePayload,
                                selectedReceiverData: widget.selectedReceiverData,
                              )))
                          .then((value) {
                        Navigator.pop(context, value);
                      });
                    }else{
                      ToastBuilder().showToast('You need to approve the terms', context, HexColor(AppColors.information));
                    }
                  }else if(widget.campus_news_type==CAMPUS_NEWS_TYPE.topics){
                    if(selectedList!=null && selectedList.length>0){
                      Navigator.pop(context,selectedList);
                    }else{
                      ToastBuilder().showToast(AppLocalizations.of(context).translate('please_select_atleast'),
                          context,
                          HexColor(AppColors.information));
                    }
                  }
                },
                child: Wrap(
                  direction: Axis.horizontal,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: (widget.campus_news_type==CAMPUS_NEWS_TYPE.assure)?[
                    Text( AppLocalizations.of(context).translate('next'),
                      style: styleElements
                          .subtitle2ThemeScalable(context)
                          .copyWith(color: HexColor(AppColors.appMainColor)),
                    ),
                    Icon(Icons.keyboard_arrow_right,
                        color: HexColor(AppColors.appMainColor))
                  ]:
                  [
                    Text( AppLocalizations.of(context).translate('submit'),
                      style: styleElements
                          .subtitle2ThemeScalable(context)
                          .copyWith(color: HexColor(AppColors.appMainColor)),
                    ),
                  ]
                  ,

                ),
                shape: CircleBorder(),
              ),]:null,
              onBackButtonPress: () {
                Navigator.pop(context);
              }),
          body: getBody(),
        )
    );
  }

  String getAppBarTitle() {
    if (widget.campus_news_type == CAMPUS_NEWS_TYPE.assure) {
      return AppLocalizations.of(context).translate('assurance');
    } else if (widget.campus_news_type == CAMPUS_NEWS_TYPE.topics) {
      return AppLocalizations.of(context).translate('select_topics');
    } else {
      return AppLocalizations.of(context).translate('help');
    }
  }

  Widget getBody() {
    if (widget.campus_news_type == CAMPUS_NEWS_TYPE.assure) {
      return getAssurance();
    } else if (widget.campus_news_type == CAMPUS_NEWS_TYPE.topics) {
      return getTopicsList();
    } else {
      return getHelp();
    }
  }

  Widget getAssurance() {
    return TricycleCard(
        child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(AppLocalizations.of(context).translate('confirmation'),
              style: styleElements.subtitle1ThemeScalable(context).copyWith(
                  fontWeight: FontWeight.w600
              ),),
            SizedBox(height: 12,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(value: confirmation_first,
                    onChanged: (value) {
                  setState(() {
                    confirmation_first = value;
                  });
                }),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(AppLocalizations.of(context).translate('news_agree_1')),
                  ),
                )
              ],
            ),
            SizedBox(height: 12,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(value: confirmation_second,
                    onChanged: (value) {
                      setState(() {
                        confirmation_second = value;
                      });
                    }),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(AppLocalizations.of(context).translate('news_agree_2')),
                  ),
                )
              ],
            ),
          ],
        ));
  }



  Widget getHelp() {
    return TricycleCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(AppLocalizations.of(context).translate('news_from_other_sources'),
            style: styleElements.subtitle1ThemeScalable(context).copyWith(
                fontWeight: FontWeight.bold),),
          SizedBox(height: 8,),
          Text(AppLocalizations.of(context).translate('news_other_des'),
            style: styleElements.bodyText2ThemeScalable(context),),
          SizedBox(height: 12,),
          Text(AppLocalizations.of(context).translate('copyright_violation'),
            style: styleElements.subtitle1ThemeScalable(context).copyWith(
                fontWeight: FontWeight.bold),),
          SizedBox(height: 8,),
          Text(AppLocalizations.of(context).translate('copyright_des'),
            style: styleElements.bodyText2ThemeScalable(context),),
        ],
      ),
    );
  }

  Widget getTopicsList() {
    return Paginator.listView(
        pageLoadFuture: fetchData,
        pageItemsGetter: listItemsGetter,
        listItemBuilder: listItemBuilder,
        loadingWidgetBuilder: CustomPaginator(context).loadingWidgetMaker,
        errorWidgetBuilder: CustomPaginator(context).errorWidgetMaker,
        emptyListWidgetBuilder: CustomPaginator(context).emptyListWidgetMaker,
        totalItemsGetter: CustomPaginator(context).totalPagesGetter,
        pageErrorChecker: CustomPaginator(context).pageErrorChecker);
  }

  Future<PostSubTypeListResponse> fetchData(int page) async{
    PostSubTypeListRequest payload = PostSubTypeListRequest();
    payload.pageNumber = page;
    payload.pageSize=20;
    payload.postType ="news";
    payload.searchVal = "";
    var value  = await Calls().call(jsonEncode(payload), context, Config.POST_SUBTYPE_LIST);
    return PostSubTypeListResponse.fromJson(value);
  }

  List<PostSubTypeListItem> listItemsGetter(PostSubTypeListResponse pageData) {
    var itr = pageData.rows.where((element){
      return selectedList.any((element1){
        return element1.postSubTypeName == element.postSubTypeName;
      });
    });
    itr.forEach((element) {
      element.isSelected = true;
    });
    postSubTypeList.addAll(pageData.rows);
    return pageData.rows;
  }

  Widget listItemBuilder(itemData, int index) {
    PostSubTypeListItem item = itemData;
    var imageurl = item.imageUrl??="";
    return
    TricycleUserListTile(
      imageUrl:Config.BASE_URL+imageurl ,
      isFullImageUrl: true,
      trailingWidget: Checkbox(
        onChanged: (bool value) {
          changeSelection(value,item,index);
        },
        value: item.isSelected??=false,
      ),
      title: item.postSubTypeName,
    );
  }

  void changeSelection(bool value,PostSubTypeListItem item,int index) {
    if(value){
      setState(() {
        selectedList.add(item);
        postSubTypeList[index].isSelected = value;
      });
    }else{
      setState(() {
        selectedList.removeWhere((element){
          return element.postSubTypeName==item.postSubTypeName;
        });
        postSubTypeList[index].isSelected = value;
      });
    }
  }


}