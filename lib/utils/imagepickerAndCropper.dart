import 'dart:io';

import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

class ImagePickerAndCropperUtil {
  late ImagePicker _imagePicker;

  ImagePickerAndCropperUtil() {
    _imagePicker = ImagePicker();
  }
  Future<File?> pickAttachments(BuildContext context) async{
    try{
      var file = await FilePicker.platform.pickFiles(type: FileType.any,allowMultiple: false);
      if (file != null) return File(file.paths[0]!);
      return null;
    }
    catch(onError){
      print(onError);
      return null;
    }
  }

  Future<File?> pickImage(BuildContext context) async {
    try {
      var picture = await FilePicker.platform.pickFiles(type: FileType.image,allowMultiple: false);
      if (picture != null) return File(picture.paths[0]!);
      return null;
    } catch (onError) {
      print(onError);
      ToastBuilder().showToast(onError.toString(), context,HexColor(AppColors.information));
      return null;
    }
  }

  Future<File?> pickImageCamera(BuildContext context) async {
    try {
      var picture = await _imagePicker.getImage(source: ImageSource.camera);

      if (picture != null) return File(picture.path);
      return null;
    } catch (onError) {
      print(onError);
      ToastBuilder().showToast(onError.toString(), context,HexColor(AppColors.information));
      return null;
    }
  }

  Future<File?> pickVideo(BuildContext context) async {
    try {
      var video  = await FilePicker.platform.pickFiles(type: FileType.video,allowMultiple: false);
      if(video !=null) return File(video.paths[0]!);
      // var picture = await _imagePicker.getVideo(source: ImageSource.gallery);
      // if (picture != null) return File(picture.path);
      return null;
    } catch (onError) {
      print(onError);
      ToastBuilder().showToast(onError.toString(), context,HexColor(AppColors.information));
      return null;
    }
  }

  Future<File?> pickVideoCamera(BuildContext context) async {
    try {
      var picture = await _imagePicker.getVideo(source: ImageSource.camera);
      if (picture != null) return File(picture.path);
      return null;
    } catch (onError) {
      print(onError);
      ToastBuilder().showToast(onError.toString(), context,HexColor(AppColors.information));
      return null;
    }
  }

  Future<File?> pickFiles(BuildContext context) async{
    try{
      var file = await FilePicker.platform.pickFiles(type: FileType.custom,allowMultiple: false,allowedExtensions: ['pdf','xls','xlsx','doc','docx','ppt','pptx']);
      if (file != null) return File(file.paths[0]!);
      return null;
    }
    catch(onError){
      print(onError);
      return null;
    }
  }

  Future<File?> cropFileMulti(BuildContext context, File file) async {
    File? croppedFile = await ImageCropper.cropImage(
        sourcePath: file.path,
        aspectRatioPresets:[
          ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop Image',
          ),
        iosUiSettings: IOSUiSettings(
          title: 'Crop Image',

        ));

    return croppedFile;
  }

  Future<File?> cropFile(BuildContext context, File file) async {
    File? croppedFile = await ImageCropper.cropImage(
        sourcePath: file.path,
        aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
        aspectRatioPresets:[
          CropAspectRatioPreset.square,
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: HexColor(AppColors.appColorWhite),
            toolbarWidgetColor: HexColor(AppColors.appColorBlack85),
            statusBarColor: HexColor(AppColors.appColorWhite),
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true),
        iosUiSettings: IOSUiSettings(
          title: 'Crop Image',
            rotateClockwiseButtonHidden:false,
          aspectRatioLockEnabled: false,
            aspectRatioPickerButtonHidden:false,
           minimumAspectRatio: 1.0

        ));

    return croppedFile;
  }

  List<String> getMimeandContentType(String path) {
    String lookupmime = lookupMimeType(path)!;
    return lookupmime.split('/');
  }
}
