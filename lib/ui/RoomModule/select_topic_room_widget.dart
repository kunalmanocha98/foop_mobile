import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/app_buttons.dart';
import 'package:oho_works_app/components/appAvatar.dart';
import 'package:oho_works_app/models/Rooms/topic_list.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/material.dart';
import 'package:oho_works_app/components/paginator.dart';

class SelectRoomTopicWidget extends StatefulWidget{
  final bool isCard;
  final  List<RoomTopicItem> _selectedList =[];
  SelectRoomTopicWidget(Key key,{this.isCard = true, List<String>? preSelected}):super(key: key){
    if(preSelected!=null && preSelected.length>0){
      preSelected.forEach((element) {
        _selectedList.add(RoomTopicItem(topicName: element,imageUrl: ""));
      });
    }
  }
  @override
  SelectRoomTopicWidgetState createState() => SelectRoomTopicWidgetState(_selectedList);
}
class SelectRoomTopicWidgetState extends State<SelectRoomTopicWidget>{
  List<RoomTopicItem> selectedList;
  SelectRoomTopicWidgetState(this.selectedList);

  @override
  Widget build(BuildContext context) {
    var styleElements = TextStyleElements(context);
    return widget.isCard? appCard(
        margin: EdgeInsets.only(left:8,right: 8,top: 0,bottom: 0),
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
            return  _RoomTopicList(selectedList: selectedList,);
          })).then((value){
            if(value!=null) {
              setState(() {
                selectedList = value;
              });
            }
          });
        },
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 12.0),
              child: appAvatar(
                key: UniqueKey(),
                size: 36,
                isFullUrl: selectedList!=null && selectedList.length>0,
                imageUrl: getImageUrl(),
              ),
            ),
            Expanded(
                child: Text(
                  getTitle()!,
                  style: styleElements.subtitle1ThemeScalable(context),
                )),
            Icon(Icons.arrow_forward_ios,
              color: HexColor(AppColors.appColorBlack35),
              size: 20,)
          ],
        )):
    Container(
        margin: EdgeInsets.only(left:0,right: 0,top: 0,bottom: 0),
        child: GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
              return  _RoomTopicList(selectedList: selectedList,);
            })).then((value){
              if(value!=null) {
                setState(() {
                  selectedList = value;
                });
              }
            });
          },
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 12.0),
                child: appAvatar(
                  key: UniqueKey(),
                  size: 36,
                  isFullUrl: selectedList!=null && selectedList.length>0,
                  isFromAsset: !(selectedList!=null && selectedList.length>0),
                  imageUrl: getImageUrl(),
                ),
              ),
              Expanded(
                  child: Text(
                    getTitle()!,
                    style: styleElements.subtitle1ThemeScalable(context),
                  )),
              Icon(Icons.arrow_forward_ios,
                color: HexColor(AppColors.appColorBlack35),
                size: 20,)
            ],
          ),
        ));
  }

  String? getTitle() {
    if(selectedList!=null && selectedList.length>0){
      if(selectedList.length>1){
        return selectedList[0].topicName!+' & Others';
      }else{
        return selectedList[0].topicName;
      }
    }else{
      return 'Select topics';
    }
  }


  String getImageUrl() {
    if(selectedList!=null && selectedList.length>0){
      debugPrint(Config.BASE_URL+selectedList[0].imageUrl!);
      return Config.BASE_URL+selectedList[0].imageUrl!;
    }else{
      return 'assets/appimages/topics-default.png';
    }

  }

  List<String?> getSelectedList(){
    List<String?> list = [];
    selectedList.forEach((element) {
      list.add(element.topicName);
    });
    return list;
  }
}



class _RoomTopicList extends StatefulWidget {
  final List<RoomTopicItem> selectedList;
  _RoomTopicList({this.selectedList=const []});

  @override
  _RoomTopicListState createState() => _RoomTopicListState(selectedList: selectedList);
}

class _RoomTopicListState extends State<_RoomTopicList> {
  late TextStyleElements styleElements;
  List<RoomTopicItem> postSubTypeList =[];
  List<RoomTopicItem>? selectedList;
  bool confirmation_first= false;
  bool confirmation_second = false;

  _RoomTopicListState({this.selectedList});
  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return SafeArea(
        child: Scaffold(
          appBar: OhoAppBar().getCustomAppBar(
              context,
              appBarTitle: getAppBarTitle(),
              actions:[
                appTextButton(
                  onPressed:() {
                      if(selectedList!=null && selectedList!.length>0){
                        Navigator.pop(context,selectedList);
                      }else{
                        ToastBuilder().showToast(AppLocalizations.of(context)!.translate('please_select_atleast'),
                            context,
                            HexColor(AppColors.information));
                      }
                  },
                  child: Wrap(
                    direction: Axis.horizontal,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children:[
                      Text( AppLocalizations.of(context)!.translate('next'),
                        style: styleElements
                            .subtitle2ThemeScalable(context)
                            .copyWith(color: HexColor(AppColors.appMainColor)),
                      ),
                      Icon(Icons.keyboard_arrow_right,
                          color: HexColor(AppColors.appMainColor))
                    ],
                  ),
                  shape: CircleBorder(),
                ),],
              onBackButtonPress: () {
                Navigator.pop(context);
              }),
          body: getBody(),
        )
    );
  }

  String getAppBarTitle() {
    return AppLocalizations.of(context)!.translate('select_topics');
  }

  Widget getBody() {
    return getTopicsList();
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

  Future<RoomTopicListResponse> fetchData(int page) async{
    RoomTopicRequest payload = RoomTopicRequest();
    payload.pageNumber = page;
    payload.pageSize=20;
    payload.searchVal = "";
    var value  = await Calls().call(jsonEncode(payload), context, Config.ROOM_TOPIC_LIST);
    return RoomTopicListResponse.fromJson(value);
  }

  List<RoomTopicItem>? listItemsGetter(RoomTopicListResponse? pageData) {
    var itr = pageData!.rows!.where((element){
      return selectedList!.any((element1){
        return element1.topicName == element.topicName;
      });
    });
    itr.forEach((element) {
      element.isSelected = true;
    });
    postSubTypeList.addAll(pageData.rows!);
    return pageData.rows;
  }

  Widget listItemBuilder(itemData, int index) {
    RoomTopicItem item = itemData;
    var imageUrl = item.imageUrl??="";
    return  ListTile(
      leading: appAvatar(
        imageUrl: Config.BASE_URL+imageUrl,
        size: 42,
        isFullUrl: true,
      ),
      trailing: Checkbox(
        onChanged: (bool? value) {
          changeSelection(value!,item,index);
        },
        value: item.isSelected??=false,
      ),
      title: Text(item.topicName!,style: styleElements.subtitle1ThemeScalable(context),),
    );
  }

  void changeSelection(bool value,RoomTopicItem item,int index) {
    if(value){
      setState(() {
        selectedList!.add(item);
        postSubTypeList[index].isSelected = value;
      });
    }else{
      setState(() {
        selectedList!.removeWhere((element){
          return element.topicName==item.topicName;
        });
        postSubTypeList[index].isSelected = value;
      });
    }
  }


}