import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/tricycle_find_card.dart';
import 'package:oho_works_app/components/tricycle_user_list_tile.dart';
import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/ui/searchmodule/searchList.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FindPage extends StatefulWidget{
  @override
  FindPageState createState() => FindPageState();
}
class FindPageState extends State<FindPage>{
  SharedPreferences? prefs = locator<SharedPreferences>();
  late TextStyleElements styleElements;
  bool isSearching = false;
  GlobalKey<SearchTypeListState> searchKey = GlobalKey();
  String? searchVal;
  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return SafeArea(
      child: Scaffold(

        appBar: TricycleAppBar().getCustomAppBarWithSearch(
            context,
            appBarTitle: AppLocalizations.of(context)!.translate('find'),
            onBackButtonPress: (){Navigator.pop(context);},
            onSearchValueChanged: (value){
              searchVal = value;
              if(isSearching){
                searchKey.currentState!.searchVal = searchVal;
                searchKey.currentState!.refresh();
              }
              isSearching = value.isNotEmpty;
            },
          actions: [
            Icon(
                Icons.segment,
                size: 32,
                color: HexColor(AppColors.appColorBlack85),
              ),
          ]
        ),


        body:
            isSearching
                ? SearchTypeListPage(
              key: searchKey,
              searchVal: searchVal,
              type: 'room',
            )
                :CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: TricycleFindCard(
                title:"Who do you want to study together?",
                subtitle:"Search for friends who can support you to learn together",
                image:  Image.asset('assets/appimages/report_content_icon.png',height: 150,width: 150,),
                color: HexColor("#F8FEF2"),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(AppLocalizations.of(context)!.translate('recently_searhced'),
                style: styleElements.subtitle1ThemeScalable(context).copyWith(
                  fontWeight: FontWeight.bold
                ),),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index){
                    return TricycleUserListTile(
                      imageUrl: Config.BASE_URL + prefs!.getString(Strings.profileImage)!,
                      isFullImageUrl: true,
                      title: 'Kunal Manocha',
                      subtitle1: 'Okay ji title',
                      padding: EdgeInsets.only(top:12,bottom: 12,left: 12,right: 12),
                      margin: EdgeInsets.only(left: 8,right: 8),
                      decoration: BoxDecoration(
                        color: HexColor(AppColors.appColorWhite),
                        borderRadius: BorderRadius.only(
                          topLeft: (index == 0)?Radius.circular(12):Radius.circular(0),
                          topRight: (index == 0)?Radius.circular(12):Radius.circular(0),
                          bottomLeft: (index == 4)?Radius.circular(12):Radius.circular(0),
                          bottomRight: (index == 4)?Radius.circular(12):Radius.circular(0),
                        )
                      ),
                    );
                  },
                childCount: 5
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(AppLocalizations.of(context)!.translate('suggested_connections'),
                style: styleElements.subtitle1ThemeScalable(context).copyWith(
                  fontWeight: FontWeight.bold
                ),),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index){
                    return TricycleUserListTile(
                      imageUrl: Config.BASE_URL + prefs!.getString(Strings.profileImage)!,
                      isFullImageUrl: true,
                      title: 'Kunal Manocha',
                      subtitle1: 'Okay ji title',
                      padding: EdgeInsets.only(top:12,bottom: 12,left: 12,right: 12),
                      margin: EdgeInsets.only(left: 8,right: 8),
                      decoration: BoxDecoration(
                          color: HexColor(AppColors.appColorWhite),
                          borderRadius: BorderRadius.only(
                            topLeft: (index == 0)?Radius.circular(12):Radius.circular(0),
                            topRight: (index == 0)?Radius.circular(12):Radius.circular(0),
                            bottomLeft: (index == 4)?Radius.circular(12):Radius.circular(0),
                            bottomRight: (index == 4)?Radius.circular(12):Radius.circular(0),
                          )
                      ),
                    );
                  },
                  childCount: 5
              ),
            ),
          ],
        )
      ),
    );
  }

}