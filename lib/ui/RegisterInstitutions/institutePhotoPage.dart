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
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'domain.dart';
import 'models/basicInstituteData.dart';
import 'models/basic_response.dart';

// ignore: must_be_immutable
class InstitutePhotoPage extends StatefulWidget {
  BasicData basicData;

  InstitutePhotoPage({
    Key key,
    @required this.basicData,
  }) : super(key: key);

  @override
  _InstitutePhotoPageState createState() => _InstitutePhotoPageState(basicData);
}

var imageChild;

class _InstitutePhotoPageState extends State<InstitutePhotoPage> {
  var imageFile;
  String type;
  int id;
  BasicData basicData;
  String imageUrl;
  String studentType;

  SharedPreferences prefs;
  BuildContext context;
  File imagePath;
  String selectPath;
  bool isLoading=false;
  _InstitutePhotoPageState(this.basicData);

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
    File pickedFile;
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
            subContextType: "",
            onProgressCallback: (int value) {
              pr.update(progress: value.toDouble());
            },
            mimeType: contentType[1],
            contentType: contentType[0])
            .uploadFile()
            .then((value) async {
          await pr.hide();
          var imageResponse = ImageUpdateResponse.fromJson(value);
          updateImage(imageResponse.rows.fileUrl, OWNERTYPE.person.type,
              IMAGETYPE.profile.type);
        }).catchError((onError) async {
          await pr.hide();
          print(onError.toString());
        });
      }
    }
  }

  updateImage(String url, String ownerType, String imageType) async {
    setState(() {
      imageUrl = url;
      prefs.setString("instImage", imagePath.path);
    });
  }

  // ignore: missing_return
  Future<bool> _onBackPressed() {
    Navigator.of(context).pop({'result': imageUrl});
  }

  TextStyleElements styleElements;
  BuildContext sctx;

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
    } else if (selectPath != null) {
      imageChild = Container(
        child: new FittedBox(
          child: new Image.file(new File(selectPath ?? "")),
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
                  appBarTitle: AppLocalizations.of(context).translate('upload_logo'),
                  actions: [

                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: (){

                          submit();
                        },
                        child: Row(
                          children: [
                            Text(AppLocalizations.of(context).translate('next'), style:styleElements.subtitle2ThemeScalable(context).copyWith(color: HexColor(AppColors.appMainColor)),),

                          ],
                        ),
                      ),
                    )
                  ],


                  onBackButtonPress: () {
                _onBackPressed();
              }



              ),
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
                                  AppLocalizations.of(context)
                                      .translate("institute_image_upload_content"),
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
                                          submit();
                                        },
                                        elevation: 2.0,
                                        child: isLoading?SizedBox(
                                          width:30,
                                            height:30,
                                            child: CircularProgressIndicator()):Icon(
                                          Icons.keyboard_arrow_right,
                                          size: 30,
                                        ),
                                        fillColor:HexColor(AppColors.appColorWhite),
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

  void submit() async {

    setState(() {
      isLoading=true;
    });
    if (selectPath != null)
    basicData.profile_image = selectPath;
    if (imageUrl != null) {
      basicData.profile_image = imageUrl;
    }
    final body = jsonEncode(basicData);
    Calls()
        .call(body, context, Config.BASIC_INSTITUTE_REGISTER)
        .then((value) async {
      if (value != null) {
        setState(() {
          isLoading=false;
        });
        var resposne = BasicDataResponse.fromJson(value);
        if (resposne.statusCode == Strings.success_code) {
          prefs.setString(Strings.registeredInstituteName, basicData.name??"");
          prefs.setString(Strings.registeredInstituteImage, imageUrl??"");
          prefs.setInt("createdSchoolId", resposne.rows.institutionId);
          prefs.setString("create_institute", "Domain");

          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DomainPage(resposne.rows.institutionId),
              ));
        }
      }
    }).catchError((onError) async {

print(onError.toString());
      setState(() {
        isLoading=false;
      });
    });
  }

  Future<void> _showSelectionDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(
                  AppLocalizations.of(context).translate('from_where_picture')),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: Text(
                          AppLocalizations.of(context).translate('gallery')),
                      onTap: () {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        Navigator.pop(context, null);
                        _profilePicker("Gallery");
                      },
                    ),
                    Padding(padding: EdgeInsets.all(16.0)),
                    GestureDetector(
                      child: Text(
                          AppLocalizations.of(context).translate('camera')),
                      onTap: () {
                        FocusScope.of(context).requestFocus(new FocusNode());
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
