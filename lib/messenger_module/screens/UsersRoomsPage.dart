import 'dart:async';
import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/tricycleProgressButton.dart';
import 'package:oho_works_app/components/tricycleavatar.dart';
import 'package:oho_works_app/enums/paginatorEnums.dart';
import 'package:oho_works_app/enums/resolutionenums.dart';
import 'package:oho_works_app/enums/serviceTypeEnums.dart';
import 'package:oho_works_app/messenger_module/entities/connect_list_response_entity.dart';
import 'package:oho_works_app/messenger_module/entities/connection_list_entity.dart';
import 'package:oho_works_app/models/suggestion_data.dart';
import 'package:oho_works_app/profile_module/pages/profile_page.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/follow_unfollow_block_remove_unblock_button.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/utility_class.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oho_works_app/components/paginator.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'chat_history_page.dart';
// ignore: must_be_immutable
class ConnectionPage extends StatefulWidget {
  IO.Socket socket;
  String type;
  bool isForward;
  Null Function() callBack;
  ConnectionPage(this.type,this.socket,this.isForward,this.callBack);
  @override
  _ConnectionsSuggestionPage createState() =>
      _ConnectionsSuggestionPage(type,socket,isForward,callBack);
}

class _ConnectionsSuggestionPage extends State<ConnectionPage> {
  _ConnectionsSuggestionPage(
      this.type,this.socket,this.isForward,this.callBack);
  IO.Socket socket;
  String searchVal;
  String type;
  Null Function() callBack;
  String ownerType;
  int ownerId;
  bool isForward;
  GlobalKey<PaginatorState> paginatorKey = GlobalKey();
  SharedPreferences prefs;
  TextStyleElements styleElements;
  bool get wantKeepAlive => true;
  PAGINATOR_ENUMS pageEnum_suggestion;
  PAGINATOR_ENUMS pageEnum_connections;
  String errorMessage;
  List<ConnectionItem> ConnectionsList = [];
  List<ConnectionItem> selectedConnections = [];
  List<Rows> suggestionList = [];
  int totalConnections = 0;
  int pageConnections = 0;
  int totalSuggestions = 0;
  int pageSuggetsions = 0;
  var connectionSliverKey = GlobalKey();
  var suggestionsSliverKey = GlobalKey();
  String names="";
BuildContext ctx;
  @override
  void initState() {
    super.initState();
    pageEnum_suggestion = PAGINATOR_ENUMS.LOADING;
    pageEnum_connections = PAGINATOR_ENUMS.LOADING;

    setPrefs();

  }
Future<void> setPrefs()
async {
  prefs = await SharedPreferences.getInstance();
  ownerId=prefs.getInt(Strings.userId);
  ownerType="person";
  initialcallConnections();
  initialcallSuggestions();
}
  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
this.ctx=context;
    return SafeArea(
      child: Scaffold(
   backgroundColor: HexColor(AppColors.appColorWhite),
          body: Stack(
           children: [
             Column(children: [
               Expanded(
                 child: CustomScrollView(
                   slivers: [
                     getConnections(),
                     SliverToBoxAdapter(
                       child: Padding(
                         padding: const EdgeInsets.only(
                             left: 20.0, top: 8, bottom: 8),
                         child: Text(
                           AppLocalizations.of(context).translate("suggestions"),
                           style: styleElements
                               .headline6ThemeScalable(context)
                               .copyWith(fontWeight: FontWeight.w600),
                         ),
                       ),
                     ),
                     getSuggestions() ,
                   ],
                 ),
               ),
             ]),
             Visibility(
               visible: isForward,
               child: Align(
                   alignment: Alignment.bottomCenter,
                   child: Container(
                       color: HexColor(AppColors.appColorWhite),
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: <Widget>[

                           Flexible(
                             child: Padding(
                               padding: const EdgeInsets.all(16.0),
                               child: Text(getNames(),
                                 maxLines: 1,
                                 overflow: TextOverflow.ellipsis,
                                 style: styleElements
                                     .subtitle1ThemeScalable(context)
                                     .copyWith(
                                     color:  HexColor(AppColors.appMainColor),),

                               ),
                             ),
                           ),


                            Padding(
                             padding: const EdgeInsets.only(right:16.0),
                             child: TricycleProgressButton(

                               shape: RoundedRectangleBorder(
                                   borderRadius:
                                   BorderRadius.circular(18.0),
                                   side: BorderSide(
                                       color:  HexColor(AppColors.appMainColor),)),
                               onPressed: () async {

                                 Navigator.of(context).pop({'result': getSelectedUsers()});
                                 },
                               color:  HexColor(AppColors.appColorWhite),
                               child: Text(
                                 AppLocalizations.of(context)
                                     .translate('next')
                                     .toUpperCase(),
                                 style: styleElements
                                     .subtitle2ThemeScalable(context)
                                     .copyWith(
                                     color:  HexColor(AppColors.appMainColor),),
                               ),
                             ),
                           )

                           ,

                         ],
                       ))),
             )
           ],
          )),
    );
  }

  getSuggestions() {
    if (pageEnum_suggestion == PAGINATOR_ENUMS.LOADING) {
      return SliverToBoxAdapter(
        child: CustomPaginator(context).loadingWidgetMaker(),
      );
    } else if (pageEnum_suggestion == PAGINATOR_ENUMS.EMPTY) {
      return SliverToBoxAdapter(
        child: CustomPaginator(context).emptyListWidgetMaker(null),
      );
    } else {
      return SliverPadding(
        padding: EdgeInsets.only(left: 8, right: 8),
        sliver: SliverList(
          key: suggestionsSliverKey,
          delegate:
          SliverChildBuilderDelegate((BuildContext context, int index) {
            if (index < suggestionList.length) {
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserProfileCards(
                            userType: suggestionList[index].id == ownerId
                                ? "person"
                                : "thirdPerson",
                            userId: suggestionList[index].id != ownerId
                                ? suggestionList[index].id
                                : null,
                            callback: () {
                              
                            },
                            currentPosition: 1,
                            type: null,
                          )));
                },
                child:Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UserProfileCards(
                                        userType:
                                        suggestionList[index].id ==
                                            ownerId
                                            ? "person"
                                            : "thirdPerson",
                                        userId:
                                        suggestionList[index].id !=
                                            ownerId
                                            ? suggestionList[index].id
                                            : null,
                                        callback: () {

                                        },
                                        currentPosition: 1,
                                        type: null,
                                      )));
                            },
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: SizedBox(
                                  height: 52,
                                  width: 52,
                                  child: CircleAvatar(
                                    radius: 52,
                                    foregroundColor:  HexColor(AppColors.appColorWhite),
                                    backgroundColor: HexColor(AppColors.appColorWhite),
                                    child: ClipOval(
                                      child: CachedNetworkImage(
                                        imageUrl: Utility().getUrlForImage(
                                            suggestionList[index].avatar,
                                            RESOLUTION_TYPE.R64,
                                            SERVICE_TYPE.PERSON),
                                        placeholder: (context, url) => Center(
                                            child: Image.asset(
                                              'assets/appimages/userplaceholder.jpg',
                                            )),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ))),
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: AlignmentDirectional.centerStart,
                                child: Container(
                                  margin: EdgeInsets.only(
                                    top: 0,
                                    left: 16,
                                    right: 8,
                                  ),
                                  child: Text(
                                      suggestionList[index].title ?? "",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: styleElements
                                          .subtitle1ThemeScalable(context)),
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional.centerStart,
                                child: Container(
                                  margin: EdgeInsets.only(
                                    top: 0,
                                    left: 16,
                                    right: 8,
                                  ),
                                  child: Text(
                                      suggestionList[index].subtitle ?? "",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: styleElements
                                          .captionThemeScalable(context)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: suggestionList[index].id != prefs.getInt(Strings.userId),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: GenericFollowUnfollowButton(
                              actionByObjectType:
                              prefs.getString("ownerType"),
                              actionByObjectId: prefs.getInt("userId"),
                              actionOnObjectType: "person",
                              actionOnObjectId: suggestionList[index].id,
                              engageFlag: AppLocalizations.of(context)
                                  .translate('follow'),
                              actionFlag: "F",
                              actionDetails: [],
                              personName: suggestionList[index].title ?? "",
                              callback: (isCallSuccess) {
                                refresh();
                              },
                            ),
                          ),
                        ),
                      ],
                    )),
              );
            } else {
              return FutureBuilder(
                future: fetchSuggestions(pageSuggetsions),
                builder: (BuildContext context,
                    AsyncSnapshot<SuggestionData> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      return CustomPaginator(context).loadingWidgetMaker();
                    case ConnectionState.done:
                      pageSuggetsions++;
                      suggestionList.addAll(snapshot.data.rows);
                      Future.microtask(() {
                        setState(() {});
                      });
                      return CustomPaginator(context).loadingWidgetMaker();
                    default:
                      return CustomPaginator(context).loadingWidgetMaker();
                  }
                },
              );
            }
          }, childCount: getItemsCountSuggestions()),
        ),
      );
    }
  }

  getConnections() {
    if (pageEnum_connections == PAGINATOR_ENUMS.LOADING) {
      return SliverToBoxAdapter(
        child: CustomPaginator(context).loadingWidgetMaker(),
      );
    } else if (pageEnum_connections == PAGINATOR_ENUMS.EMPTY) {
      return SliverToBoxAdapter(
        child: CustomPaginator(context).emptyListWidgetMaker(null),
      );
    } else {
      return SliverPadding(
        padding: EdgeInsets.only(left: 8, right: 8),
        sliver: SliverList(
          key: connectionSliverKey,
          delegate:
          SliverChildBuilderDelegate((BuildContext context, int index) {
            if (index < ConnectionsList.length) {
              return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    if(!isForward)
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (ctx) =>
                            new ChatHistoryPage(
                                type:"normal"
                                ,
                                conversationItem: null, connectionItem:ConnectionsList[index],socket: socket,callBack:callBack)));
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      ListTile(
                        leading: SizedBox(
                          height: 54,
                          width: 54,
                          child: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {

                              },
                              child: TricycleAvatar(
                                size: 52,
                                imageUrl: Utility().getUrlForImage(
                                    ConnectionsList[index].connectionProfileThumbnailUrl,
                                    RESOLUTION_TYPE.R64,
                                    SERVICE_TYPE.PERSON),
                              )),
                        ),
                        title: Text(ConnectionsList[index].connectionName ?? "",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: styleElements
                                .subtitle1ThemeScalable(context)),
                        subtitle: (ConnectionsList[index].connectionSubTitle !=
                            null)
                            ? Text(
                            ConnectionsList[index].connectionSubTitle ?? "",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: styleElements
                                .captionThemeScalable(context))
                            : null,

                         trailing:isForward? Checkbox(
                              activeColor:
                              HexColor(AppColors.appMainColor),
                              value: ConnectionsList[index].isSelected,
                              onChanged: (val) {
                                if (this.mounted) {
                                  setState(() {
                                    if (val ) {
                                      ConnectionsList[index].isSelected=true;

                                      setState(() {

                                      });
                                    } else {
                                      ConnectionsList[index].isSelected=false;
                                      setState(() {

                                      });
                                    }
                                  });
                                }
                              },
                            ):SizedBox(
                             height: 2,
                             width: 2,
                             child: Container()),
                      )
                    ],
                  ));
            } else {
              return FutureBuilder(
                future: fetchConnections(pageConnections),
                builder: (BuildContext context,
                    AsyncSnapshot<ConnectionListResponseEntity> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      return CustomPaginator(context).loadingWidgetMaker();
                    case ConnectionState.done:
                      pageConnections++;
                      ConnectionsList.addAll(snapshot.data.rows);
                      Future.microtask(() {
                        setState(() {});
                      });
                      return CustomPaginator(context).loadingWidgetMaker();
                    default:
                      return CustomPaginator(context).loadingWidgetMaker();
                  }
                },
              );
            }
          }, childCount: getItemsCountConnections()),
        ),
      );
    }
  }

  void initialcallConnections() async {

    ConnectionListEntity connectionListEntity= ConnectionListEntity();
    connectionListEntity.searchValue=searchVal;
    connectionListEntity.connectionCategory="contact";
    connectionListEntity.connectionOwnerType="person";
    connectionListEntity.connectionOwnerId=ownerId.toString();
    connectionListEntity.pageNumber=pageConnections+1;
    connectionListEntity.pageSize=50;
    var res = await Calls().call(jsonEncode(connectionListEntity), context, Config.GET_CONNECTIONS);
    var response = ConnectionListResponseEntity.fromJson(res);
    totalConnections = response.total;
    if (response.statusCode == Strings.success_code) {
      if (totalConnections > 0) {
        ConnectionsList.addAll(response.rows);
        setState(() {
          pageEnum_connections = PAGINATOR_ENUMS.SUCCESS;
          pageConnections++;
        });
      } else {
        setState(() {
          pageEnum_connections = PAGINATOR_ENUMS.EMPTY;
        });
      }
    } else {
      setState(() {
        pageEnum_connections = PAGINATOR_ENUMS.EMPTY;
      });
    }
  }

  int getItemsCountConnections() {
    if (totalConnections > ConnectionsList.length) {
      return ConnectionsList.length + 1;
    } else {
      return totalConnections;
    }
  }

  void initialcallSuggestions() async {
    final body = jsonEncode(
        {"type": "network", "page_size": 20, "page_number": pageSuggetsions + 1});
    var res = await Calls().call(body, context, Config.SUGGESTIONS);
    var response = SuggestionData.fromJson(res);
    totalSuggestions = response.total;
    if (response.statusCode == Strings.success_code) {
      if (response.total > 0) {
        suggestionList.addAll(response.rows);
        pageSuggetsions = 2;

        setState(() {
          pageEnum_suggestion = PAGINATOR_ENUMS.SUCCESS;
        });
      } else {
        setState(() {
          pageEnum_suggestion = PAGINATOR_ENUMS.EMPTY;
        });
      }
    } else {
      setState(() {
        pageEnum_suggestion = PAGINATOR_ENUMS.EMPTY;
      });
    }
  }

  int getItemsCountSuggestions() {
    if (totalSuggestions > suggestionList.length) {
      return suggestionList.length + 1;
    } else {
      return totalSuggestions;
    }
  }

  Future<ConnectionListResponseEntity> fetchConnections(int page) async {
    ConnectionListEntity connectionListEntity= ConnectionListEntity();
    connectionListEntity.searchValue=searchVal;
    connectionListEntity.connectionCategory="contact";
    connectionListEntity.connectionOwnerId=ownerId.toString();
    connectionListEntity.pageNumber=pageConnections;
    connectionListEntity.pageSize=50;
    var res = await Calls().call(jsonEncode(connectionListEntity), context,  Config.GET_CONNECTIONS);
    return ConnectionListResponseEntity.fromJson(res);
  }

  Future<SuggestionData> fetchSuggestions(int page) async {
    final body =
    jsonEncode({"type": "network", "page_size": 20, "page_number": page});

    var res = await Calls().call(body, context, Config.SUGGESTIONS);
    return SuggestionData.fromJson(res);
  }

  getPrefs() async {
    return await SharedPreferences.getInstance();
  }

  void refresh() {
    ConnectionsList.clear();
    suggestionList.clear();
    pageConnections = 0;
    pageSuggetsions = 0;
    initialcallConnections();
    initialcallSuggestions();
    // paginatorKey.currentState.changeState(resetState: true);
  }

  String getNames()
  {
    String selectedNames="";
    for(var item in ConnectionsList)
      {
        if(item.isSelected)
        selectedNames=selectedNames+(item.connectionName+",");
      }
    return selectedNames;

  }


  List<ConnectionItem> getSelectedUsers()
  {
    List<ConnectionItem> list=[];
    for(var item in ConnectionsList)
    {
      if(item.isSelected)
        list.add(item);
    }
    return list;
    
  }
}
