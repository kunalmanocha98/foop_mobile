// import 'dart:io';
//
// import 'package:GlobalUploadFilePkg/Enums/contexttype.dart';
// import 'package:GlobalUploadFilePkg/Enums/ownertype.dart';
// import 'package:GlobalUploadFilePkg/Files/GlobalUploadFilePkg.dart';
// import 'package:oho_works_app/models/imageuploadrequestandresponse.dart';
// import 'package:oho_works_app/utils/config.dart';
// import 'package:oho_works_app/utils/imagepickerAndCropper.dart';
// import 'package:oho_works_app/utils/strings.dart';
// import 'package:oho_works_app/utils/toast_builder.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:zefyr/zefyr.dart';

// class CustomImageDelegate implements ZefyrImageDelegate<ImageSource> {
//   BuildContext context;
//   SharedPreferences prefs;
//   CustomImageDelegate(this.context,this.prefs);
//
//   @override
//   Future<String> pickImage(ImageSource source) async {
//     prefs ??= await SharedPreferences.getInstance();
//     var progress = ToastBuilder().setProgressDialog(context);
//     progress.show();
//     File pickedFile ;
//     var contentType ;
//     if(source == ImageSource.gallery){
//       var  file = await FilePicker.platform.pickFiles(type: FileType.image,allowMultiple: false);
//       if (file == null) return null;
//       pickedFile = File(file.paths[0]);
//       contentType = ImagePickerAndCropperUtil().getMimeandContentType(pickedFile.path);
//     }else{
//       var  file = await ImagePicker().getImage(source: ImageSource.camera);
//       if (file == null) return null;
//       pickedFile = File(file.path);
//       contentType = ImagePickerAndCropperUtil().getMimeandContentType(pickedFile.path);
//     }
//     var res  =  await UploadFile(
//         baseUrl: Config.BASE_URL,
//         context: context,
//         token: prefs.getString("token"),
//         contextId: '',
//         contextType: CONTEXTTYPE_ENUM.FEED.type,
//         ownerId: prefs.getInt(Strings.userId).toString(),
//         ownerType: OWNERTYPE_ENUM.PERSON.type,
//         file: pickedFile,
//         subContextId: "",
//         subContextType: "",
//         mimeType: contentType[1],
//         contentType: contentType[0])
//         .uploadFile();
//     progress.hide();
//     print(res);
//     var imageResponse = ImageUpdateResponse.fromJson(res);
//     print(imageResponse);
//     // We simply return the absolute path to selected file
//     return Config.BASE_URL+imageResponse.rows.fileThumbnailUrl;
//   }
//
//   @override
//   Widget buildImage(BuildContext context, String key) {
//     // final file = File.fromUri(Uri.parse(key));
//     /// Create standard [FileImage] provider. If [key] was an HTTP link
//     /// we could use [CachedNetworkImageProvider] instead.
//     // final image = FileImage(file);
//     return CachedNetworkImage(
//       imageUrl: key,
//       fit: BoxFit.contain,
//     );
//   }
//
//   @override
//   ImageSource get cameraSource => ImageSource.camera;
//
//   @override
//   ImageSource get gallerySource => ImageSource.gallery;
// }