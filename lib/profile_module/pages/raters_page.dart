
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/customtabview.dart';
import 'package:oho_works_app/models/base_res.dart';
import 'package:oho_works_app/models/custom_tab_maker.dart';
import 'package:oho_works_app/profile_module/pages/profile_page.dart';
import 'package:oho_works_app/profile_module/pages/raters_list.dart';
import 'package:oho_works_app/profile_module/pages/reviews_page.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';




// ignore: must_be_immutable
class RatersPage extends StatefulWidget {
  String? imageUrl;
  String? name;
  int? id;
  String ratingType;
  double? previousRating;
  int? ratingId;
  CommonCardData? data;
  Null Function()? callback;
  int? ownerId;
  String? ownerType;
  RatersPage({Key? key, required this.ratingType, this.id,this.imageUrl,this.name,this.previousRating,this.ratingId,this.data,this.callback,this.ownerType,this.ownerId}) : super(key: key);
  @override
  _RatersPage createState() => _RatersPage(imageUrl,name,id,previousRating,ratingId,ratingType,data,callback);



}

class _RatersPage extends State<RatersPage> with SingleTickerProviderStateMixin {
  List<CustomTabMaker> list = [];
  late TabController _tabController;
  TextStyleElements? styleElements;
  String? type;
  int? id;
  Null Function()? callback;
  late SharedPreferences prefs;
  String? ownerType;
  int? ownerId;
  int _currentPosition=0;
  String? pageTitle;
  String? imageUrl;
  String? name;
  String ratingType;
  double? previousRating;
  int? ratingId;
  CommonCardData? data;
  _RatersPage(this.imageUrl, this.name, this.id,this.previousRating,this.ratingId,this.ratingType,this.data,this.callback);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => setSharedPreferences());
  }

  onPositionChange() {
    if (!_tabController.indexIsChanging && this.mounted) {
      setState(() {
        _currentPosition = _tabController.index;
      });
    }
  }

  void setSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    ownerType=prefs.getString("ownerType");
    ownerId=prefs.getInt("userId");
    loadPages();
  }
  loadPages() {
    if(ratingType!='post') {
      list.add(CustomTabMaker(
          statelessWidget: ReviewsPage(pageTitle, ratingType, id, callback),
          tabName: "Reviews"));
    }
    list.add(new CustomTabMaker(statelessWidget: new RatersListPage(1,id,ratingType,callback,ownerId: widget.ownerId,ownerType: widget.ownerType,isProfile: ratingType!='post',), tabName: "1⭐"));
    list.add(new CustomTabMaker(statelessWidget: new RatersListPage(2,id,ratingType,callback,ownerId: widget.ownerId,ownerType: widget.ownerType,isProfile: ratingType!='post',), tabName: "2⭐"));
    list.add(new CustomTabMaker(statelessWidget: new RatersListPage(3,id,ratingType,callback,ownerId: widget.ownerId,ownerType: widget.ownerType,isProfile: ratingType!='post'), tabName: "3⭐"));
    list.add(new CustomTabMaker(statelessWidget:new  RatersListPage(4,id,ratingType,callback,ownerId: widget.ownerId,ownerType: widget.ownerType,isProfile: ratingType!='post'), tabName: "4⭐"));
    list.add(new CustomTabMaker(statelessWidget:new  RatersListPage(5,id,ratingType,callback,ownerId: widget.ownerId,ownerType: widget.ownerType,isProfile: ratingType!='post'), tabName: "5⭐"));
    setState(() {
      _tabController = TabController(vsync: this, length: list.length);
      _tabController.addListener(onPositionChange);
    });
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: HexColor(AppColors.appColorBackground),
        appBar: appAppBar().getCustomAppBar(context,
            appBarTitle: AppLocalizations.of(context)!.translate('network'),
            onBackButtonPress: () {
              Navigator.pop(context);

            }),
        body: DefaultTabController(
          length: list.length,
          child: CustomTabView(
            marginTop:const EdgeInsets.only(top:16.0 ),
            currentPosition: _currentPosition,
            itemCount: list!=null && list.isNotEmpty?list.length:0,
            tabBuilder: (context, index) => appTabButton(
              onPressed: () {
                setState(() {
                  _currentPosition = index;
                });
              },
              tabName: list[index].tabName,
              isActive: index == _currentPosition,
            ),
            pageBuilder: (context, index) =>
                Center(child: list[index].statelessWidget),
            onPositionChange: (index) {
              setState(() {
                _currentPosition = index!;
              });
            },
            onScroll: (position) => print('$position'),
          ),
        ),
      ),
    );
  }
}

