
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/appbar_with_profile%20_image.dart';
import 'package:oho_works_app/components/customtabview.dart';
import 'package:oho_works_app/crm_module/payment_type_sheet.dart';
import 'package:oho_works_app/crm_module/product_list_page.dart';
import 'package:oho_works_app/crm_module/quantity_and_price_bottomSheet.dart';
import 'package:oho_works_app/e_learning_module/ui/selected_lesson_list.dart';
import 'package:oho_works_app/models/custom_tab_maker.dart';
import 'package:oho_works_app/profile_module/pages/common__page_network.dart';
import 'package:oho_works_app/profile_module/pages/profile_page.dart';
import 'package:oho_works_app/regisration_module/welcomePage.dart';
import 'package:oho_works_app/ui/LearningModule/lessons_list_page.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'CompanyAndCustomerPage.dart';
import 'crm_list_page.dart';



// ignore: must_be_immutable
class SelectItemsPage extends StatefulWidget {

  String? title;
  bool hideTabs;
  String? type;
  int? id;
  int currentTab;
  String? pageTitle;
  Null Function() callback;
  String? imageUrl;
  final bool hideAppBar;
  bool isEdit=false;
  int? selectedTab;
  final bool? isSwipeDisabled;
  String? from;
  SelectItemsPage({
    Key? key,
    this.hideAppBar=false,
    required this.type,
    this.isEdit=false,
    required this.id,
    this.selectedTab,
    this.from,
    this.hideTabs=false,
    this.isSwipeDisabled,
    required this.pageTitle,
    required this.callback,
    required this.currentTab,
    required this.imageUrl,
    this.title
  }) : super(key: key);

  SelectItemsPageState createState() =>
      SelectItemsPageState(type, id, pageTitle, callback, currentTab,imageUrl);
}

class SelectItemsPageState extends State<SelectItemsPage> with SingleTickerProviderStateMixin {
  List<CustomTabMaker> list = [];
  late TabController _tabController;
  TextStyleElements? styleElements;
  String? type;
  int? id;
  late SharedPreferences prefs;
  String? ownerType;
  int? ownerId;
  int _currentPosition=0;
  String? pageTitle;
  Null Function() callback;
  String? imageUrl;


  SelectItemsPageState(this.type, this.id,this.pageTitle, this.callback, this._currentPosition,this.imageUrl);

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

    list.add(new CustomTabMaker(statelessWidget: new ProductListPage("S",widget.isEdit,widget.from), tabName: AppLocalizations.of(context)!.translate('products')));
    list.add(new CustomTabMaker(statelessWidget: new ProductListPage("O",widget.isEdit,widget.from), tabName: AppLocalizations.of(context)!.translate('services')));
    list.add(new CustomTabMaker(statelessWidget: new ProductListPage("I",widget.isEdit,widget.from), tabName: AppLocalizations.of(context)!.translate('inventory')));
     setState(() {
      _tabController = TabController(vsync: this, length: list.length);
      _tabController.addListener(onPositionChange);
    });
  }

  void  setCurrentPage(int page)
  {
    setState(() {
      _currentPosition=page;
    });

  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);

    return SafeArea(
      child:
    Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: HexColor(AppColors.appColorBackground),

        appBar: appAppBar().getCustomAppBar(context,
            centerTitle:false,
            actions: [
              InkWell(

                onTap: (){
                  showModalBottomSheet<void>(
                    context: context,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
                    ),

                    isScrollControlled: true,
                    builder: (context) {
                      return PaymentSheet(
                        prefs: prefs,
                          selectedTab:widget.selectedTab,
                        onClickCallback: (value) {

                        },
                      );
                      // return BottomSheetContent();
                    },
                  );
                },
                child: Visibility(
                  visible: widget.from!=null && widget.from!="home",
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 2.0, left: 16.0, right: 16.0),
                    child: Row(

                      children: [

                        Text(AppLocalizations.of(context)!
                            .translate('next'),
                          textAlign: TextAlign.center,
                          style: styleElements!
                              .subtitle1ThemeScalable(context)
                              .copyWith(color: HexColor(AppColors.appMainColor)),)
                      ],
                    ),
                  ),
                ),
              ),
              _simplePopup()
            ],
            appBarTitle: widget.title!,
            onBackButtonPress: (){  Navigator.pop(context);}),



        body: DefaultTabController(
          length: list.length,
          child: CustomTabView(
            isTabVisible:true,
            isSwipeDisabled: false,
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
      )
    );
  }
  Widget _simplePopup() {
    return PopupMenuButton(
      icon: Icon(
        Icons.segment,
        size: 30,
        color: HexColor(AppColors.appColorBlack65),
      ),
      padding: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: HexColor(AppColors.appColorBackground),
      itemBuilder: (context) => LessonDropMenu(context: context).menuList,
      onSelected: (dynamic value) {
        switch (value) {
          case 'drafted':
            {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                    return SelectedLessonList(
                      callBack: () {


                      },
                      isBookmark: false,
                      isDrafted: true,
                      isOwnPost: true,
                    );
                  }));
              break;
            }

          case 'created_by_me':
            {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                    return SelectedLessonList(
                      isBookmark: false,
                      isOwnPost: true,
                    );
                  }));
              break;
            }
          case 'bookmark':
            {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                    return SelectedLessonList(
                      isBookmark: true,
                      isOwnPost: false,
                    );
                  }));
              break;
            }

          case 'learning':
            {  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
              return WelComeScreen(
                institutionIdtoDelete: prefs.getInt(Strings.instituteId),
                isEdit: true,
              );
            })).then((value){
              if(value!=null && value){

              }
            });
            break;
            }
          default:
            {
              break;
            }
        }
      },
    );
  }
  String getPageTitle(){
    var vals= pageTitle!.split(' ');
    if(vals.length>0)
      return vals[0];
    else
      return '';
  }
}

