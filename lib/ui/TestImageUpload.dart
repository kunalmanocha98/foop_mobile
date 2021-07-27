import 'dart:async';
// import 'package:image_cropper/image_cropper.dart';
import 'dart:io';

import 'package:GlobalUploadFilePkg/Enums/contexttype.dart';
import 'package:GlobalUploadFilePkg/Enums/ownertype.dart';
import 'package:GlobalUploadFilePkg/Files/GlobalUploadFilePkg.dart';
import 'package:oho_works_app/components/app_buttons.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:file_picker/file_picker.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TestImageUpload extends StatefulWidget {
  @override
  _TestImageUpload createState() => _TestImageUpload();
}

class _TestImageUpload extends State<TestImageUpload> {
  var imagePicker = ImagePicker();
  File? _imageFile;
  late SharedPreferences prefs;
  String? mimeType, contentType;
  File? _videoFile;

  // File _documentFile;

  void _openGallery(BuildContext context) async {
    try {
      var picture = await (imagePicker.getImage(source: ImageSource.gallery) as FutureOr<PickedFile>);
      prefs = await SharedPreferences.getInstance();
      String lookupmime = lookupMimeType(picture.path)!;
      var filetype = lookupmime.split('/');
      mimeType = filetype[1];
      contentType = filetype[0];
      _cropImage(picture.path);
      // setState(() {
      //   _imageFile = File(picture.path);
      // });
    } catch (onError) {
      print(onError);
      ToastBuilder().showToast(onError.toString(), context,HexColor(AppColors.failure));
    }
  }

  void _openGalleryForVideo(BuildContext context) async {
    try {
      var picture = await (imagePicker.getVideo(source: ImageSource.gallery) as FutureOr<PickedFile>);
      prefs = await SharedPreferences.getInstance();
      String lookupmime = lookupMimeType(picture.path)!;
      var filetype = lookupmime.split('/');
      mimeType = filetype[1];
      contentType = filetype[0];
      // _cropImage(File(picture.path));
      setState(() {
        _videoFile = File(picture.path);
      });
    } catch (onError) {
      print(onError);
      ToastBuilder().showToast(onError.toString(), context,HexColor(AppColors.failure));
    }
  }

  void _openGalleryForDocument(BuildContext context) async {
    try {
      var file = await (FilePicker.platform.pickFiles(type: FileType.custom) as FutureOr<FilePickerResult>);
      prefs = await SharedPreferences.getInstance();
      String lookupmime = lookupMimeType(file.files.first.path!)!;
      var filetype = lookupmime.split('/');
      mimeType = filetype[1];
      contentType = filetype[0];
      // _cropImage(File(picture.path));
      setState(() {
        // _documentFile = File(file.files.first.path);
      });
    } catch (onError) {
      print(onError);
      ToastBuilder().showToast(onError.toString(), context,HexColor(AppColors.information));
    }
  }

  Future<Null> _cropImage(String path) async {
    File? croppedFile = await ImageCropper.cropImage(
        sourcePath: path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: HexColor(AppColors.appMainColor),
            toolbarWidgetColor: HexColor(AppColors.appColorWhite),
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Crop Image',
        ));
    if (croppedFile != null) {
      setState(() {
        _imageFile = croppedFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
            child: Wrap(
          direction: Axis.vertical,
          spacing: 24,
          children: [
            Container(
              height: 200,
              width: 100,
              child: _imageFile != null
                  ? Image.file(
                      _imageFile!,
                      fit: BoxFit.fill,
                    )
                  : Text(AppLocalizations.of(context)!.translate('no_image_selected')),
            ),
            appElevatedButton(
              elevation: 8,
              child: Text(AppLocalizations.of(context)!.translate('img_upload')),
              shape: StadiumBorder(),
              onPressed: () {
                _openGallery(context);
              },
            ),
            appElevatedButton(
              elevation: 8,
              child: Text(AppLocalizations.of(context)!.translate('vid_upload')),
              shape: StadiumBorder(),
              onPressed: () {
                _openGalleryForVideo(context);
              },
            ),
            appElevatedButton(
              elevation: 8,
              child: Text(AppLocalizations.of(context)!.translate('doc_upload')),
              shape: StadiumBorder(),
              onPressed: () {
                _openGalleryForDocument(context);
              },
            ),
            appElevatedButton(
              color: HexColor(AppColors.appMainColor),
              padding: EdgeInsets.all(16),
              elevation: 8,
              child: Text(AppLocalizations.of(context)!.translate('doc_upload')),
              shape: StadiumBorder(),
              onPressed: () {
                uploadDocumentfile();
              },
            ),
          ],
        )),
      ),
    );
  }

  void uploadfile() async {
    var response = await UploadFile(
            baseUrl: Config.BASE_URL,
            context: context,
            token: prefs.getString("token"),
            contextId: "2",
            contextType: CONTEXTTYPE_ENUM.COVER.type,
            ownerId: "2",
            ownerType: OWNERTYPE_ENUM.PERSON.type,
            file: _imageFile,
            subContextId: "",
            subContextType: "",
            mimeType: mimeType,
            contentType: contentType)
        .uploadFile();

    print(response);
  }

  void uploadVideofile() async {
    var response = await UploadFile(
            baseUrl: Config.BASE_URL,
            context: context,
            token: prefs.getString("token"),
            contextId: "2",
            contextType: CONTEXTTYPE_ENUM.COVER.type,
            ownerId: "2",
            ownerType: OWNERTYPE_ENUM.PERSON.type,
            file: _videoFile,
            subContextId: "",
            subContextType: "",
            mimeType: mimeType,
            contentType: contentType)
        .uploadFile();
    print(response);
  }

  void uploadDocumentfile() async {
    var response = await UploadFile(
            baseUrl: Config.BASE_URL,
            context: context,
            token: prefs.getString("token"),
            contextId: "2",
            contextType: CONTEXTTYPE_ENUM.COVER.type,
            ownerId: "2",
            ownerType: OWNERTYPE_ENUM.PERSON.type,
            file: _imageFile,
            subContextId: "",
            subContextType: "",
            mimeType: mimeType,
            contentType: contentType)
        .uploadFile();
    print(response.toString());
  }
}
