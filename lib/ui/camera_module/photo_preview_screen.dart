import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:GlobalUploadFilePkg/Enums/contexttype.dart';
import 'package:GlobalUploadFilePkg/Enums/ownertype.dart';
import 'package:GlobalUploadFilePkg/Files/GlobalUploadFilePkg.dart';
import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/camera_module/camera_page.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/app_buttons.dart';
import 'package:oho_works_app/enums/imageType.dart';
import 'package:oho_works_app/enums/ownerType.dart';
import 'package:oho_works_app/models/RegisterUserAs.dart';
import 'package:oho_works_app/models/dynmaicres.dart';
import 'package:oho_works_app/models/imageuploadrequestandresponse.dart';
import 'package:oho_works_app/ui/dialogs/invalid%20_profile_image_dialog.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/imagepickerAndCropper.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:oho_works_app/utils/utility_class.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class PhotoPreviewScreen extends StatefulWidget {
  RegisterUserAs? registerUserAs;
  String? from;
  PhotoPreviewScreen({
    Key? key,
    required this.registerUserAs,
    this.from
  }) : super(key: key);

  @override
  _PhotoPreviewScreenState createState() =>
      _PhotoPreviewScreenState(registerUserAs,from);
}

var imageChild;

class _PhotoPreviewScreenState extends State<PhotoPreviewScreen> {
  var imageFile;
  String? type;
  int? id;
  RegisterUserAs? registerUserAs;
  String? imageUrl;
  String? studentType;
  String? from;
  SharedPreferences? prefs;
 late  BuildContext context;
  File? imagePath;
  String? selectPath;

  _PhotoPreviewScreenState(this.registerUserAs,this.from);

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
    if (prefs != null && prefs!.getString("profileImagePath") != null) {
      setState(() {
        selectPath = prefs!.getString("profileImagePath");
      });
    }
    if (prefs != null && prefs!.getString(Strings.profileImage) != null && prefs!.getBool("isProfileCreated")!) {
      setState(() {
        imageUrl = prefs!.getString(Strings.profileImage);
      });
    }



  }

  _profilePicker(String type) async {
    File? pickedFile;
    var pr = ToastBuilder().setProgressDialogWithPercent(context,'Uploading Image...');
    if (type == "Gallery")
      pickedFile = await ImagePickerAndCropperUtil().pickImage(context);
    else {
      final cameras = await availableCameras();
      var reult = await Navigator.push(context,
          MaterialPageRoute(builder: (context) => Camera(cameras: cameras,type: "camera")));
      pickedFile = File(reult["result"]);
    }
    if (pickedFile != null) {
      var croppedFile =
      await ImagePickerAndCropperUtil().cropFile(context, pickedFile);

      if (croppedFile != null) {
        print("Selected path"+croppedFile.path);
        bool isFaceDetected= await Utility().recognizeFace(croppedFile);
        if(isFaceDetected)
          {   await pr.show();
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
              token: prefs!.getString("token"),
              contextId: prefs!.getInt("userId").toString(),
              contextType: CONTEXTTYPE_ENUM.PROFILE.type,
              ownerId: prefs!.getInt("userId").toString(),
              ownerType: OWNERTYPE_ENUM.PERSON.type,
              file: croppedFile,
              subContextId: "",
              subContextType: "",
              onProgressCallback: (int value){
                pr.update(progress:value.toDouble());
              },
              mimeType: contentType[1],
              contentType: contentType[0])
              .uploadFile()
              .then((value) async {
            await  pr.hide();
            var imageResponse = ImageUpdateResponse.fromJson(value);
            updateImage(imageResponse.rows!.fileUrl, OWNERTYPE.person.type,
                IMAGETYPE.profile.type);
          }).catchError((onError) async {
            await pr.hide();
            print(onError.toString());
          });}
        else
          {
            showDialog(context: context,builder: (BuildContext context)=> InvalidProfileImageDilog());
          }




      }
    }
  }

  updateImage(String? url, String ownerType, String imageType) async {
    ImageUpdateRequest request = ImageUpdateRequest();
    request.imagePath = url;
    request.imageType = imageType;
    request.ownerId = prefs!.getInt("userId");
    request.ownerType = ownerType;
    var data = jsonEncode(request);
    Calls().call(data, context, Config.IMAGEUPDATE).then((value) async {

      var resposne = DynamicResponse.fromJson(value);
      if (resposne.statusCode == Strings.success_code) {
        setState(() {
          imageUrl = url;
          prefs!.setString("profileImagePath", imagePath!.path);
          prefs!.setString("imageUrl", imageUrl!);
        });
      }
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



    if (imagePath != null) {
      imageChild = Container(
        child: new FittedBox(
          child: new Image.file(imagePath!),
          fit: BoxFit.fill,
        ),
      );
    }

    if (imageUrl != null) {
      imageChild = Container(
        child: new FittedBox(
          child: Container(
            child:  CachedNetworkImage(
              imageUrl:Config.BASE_URL+ imageUrl!,

              fit: BoxFit.fill,
            ),
          ),
          fit: BoxFit.fill,
        ),
      );
    }


    else if (selectPath != null) {
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
              appBar: appAppBar().getCustomAppBar(context,
                  appBarTitle: AppLocalizations.of(context)!.translate('upload_image'), onBackButtonPress: () {
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
                                  AppLocalizations.of(context)!
                                      .translate("upload_image_content"),
                                  style: styleElements
                                      .subtitle1ThemeScalable(context),
                                  textAlign: TextAlign.center,
                                ),
                              )),
                          Align(
                              alignment: Alignment.center,
                              child: Container(
                                margin: const EdgeInsets.only(
                                    left: 16.0, right: 16.0, top: 5),
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .translate("upload_image_content2"),
                                  style: styleElements
                                      .subtitle2ThemeScalable(context),
                                  textAlign: TextAlign.center,
                                ),
                              )),
                          Container(
                              margin: const EdgeInsets.only(
                                  left: 16.0, right: 16.0, top: 10),
                              child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: ButtonTheme(
                                    minWidth: 80,
                                    height: 80,
                                    child: RawMaterialButton(
                                      onPressed: () {
                                        _showSelectionDialog(context);
                                      },
                                      elevation: 2.0,
                                      child: Icon(
                                        Icons.camera_alt,
                                        size: 30,
                                        color: HexColor(AppColors.appColorWhite),
                                      ),
                                      fillColor: HexColor(AppColors.appMainColor),
                                      padding: EdgeInsets.all(15.0),
                                      shape: CircleBorder(),
                                    ),
                                  ))),
                        ],
                      ),
                    ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 60,
                          color: HexColor(AppColors.appColorWhite),
                          child: Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                margin: const EdgeInsets.only(
                                    left: 16.0, right: 16.0),
                                child: appElevatedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side:
                                      BorderSide(color: HexColor(AppColors.appMainColor))),
                                  onPressed: () {
                                    {

                                      if (imageUrl != null ||
                                          selectPath != null) {
                                        if (registerUserAs != null) {
                                          print(
                                              "UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU");

                                        } else {

                                          Navigator.of(context).pop({
                                            'imageUrl': imageUrl
                                          });

                                        }
                                      } else {
                                        ToastBuilder().showToast(
                                            AppLocalizations.of(context)!.translate("upload_image_"),
                                            sctx,
                                            HexColor(AppColors.information));
                                      }
                                    }
                                  },
                                  color: HexColor(AppColors.appColorWhite),
                                  child: Text(
                                      AppLocalizations.of(context)!
                                          .translate('next'),
                                      style: styleElements
                                          .buttonThemeScalable(context)
                                          .copyWith(
                                          color: Theme.of(context)
                                              .accentColor)),
                                ),
                              )),
                        ))
                  ],
                );
              })),
        ));
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
