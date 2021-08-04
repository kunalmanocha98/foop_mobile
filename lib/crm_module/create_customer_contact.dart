import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/app_buttons.dart';
import 'package:oho_works_app/components/appAvatar.dart';
import 'package:oho_works_app/enums/event_status_code.dart';
import 'package:oho_works_app/enums/resolutionenums.dart';
import 'package:oho_works_app/enums/serviceTypeEnums.dart';
import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/mixins/editProfileMixin.dart';
import 'package:oho_works_app/mixins/someCommonMixins.dart';
import 'package:oho_works_app/models/CalenderModule/event_create_models.dart';
import 'package:oho_works_app/models/Rooms/memberAdd.dart';
import 'package:oho_works_app/models/Rooms/roomlistmodels.dart';
import 'package:oho_works_app/models/campus_talk/host_list_models.dart';
import 'package:oho_works_app/ui/BottomSheets/CreateNewSheet.dart';
import 'package:oho_works_app/ui/BottomSheets/select_host_sheet.dart';
import 'package:oho_works_app/ui/CalenderModule/event_detail_page.dart';
import 'package:oho_works_app/ui/CalenderModule/host_list_page.dart';
import 'package:oho_works_app/ui/RoomModule/createRoomPage.dart';
import 'package:oho_works_app/ui/RoomModule/room_privacy_type_selection_widget.dart';
import 'package:oho_works_app/ui/RoomModule/select_topic_room_widget.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
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



class CreateContactPage extends StatefulWidget {
  final String type;
  final String? title;
  final String? ownerName;
  final String? ownerType;
  final String? ownerImage;
  final int? ownerId;
  final RoomListItem? roomItem;
  final Function? refreshCallBack;
  final String? from;
  final int? currentTab;

  CreateContactPage({
    required this.type,
    this.from,
    this.currentTab,
    this.title,
    this.ownerId,
    this.ownerName,
    this.ownerImage,
    this.refreshCallBack,
    this.ownerType,
    this.roomItem
  });

  @override
  CreateContactPageState createState() =>
      CreateContactPageState(type: type, );
}

class CreateContactPageState extends State<CreateContactPage> {
  String type;
  String? title;


  CreateContactPageState({required this.type,});

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


    WidgetsBinding.instance!
        .addPostFrameCallback((_) => _showModalBottomSheet(context));
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
                  child: Wrap(
                    direction: Axis.horizontal,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.translate('next'),
                        style: styleElements
                            .subtitle2ThemeScalable(context)
                            .copyWith(color: HexColor(AppColors.appMainColor)),
                      ),
                      Icon(Icons.keyboard_arrow_right,
                          color: HexColor(AppColors.appMainColor))
                    ],
                  ),
                  shape: CircleBorder(),
                ),
              ],
              appBarTitle: "Create Customer Contact",
              onBackButtonPress: () {
                Navigator.pop(context);
              }),
          body: Form(
            key: formKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                appListCard(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Account Manager",
                        style: styleElements
                            .subtitle2ThemeScalable(context)

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
                appListCard(
                  child: ListView(
                    shrinkWrap: true,
                    children: [


                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child:Image(
                          image: AssetImage('assets/appimages/cart.png'),
                          fit: BoxFit.contain,
                          width: 80,
                          height: 80,
                        ),
                      ),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                padding: EdgeInsets.only(bottom: 0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: HexColor(AppColors.appColorBackground),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        Center(
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 8.0, right: 4),
                                            child: Icon(Icons.person_outline,size: 30,),
                                          ),
                                        ),
                                        Expanded(
                                          child: TextFormField(
                                            validator: EditProfileMixins().validateEmail,
                                            initialValue: "",
                                            onSaved: (value) {

                                            },


                                            decoration: InputDecoration(
                                                hintText: "First Name",
                                                contentPadding: EdgeInsets.only(
                                                    left: 12, top: 16, bottom: 8),
                                                border: UnderlineInputBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(12)),
                                                floatingLabelBehavior:
                                                FloatingLabelBehavior.auto,
                                                labelText:
                                                "Enter first name"),


                                          ),
                                        ),
                                      ],
                                    ),

                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                padding: EdgeInsets.only(bottom: 0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: HexColor(AppColors.appColorBackground),
                                ),
                                child: Column(
                                  children: [
                                    Row(

                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            validator: EditProfileMixins().validateEmail,
                                            initialValue: "Last Nmae",
                                            onSaved: (value) {

                                            },

                                            decoration: InputDecoration(
                                                hintText: "Last Name",
                                                contentPadding: EdgeInsets.only(
                                                    left: 12, top: 16, bottom: 8),
                                                border: UnderlineInputBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(12)),
                                                floatingLabelBehavior:
                                                FloatingLabelBehavior.auto,
                                                labelText:
                                                "Enter Last Name"),


                                          ),
                                        ),
                                      ],
                                    ),

                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                      ,
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: EdgeInsets.only(bottom: 0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: HexColor(AppColors.appColorBackground),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Center(
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 8.0, right: 4),
                                      child: Icon(Icons.commute,size: 30,),
                                    ),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      validator: EditProfileMixins().validateEmail,
                                      initialValue: "",
                                      onSaved: (value) {

                                      },


                                      decoration: InputDecoration(
                                          hintText: "Designation",
                                          contentPadding: EdgeInsets.only(
                                              left: 12, top: 16, bottom: 8),
                                          border: UnderlineInputBorder(
                                              borderRadius:
                                              BorderRadius.circular(12)),
                                          floatingLabelBehavior:
                                          FloatingLabelBehavior.auto,
                                          labelText:
                                          "Designation of contact"),



                                    ),
                                  ),
                                ],
                              ),

                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: EdgeInsets.only(bottom: 0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: HexColor(AppColors.appColorBackground),
                          ),
                          child: Column(
                            children: [
                              Row(

                                children: [
                                  Center(
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 8.0, right: 4),
                                      child: Image(
                                        image: AssetImage('assets/appimages/logo.png'),
                                        fit: BoxFit.contain,
                                        width: 30,
                                        height: 30,
                                      ),
                                    ),
                                  ),
                                  /* Container(
                            width: 80,
                            child: codes,
                          ),*/
                                  Expanded(
                                    child: TextFormField(

                                      initialValue: "",
                                      onSaved: (value) {

                                      },

                                      decoration: InputDecoration(
                                          hintText:  "Oho Id",
                                          contentPadding: EdgeInsets.only(
                                              left: 12, top: 16, bottom: 8),
                                          border: UnderlineInputBorder(
                                              borderRadius:
                                              BorderRadius.circular(12)),
                                          floatingLabelBehavior:
                                          FloatingLabelBehavior.auto,
                                          labelText:
                                          "Oho Id of Contact"),


                                    ),
                                  ),
                                ],
                              ),



                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          'Oho Id is an unique Id for every user and company from oho works',
                          style: styleElements.captionThemeScalable(context),
                        ),
                      ),

                    ],
                  ),
                ),



                appListCard(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Associated Company",
                        style: styleElements
                            .subtitle2ThemeScalable(context)
                            ,
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






              ],
            ),
          ),
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

  String getTitle() {
    if (type == 'event') {
      return AppLocalizations.of(context)!.translate('create_event');
    } else if (type == 'task') {
      return AppLocalizations.of(context)!.translate('task_details');
    } else {
      return "Details";
    }
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
              payload.standardEventsId = 6;
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
