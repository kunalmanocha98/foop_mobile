import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/appProgressButton.dart';
import 'package:oho_works_app/components/appAvatar.dart';
import 'package:oho_works_app/enums/resolutionenums.dart';
import 'package:oho_works_app/enums/serviceTypeEnums.dart';
import 'package:oho_works_app/mixins/editProfileMixin.dart';
import 'package:oho_works_app/models/personal_profile.dart';
import 'package:oho_works_app/ui/RegisterInstitutions/models/create_referral.dart';
import 'package:oho_works_app/ui/RegisterInstitutions/upload_photo_id.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/scrach_card_dialogue.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/basic_refral_data.dart';
import 'models/create_referral_response.dart';
import 'models/scratch_card_response.dart';
import 'models/scratch_data.dart';

// ignore: must_be_immutable
class ConfirmDetails extends StatefulWidget {
  int? instId;
  Persondata? personData;
  String? fromPage;
  final Null Function()? callbackPicker;
  _ConfirmDetails createState() => _ConfirmDetails(instId, fromPage,callbackPicker);
  ConfirmDetails(
      {Key? key,
        this.instId, this.fromPage,this.callbackPicker})
      : super(key: key);

}

class _ConfirmDetails extends State<ConfirmDetails>
    with EditProfileMixins, SingleTickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  String? fromPage;
   Null Function()? callbackPicker;
  late SharedPreferences prefs;
  late TextStyleElements styleElements;
  final emailController = TextEditingController();
  final upidController = TextEditingController();
  final studentIdController = TextEditingController();
  final bioController = TextEditingController();
  final mobileController = TextEditingController();
  final firstNameController = TextEditingController();

  final genderController = TextEditingController();
  final quotesController = TextEditingController();
  final secondCon = TextEditingController();
  String bioCharacterLength = "0";
  String quotesCharacterLength = "0";
  String? userPhotoId;
  String? email, biog, quotes;
  late BuildContext context;
  String selectedDoA = 'Date of Anniversary';
  String selectedDate = 'Date of Birth';
  String selectedGender = "Gender";
  String selectedBGroup = "Blood Group";
  int? selectedEpoch;
  String? name = "";
  String image = "";
  var items = ['Male', 'Female', 'Transgender'];
  var itemsBG = ['A+', 'A-', 'B+', ' B-', ' O+', 'O-', 'AB+', ' AB-'];
  Map<String, String> mpGroup = {
    'A+': 'APOSITIVE',
    'A-': 'ANEGATIVE',
    'B+': 'BPOSITIVE',
    ' B-': 'BNEGATIVE',
    ' O+': 'OPOSITIVE',
    'O-': 'ONEGATIVE',
    'AB+': 'ABPOSITIVE',
    ' AB-': 'ABNEGATIVE'
  };

  Map<String, String> mpGroupRev = {
    'APOSITIVE': 'A+',
    'ANEGATIVE': 'A-',
    'BPOSITIVE': 'B+',
    'BNEGATIVE': ' B-',
    'OPOSITIVE': ' O+',
    'ONEGATIVE': 'O-',
    'ABPOSITIVE': 'AB+',
    'ABNEGATIVE': ' AB-'
  };

  GlobalKey<appProgressButtonState> progressButtonKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) => setData());
  }
  void setSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();

  }

  Widget build(BuildContext context) {
    ScreenUtil.init;
    styleElements = TextStyleElements(context);
    this.context = context;

    final dob = GestureDetector(
      onTap: () {
        _showModalBottomSheet(context, "dob");
      },
      child: Container(
          padding: EdgeInsets.all(16),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                //
                color: HexColor(AppColors.appColorGrey500),
                width: 1.0,
              ),
            ), // set border width
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              selectedDate != "Date of Birth"
                  ? DateFormat('dd-MM-yyyy')
                  .format(DateTime.parse(selectedDate))
                  : selectedDate,
              textAlign: TextAlign.left,
              style: styleElements.subtitle2ThemeScalable(context),
            ),
          )),
    );
    final gender = Stack(
      children: <Widget>[
        Column(
          children: [
            Row(
              children: <Widget>[
                new Expanded(
                    child: Container(
                        padding: EdgeInsets.only(
                            left: 8, top: 16, bottom: 16, right: 4),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              //
                              color: HexColor(AppColors.appColorGrey500),
                              width: 1.0,
                            ),
                          ), // set border width
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "$selectedGender",
                            textAlign: TextAlign.left,
                            style:
                            styleElements.subtitle2ThemeScalable(context),
                          ),
                        ))),
              ],
            ),
          ],
        ),
        Align(
          alignment: Alignment.centerRight,
          child: new PopupMenuButton<String>(
            icon: const Icon(Icons.arrow_drop_down),
            onSelected: (String value) {
              setState(() {
                selectedGender = value;
              });
            },
            itemBuilder: (BuildContext context) {
              return items.map<PopupMenuItem<String>>((String value) {
                return new PopupMenuItem(child: new Text(value), value: value);
              }).toList();
            },
          ),
        )
      ],
    );
    final secondName = TextFormField(
      style: styleElements.subtitle1ThemeScalable(context).copyWith(
          color: HexColor(AppColors.appColorBlack65)
      ),
      controller: secondCon,
      keyboardType: TextInputType.text,
      inputFormatters: [
        new FilteringTextInputFormatter.allow(RegExp(
          "[a-z,A-Z,]",
        )),
        FilteringTextInputFormatter.deny(RegExp(r'[,\.]')),
      ],
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: AppLocalizations.of(context)!.translate('last_name'),
          hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35)),
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 0.0,
            ),
          )),
    );
    final firstName = TextField(
      controller: firstNameController,
      keyboardType: TextInputType.text,
      style: styleElements.subtitle1ThemeScalable(context).copyWith(
        color: HexColor(AppColors.appColorBlack65)
      ),
      inputFormatters: [
        new FilteringTextInputFormatter.allow(RegExp(
          "[a-z,A-Z,]",
        )),
        FilteringTextInputFormatter.deny(RegExp(r'[,\.]')),
      ],
      textCapitalization: TextCapitalization.sentences,
      onChanged: (text) {
        if (text.length == 1 && text != text.toUpperCase()) {
          firstNameController.text = text.toUpperCase();
          firstNameController.selection = TextSelection.fromPosition(
              TextPosition(offset: firstNameController.text.length));
        }
      },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(8.0, 15.0, 20.0, 4.0),
          hintText: AppLocalizations.of(context)!.translate('first_name'),
          hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(
            color: HexColor(AppColors.appColorBlack35)
          ),
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 0.0,
            ),
          )),
    );
    final mob = TextField(
        controller: mobileController,
        style: styleElements.subtitle1ThemeScalable(context).copyWith(
            color: HexColor(AppColors.appColorBlack65)
        ),
        keyboardType: TextInputType.number,
        textCapitalization: TextCapitalization.words,


        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(8.0, 15.0, 20.0, 4.0),
          hintText: AppLocalizations.of(context)!.translate("ur_mobile"),
          hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35)),
        ));
    final studentId = TextField(
        controller: studentIdController,
        style: styleElements.subtitle1ThemeScalable(context).copyWith(
            color: HexColor(AppColors.appColorBlack65)
        ),
        keyboardType: TextInputType.number,
        textCapitalization: TextCapitalization.words,

        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(8.0, 15.0, 20.0, 4.0),
          hintText:
          AppLocalizations.of(context)!.translate("student_id_required"),
          hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35)),
        ));
    final upid = TextField(
        controller: upidController,
        style: styleElements.subtitle1ThemeScalable(context).copyWith(
            color: HexColor(AppColors.appColorBlack65)
        ),
        keyboardType: TextInputType.name,
        textCapitalization: TextCapitalization.words,

        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(8.0, 15.0, 20.0, 4.0),
          hintText: AppLocalizations.of(context)!.translate('upi'),
          hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35)),
        ));

    Widget _body() {
      return FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder:
            (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
          return Stack(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 20, bottom: 80),
                child: ListView(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.all(8),
                      child: appCard(
                        margin: EdgeInsets.all(4),
                        padding: EdgeInsets.all(4),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                leading: appAvatar(
                                  resolution_type: RESOLUTION_TYPE.R64,
                                  service_type: SERVICE_TYPE.INSTITUTION,
                                  imageUrl: fromPage == "registration"
                                      ?snapshot.data!.getString(Strings.registeredInstituteImage)
                                      : snapshot.data!.getStringList(Strings.institutionImageList)![0],
                                  size: 52,
                                ),
                                title: Text(
                                  fromPage == "registration"
                                      ? snapshot.data!.getString(Strings
                                      .registeredInstituteName) ??
                                      ""
                                      : snapshot.data!.getStringList(
                                      Strings.institutionNameList)![0],
                                  style: styleElements
                                      .subtitle1ThemeScalable(context),
                                ),
                                subtitle: Text(
                                  fromPage == "registration"
                                      ? snapshot.data!.getString(Strings
                                      .registeredInstituteLocation) ??
                                      ""
                                      : snapshot.data!.getStringList(
                                      Strings.roleTypeList)![0],
                                  style: styleElements
                                      .bodyText2ThemeScalable(context),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                AppLocalizations.of(context)!.translate("ensure_details"),
                                style: styleElements
                                    .bodyText2ThemeScalable(context)
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              margin:
                              const EdgeInsets.only(left: 16, right: 16),
                              child: studentId,
                            ),

                            Container(
                                child: Container(
                                  margin: const EdgeInsets.only(left: 8, right: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      new Flexible(
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                left: 8, right: 8),
                                            child: firstName,
                                          )),
                                      new Flexible(
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                left: 8, right: 8),
                                            child: secondName,
                                          )),
                                    ],
                                  ),
                                )),
                            Container(
                              margin:
                              const EdgeInsets.only(left: 16, right: 16),
                              child: mob,
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 8, right: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new Flexible(
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            left: 8, right: 8),
                                        child: dob,
                                      )),
                                  new Flexible(
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            left: 8, right: 8),
                                        child: gender,
                                      )),
                                ],
                              ),
                            ),
                            Container(
                              margin:
                              const EdgeInsets.only(left: 16, right: 16),
                              child: upid,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(AppLocalizations.of(context)!.translate('entity_confirm_des'),
                                style: styleElements
                                    .bodyText2ThemeScalable(context)
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(AppLocalizations.of(context)!.translate('share_detail_outside'),
                                style: styleElements
                                    .bodyText2ThemeScalable(context)
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      color: HexColor(AppColors.appColorWhite),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Spacer(),
                          Container(
                            height: 60,
                            color: HexColor(AppColors.appColorWhite),
                            child: Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 16.0, right: 16.0),
                                  child: appProgressButton(
                                    key: progressButtonKey,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(116.0),
                                        side: BorderSide(
                                            color: HexColor(AppColors.appMainColor))),
                                    onPressed: () async {
                                      if (studentIdController.text != null &&
                                          studentIdController.text.trim() !=
                                              "") {

                                          if (userPhotoId != null &&
                                              userPhotoId!.isNotEmpty)
                                            _createReferral();
                                          else {

                                            CreateReferralEntity createReferralEntity = CreateReferralEntity();
                                            createReferralEntity.referredByPersonMobileNumber = mobileController.text;
                                            createReferralEntity.referredByUpiId = upidController.text;
                                            createReferralEntity.firstName = firstNameController.text;
                                            createReferralEntity.lastName = secondCon.text;
                                            createReferralEntity.dateOfBirth = selectedDate;
                                            createReferralEntity.gender = genderController.text;
                                            createReferralEntity.institutionId = instId;
                                            createReferralEntity.referredByPersonId = prefs.getInt("userId");
                                         Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                    context) =>
                                                        UploadUserId(instId:instId,createReferralEntity:createReferralEntity,fromPage:fromPage,callbackPicker:(){
                                                          if(callbackPicker!=null)
                                                            {
                                                              callbackPicker!();
                                                              Navigator.pop(context);
                                                            }
                                                        })));


                                          }

                                      } else if (fromPage != null &&
                                          fromPage == 'buddy') {
                                        if (upidController.text != null &&
                                            upidController.text.trim() != "") {
                                          _createReferral();
                                        } else
                                          ToastBuilder().showToast(
                                              AppLocalizations.of(context)!
                                                  .translate("upid_req"),
                                              context,
                                              HexColor(AppColors.information));
                                      } else {
                                        ToastBuilder().showToast(
                                            AppLocalizations.of(context)!
                                                .translate(
                                                "student_id_required"),
                                            context,
                                            HexColor(AppColors.information));
                                      }
                                    },
                                    color: HexColor(AppColors.appColorWhite),
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .translate('next'),
                                      style: styleElements
                                          .subtitle2ThemeScalable(context)
                                          .copyWith(color: HexColor(AppColors.appMainColor)),
                                    ),
                                  ),
                                )),
                          )
                        ],
                      )))
            ],
          );
        },
      );
    }

    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: HexColor(AppColors.appColorBackground),
            appBar: appAppBar().getCustomAppBar(
              context,
              appBarTitle: 'Verify Profile Details',
              isIconVisible: true,
              onBackButtonPress: () {
                Navigator.pop(context);
              },
            ),
            body: Form(
              key: formKey,
              child: _body(),
            )));
  }

  void callback() {
    Navigator.pop(context, true);
  }

  void getScratchCardData() async {
    progressButtonKey.currentState!.show();
    ScratchCardEntity scratchCardEntity = ScratchCardEntity();
    scratchCardEntity.allPersonsId = prefs.getInt("userId");
    scratchCardEntity.scratchCardContextId = instId;
    scratchCardEntity.scratchCardContext = fromPage == 'buddy'
        ? "Buddy_Approval"
        : fromPage == 'earn'
        ? "Earn"
        : "Institutional_Registration";
    scratchCardEntity.scratchCardSubContext = "";
    scratchCardEntity.scratchCardSubContextId = instId;
    Calls()
        .call(jsonEncode(scratchCardEntity), context, Config.CARD_ALLOCATE)
        .then((value) async {
      progressButtonKey.currentState!.hide();
      if (value != null) {
        var data = ScratchCardResult.fromJson(value);
        if (data.statusCode == Strings.success_code) {
          if(data.rows!=null) {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) =>
                    ScratchCardDialogue(
                      prefs.getInt("userId"),
                      data.rows!.id,
                      data.rows!.scratchCardValue,
                      data.rows!.scratchCardRewardType,
                      fromPage: fromPage,
                      callBack: callback,
                    ));
          }else{
            callback();
          }
        }
      }
    }).catchError((onError) {
      progressButtonKey.currentState!.hide();
      ToastBuilder().showToast(
         "Something Went Wrong !!", context, HexColor(AppColors.information));
    });
  }

  setData() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.getString("createdSchoolImage") != null)
      image = prefs.getString("createdSchoolImage") ?? "";
    name = prefs.getString("createdSchool");
    if (prefs.getString("basicData") != null) {
      Map<String, dynamic> map =
      json.decode(prefs.getString("basicData") ?? "");
      personData = Persondata.fromJson(map);
    }
    _getData();
    if (personData != null) {
      if (personData!.firstName != null)
        firstNameController.text = personData!.firstName ?? "";
      if (personData!.lastName != null)
        secondCon.text = personData!.lastName ?? "";
      if (personData!.mobile != null)
        mobileController.text = personData!.mobile ?? "";
      if (personData!.email != null)
        emailController.text = personData!.email ?? "";
      if (personData!.dateOfBirth != null)
        selectedDate = personData!.dateOfBirth ?? "";
      if (personData!.dateOfAnniversary != null)
        selectedDoA = personData!.dateOfAnniversary ?? "";
      if (personData!.gender != null)
        selectedGender = personData!.gender == 1
            ? 'Male'
            : personData!.gender == 2
            ? 'Female'
            : personData!.gender == 3
            ? 'Transgender'
            : "Select gender";
      if (personData!.fullBio != null) {
        bioController.text = personData!.fullBio ?? "";
        bioCharacterLength = personData!.fullBio!.length.toString();
      }

      if (personData!.message != null) {
        quotesController.text = personData!.message ?? "";
        quotesCharacterLength = personData!.message!.length.toString();
      }

      if (personData!.middleName != null)
        secondCon.text = personData!.middleName ?? "";
      if (personData!.bloodGroup != null)
        selectedBGroup = mpGroupRev[personData!.bloodGroup!] ?? "";
    }
  }

  Widget _showCuperTinoDatePicker(String type) {
    DateTime today = new DateTime.now();
    var newDate;
    if (type == "dob")
      newDate = new DateTime(today.year - 4, today.month, today.day);
    else
      newDate = new DateTime.now();
    return CupertinoDatePicker(
      initialDateTime: newDate,
      maximumDate: newDate,
      onDateTimeChanged: (DateTime newdate) {
        setState(() {
          if (type == "dob") {
            selectedEpoch = newdate.millisecondsSinceEpoch;
            selectedDate = DateFormat('yyyy-MM-dd').format(newdate);
          } else {
            selectedEpoch = newdate.millisecondsSinceEpoch;
            selectedDoA = DateFormat('yyyy-MM-dd').format(newdate);
          }
        });
      },
      mode: CupertinoDatePickerMode.date,
    );
  }

  // ignore: missing_return
  Widget? _showModalBottomSheet(context, type) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Container(
              height: MediaQuery.of(context).copyWith().size.height / 3,
              child: _showCuperTinoDatePicker(type),
            ),
          );
        });
  }

  void _getData() {
    var data = jsonEncode({"person_id": prefs.getInt("userId")});

    Calls()
        .call(data, context, Config.GET_REFERRAL_DETAILS)
        .then((value) async {
      BasicDataForRefral basicDataForRefral =
      BasicDataForRefral.fromJson(value);
      if (basicDataForRefral.statusCode == Strings.success_code) {
        setState(() {
          if (basicDataForRefral.rows != null &&
              basicDataForRefral.rows!.referredByUpiId != null)
            upidController.text = basicDataForRefral.rows!.referredByUpiId!;
          if (basicDataForRefral.rows != null &&
              basicDataForRefral.rows!.adminStaffPersonId != null)
            studentIdController.text =
                basicDataForRefral.rows!.adminStaffPersonId.toString();
        });
      } else {
        ToastBuilder().showToast(basicDataForRefral.message!, context,
            HexColor(AppColors.information));
      }
    }).catchError((onError) {
      ToastBuilder().showToast(
          "Something Went Wrong !!", context, HexColor(AppColors.information));
    });
  }

  Future<void> _createReferral() async {
    progressButtonKey.currentState!.show();
    CreateReferralEntity createReferralEntity = CreateReferralEntity();
    createReferralEntity.referredByPersonMobileNumber = mobileController.text;
    createReferralEntity.referredByUpiId = upidController.text;
    createReferralEntity.firstName = firstNameController.text;
    createReferralEntity.lastName = secondCon.text;
    createReferralEntity.dateOfBirth = selectedDate;
    createReferralEntity.gender = genderController.text;
    createReferralEntity.institutionId = instId;
    createReferralEntity.adminStaffPersonId = int.parse(studentIdController.text);
    createReferralEntity.referredByPersonId = prefs.getInt("userId");

    Calls()
        .call(jsonEncode(createReferralEntity), context, Config.CREATE_REF)
        .then((value) async {
      CreateReferraResponselEntity basicDataForRefral =
      CreateReferraResponselEntity.fromJson(value);
      if (basicDataForRefral.statusCode == Strings.success_code) {
        progressButtonKey.currentState!.hide();
        // if(fromPage=='buddy'){
        //   callback();
        // }else {
          getScratchCardData();
        // }
      } else {
        progressButtonKey.currentState!.hide();
        ToastBuilder().showToast(basicDataForRefral.message!, context,
            HexColor(AppColors.information));
      }
    }).catchError((onError) async {
      progressButtonKey.currentState!.hide();
      ToastBuilder().showToast(
          "Something Went Wrong !!", context, HexColor(AppColors.information));
    });
  }

  Persondata? personData;

  int? instId;

  _ConfirmDetails(this.instId, this.fromPage,this.callbackPicker);
}
