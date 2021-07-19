import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/commonComponents.dart';
import 'package:oho_works_app/components/customtabview.dart';
import 'package:oho_works_app/components/searchtypeCardComponent.dart';
import 'package:oho_works_app/components/tricycleemptywidget.dart';
import 'package:oho_works_app/enums/paginatorEnums.dart';
import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/models/custom_tab_maker.dart';
import 'package:oho_works_app/models/global_search/globalsearchmodels.dart';
import 'package:oho_works_app/ui/searchmodule/searchList.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalSearchPage extends StatefulWidget {
  final bool withAppBar;
  // final SharedPreferences prefs;

  GlobalSearchPage({this.withAppBar});

  _GlobalSearchPage createState() => _GlobalSearchPage();
}

class _GlobalSearchPage extends State<GlobalSearchPage>
    with SingleTickerProviderStateMixin {
  TextStyleElements styleElements;
  final SharedPreferences prefs = locator<SharedPreferences>();
  String searchVal;

  // _GlobalSearchPage({this.prefs});

  List<SearchTypeItem> persons = [];
  List<SearchTypeItem> institutions = [];
  List<SearchTypeItem> rooms =[];

  List<SearchTypeMasterModel> masterList = [];
  List<CustomTabBarMaker<SearchTypeListPage>> list = [];

  PAGINATOR_ENUMS pageEnums = PAGINATOR_ENUMS.SUCCESS;
  int _currentPosition = 3;
  TabController _tabController;

  bool isSearching = false;
  bool isTabSelected = false;

  GlobalKey<SearchTypeListState> personKey = GlobalKey();
  GlobalKey<SearchTypeListState> instituteKey = GlobalKey();
  GlobalKey<SearchTypeListState> roomsKey = GlobalKey();
  // Animation<Offset> animation;
  // AnimationController animationController;
  // FocusNode focusNode;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadPages());
    // focusNode = FocusNode();
    // animationController = AnimationController(
    //   vsync: this,
    //   duration: Duration(seconds: 2),
    // );
    // animation = Tween<Offset>(
    //   begin: Offset(0.0,-2.0),
    //   end: Offset(0.0, 0.0),
    // ).animate(CurvedAnimation(
    //   parent: animationController,
    //   curve: Curves.fastLinearToSlowEaseIn,
    // ));

    // Future<void>.delayed(Duration(seconds: 1), () {
    //   animationController.forward();
    // });
    // animationController.addStatusListener((status) {
    //   if(status == AnimationStatus.completed) {
    //     focusNode.requestFocus();
    //     // custom code here
    //   }
    // });
  }

  loadPages() async {
    list.clear();
    list.add(CustomTabBarMaker(
      statelessWidget: SearchTypeListPage(
        key: UniqueKey(),
        searchVal: searchVal,
        type: 'person',
      ),
      tabName: AppLocalizations.of(context).translate('people'),
    ));
    list.add(CustomTabBarMaker(
      statelessWidget: SearchTypeListPage(
        key: UniqueKey(),
        searchVal: searchVal,
        type: 'institution',
      ),
      tabName: AppLocalizations.of(context).translate('institution'),
    ));
    _tabController = TabController(vsync: this, length: list.length);
    _tabController.addListener(onPositionChange);
  }
  onPositionChange() {
    if (!_tabController.indexIsChanging && this.mounted) {
      setState(() {
        isTabSelected = true;
        _currentPosition = _tabController.index;
      });
    }
  }
  Widget getTabBarView() {
    return TabBarView(
      physics: NeverScrollableScrollPhysics(),
      controller: _tabController,
      children: List<Widget>.generate(list.length, (int index) {
        list[index].statelessWidget.searchVal = searchVal;
        return Center(
            child: list[index].statelessWidget);
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return
      SafeArea(
        child: Scaffold(
          appBar: (widget.withAppBar!=null && widget.withAppBar)?TricycleAppBar().getCustomAppBar(context, appBarTitle:AppLocalizations.of(context).translate('global_search_title') , onBackButtonPress: (){Navigator.pop(context);}):null,
          body: DefaultTabController(
            length: list.length,
            child: NestedScrollView(
                headerSliverBuilder: (BuildContext context,
                    bool innerBoxIsScrolled) {
                  return [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(top: 16.0),
                        child:Container(
                          height: 48,
                          margin: EdgeInsets.only(
                              left: 16, right: 16, top: 2, bottom: 12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                HexColor(AppColors.appColorWhite),
                                HexColor(AppColors.appColorWhite),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(30.0)),
                            boxShadow: [
                              CommonComponents().getShadowforBox_01_3()
                            ],
                          ),
                          child: Center(
                            child: Container(
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: TypeAheadField(
                                        suggestionsBoxDecoration: SuggestionsBoxDecoration(
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        animationDuration: Duration(seconds: 1),
                                        textFieldConfiguration: TextFieldConfiguration(
                                          style: styleElements.subtitle1ThemeScalable(context).copyWith(
                                            color: HexColor(AppColors.appColorBlack65)
                                          ),
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(top:12,left: 16),
                                              border: InputBorder.none,
                                              hintText: AppLocalizations.of(context).translate('search'),
                                              hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35)),
                                              prefixIcon: Padding(
                                                  padding: EdgeInsets.all(0.0),
                                                  child: Icon(Icons.search, color: HexColor(AppColors.appColorGrey500))),
                                            ),
                                            onSubmitted: (value){
                                              if(value!=null && value.trim()!="")
                                              {
                                                isSearching = true;
                                                searchVal = value;
                                                doSearch(value);
                                              }

                                            }
                                        ),
                                        suggestionsCallback: (
                                            String pattern) async {
                                          if (pattern.isEmpty) {
                                            GlobalSearchRequest payload = GlobalSearchRequest();
                                            payload.institutionId = prefs.getInt(Strings.instituteId);
                                            payload.personId = prefs.getInt(Strings.userId);
                                            payload.pageNumber=1;
                                            payload.pageSize=5;
                                            payload.searchType = 'person';
                                            var res =  await Calls().call( jsonEncode(payload), context, Config.GLOBAL_SEARCH_HISTORY);
                                            return GlobalSearchHistoryResponse.fromJson(res).rows;
                                          }else {
                                            return null;
                                          }
                                        },
                                        itemBuilder:(context,suggestion){
                                          GlobalSearchHistoryItem item = suggestion;
                                          return ListTile(
                                            leading: Container(
                                              margin: const EdgeInsets.only(
                                                right: 8,
                                              ),
                                              child: Icon(Icons.access_time_rounded),
                                            ),
                                            title: Text(item.searchVal),
                                          );
                                        },
                                        onSuggestionSelected:(suggestion){
                                          isSearching = true;
                                          searchVal = suggestion.searchVal;
                                          doSearch(suggestion.searchVal);
                                        },
                                      ),
                                    ),
                                  ],
                                )
                            ),
                          ),
                        ),
                      )
                    ),
                    SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(left:16.0,right:16.0),
                          child: Container(
                            color: HexColor(AppColors.appColorWhite),
                            child: Card(
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: HexColor(AppColors.appMainColor10),
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(4.0),
                                          topLeft: Radius.circular(4.0))),
                                  child: Container(
                                    margin: const EdgeInsets.all(16),
                                    child: Text(
                                      AppLocalizations.of(context)
                                          .translate("verified_person"),
                                      textAlign: TextAlign.center,
                                      style: styleElements
                                          .bodyText2ThemeScalable(context)
                                          .copyWith(color: HexColor(AppColors.appColorBlack85)),
                                    ),
                                  ),
                                )),
                          ),
                        )
                    ),
                    if(isSearching) SliverToBoxAdapter(
                      child: Visibility(
                          visible: list.length > 0 ? true : false,
                          child: Container(
                            margin: const EdgeInsets.only(
                              left: 0,
                              right: 0,
                            ),
                            alignment: Alignment.center,
                            child: TabBar(
                              labelColor: HexColor(AppColors.appColorWhite),
                              indicatorColor: HexColor(AppColors.appColorTransparent),
                              controller: _tabController,
                              labelPadding: EdgeInsets.symmetric(horizontal: 2.0),
                              isScrollable: false,
                              tabs: List<Widget>.generate(list.length, (int index) {
                                return TricycleTabButton(
                                  tabName: list[index].tabName,
                                  isActive: index == _currentPosition,
                                  onPressed: () {
                                    _tabController.animateTo(index);
                                    // if (this.mounted) {
                                    //   setState(() {
                                    //     isTabSelected = true;
                                    //     _currentPosition = index;
                                    //   });
                                    // }
                                  },
                                );
                              }),
                            ),
                          )),
                    ),
                  ];
                },
                body: pageEnums == PAGINATOR_ENUMS.LOADING ?
                Center(
                  child: CustomPaginator(context).loadingWidgetMaker(),
                )
                    : isTabSelected ?
               getTabBarView()
                    :

                masterList.isNotEmpty?

                ListView.builder(
                  itemCount: masterList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return SearchTypeCard(
                      prefs: prefs,
                      typeList: masterList[index].list,
                      type: masterList[index].type,
                      title: masterList[index].title,
                      seeMoreCallback: (type) {
                        setState(() {
                          if (type == 'person') {
                            _tabController.animateTo(0);
                            isTabSelected = true;
                            _currentPosition = 0;
                          } else {
                            _tabController.animateTo(1);
                            isTabSelected = true;
                            _currentPosition = 1;
                          }
                        });
                      },
                    );
                  },): TricycleEmptyWidget(
                  message: AppLocalizations.of(context)
                      .translate('no_data'),
                )
            ),
          ),
        ),
      );
  }

  void doSearch(String value) async {
    setState(() {
      pageEnums = PAGINATOR_ENUMS.LOADING;
    });
    GlobalSearchRequest payload = GlobalSearchRequest();
    payload.institutionId = prefs.getInt(Strings.instituteId);
    payload.searchType = 'person';
    payload.personId = prefs.getInt(Strings.userId);
    payload.searchPage = 'common';
    payload.searchVal = value;
    payload.entityType = 'all';
    payload.pageNumber = 1;
    payload.pageSize = 10;
    var body = jsonEncode(payload);
    var res = await Calls().call(body, context, Config.GLOBAL_SEARCH);
    var response = GlobalSearchResponse.fromJson(res);
    pageEnums = PAGINATOR_ENUMS.SUCCESS;
    if (response.statusCode == Strings.success_code) {
      setState(() {
        masterList.clear();
        if(response.rows!=null && response.rows.person!=null && response.rows.person.isNotEmpty)
          {
            masterList.add(SearchTypeMasterModel(
                type: 'person',
                title: 'People',
                list: response.rows.person
            ));
          }
        if(response.rows!=null && response.rows.institution!=null && response.rows.institution.isNotEmpty)
        {
          masterList.add(SearchTypeMasterModel(
              type: 'institution',
              title: 'Institutions',
              list: response.rows.institution
          ));
        }

      });
    }
  }
}