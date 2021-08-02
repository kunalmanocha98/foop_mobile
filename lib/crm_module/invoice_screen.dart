import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/appProgressButton.dart';
import 'package:oho_works_app/components/app_chat_footer.dart';
import 'package:oho_works_app/components/app_user_list_tile.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/app_buttons.dart';
import 'package:oho_works_app/components/appAvatar.dart';
import 'package:oho_works_app/components/paginator.dart';
import 'package:oho_works_app/components/postcardactionbuttons.dart';
import 'package:oho_works_app/crm_module/payment_type_sheet.dart';
import 'package:oho_works_app/crm_module/product_inventry_services_page.dart';
import 'package:oho_works_app/e_learning_module/ui/chapter_lessons_page.dart';
import 'package:oho_works_app/e_learning_module/ui/selected_lesson_list.dart';
import 'package:oho_works_app/enums/event_status_code.dart';
import 'package:oho_works_app/enums/resolutionenums.dart';
import 'package:oho_works_app/enums/serviceTypeEnums.dart';
import 'package:oho_works_app/generic_libraries/generic_comment_review_feedback.dart';
import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/mixins/editProfileMixin.dart';
import 'package:oho_works_app/mixins/someCommonMixins.dart';
import 'package:oho_works_app/models/CalenderModule/event_create_models.dart';
import 'package:oho_works_app/models/Rooms/memberAdd.dart';
import 'package:oho_works_app/models/Rooms/roomlistmodels.dart';
import 'package:oho_works_app/models/campus_talk/host_list_models.dart';
import 'package:oho_works_app/models/review_rating_comment/noteslistmodel.dart';
import 'package:oho_works_app/regisration_module/welcomePage.dart';
import 'package:oho_works_app/ui/BottomSheets/CreateNewSheet.dart';
import 'package:oho_works_app/ui/BottomSheets/select_host_sheet.dart';
import 'package:oho_works_app/ui/CalenderModule/calender_view_page.dart';
import 'package:oho_works_app/ui/CalenderModule/event_detail_page.dart';
import 'package:oho_works_app/ui/CalenderModule/host_list_page.dart';
import 'package:oho_works_app/ui/LearningModule/lessons_list_page.dart';
import 'package:oho_works_app/ui/RoomModule/room_privacy_type_selection_widget.dart';
import 'package:oho_works_app/ui/RoomModule/select_topic_room_widget.dart';
import 'package:oho_works_app/ui/commentItem.dart';

import 'package:oho_works_app/ui/dialogs/cancel_dilog.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/Transitions/transitions.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:oho_works_app/utils/utility_class.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bottom_sheet_address.dart';
import 'botton_sheet_create_customer.dart';
import 'contact_detailBottom_sheet.dart';



class InvoiceOrderPage extends StatefulWidget {
  final String type;
  final int standardEventId;
  final String? title;
  final String? ownerName;
  final String? ownerType;
  final String? ownerImage;
  final int? ownerId;
  final RoomListItem? roomItem;
  final Function? refreshCallBack;
  InvoiceOrderPage({
    required this.type,
    required this.standardEventId,
    this.title,
    this.ownerId,
    this.ownerName,
    this.ownerImage,
    this.refreshCallBack,
    this.ownerType,
    this.roomItem
  });

  @override
  InvoiceOrderPageState createState() =>
      InvoiceOrderPageState(type: type, standardEventId: standardEventId);
}

class InvoiceOrderPageState extends State<InvoiceOrderPage> {
  String type;
  String? title;
  final int standardEventId;

  InvoiceOrderPageState({required this.type, required this.standardEventId,});
  GlobalKey<appChatFooterState>? chatFooterKey = GlobalKey();
  late TextStyleElements styleElements;
  int selectedStartEpoch = 0;
  String selectedStartDate = "Start date";
  int selectedEndEpoch = 0;
  String selectedEndDate = "End date";
  int selectedDueEpoch = 0;
  String selectedDueDate = "Due date";
  TimeOfDay? selectedStartTimeOfDay;
  String selectedStartTime = 'Start Time';
  TimeOfDay? selectedEndTimeOfDay;
  String selectedEndTime = 'End Time';
  String? selectedPrivacyType;

  SharedPreferences? prefs = locator<SharedPreferences>();
  GlobalKey<SelectRoomTopicWidgetState> roomTopicKey = GlobalKey();
  GlobalKey<RoomPrivacyTypeWidgetState> privacyTypeKey = GlobalKey();
  GlobalKey<FormState> formKey = GlobalKey();
  bool isOnline = false;
  bool startsNow = false;
  List<MembersItem>? selectedMembersItem = [];

  String? ownerImage;
  String? ownerName;
  int? ownerId;
  String? ownerType = 'person';

  @override
  void initState() {
    ownerName = widget.ownerName ?? prefs!.getString(Strings.userName);
    ownerId = widget.ownerId ?? prefs!.getInt(Strings.userId);
    ownerType = widget.ownerType ?? 'person';
    ownerImage = widget.ownerImage ?? prefs!.getString(Strings.profileImage);



    super.initState();
  }
  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
      ),

      isScrollControlled: true,
      builder: (context) {
        return CustomerContactDetailSheet(
          prefs: prefs,
          onClickCallback: (value) {

          },
        );
        // return BottomSheetContent();
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);


    return SafeArea(
        child: Scaffold(
            appBar: appAppBar().getCustomAppBar(context,
                centerTitle: false,
                actions: [


                  appTextButton(
                    onPressed: () {
                      showModalBottomSheet<void>(
                        context: context,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
                        ),
                        isScrollControlled: true,
                        builder: (context) {
                          return BottomSheetAddress(
                            prefs: prefs,
                            onClickCallback: (value) {

                            },
                          );
                          // return BottomSheetContent();
                        },
                      );
                    },
                    child: InkWell(
                      onTap: (){
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CancelOrderDilog(
                                  title:  "Cancel Order",
                                  subTile:  "Are you sure youy want to cancel this order",
                                  description:  "Order Id:097980",
                                  callBack:(isYes){}
                              );
                            });
                      },
                      child: Wrap(
                        direction: Axis.horizontal,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            "Close",
                            style: styleElements
                                .subtitle2ThemeScalable(context)
                                .copyWith(color: HexColor(AppColors.appMainColor)),
                          ),

                        ],
                      ),
                    ),
                    shape: CircleBorder(),
                  ),


                  _simplePopup()
                ],
                appBarTitle: "Order Details",
                onBackButtonPress: () {
                  Navigator.pop(context);
                }),
            body: Column(
              children: [  Expanded(
                child: Form(
                  key: formKey,
                  child: ListView(
                    shrinkWrap: true,
                    children: [

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [

                          Expanded(
                            child: Card(
                                child:
                                Padding(
                                  padding: const EdgeInsets.only(left:8.0,right: 8.0,top: 8,bottom: 8),
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text("To be received",style: styleElements
                                            .subtitle2ThemeScalable(
                                            context)
                                            .copyWith(
                                            color: HexColor(
                                                AppColors
                                                    .appColorBlack35),
                                            fontWeight:
                                            FontWeight
                                                .bold),),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Text("200",style: styleElements
                                            .headlinecustomThemeScalable(
                                            context)
                                            .copyWith(
                                            color: HexColor(
                                                AppColors
                                                    .appColorBlack85),
                                            fontWeight:
                                            FontWeight
                                                .bold),),
                                      )
                                    ],

                                  ),
                                )
                            ),
                          ),

                          Expanded(
                            child: Card(
                                child:
                                Padding(
                                  padding: const EdgeInsets.only(left:8.0,right: 8.0,top: 8,bottom: 8),
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text("Received",style: styleElements
                                            .subtitle2ThemeScalable(
                                            context)
                                            .copyWith(
                                            color: HexColor(
                                                AppColors
                                                    .appColorBlack35),
                                            fontWeight:
                                            FontWeight
                                                .bold),),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Text("200",style: styleElements
                                            .headlinecustomThemeScalable(
                                            context)
                                            .copyWith(
                                            color: HexColor(
                                                AppColors
                                                    .appColorBlack85),
                                            fontWeight:
                                            FontWeight
                                                .bold),),
                                      )
                                    ],

                                  ),
                                )
                            ),
                          ),

                          Expanded(
                            child: Card(
                                child:
                                Padding(
                                  padding: const EdgeInsets.only(left:8.0,right: 8.0,top: 8,bottom: 8),
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text("Yet to be received",style: styleElements
                                            .subtitle2ThemeScalable(
                                            context)
                                            .copyWith(
                                            color: HexColor(
                                                AppColors
                                                    .appColorBlack35),
                                            fontWeight:
                                            FontWeight
                                                .bold),),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Text("20000",style: styleElements
                                            .headlinecustomThemeScalable(
                                            context)
                                            .copyWith(
                                            color: HexColor(
                                                AppColors
                                                    .appColorBlack85),
                                            fontWeight:
                                            FontWeight
                                                .bold),),
                                      )
                                    ],

                                  ),
                                )
                            ),
                          ),
                        ],
                      ),

                      appListCard(
                        padding: EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 4),
                        child:    Column(
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.all(0),

                              title:  Padding(
                                padding: const EdgeInsets.only(top:8.0),
                                child: Text(
                                  "Order Date",
                                  style: styleElements.subtitle1ThemeScalable(context),
                                ),
                              )
                              ,


                              trailing:     InkWell(
                                onTap: (){

                                  Navigator.push(context, appRouteSlideRight(page: CalenderViewPage(selectedDate: DateTime.now(),))).then((value){
                                    if(value!=null){
                                      setState(() {

                                      });
                                    }
                                  });
                                },
                                child: Text(
                                  "24 July 2021",
                                  style: styleElements.subtitle1ThemeScalable(context).copyWith(color: HexColor(AppColors.appColorBlack65),fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.all(0),

                              title:  Padding(
                                padding: const EdgeInsets.only(top:8.0),
                                child: Text(
                                  "Order Id",
                                  style: styleElements.subtitle1ThemeScalable(context),
                                ),
                              )
                              ,


                              trailing:     InkWell(
                                onTap: (){

                                  Navigator.push(context, appRouteSlideRight(page: CalenderViewPage(selectedDate: DateTime.now(),))).then((value){
                                    if(value!=null){
                                      setState(() {

                                      });
                                    }
                                  });
                                },
                                child: Text(
                                  "41654689086667",
                                  style: styleElements.subtitle1ThemeScalable(context).copyWith(color: HexColor(AppColors.appColorBlack65),fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.all(0),

                              title:  Padding(
                                padding: const EdgeInsets.only(top:8.0),
                                child: Text(
                                  "Invoice Id",
                                  style: styleElements.subtitle1ThemeScalable(context),
                                ),
                              )
                              ,


                              trailing:     InkWell(
                                onTap: (){

                                  Navigator.push(context, appRouteSlideRight(page: CalenderViewPage(selectedDate: DateTime.now(),))).then((value){
                                    if(value!=null){
                                      setState(() {

                                      });
                                    }
                                  });
                                },
                                child: Text(
                                  "88778",
                                  style: styleElements.subtitle1ThemeScalable(context).copyWith(color: HexColor(AppColors.appColorBlack65),fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),

                      appCard(


                        child: Column(

                          children: [

                            Row
                              (
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,

                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top:16.0),
                                  child: Text(
                                    "Billing Address",
                                    style: styleElements.subtitle1ThemeScalable(context).copyWith(fontWeight: FontWeight.bold),
                                  ),),

                                Padding(
                                  padding: const EdgeInsets.only(top:16.0),
                                  child: InkWell(
                                    onTap: (){
                                      showModalBottomSheet<void>(
                                        context: context,

                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
                                        ),

                                        isScrollControlled: true,
                                        builder: (context) {
                                          return BottomSheetAddress(
                                            prefs: prefs,
                                            onClickCallback: (value) {

                                            },
                                          );
                                          // return BottomSheetContent();
                                        },
                                      );
                                    },
                                    child: Text(
                                      "Edit",
                                      style: styleElements.subtitle1ThemeScalable(context).copyWith(color: HexColor(AppColors.appMainColor)),
                                    ),
                                  ),)



                              ],
                            ),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right:16.0,top:16),
                                  child: appAvatar(
                                    key: UniqueKey(),
                                    imageUrl:
                                    ownerImage ?? prefs!.getString(Strings.profileImage),
                                    isClickable: false,
                                    service_type: ownerType == 'person'
                                        ? SERVICE_TYPE.PERSON
                                        : ownerType == 'room'
                                        ? SERVICE_TYPE.ROOM
                                        : SERVICE_TYPE.INSTITUTION,
                                    resolution_type: RESOLUTION_TYPE.R64,
                                    size: 40,
                                  ),
                                ),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top:16.0),
                                      child: Text(
                                          "Business Name",
                                          style: styleElements.subtitle1ThemeScalable(context)
                                      ),),
                                    Padding(
                                      padding: const EdgeInsets.only(top:16.0),
                                      child: Text(
                                        "Address 1",
                                        style: styleElements.subtitle1ThemeScalable(context).copyWith(color: HexColor(AppColors.appColorBlack35)),
                                      ),),
                                    Padding(
                                      padding: const EdgeInsets.only(top:16.0),
                                      child: Text(
                                        "address 2",
                                        style: styleElements.subtitle1ThemeScalable(context).copyWith(color: HexColor(AppColors.appColorBlack35)),
                                      ),),
                                    Padding(
                                      padding: const EdgeInsets.only(top:16.0,bottom: 16),
                                      child: Text(
                                        "City",
                                        style: styleElements.subtitle1ThemeScalable(context).copyWith(color: HexColor(AppColors.appColorBlack35)),
                                      ),)
                                  ],
                                )



                              ],
                            )

                          ],
                        ),



                      ),

                      appCard(


                        child: Column(

                          children: [

                            Row
                              (
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,

                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top:16.0),
                                  child: Text(
                                    "Shipping Address",
                                    style: styleElements.subtitle1ThemeScalable(context).copyWith(fontWeight: FontWeight.bold),
                                  ),),
                                Padding(
                                  padding: const EdgeInsets.only(top:16.0),
                                  child: InkWell(
                                    onTap: (){
                                      showModalBottomSheet<void>(
                                        context: context,

                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
                                        ),

                                        isScrollControlled: true,
                                        builder: (context) {
                                          return BottomSheetAddress(
                                            prefs: prefs,
                                            onClickCallback: (value) {

                                            },
                                          );
                                          // return BottomSheetContent();
                                        },
                                      );
                                    },
                                    child: Text(
                                      "Edit",
                                      style: styleElements.subtitle1ThemeScalable(context).copyWith(color: HexColor(AppColors.appMainColor)),
                                    ),
                                  ),)



                              ],
                            ),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right:16.0,top: 16),
                                  child: appAvatar(
                                    key: UniqueKey(),
                                    imageUrl:
                                    ownerImage ?? prefs!.getString(Strings.profileImage),
                                    isClickable: false,
                                    service_type: ownerType == 'person'
                                        ? SERVICE_TYPE.PERSON
                                        : ownerType == 'room'
                                        ? SERVICE_TYPE.ROOM
                                        : SERVICE_TYPE.INSTITUTION,
                                    resolution_type: RESOLUTION_TYPE.R64,
                                    size: 40,
                                  ),
                                ),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top:16.0),
                                      child: Text(
                                          "Business Name",
                                          style: styleElements.subtitle1ThemeScalable(context)
                                      ),),
                                    Padding(
                                      padding: const EdgeInsets.only(top:16.0),
                                      child: Text(
                                        "Address 1",
                                        style: styleElements.subtitle1ThemeScalable(context).copyWith(color: HexColor(AppColors.appColorBlack35)),
                                      ),),
                                    Padding(
                                      padding: const EdgeInsets.only(top:16.0),
                                      child: Text(
                                        "address 2",
                                        style: styleElements.subtitle1ThemeScalable(context).copyWith(color: HexColor(AppColors.appColorBlack35)),
                                      ),),
                                    Padding(
                                      padding: const EdgeInsets.only(top:16.0,bottom: 16),
                                      child: Text(
                                        "City",
                                        style: styleElements.subtitle1ThemeScalable(context).copyWith(color: HexColor(AppColors.appColorBlack35)),
                                      ),)
                                  ],
                                )



                              ],
                            )

                          ],
                        ),



                      ),

                      appListCard(
                        padding: EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top:8.0),
                              child: Text(
                                "Contact Member",
                                style: styleElements.subtitle1ThemeScalable(context),
                              ),
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.all(0),
                              leading: GestureDetector(
                                onLongPress: () {
                                  _showSelectorBottomSheet(context);
                                },
                                child:   appAvatar(
                                  key: UniqueKey(),
                                  imageUrl:
                                  ownerImage ?? prefs!.getString(Strings.profileImage),
                                  isClickable: false,
                                  service_type: ownerType == 'person'
                                      ? SERVICE_TYPE.PERSON
                                      : ownerType == 'room'
                                      ? SERVICE_TYPE.ROOM
                                      : SERVICE_TYPE.INSTITUTION,
                                  resolution_type: RESOLUTION_TYPE.R64,
                                  size: 40,
                                ),
                              ),
                              title:  Padding(
                                padding: const EdgeInsets.only(top:8.0),
                                child: Text(
                                  ownerName ?? prefs!.getString(Strings.userName)!,
                                  style: styleElements.subtitle1ThemeScalable(context),
                                ),
                              )
                              ,
                              subtitle:  Text(
                                'Department',
                                style: styleElements.captionThemeScalable(context),
                              ),

                              trailing: Icon(Icons.keyboard_arrow_right),
                            ),
                          ],
                        ),
                      ),

                      appCard(
                        padding: EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [

                            ListTile(
                              contentPadding: EdgeInsets.all(0),

                              title:  Padding(
                                padding: const EdgeInsets.only(top:8.0),
                                child: Text(
                                  "Items",
                                  style: styleElements.subtitle1ThemeScalable(context),
                                ),
                              )
                              ,


                              trailing:  Padding(
                                padding: const EdgeInsets.only(right:8.0),
                                child:  InkWell(
                                  onTap: (){


                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SelectItemsPage(
                                              id: 2,
                                              type: "person",
                                              hideTabs:true,
                                              isEdit:true,
                                              isSwipeDisabled:true,
                                              hideAppBar: true,
                                              currentTab: 0,
                                              pageTitle: "",
                                              imageUrl: "",
                                              callback: () {

                                              }),
                                        ));


                                  },
                                  child: Text(
                                    "Edit",
                                    style: styleElements.subtitle1ThemeScalable(context).copyWith(color: HexColor(AppColors.appMainColor),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            listItemBuilder2(),
                            listItemBuilder2()

                          ],
                        ),
                      ),
                      appCard(
                        padding: EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [

                            ListTile(
                              contentPadding: EdgeInsets.all(0),

                              title:  Padding(
                                padding: const EdgeInsets.only(top:8.0),
                                child: Text(
                                  "SGST",
                                  style: styleElements.subtitle1ThemeScalable(context),
                                ),
                              )
                              ,


                              trailing:  Padding(
                                padding: const EdgeInsets.only(right:8.0),
                                child: Text(
                                  "₹ 200899",
                                  style: styleElements.subtitle1ThemeScalable(context).copyWith(color: HexColor(AppColors.appColorBlack65),
                                  ),
                                ),
                              ),
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.all(0),

                              title:  Padding(
                                padding: const EdgeInsets.only(top:8.0),
                                child: Text(
                                  "CGST",
                                  style: styleElements.subtitle1ThemeScalable(context),
                                ),
                              )
                              ,


                              trailing:  Padding(
                                padding: const EdgeInsets.only(right:8.0),
                                child: Text(
                                  "₹ 200899",
                                  style: styleElements.subtitle1ThemeScalable(context).copyWith(color: HexColor(AppColors.appColorBlack65),
                                  ),
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),



                      appCard(

                        padding: EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 4),
                        child: Column(

                          children: [

                            Row
                              (
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,

                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top:16.0),
                                  child: Text(
                                    "Payment",
                                    style: styleElements.subtitle1ThemeScalable(context).copyWith(fontWeight: FontWeight.bold),
                                  ),),

                                Padding(
                                  padding: const EdgeInsets.only(top:16.0),
                                  child: InkWell(
                                    onTap: (){  showModalBottomSheet<void>(
                                      context: context,

                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
                                      ),

                                      isScrollControlled: true,
                                      builder: (context) {
                                        return PaymentSheet(
                                          prefs: prefs,
                                          onClickCallback: (value) {

                                          },
                                        );
                                        // return BottomSheetContent();
                                      },
                                    );},
                                    child: Text(
                                      "Edit",
                                      style: styleElements.subtitle1ThemeScalable(context).copyWith(color: HexColor(AppColors.appMainColor)),
                                    ),
                                  ),)



                              ],
                            ),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [


                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top:16.0),
                                      child: Text(
                                          "With in 90 days",
                                          style: styleElements.subtitle1ThemeScalable(context)
                                      ),),
                                    Padding(
                                      padding: const EdgeInsets.only(top:16.0),
                                      child: Text(
                                        "Bank Details",
                                        style: styleElements.subtitle1ThemeScalable(context).copyWith(color: HexColor(AppColors.appColorBlack35),fontWeight: FontWeight.bold),
                                      ),),
                                    Padding(
                                      padding: const EdgeInsets.only(top:16.0),
                                      child: Text(
                                        "Bank of broda",
                                        style: styleElements.subtitle1ThemeScalable(context).copyWith(color: HexColor(AppColors.appColorBlack35)),
                                      ),),
                                    Padding(
                                      padding: const EdgeInsets.only(top:16.0,bottom: 16),
                                      child: Text(
                                        "Bank of broda",
                                        style: styleElements.subtitle1ThemeScalable(context).copyWith(color: HexColor(AppColors.appColorBlack35)),
                                      ),)
                                  ],
                                )



                              ],
                            )

                          ],
                        ),



                      ),
                      appCard(
                        padding: EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 4),

                        child: Column(

                          children: [

                            Row
                              (
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,

                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top:16.0),
                                  child: Text(
                                    "Term & Conditions",
                                    style: styleElements.subtitle1ThemeScalable(context).copyWith(fontWeight: FontWeight.bold),
                                  ),),

                                Padding(
                                  padding: const EdgeInsets.only(top:16.0),
                                  child: Text(
                                    "Edit",
                                    style: styleElements.subtitle1ThemeScalable(context).copyWith(color: HexColor(AppColors.appMainColor)),
                                  ),)



                              ],
                            ),



                          ],
                        ),



                      ),
                    ],
                  ),
                ),
              ),

                Container(

                    child: Padding(
                      padding: const EdgeInsets.only(top:8.0,bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: <Widget>[
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: InkWell(
                                            onTap: (){

                                              showModalBottomSheet(
                                                  context: context,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(12),
                                                        topRight: Radius.circular(12),
                                                      )),
                                                  isScrollControlled: true,
                                                  builder: (BuildContext context) {
                                                    return CommentSheet(postId: 2);
                                                  });
                                            },

                                            child: Icon(Icons.messenger_outline_rounded,color: HexColor(AppColors.appColorBlack35),)),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(Icons.share,color: HexColor(AppColors.appColorBlack35)),
                                      )
                                    ],
                                  )
                              ),
                            ),
                          ),




                          Padding(
                            padding: const EdgeInsets.only(right:8.0),
                            child: appProgressButton(

                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(18.0),
                                  side: BorderSide(
                                      color: HexColor(AppColors.appColorWhite))),
                              onPressed: () async {
                              },
                              color: HexColor(AppColors.appMainColor),
                              child: Text(
                                "Cancel Sale"
                                    .toUpperCase(),
                                style: styleElements
                                    .subtitle2ThemeScalable(context)
                                    .copyWith(
                                    color: HexColor(AppColors.appColorWhite)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left:8.0,right: 16),
                            child: appProgressButton(

                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(18.0),
                                  side: BorderSide(
                                      color: HexColor(AppColors.appMainColor))),
                              onPressed: () async {


                              },
                              color: HexColor(AppColors.appColorWhite),
                              child: Text(
                                "Update Payment"
                                    .toUpperCase(),
                                style: styleElements
                                    .subtitle2ThemeScalable(context)
                                    .copyWith(
                                    color: HexColor(AppColors.appMainColor)),
                              ),
                            ),
                          )
                          ,

                        ],
                      ),
                    )),
              ],
            )
        ));
  }

  void _showSelectorBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
      ),
      builder: (context) {
        return SelectHostSheet(
          selectedId: ownerId,
          onClickCallback: (HostListItem item) {
            setState(() {
              ownerType = item.eventOwnerType;
              ownerId = item.eventOwnerId;
              ownerImage = item.eventOwnerImageUrl;
              ownerName = item.eventOwnerName;
              print(item.privacyType);
              privacyTypeKey.currentState!.setPrivacyType(item.privacyType);
            });
          },
        );
      },
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
                institutionIdtoDelete: prefs!.getInt(Strings.instituteId),
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
  String getTitle() {
    if (type == 'event') {
      return AppLocalizations.of(context)!.translate('create_event');
    } else if (type == 'task') {
      return AppLocalizations.of(context)!.translate('task_details');
    } else {
      return "Details";
    }
  }
  Widget listItemBuilder2() {


    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {

        },
        child:  appUserListTile(
          onPressed: (){

          },
          iconWidget: SizedBox(
              height: 30,width: 30,
              child: Image(image: AssetImage('assets/appimages/dice.png'),)),

          title: "Product Name",
          subtitle1: "Qty:No2",
          trailingWidget:  Row(children: [
            Padding(
              padding: const EdgeInsets.only(left:8.0,right: 8.0),
              child: Text("₹ 2000",    style: styleElements.bodyText2ThemeScalable(context),),
            ),



          ],),
        )
    );
  }
  Widget get _divider => Padding(
    padding: EdgeInsets.only(top: 4, bottom: 4),
    child: Container(
      width: double.infinity,
      height: 1,
      color: HexColor(AppColors.appColorBackground),
    ),
  );

  Future<void> _selectStartDate(BuildContext context) async {
    var newDate;

    newDate = new DateTime.now();

    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: newDate,
        firstDate: newDate,
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: HexColor(AppColors.appColorBlack85),
              accentColor: HexColor(AppColors.appColorBlack85),
              colorScheme: ColorScheme.dark(
                primary: HexColor(AppColors.appColorBlack85),
                onPrimary: HexColor(AppColors.appColorWhite),
                surface: HexColor(AppColors.appColorWhite),
                onSurface: HexColor(AppColors.appColorBlack85),
              ),
              buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            ),
            child: child!,
          );
        },
        lastDate: DateTime(DateTime.now().year + 100));
    if (picked != null)
      setState(() {
        selectedStartEpoch = picked.millisecondsSinceEpoch;
        selectedStartDate = DateFormat('yyyy-MM-dd').format(picked);
      });
  }

  Future<void> _selectEndDate(BuildContext context) async {
    var newDate = new DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(newDate.year, newDate.month, newDate.day + 1),
      firstDate: DateTime(newDate.year, newDate.month, newDate.day),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: HexColor(AppColors.appColorBlack85),
            accentColor: HexColor(AppColors.appColorBlack85),
            colorScheme: ColorScheme.dark(
              primary: HexColor(AppColors.appColorBlack85),
              onPrimary: HexColor(AppColors.appColorWhite),
              surface: HexColor(AppColors.appColorWhite),
              onSurface: HexColor(AppColors.appColorBlack85),
            ),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
      lastDate: DateTime(newDate.year + 100),
    );
    if (picked != null)
      setState(() {
        selectedEndEpoch = picked.millisecondsSinceEpoch;
        selectedEndDate = DateFormat('yyyy-MM-dd').format(picked);
      });
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),

      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor:HexColor(AppColors.appColorBlack85),
            accentColor: HexColor(AppColors.appColorBlack85),
            colorScheme: ColorScheme.dark(
              primary: HexColor(AppColors.appColorBlack85),
              onPrimary: HexColor(AppColors.appColorWhite),
              surface: HexColor(AppColors.appColorWhite),
              onSurface:HexColor(AppColors.appColorBlack85),
            ),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null)
      setState(() {

        String  time=(picked.hour<10?"0"+   picked.hour.toString():picked.hour.toString()) + ':' +(picked.minute<10?"0"+picked.minute.toString(): picked.minute.toString())+":00.000";

        DateTime dt = DateTime.parse('$selectedStartDate $time');



        print(selectedStartDate);
        if(dt.isAfter(DateTime.now()))
        {

          selectedStartTimeOfDay = picked;
          selectedStartTime = picked.hour.toString() + ':' +(picked.minute<10?"0"+picked.minute.toString(): picked.minute.toString());
        }
        else
        {
          ToastBuilder().showToast(
              AppLocalizations.of(context)!.translate('future_date'),
              context,
              HexColor(AppColors.information));
        }

      });
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.black,
            accentColor: Colors.black,
            colorScheme: ColorScheme.dark(
              primary: Colors.black,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null)
      setState(() {
        selectedEndTimeOfDay = picked;
        selectedEndTime =
            picked.hour.toString() + ':' + picked.minute.toString();
      });
  }

  Widget getEventDetailCard(String title, Widget child, {EdgeInsets? padding}) {
    return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title),
            Padding(
              padding: padding ?? EdgeInsets.all(0),
              child: child,
            )
          ],
        ));
  }

  void createPayload() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      if (privacyTypeKey.currentState!.selectedTypeCode != null && privacyTypeKey.currentState!.selectedTypeCode!.isNotEmpty) {
        if (selectedStartEpoch != null && selectedStartTimeOfDay != null) {
          if (type == 'talk' || (selectedEndEpoch != null && selectedEndTimeOfDay != null)) {
            if (roomTopicKey.currentState!.selectedList != null && roomTopicKey.currentState!.selectedList.length > 0) {
              EventCreateRequest payload = EventCreateRequest();

              var d = DateTime.fromMillisecondsSinceEpoch(selectedStartEpoch);
              var sd = DateTime(d.year, d.month, d.day,
                  selectedStartTimeOfDay!.hour, selectedStartTimeOfDay!.minute);
              // var startDate =
              // Utility().getDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", sd);

              if (type != 'talk') {
                var e_d = DateTime.fromMillisecondsSinceEpoch(selectedEndEpoch);
                var ed = DateTime(e_d.year, e_d.month, e_d.day,
                    selectedEndTimeOfDay!.hour, selectedEndTimeOfDay!.minute);
                // var endDate =
                // Utility().getDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", ed);
                payload.endTime = ed.millisecondsSinceEpoch;
              }
              payload.eventOwnerType = prefs!.getString(Strings.ownerType);
              payload.eventOwnerId = prefs!.getInt(Strings.userId);
              payload.eventOrganizerType = prefs!.getString(Strings.ownerType);
              payload.eventOrganizerId = prefs!.getInt(Strings.userId);
              payload.calContextType = prefs!.getString(Strings.ownerType);
              payload.calContextTypeId = prefs!.getInt(Strings.userId);
              payload.standardEventsId = standardEventId;
              payload.eventName = title;
              payload.startTime = sd.millisecondsSinceEpoch;
              if (type == 'talk') payload.eventCategory = 'talk';
              payload.eventDate = Utility().getDateFormat('yyyy-MM-dd',
                  DateTime.fromMillisecondsSinceEpoch(selectedStartEpoch));
              payload.eventStatus = EVENT_STATUS.ACTIVE.status;
              payload.eventTopics = List<String?>.generate(
                  roomTopicKey.currentState!.selectedList.length, (index) {
                return roomTopicKey.currentState!.selectedList[index].topicName;
              });
              payload.eventPrivacyType =
                  privacyTypeKey.currentState!.selectedTypeCode;
              payload.involvedPeopleList = List<InvolvedPeopleList>.generate(
                  selectedMembersItem!.length, (index) {
                return InvolvedPeopleList(
                    memberType: selectedMembersItem![index].memberType,
                    memberId: selectedMembersItem![index].memberId,
                    roleType: 'cohost');
              });

              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                    return EventDetailPage(type: type, payload: payload,roomItem: widget.roomItem,refreshCallBack:widget.refreshCallBack);
                  })).then((value) {
                if (value != null && value) {
                  Navigator.pop(context);
                }
              });
            } else {
              ToastBuilder().showToast(
                  AppLocalizations.of(context)!.translate('please_select_topic'),
                  context,
                  HexColor(AppColors.information));
            }
          } else {
            ToastBuilder().showToast(
                AppLocalizations.of(context)!.translate('select_end_date_time'),
                context,
                HexColor(AppColors.information));
          }
        } else {
          ToastBuilder().showToast(
              AppLocalizations.of(context)!.translate('select_start_date_time'),
              context,
              HexColor(AppColors.information));
        }
      } else {
        ToastBuilder().showToast(
            AppLocalizations.of(context)!
                .translate('please_select_privacy_type'),
            context,
            HexColor(AppColors.information));
      }
    }
  }
}

class CommentSheet extends StatefulWidget {
  final int? postId;

  CommentSheet({this.postId});

  @override
  _CommentSheet createState() => _CommentSheet();
}

class _CommentSheet extends State<CommentSheet> {
  SharedPreferences? prefs = locator<SharedPreferences>();
  GlobalKey<PaginatorState> paginatorKey = GlobalKey();
  GlobalKey<appChatFooterState> chatFooterKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var styleElements = TextStyleElements(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            AppLocalizations.of(context)!.translate('comments'),
            style: styleElements
                .headline6ThemeScalable(context)
                .copyWith(fontWeight: FontWeight.bold),
          ),
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