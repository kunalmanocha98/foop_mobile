import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/tricycle_buttons.dart';
import 'package:oho_works_app/components/tricycleavatar.dart';
import 'package:oho_works_app/enums/event_status_code.dart';
import 'package:oho_works_app/enums/resolutionenums.dart';
import 'package:oho_works_app/enums/serviceTypeEnums.dart';
import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/mixins/someCommonMixins.dart';
import 'package:oho_works_app/models/CalenderModule/event_create_models.dart';
import 'package:oho_works_app/models/Rooms/memberAdd.dart';
import 'package:oho_works_app/models/Rooms/roomlistmodels.dart';
import 'package:oho_works_app/models/campus_talk/host_list_models.dart';
import 'package:oho_works_app/ui/BottomSheets/select_host_sheet.dart';
import 'package:oho_works_app/ui/CalenderModule/event_detail_page.dart';
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

import 'host_list_page.dart';

class CreateEventPage extends StatefulWidget {
  final String type;
  final int standardEventId;
  final String title;
  final String ownerName;
  final String ownerType;
  final String ownerImage;
  final int ownerId;
  final RoomListItem roomItem;
final Function refreshCallBack;
  CreateEventPage({
    @required this.type,
    @required this.standardEventId,
    this.title,
    this.ownerId,
    this.ownerName,
    this.ownerImage,
    this.refreshCallBack,
    this.ownerType,
    this.roomItem
  });

  @override
  CreateEventPageState createState() =>
      CreateEventPageState(type: type, standardEventId: standardEventId);
}

class CreateEventPageState extends State<CreateEventPage> {
  String type;
  String title;
  final int standardEventId;

  CreateEventPageState({@required this.type, @required this.standardEventId,});

  TextStyleElements styleElements;
  int selectedStartEpoch = 0;
  String selectedStartDate = "Start date";
  int selectedEndEpoch = 0;
  String selectedEndDate = "End date";
  int selectedDueEpoch = 0;
  String selectedDueDate = "Due date";
  TimeOfDay selectedStartTimeOfDay;
  String selectedStartTime = 'Start Time';
  TimeOfDay selectedEndTimeOfDay;
  String selectedEndTime = 'End Time';
  String selectedPrivacyType;

  SharedPreferences prefs = locator<SharedPreferences>();
  GlobalKey<SelectRoomTopicWidgetState> roomTopicKey = GlobalKey();
  GlobalKey<RoomPrivacyTypeWidgetState> privacyTypeKey = GlobalKey();
  GlobalKey<FormState> formKey = GlobalKey();
  bool isOnline = false;
  bool startsNow = false;
  List<MembersItem> selectedMembersItem = [];

  String ownerImage;
  String ownerName;
  int ownerId;
  String ownerType = 'person';

  @override
  void initState() {
    ownerName = widget.ownerName ?? prefs.getString(Strings.userName);
    ownerId = widget.ownerId ?? prefs.getInt(Strings.userId);
    ownerType = widget.ownerType ?? 'person';
    ownerImage = widget.ownerImage ?? prefs.getString(Strings.profileImage);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    final titleFieldWidget = TextFormField(
        validator: CommonMixins().validateTextField,
        onSaved: (value) {
          title = value;
        },
        initialValue: widget.title ?? '',
        textCapitalization: TextCapitalization.sentences,
        style: styleElements
            .subtitle1ThemeScalable(context)
            .copyWith(color: HexColor(AppColors.appColorBlack65)),
        decoration: InputDecoration(
            hintStyle: styleElements
                .bodyText2ThemeScalable(context)
                .copyWith(color: HexColor(AppColors.appColorBlack35)),
            hintText:
            AppLocalizations.of(context).translate('give_name_to_event')));
    final startDateWidget = GestureDetector(
        onTap: () {
          _selectStartDate(context);
        },
        child: Container(
            padding: EdgeInsets.only(top: 16),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  //
                  color: Colors.grey,
                  width: 1.0,
                ),
              ), // set border width
            ),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  selectedStartDate != "Start date"
                      ? DateFormat('dd-MM-yyyy')
                      .format(DateTime.parse(selectedStartDate))
                      : "Start date",
                  textAlign: TextAlign.left,
                  style: styleElements.bodyText2ThemeScalable(context),
                ))));
    final endDateWidget = GestureDetector(
        onTap: () {
          _selectEndDate(context);
        },
        child: Container(
            padding: EdgeInsets.only(top: 16),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  //
                  color: Colors.grey,
                  width: 1.0,
                ),
              ), // set border width
            ),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  selectedEndDate != "End date"
                      ? DateFormat('dd-MM-yyyy')
                      .format(DateTime.parse(selectedEndDate))
                      : "End date",
                  textAlign: TextAlign.left,
                  style: styleElements.bodyText2ThemeScalable(context),
                ))));
    final startTimeWidget = GestureDetector(
        onTap: () {
          _selectStartTime(context);
        },
        child: Container(
            padding: EdgeInsets.only(top: 16),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  //
                  color: Colors.grey,
                  width: 1.0,
                ),
              ), // set border width
            ),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  selectedStartTime,
                  textAlign: TextAlign.left,
                  style: styleElements.bodyText2ThemeScalable(context),
                ))));
    final startsNowWidget = Row(
      children: [
        Checkbox(
          onChanged: (bool value) {
            setState(() {
              startsNow = !startsNow;
              if (value) {
                selectedStartEpoch = DateTime.now().millisecondsSinceEpoch;
                selectedStartTimeOfDay = TimeOfDay.now();
                selectedStartDate =
                    DateFormat('yyyy-MM-dd').format(DateTime.now());
                selectedStartTime = DateFormat('HH:mm').format(DateTime.now());
              }
            });
          },
          value: startsNow,
        ),
        Text(
          'Starts now',
          style: styleElements.subtitle1ThemeScalable(context),
        )
      ],
    );
    final endTimeWidget = GestureDetector(
        onTap: () {
          _selectEndTime(context);
        },
        child: Container(
            padding: EdgeInsets.only(top: 16),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  //
                  color: Colors.grey,
                  width: 1.0,
                ),
              ), // set border width
            ),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  selectedEndTime,
                  textAlign: TextAlign.left,
                  style: styleElements.bodyText2ThemeScalable(context),
                ))));
    final participantsListWidget = GestureDetector(
      onTap: () {
        if (privacyTypeKey.currentState.selectedTypeCode.isNotEmpty) {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
                return HostListPage(
                  privacyType: privacyTypeKey.currentState.selectedTypeCode,
                  selectedList: selectedMembersItem,
                );
              })).then((value) {
            if (value != null) {
              Map<String, dynamic> map = value;
              if (map['type'] == 'list') {
                setState(() {
                  selectedMembersItem = map['value'];
                });
              }
            }
          });
        } else {
          ToastBuilder().showToast(
              AppLocalizations.of(context)
                  .translate('please_select_privacy_type'),
              context,
              HexColor(AppColors.information));
        }
      },
      child: ListTile(
        contentPadding: EdgeInsets.all(0),
        leading: TricycleAvatar(
          key: UniqueKey(),
          imageUrl: selectedMembersItem.length > 0
              ? selectedMembersItem[0].profileImage
              : '',
          service_type: SERVICE_TYPE.PERSON,
          resolution_type: RESOLUTION_TYPE.R64,
          size: 36,
        ),
        title: Text(
          selectedMembersItem.length > 0
              ? selectedMembersItem.length > 1
              ? selectedMembersItem[0].memberName + ' & Others'
              : selectedMembersItem[0].memberName
              : 'Co-hosts',
          style: styleElements.subtitle1ThemeScalable(context),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: HexColor(AppColors.appColorBlack35),
          size: 20,
        ),
      ),
    );
    final selectTopicWidget = Padding(
        padding: EdgeInsets.only(top: 8, bottom: 8),
        child: SelectRoomTopicWidget(
          roomTopicKey,
          isCard: false,
        ));
    final selectPrivacyTypeWidget = RoomPrivacyTypeWidget(
      key: privacyTypeKey,
      selectedValue: selectedPrivacyType ?? "",
    );

    return SafeArea(
        child: Scaffold(
          appBar: TricycleAppBar().getCustomAppBar(context,
              actions: [
                TricycleTextButton(
                  onPressed: () {
                    createPayload();
                  },
                  child: Wrap(
                    direction: Axis.horizontal,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context).translate('next'),
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
              appBarTitle: AppLocalizations.of(context).translate('create_event'),
              onBackButtonPress: () {
                Navigator.pop(context);
              }),
          body: Form(
            key: formKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                TricycleListCard(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 4),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(0),
                    leading: GestureDetector(
                      onLongPress: () {
                        _showSelectorBottomSheet(context);
                      },
                      child: TricycleAvatar(
                        key: UniqueKey(),
                        imageUrl:
                        ownerImage ?? prefs.getString(Strings.profileImage),
                        isClickable: false,
                        service_type: ownerType == 'person'
                            ? SERVICE_TYPE.PERSON
                            : ownerType == 'room'
                            ? SERVICE_TYPE.ROOM
                            : SERVICE_TYPE.INSTITUTION,
                        resolution_type: RESOLUTION_TYPE.R64,
                        size: 36,
                      ),
                    ),
                    title: Text(
                      'Hosted by (Long press the image to change)',
                      style: styleElements.captionThemeScalable(context),
                    ),
                    subtitle: Text(
                      ownerName ?? prefs.getString(Strings.userName),
                      style: styleElements.subtitle1ThemeScalable(context),
                    ),
                  ),
                ),
                TricycleListCard(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(bottom: 16, left: 8.0, right: 8),
                          child: getEventDetailCard(
                            'Select privacy type',
                            selectPrivacyTypeWidget,
                          )),
                      Padding(
                          padding: EdgeInsets.only(bottom: 16, left: 8.0, right: 8),
                          child: getEventDetailCard(
                            'Name of the event',
                            titleFieldWidget,
                          )),
                      Visibility(
                        visible: type == 'talk',
                        child: Padding(
                            padding:
                            EdgeInsets.only(bottom: 16, left: 0.0, right: 8),
                            child: startsNowWidget),
                      ),

                      Padding(
                          padding: EdgeInsets.only(bottom: 16, left: 8.0, right: 8),
                          child: Row(
                            children: [
                              Expanded(
                                  child: getEventDetailCard(
                                    'Start date',
                                    startDateWidget,
                                  )),
                              SizedBox(
                                width: 100,
                              ),
                              Expanded(
                                  child: getEventDetailCard(
                                    'Start time',
                                    startTimeWidget,
                                  )),
                            ],
                          )),
                      Visibility(
                        visible: type != 'talk',
                        child: Padding(
                            padding:
                            EdgeInsets.only(bottom: 16, left: 8.0, right: 8),
                            child: Row(
                              children: [
                                Expanded(
                                    child: getEventDetailCard(
                                      'End date',
                                      endDateWidget,
                                    )),
                                SizedBox(
                                  width: 100,
                                ),
                                Expanded(
                                    child: getEventDetailCard(
                                      'End time',
                                      endTimeWidget,
                                    )),
                              ],
                            )),
                      ),

                      _divider,
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child:
                        getEventDetailCard('Select topic', selectTopicWidget),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: getEventDetailCard('Offline or Online', onlineWidget),
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: getEventDetailCard('Location', locationWidget),
                      // ),
                      _divider,
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: getEventDetailCard(
                            'Select co-hosts', participantsListWidget),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: getEventDetailCard('Paid Event', paidEventWidget),
                      // ),
                      // Visibility(
                      //   visible: true,
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(8.0),
                      //     child: getEventDetailCard('Online Details', onlineDetailsWidget),
                      //   ),
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: getEventDetailCard('Select Priority', colorSelectorWidget),
                      // )
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
              privacyTypeKey.currentState.setPrivacyType(item.privacyType);
            });
          },
        );
      },
    );
  }

  String getTitle() {
    if (type == 'event') {
      return AppLocalizations.of(context).translate('create_event');
    } else if (type == 'task') {
      return AppLocalizations.of(context).translate('task_details');
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

    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: newDate,
        firstDate: newDate,
        builder: (BuildContext context, Widget child) {
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
            child: child,
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

    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime(newDate.year, newDate.month, newDate.day + 1),
      firstDate: DateTime(newDate.year, newDate.month, newDate.day),
      builder: (BuildContext context, Widget child) {
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
          child: child,
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
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),

      builder: (BuildContext context, Widget child) {
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
          child: child,
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
                AppLocalizations.of(context).translate('future_date'),
                context,
                HexColor(AppColors.information));
          }

      });
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget child) {
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
          child: child,
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

  Widget getEventDetailCard(String title, Widget child, {EdgeInsets padding}) {
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
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      if (privacyTypeKey.currentState.selectedTypeCode != null && privacyTypeKey.currentState.selectedTypeCode.isNotEmpty) {
        if (selectedStartEpoch != null && selectedStartTimeOfDay != null) {
          if (type == 'talk' || (selectedEndEpoch != null && selectedEndTimeOfDay != null)) {
            if (roomTopicKey.currentState.selectedList != null && roomTopicKey.currentState.selectedList.length > 0) {
              EventCreateRequest payload = EventCreateRequest();

              var d = DateTime.fromMillisecondsSinceEpoch(selectedStartEpoch);
              var sd = DateTime(d.year, d.month, d.day,
                  selectedStartTimeOfDay.hour, selectedStartTimeOfDay.minute);
              // var startDate =
              // Utility().getDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", sd);

              if (type != 'talk') {
                var e_d = DateTime.fromMillisecondsSinceEpoch(selectedEndEpoch);
                var ed = DateTime(e_d.year, e_d.month, e_d.day,
                    selectedEndTimeOfDay.hour, selectedEndTimeOfDay.minute);
                // var endDate =
                // Utility().getDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", ed);
                payload.endTime = ed.millisecondsSinceEpoch;
              }
              payload.eventOwnerType = prefs.getString(Strings.ownerType);
              payload.eventOwnerId = prefs.getInt(Strings.userId);
              payload.eventOrganizerType = prefs.getString(Strings.ownerType);
              payload.eventOrganizerId = prefs.getInt(Strings.userId);
              payload.calContextType = prefs.getString(Strings.ownerType);
              payload.calContextTypeId = prefs.getInt(Strings.userId);
              payload.standardEventsId = standardEventId;
              payload.eventName = title;
              payload.startTime = sd.millisecondsSinceEpoch;
              if (type == 'talk') payload.eventCategory = 'talk';
              payload.eventDate = Utility().getDateFormat('yyyy-MM-dd',
                  DateTime.fromMillisecondsSinceEpoch(selectedStartEpoch));
              payload.eventStatus = EVENT_STATUS.ACTIVE.status;
              payload.eventTopics = List<String>.generate(
                  roomTopicKey.currentState.selectedList.length, (index) {
                return roomTopicKey.currentState.selectedList[index].topicName;
              });
              payload.eventPrivacyType =
                  privacyTypeKey.currentState.selectedTypeCode;
              payload.involvedPeopleList = List<InvolvedPeopleList>.generate(
                  selectedMembersItem.length, (index) {
                return InvolvedPeopleList(
                    memberType: selectedMembersItem[index].memberType,
                    memberId: selectedMembersItem[index].memberId,
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
                  AppLocalizations.of(context).translate('please_select_topic'),
                  context,
                  HexColor(AppColors.information));
            }
          } else {
            ToastBuilder().showToast(
                AppLocalizations.of(context).translate('select_end_date_time'),
                context,
                HexColor(AppColors.information));
          }
        } else {
          ToastBuilder().showToast(
              AppLocalizations.of(context).translate('select_start_date_time'),
              context,
              HexColor(AppColors.information));
        }
      } else {
        ToastBuilder().showToast(
            AppLocalizations.of(context)
                .translate('please_select_privacy_type'),
            context,
            HexColor(AppColors.information));
      }
    }
  }
}
