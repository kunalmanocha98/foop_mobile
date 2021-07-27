import 'dart:convert';
import 'dart:io';

import 'package:GlobalUploadFilePkg/Enums/contexttype.dart';
import 'package:GlobalUploadFilePkg/Enums/ownertype.dart';
import 'package:GlobalUploadFilePkg/Files/GlobalUploadFilePkg.dart';
import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/camera_module/camera_page.dart';
import 'package:oho_works_app/components/appAvatar.dart';
import 'package:oho_works_app/enums/resolutionenums.dart';
import 'package:oho_works_app/enums/serviceTypeEnums.dart';
import 'package:oho_works_app/models/imageuploadrequestandresponse.dart';
import 'package:oho_works_app/models/post/keywordsList.dart';
import 'package:oho_works_app/models/post/postcreate.dart';
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
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class appAttachments extends StatefulWidget {
  Function(String?)? mentionCallback;
  Function(String)? hashTagCallback;
  bool isHashTagVisible;
  bool isMentionVisible;

  appAttachments(Key key,{this.mentionCallback,this.hashTagCallback,this.isHashTagVisible= true, this.isMentionVisible= true}):super(key: key);
  @override
  appAttachmentsState createState() => appAttachmentsState();
}

class appAttachmentsState extends State<appAttachments> {
  List<MediaDetails> mediaList = [];
  late TextStyleElements styleElements;
  SharedPreferences? prefs;
  TextEditingController typeAheadControllerMention =TextEditingController();
  TextEditingController typeAheadControllerHashTag =TextEditingController();
  bool isMentionActive = false;
  bool isHashTagActive = false;
  List<String?> _listOfHashTags = [];

  List<String?> get  getListOfTags => _listOfHashTags;

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          Visibility(
            visible: mediaList.length>0,
            child: Container(
              width: double.infinity,
              height: 72,
              child: ListView.builder(
                itemCount: mediaList.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 72,
                    width: 72,
                    padding: EdgeInsets.only(
                        left: 4, right: 4, bottom: 4, top: 4),
                    child: Stack(
                      children: [
                        Align(
                            alignment: Alignment.bottomLeft,
                            child: SizedBox(
                              height: 56,
                              width: 56,
                              child: Stack(
                                children: [
                                  // mediaList[index].mediaType == 'video'?
                                  //     appVideoView(
                                  //       onFullPage: false,
                                  //       mediaUrl: Config.BASE_URL+mediaList[index].mediaThumbnailUrl,
                                  //     )
                                  //     :
                                  CachedNetworkImage(
                                    height: 56,
                                    width: 56,
                                    imageUrl: Utility().getUrlForImage(mediaList[index].mediaUrl, RESOLUTION_TYPE.R64, SERVICE_TYPE.POST) ,
                                    fit: BoxFit.cover,
                                  ),
                                  Visibility(
                                    visible: mediaList[index].mediaType == 'video',
                                    child: Container(
                                      child: Center(
                                          child:Icon(Icons.play_circle_outline_outlined,color:HexColor(AppColors.appMainColor)
                                          )
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: Utility().checkFileMimeType(mediaList[index].mediaType),
                                    child: Container(
                                      child: Center(
                                          child:Icon(Icons.file_copy_outlined,color:HexColor(AppColors.appMainColor)
                                          )
                                      ),
                                    ),
                                  )

                                ],
                              ),
                            )
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  mediaList.removeAt(index);
                                });
                              },
                              child: Container(
                                height: 18,
                                width: 18,
                                child: Image.asset('assets/appimages/cancel.png',fit: BoxFit.cover,
                                ),
                              )
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          // SingleChildScrollView(
          //   scrollDirection: Axis.horizontal,
          //   child: Row(
          //       children: [
          //
          //   ),
          // ),

          Visibility(
              visible: _listOfHashTags.length>0,
              child: Container(
                height: 50,
                padding: EdgeInsets.only(top: 8,bottom: 8,left:8 ,right: 8),
                alignment: Alignment.centerLeft,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: _listOfHashTags.length,
                  padding: EdgeInsets.only(left: 8,right: 8),
                  itemBuilder: (BuildContext context, int index) {
                    return Flexible(
                      child: Chip(
                        label: Text(_listOfHashTags[index]!),
                        padding: EdgeInsets.all(8),
                        onDeleted: (){
                          setState(() {
                            _listOfHashTags.removeAt(index);
                          });
                        },
                      ),
                    );
                  },),
              )
          ),

          Visibility(
              visible: isMentionActive,
              child:Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: TypeAheadField(
                    suggestionsCallback: (String pattern) async{
                      if(pattern.isNotEmpty) {
                        var data = {
                          "page_size":5,
                          "page_number":1,
                          "search_val": pattern
                        };
                        var res = await Calls().call(jsonEncode(data), context, Config.MENTIONS_LIST);
                        if(MentionsListResponse
                            .fromJson(res)
                            .rows!.length>0) {
                          return MentionsListResponse
                              .fromJson(res)
                              .rows!;
                        }else{
                          return [];
                        }
                      }else{
                        return [];
                      }
                    },

                    itemBuilder: ( context,  itemData) {

                      itemData as MentionListItem;
                      return ListTile(
                        leading: appAvatar(
                          service_type: SERVICE_TYPE.PERSON,
                          resolution_type: RESOLUTION_TYPE.R64,
                          imageUrl: itemData.profileImage,
                        ),
                        title: Text(itemData.fullName!, style: styleElements.subtitle1ThemeScalable(context),),
                        subtitle: Text(AppLocalizations.of(context)!.translate('at_the_rate')+itemData.slug!,style: styleElements.subtitle2ThemeScalable(context),),
                      );
                    },
                    onSuggestionSelected: ( suggestion) {
                      suggestion as MentionListItem;
                      typeAheadControllerMention.text ="";
                      widget.mentionCallback!(suggestion.slug);
                    },
                    direction: AxisDirection.up,
                    textFieldConfiguration: TextFieldConfiguration(
                      autofocus: true,
                      controller: typeAheadControllerMention,
                      style: styleElements.subtitle1ThemeScalable(context).copyWith(
                          color: HexColor(AppColors.appColorBlack65)
                      ),
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(AppLocalizations.of(context)!.translate('at_the_rate'),style: styleElements.headline6ThemeScalable(context),),
                        ),
                        contentPadding: EdgeInsets.only(top:16,left: 16,right: 16),
                        hintText: AppLocalizations.of(context)!.translate('mention_here'),
                        hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35))
                      ),
                    ),
                  )
              )
          ),

          Visibility(
              visible: isHashTagActive,
              child:Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: TypeAheadField(
                    suggestionsCallback: (String pattern) async{
                      if(pattern.isNotEmpty) {
                        KeywordListRequest payload = KeywordListRequest();
                        payload.searchVal = pattern;
                        payload.pageSize = 5;
                        payload.pageNumber = 1;
                        var res = await Calls().call(
                            jsonEncode(payload), context, Config.KEYWORDS_LIST);
                        if(KeywordListResponse
                            .fromJson(res)
                            .rows!.length>0) {
                          return KeywordListResponse
                              .fromJson(res)
                              .rows!;
                        }else{
                          return [];
                        }
                      }else{
                        return [];
                      }
                    },

                    itemBuilder: ( context,  itemData) {

                      itemData as KeywordListItem;
                      return ListTile(
                        title: Text(AppLocalizations.of(context)!.translate('hash')+itemData.keyword!, style: styleElements.subtitle1ThemeScalable(context),),
                      );
                    },
                    onSuggestionSelected: ( suggestion) {

                      suggestion as KeywordListItem;
                      typeAheadControllerHashTag.text ="";
                      setState(() {
                        _listOfHashTags.add(suggestion.display);
                      });
                      // widget.hashTagCallback(suggestion.display);
                    },
                    direction: AxisDirection.up,
                    textFieldConfiguration: TextFieldConfiguration(
                      autofocus: true,
                      onSubmitted: (value){
                        typeAheadControllerHashTag.text ="";
                        setState(() {
                          _listOfHashTags.add(value);
                        });
                        // widget.hashTagCallback(value);
                      },
                      controller: typeAheadControllerHashTag,
                      style: styleElements.subtitle1ThemeScalable(context).copyWith(
                        color: HexColor(AppColors.appColorBlack65)
                      ),
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(AppLocalizations.of(context)!.translate('hash'),style: styleElements.headline6ThemeScalable(context),),
                        ),
                        contentPadding: EdgeInsets.only(top:16,left: 16,right: 16),
                        hintText: AppLocalizations.of(context)!.translate('enter_tags'),
                        hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35))
                      ),
                    ),
                  )
              )
          ),

          Card(
            elevation: 0,
            child: Row(
              children: [
                Visibility(
                  visible: widget.isMentionVisible,
                  child: IconButton(
                    icon: Text(AppLocalizations.of(context)!.translate('at_the_rate'),style: styleElements.headline6ThemeScalable(context).copyWith(
                        color: HexColor(AppColors.appColorBlack35)
                    ),),
                    onPressed: (){
                      setState(() {
                        if(isMentionActive){
                          isMentionActive = !isMentionActive;
                        }else{
                          isMentionActive =!isMentionActive;
                          isHashTagActive = false;
                        }
                      });
                    },
                  ),
                ),
                Visibility(
                  visible: widget.isHashTagVisible,
                  child: IconButton(
                    icon: Text(AppLocalizations.of(context)!.translate('hash'),style: styleElements.headline6ThemeScalable(context).copyWith(
                        color: HexColor(AppColors.appColorBlack35)
                    ),),
                    onPressed: (){
                      setState(() {
                        if(isHashTagActive){
                          isHashTagActive = !isHashTagActive;
                        }else{
                          isHashTagActive =!isHashTagActive;
                          isMentionActive = false;
                        }
                      });
                    },
                  ),
                ),
                Spacer(),
                // IconButton(
                //     icon: Icon(Icons.file_copy_outlined,color: HexColor(AppColors.appColorBlack35),),
                //     onPressed: () {
                //       fileUploader();
                //     }
                // ),
                IconButton(
                    icon: Icon(Icons.file_copy_outlined,color: HexColor(AppColors.appColorBlack35),),
                    onPressed: () {
                      fileUploader();
                    }
                ),
                IconButton(
                    icon: Icon(Icons.image_outlined,color: HexColor(AppColors.appColorBlack35),),
                    onPressed: () {
                      if(mediaList.length<=10) {
                        _showSelectionDialog(context, 'image');
                      }else{
                        ToastBuilder().showToast('you can only add 10 images/videos', context,HexColor(AppColors.information));
                      }
                    }
                ),
                IconButton(
                    icon: Icon(Icons.videocam_outlined,color: HexColor(AppColors.appColorBlack35)),
                    onPressed: () {
                      if(mediaList.length<=10) {
                        _showSelectionDialog(context, 'video');
                      }else{
                        ToastBuilder().showToast('you can only add 10 images/videos', context,HexColor(AppColors.information));
                      }
                    }
                ),
                /*  Visibility(
                  visible: false,
                  child: IconButton(
                      icon: Icon(Icons.upload_file,color: HexColor(AppColors.appColorBlack35)),
                      onPressed: () async {
                        FilePickerResult result = await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: [ 'pdf', 'doc','txt','xlsx','xlsm','xls','csv'],
                        );
                        if(result != null) {
                          File file = File(result.files.single.path);
                          PlatformFile f = result.files.first;
                          fileUploader(file,f.extension);
                        } else {
                          // User canceled the picker
                        }
                      }
                  ),
                )*/
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> _showSelectionDialog(BuildContext context,String type) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(
                  AppLocalizations.of(context)!.translate('select_an_option')
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        FocusScope.of(context).requestFocus(new FocusNode());
                        Navigator.pop(context, null);
                        if(type == 'image') {
                          imagePicker("gallery");
                        }else{
                          videoPicker("gallery");
                        }
                        // _profilePicker("Gallery");
                      },
                      child: Text(
                          AppLocalizations.of(context)!.translate('gallery')),
                    ),
                    Padding(padding: EdgeInsets.all(16.0)),
                    GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        FocusScope.of(context).requestFocus(new FocusNode());
                        Navigator.pop(context, null);
                        if(type == 'image') {
                          imagePicker("camera");
                        }else{
                          videoPicker("camera");
                        }
                      },
                      child: Text(
                          AppLocalizations.of(context)!.translate('camera')),
                    ),
                    Padding(padding: EdgeInsets.all(8.0)),
                  ],
                ),
              ));
        });
  }

  void imagePicker(String type) async {
    File? pickedFile;
    var pr = ToastBuilder().setProgressDialogWithPercent(context,'Uploading Image...');
    prefs ??= await SharedPreferences.getInstance();
    if(type=="gallery"){
      pickedFile = await ImagePickerAndCropperUtil().pickImage(context);
      print("#####PATH###  "+pickedFile!.path);
    }else{
      final cameras = await availableCameras();
      var reult = await Navigator.push(context,
          MaterialPageRoute(builder: (context) => Camera(cameras: cameras,type: "camera",)));
      File p = File(reult["result"]);
      pickedFile = await ImagePickerAndCropperUtil().cropFileMulti(context, p);
      print(reult["result"]+"pppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp");
    }
    // File pickedFile = await ImagePickerAndCropperUtil().pickImage(context);
    // var croppedFile = await ImagePickerAndCropperUtil().cropFile(
    //     context, pickedFile);
    if (pickedFile != null) {
      await pr.show();
      var contentType = ImagePickerAndCropperUtil().getMimeandContentType(
          pickedFile.path);
      await UploadFile(
          baseUrl: Config.BASE_URL,
          context: context,
          token: prefs!.getString("token"),
          contextId: '',
          contextType: CONTEXTTYPE_ENUM.FEED.type,
          ownerId: prefs!.getInt(Strings.userId).toString(),
          ownerType: OWNERTYPE_ENUM.PERSON.type,
          file: pickedFile,
          subContextId: "",
          subContextType: "",
          onProgressCallback: (int value){
            pr.update(progress:value.toDouble());
          },
          mimeType: contentType[1],
          contentType: contentType[0])
          .uploadFile()
          .then((value) async {
        print(value);
        var imageResponse = ImageUpdateResponse.fromJson(value);
        print (jsonEncode(imageResponse));
        if(imageResponse.statusCode == Strings.success_code) {
          addImage(
              imageResponse.rows!.fileUrl, imageResponse.rows!.fileThumbnailUrl,
              "image");
          await pr.hide();
        }else{
          await pr.hide();
          ToastBuilder().showToast(imageResponse.message!, context, HexColor(AppColors.information));
        }
      }).catchError((onError) async {
        await pr.hide();
        print(onError.toString());
        ToastBuilder().showToast(AppLocalizations.of(context)!.translate('some_error_occurred'), context, HexColor(AppColors.information));
      });
    }else{
      await pr.hide();
      ToastBuilder().showToast(AppLocalizations.of(context)!.translate('corrupted_file_error'), context, HexColor(AppColors.information));

    }
  }
  void fileUploader() async {
    File? pickedFile;
    prefs ??= await SharedPreferences.getInstance();
    var pr = ToastBuilder().setProgressDialogWithPercent(context,'Uploading File...');
    pickedFile = await ImagePickerAndCropperUtil().pickFiles(context);
    if (pickedFile != null) {
      pr.show();
      var contentType = ImagePickerAndCropperUtil().getMimeandContentType(pickedFile.path);
      await UploadFile(
          baseUrl: Config.BASE_URL,
          context: context,
          token: prefs!.getString("token"),
          contextId: '',
          contextType: CONTEXTTYPE_ENUM.FEED.type,
          ownerId: prefs!.getInt(Strings.userId).toString(),
          ownerType: OWNERTYPE_ENUM.PERSON.type,
          onProgressCallback: (int value){
            pr.update(progress:value.toDouble());
          },
          file: pickedFile,
          subContextId: "",
          subContextType: "",
          mimeType: contentType[1],
          contentType: contentType[0])
          .uploadFile()
          .then((value) async {
        await pr.hide();
        print(value);
        var imageResponse = ImageUpdateResponse.fromJson(value);
        print(jsonEncode(imageResponse));
        if(imageResponse.statusCode == Strings.success_code) {
          await pr.hide();

          print(Utility().getExtension(context, pickedFile!.path)+"-------------------------------------------------------file uploader method");
          addImage(
              imageResponse.rows!.fileUrl, imageResponse.rows!.fileThumbnailUrl,
              Utility().getExtension(context, pickedFile.path));
        }else{
          await pr.hide();
          ToastBuilder().showToast(imageResponse.message!, context, HexColor(AppColors.information));
        }
      }).catchError((onError) async {
        await pr.hide();
        print(onError.toString());
        ToastBuilder().showToast(AppLocalizations.of(context)!.translate('some_error_occurred'), context, HexColor(AppColors.information));
      });
    }else{
      await pr.hide();
      ToastBuilder().showToast(AppLocalizations.of(context)!.translate('corrupted_file_error'), context, HexColor(AppColors.information));
    }
  }
  void videoPicker(String type) async {
    File? pickedFile;
    var pr = ToastBuilder().setProgressDialogWithPercent(context, 'Uploading Video');
    prefs = await SharedPreferences.getInstance();
    if(type=="gallery"){
      pickedFile = await ImagePickerAndCropperUtil().pickVideo(context);
    }else{
      pickedFile = await ImagePickerAndCropperUtil().pickVideoCamera(context);
      print(pickedFile!.path.toString()+"------------------------------------------------------------");
    }
    // File pickedFile = await ImagePickerAndCropperUtil().pickImage(context);
    // var croppedFile = await ImagePickerAndCropperUtil().cropFile(
    //     context, pickedFile);
    if (pickedFile != null) {
      await pr.show();
      var contentType = ImagePickerAndCropperUtil().getMimeandContentType(
          pickedFile.path);
      await UploadFile(
          baseUrl: Config.BASE_URL,
          context: context,
          token: prefs!.getString("token"),
          contextId: '',
          contextType: CONTEXTTYPE_ENUM.FEED.type,
          ownerId:  prefs!.getInt(Strings.userId).toString(),
          ownerType: OWNERTYPE_ENUM.PERSON.type,
          file: pickedFile,
          subContextId: "",
          subContextType: "",
          onProgressCallback: (int progress){
            pr.update(progress: progress.toDouble());
          },
          mimeType: contentType[1],
          contentType: contentType[0])
          .uploadFile()
          .then((value) async {
        var imageResponse = ImageUpdateResponse.fromJson(value);
        print(value);
        if(imageResponse.statusCode == Strings.success_code) {
          addImage(
              imageResponse.rows!.fileUrl, imageResponse.rows!.fileThumbnailUrl,
              "video");
          await pr.hide();
        }else{
          ToastBuilder().showToast(imageResponse.message!, context, HexColor(AppColors.information));
        }
      }).catchError((onError) async {
        await pr.hide();
        print(onError.toString());
        ToastBuilder().showToast(AppLocalizations.of(context)!.translate('some_error_occurred'), context, HexColor(AppColors.information));
      });
    }else{
      await pr.hide();
      ToastBuilder().showToast(AppLocalizations.of(context)!.translate('corrupted_file_error'), context, HexColor(AppColors.information));
    }
  }
  void addImage(String? mediaUrl,String? mediaThumbnailUrl, String mediaType) {
    setState(() {
      mediaList.add(MediaDetails(mediaType: mediaType, mediaUrl: mediaUrl,mediaThumbnailUrl: mediaThumbnailUrl));
    });
  }

  int getcount() {
    return mediaList.length;
  }
  @override
  void initState() {

    super.initState();
  }

  /*  uploadSharedImages(List<SharedMediaFile> sharedFiles)
    async {
      for(var item in widget.sharedFiles )
      {
        uploadFiles(item.path,"image");
      }

    }*/



    uploadFiles(String path, String type)
    async {
      File pickedFile=new File(path);
      prefs ??= await SharedPreferences.getInstance();

      if (pickedFile != null) {

        var contentType =ImagePickerAndCropperUtil().getMimeandContentType(pickedFile.path);
        await UploadFile(
            baseUrl: Config.BASE_URL,
            context: context,
            token: prefs!.getString("token"),
      contextId: '',
      contextType: CONTEXTTYPE_ENUM.FEED.type,
      ownerId: prefs!.getInt(Strings.userId).toString(),
      ownerType: OWNERTYPE_ENUM.PERSON.type,
      onProgressCallback: (int value){

      },
      file: pickedFile,
      subContextId: "",
      subContextType: "",
      mimeType: contentType[1],
      contentType: contentType[0])
          .uploadFile()
          .then((value) async {

    print(value);
    var imageResponse = ImageUpdateResponse.fromJson(value);
    print(jsonEncode(imageResponse));
    addImage(imageResponse.rows!.fileUrl, imageResponse.rows!.fileThumbnailUrl, "image");
    }).catchError((onError) async {
    print(onError.toString());
    });
    }else{

    }
    }
  }

