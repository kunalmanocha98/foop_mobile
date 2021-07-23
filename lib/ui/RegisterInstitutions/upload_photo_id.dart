import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:GlobalUploadFilePkg/Enums/contexttype.dart';
import 'package:GlobalUploadFilePkg/Enums/ownertype.dart';
import 'package:GlobalUploadFilePkg/Files/GlobalUploadFilePkg.dart';
import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/camera_module/camera_page.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/enums/imageType.dart';
import 'package:oho_works_app/enums/ownerType.dart';
import 'package:oho_works_app/models/imageuploadrequestandresponse.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/imagepickerAndCropper.dart';
import 'package:oho_works_app/utils/scrach_card_dialogue.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/create_referral.dart';
import 'models/create_referral_response.dart';
import 'models/scratch_card_response.dart';
import 'models/scratch_data.dart';

// ignore: must_be_immutable
class UploadUserId extends StatefulWidget {

  int? instId;
  CreateReferralEntity? createReferralEntity;
  String? fromPage;
   Null Function()? callbackPicker;
  @override
  _UploadUserIdState createState() => _UploadUserIdState(instId,createReferralEntity,fromPage,callbackPicker);



  UploadUserId(
      {Key? key,
        this.instId, this.createReferralEntity, this.fromPage,this.callbackPicker})
      : super(key: key);
}

var imageChild;

class _UploadUserIdState extends State<UploadUserId> {
  var imageFile;
  _UploadUserIdState(this.instId, this.createReferralEntity, this.fromPage,this.callbackPicker);
  String? type;
  int? id;
  int? instId;
  Null Function()? callbackPicker;
  CreateReferralEntity? createReferralEntity;
  String? fromPage;
  String? imageUrl;
  String? studentType;

  late SharedPreferences prefs;
 late BuildContext context;
  late File imagePath;

  bool isLoading = false;


  Size displaySize(BuildContext context) {
    debugPrint('Size = ' + MediaQuery.of(context).size.toString());
    return MediaQuery.of(context).size;
  }

  double displayHeight(BuildContext context) {
    debugPrint('Height = ' + displaySize(context).height.toString());
    return displaySize(context).height;
  }

  double displayWidth(BuildContext context) {
    debugPrint('Width = ' + displaySize(context).width.toString());
    return displaySize(context).width;
  }

  @override
  void initState() {
    setSharedPreferences();
    super.initState();
  }

  void setSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  _profilePicker(String type) async {
    File? pickedFile;
    var pr = ToastBuilder()
        .setProgressDialogWithPercent(context, 'Uploading Image...');
    if (type == "Gallery")
      pickedFile = await ImagePickerAndCropperUtil().pickImage(context);
    else {
      final cameras = await availableCameras();
      var reult = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Camera(cameras: cameras, type: "camera")));
      pickedFile = File(reult["result"]);
    }
    if (pickedFile != null) {
      var croppedFile =
      await ImagePickerAndCropperUtil().cropFile(context, pickedFile);

      if (croppedFile != null) {
        await pr.show();
        if (croppedFile != null) {
          setState(() {
            imagePath = croppedFile;
          });
        }
        var contentType =
        ImagePickerAndCropperUtil().getMimeandContentType(croppedFile.path);
        await UploadFile(
            baseUrl: Config.BASE_URL,
            context: context,
            token: prefs.getString("token"),
            contextId: prefs.getInt("userId").toString(),
            contextType: CONTEXTTYPE_ENUM.PROFILE.type,
            ownerId: prefs.getInt("userId").toString(),
            ownerType: OWNERTYPE_ENUM.PERSON.type,
            file: croppedFile,
            subContextId: "",
            subContextType: "idcard",
            onProgressCallback: (int value) {
              pr.update(progress: value.toDouble());
            },
            mimeType: contentType[1],
            contentType: contentType[0])
            .uploadFile()
            .then((value) async {
          await pr.hide();
          var imageResponse = ImageUpdateResponse.fromJson(value);
          updateImage(imageResponse.rows!.fileUrl, OWNERTYPE.person.type,
              IMAGETYPE.profile.type);
        }).catchError((onError) async {
          await pr.hide();
          print(onError.toString());
        });
      }
    }
  }

  updateImage(String? url, String ownerType, String imageType) async {
    setState(() {
      imageUrl = url;

    });
  }

  // ignore: missing_return
  Future<bool> _onBackPressed() {
    Navigator.of(context).pop({'result': imageUrl});
    return new Future(() => false);
  }

  late TextStyleElements styleElements;
  BuildContext? sctx;

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);

    this.context = context;
    if (imageUrl != null) {
      imageChild = Container(
        child: new FittedBox(
          child: new Image.file(imagePath),
          fit: BoxFit.fill,
        ),
      );
    } else {
      imageChild = GestureDetector(
        onTap: () {
          _showSelectionDialog(context);
        },
        child: Icon(
          Icons.camera_alt,
          size: 30,
          color: HexColor(AppColors.appColorGrey500),
        ),
      );
    }

    return new WillPopScope(
        onWillPop: _onBackPressed,
        child: SafeArea(
          child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: HexColor(AppColors.appColorBackground),
              appBar: TricycleAppBar().getCustomAppBar(context,
                  appBarTitle: AppLocalizations.of(context)!.translate('upload_photo_id_header'),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          if (imageUrl != null)
                          {
                            _createReferral();
                          }
                          else
                            ToastBuilder().showToast(
                                "Upload a photo Id", context, HexColor(AppColors.information));
                        },
                        child: Row(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.translate('next'),
                              style: styleElements
                                  .subtitle2ThemeScalable(context)
                                  .copyWith(color: HexColor(AppColors.appMainColor)),
                            ),
                          ],
                        ),
                      ),
                    )
                  ], onBackButtonPress: () {
                _onBackPressed();
              }),
              body: new Builder(builder: (BuildContext context) {
                this.sctx = context;
                return new Stack(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(bottom: 65),
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 352,
                            width: 352,
                            margin: const EdgeInsets.all(16),
                            child: imageChild,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: HexColor(AppColors.appColorGrey500),
                                width: 2.0,
                              ),
                            ),
                          ),
                          Align(
                              alignment: Alignment.center,
                              child: Container(
                                margin: const EdgeInsets.only(
                                    left: 16.0, right: 16.0, top: 5),
                                child: Text(
                                  AppLocalizations.of(context)!.translate(
                                      "upload_photo_id"),
                                  style: styleElements
                                      .subtitle1ThemeScalable(context),
                                  textAlign: TextAlign.center,
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                                margin: const EdgeInsets.only(
                                    left: 16.0, right: 16.0, top: 10),
                                child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: ButtonTheme(
                                      minWidth: 80,
                                      height: 80,
                                      child: RawMaterialButton(
                                        onPressed: () {
                                          if(imageUrl!=null)
                                        {

                                          _createReferral();
                                        }
                                          else
                                            ToastBuilder().showToast(
                                                "Upload a photo Id", context, HexColor(AppColors.information));
                                        },
                                        elevation: 2.0,
                                        child: isLoading
                                            ? SizedBox(
                                                width: 30,
                                                height: 30,
                                                child:
                                                    CircularProgressIndicator())
                                            : Icon(
                                                Icons.keyboard_arrow_right,
                                                size: 30,
                                              ),
                                        fillColor: HexColor(AppColors.appColorWhite),
                                        padding: EdgeInsets.all(15.0),
                                        shape: CircleBorder(),
                                      ),
                                    ))),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              })),
        ));
  }

  void getScratchCardData() async {

    ScratchCardEntity scratchCardEntity = ScratchCardEntity();
    scratchCardEntity.allPersonsId = prefs.getInt("userId");
    scratchCardEntity.scratchCardContextId = instId;
    if(imageUrl!=null)
      scratchCardEntity.photoIdUrl = imageUrl;
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

      if (value != null) {
        var data = ScratchCardResult.fromJson(value);
        if (data.statusCode == Strings.success_code) {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) => ScratchCardDialogue(
                prefs.getInt("userId"),
                data.rows!.id,
                data.rows!.scratchCardValue,
                data.rows!.scratchCardRewardType,
                fromPage: fromPage,
                  callBack: () {
                  if(callbackPicker!=null)
                    {
                      callbackPicker!();
                      Navigator.pop(context);
                    }

                  }
              ));
        }
      }
    }).catchError((onError) {

      ToastBuilder().showToast(
          onError.toString(), context, HexColor(AppColors.information));
    });
  }
  Future<void> _createReferral() async {

    Calls()
        .call(jsonEncode(createReferralEntity), context, Config.CREATE_REF)
        .then((value) async {
      CreateReferraResponselEntity basicDataForRefral =
      CreateReferraResponselEntity.fromJson(value);
      if (basicDataForRefral.statusCode == Strings.success_code) {
        getScratchCardData();
      } else {

        ToastBuilder().showToast(basicDataForRefral.message!, context,
            HexColor(AppColors.information));
      }
    }).catchError((onError) async {

      ToastBuilder().showToast(
          onError.toString(), context, HexColor(AppColors.information));
    });
  }
  Future<void> _showSelectionDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(
                  AppLocalizations.of(context)!.translate('from_where_picture')),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: Text(
                          AppLocalizations.of(context)!.translate('gallery')),
                      onTap: () {
                        Navigator.pop(context, null);
                        _profilePicker("Gallery");
                      },
                    ),
                    Padding(padding: EdgeInsets.all(16.0)),
                    GestureDetector(
                      child: Text(
                          AppLocalizations.of(context)!.translate('camera')),
                      onTap: () {
                        Navigator.pop(context, null);
                        _profilePicker("Camera");
                      },
                    ),
                    Padding(padding: EdgeInsets.all(8.0)),
                  ],
                ),
              ));
        });
  }
}
