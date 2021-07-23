import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:GlobalUploadFilePkg/Enums/contexttype.dart';
import 'package:GlobalUploadFilePkg/Enums/ownertype.dart';
import 'package:GlobalUploadFilePkg/Enums/subcontexttype.dart';
import 'package:GlobalUploadFilePkg/Files/GlobalUploadFilePkg.dart';
import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/tricycle_buttons.dart';
import 'package:oho_works_app/enums/room_type.dart';
import 'package:oho_works_app/mixins/someCommonMixins.dart';
import 'package:oho_works_app/models/Rooms/createroom.dart';
import 'package:oho_works_app/models/Rooms/createroomresponse.dart';
import 'package:oho_works_app/models/Rooms/roomlistmodels.dart';
import 'package:oho_works_app/models/imageuploadrequestandresponse.dart';
import 'package:oho_works_app/ui/RoomModule/room_privacy_type_selection_widget.dart';
import 'package:oho_works_app/ui/RoomModule/select_topic_room_widget.dart';
import 'package:oho_works_app/ui/selectmemberPage.dart';
import 'package:oho_works_app/ui/testpages/help_rooms_page.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/imagepickerAndCropper.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class CreateRoomPage extends StatefulWidget {
  final  RoomListItem? value;
  final  bool isEdit;
  final Null Function()? callback;

  const CreateRoomPage( {
    Key? key,
    this.value, this.isEdit=false,this.callback
  }) : super(key: key);
  @override
  _CreateRoomPage createState() => _CreateRoomPage(value, isEdit,callback);
}

class _CreateRoomPage extends State<CreateRoomPage> with CommonMixins {
  RoomListItem? value;
  bool isEdit;
  late SharedPreferences prefs;
  String? _imageUrl;
  String? _thumbnailUrl;
  final Null Function()? callback;
  GlobalKey<SelectRoomTopicWidgetState> roomTopicKey = GlobalKey();
  GlobalKey<RoomPrivacyTypeWidgetState> roomPrivacyKey  = GlobalKey();

  final formKey = GlobalKey<FormState>();
  String? roomName;
  String? description;
  late TextStyleElements styleElements;
  bool isRoomCreated = false;

  void setSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  _CreateRoomPage(this.value, this.isEdit,this.callback);

  @override
  void initState() {
    super.initState();
    if(isEdit){
      if(value!=null  && value!.roomProfileImageUrl!=null){
        _imageUrl = value!.roomProfileImageUrl;
      }
    }
  }
  Widget _body() {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Container(
            child: TricycleListCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                        return HelpRoomsPage();
                      }));
                    },
                    child: Padding(
                      padding:
                      EdgeInsets.only(top: 8, bottom: 8, left: 24, right: 24),
                      child: RichText(
                        text: TextSpan(
                            children: [
                              TextSpan(
                                  text: AppLocalizations.of(context)!.translate('select_privacy_type'),
                                  style:  styleElements.bodyText2ThemeScalable(context)
                              ),
                              WidgetSpan(child: SizedBox(width: 8,)),
                              WidgetSpan(
                                  child: Icon(Icons.info_outline,color: HexColor(AppColors.appColorBlack35),size: 16,)
                              )
                            ]
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RoomPrivacyTypeWidget(key: roomPrivacyKey,selectedValue:isEdit?value!.roomPrivacyType:""),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top:4),
                      child:Container(height: 0.5,color: HexColor(AppColors.appColorBlack35),)
                  ),
                  Padding(
                    padding:
                    EdgeInsets.only(top: 8, bottom: 8, left: 24, right: 24),
                    child: Text(AppLocalizations.of(context)!.translate('select_topics'),
                      style: styleElements.bodyText2ThemeScalable(context),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SelectRoomTopicWidget(roomTopicKey,isCard: false,preSelected: isEdit?value!.roomTopics:null,),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top:8,bottom: 8),
                      child:Container(height: 0.5,color: HexColor(AppColors.appColorBlack35),)
                  ),
                  SizedBox(height: 12,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: (){
                          _showSelectionDialog(context);
                        },
                        child: Padding(
                          padding:EdgeInsets.only( left: 12, right: 12),
                          child: Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                  color: HexColor(AppColors.appColorBackground),
                                  image: DecorationImage(
                                      image: isEdit?CachedNetworkImageProvider(value!.roomProfileImageUrl!=null?Config.BASE_URL+value!.roomProfileImageUrl!:""):(_thumbnailUrl!=null?CachedNetworkImageProvider(Config.BASE_URL+_thumbnailUrl!):AssetImage('assets/appimages/grey_bg.png')) as ImageProvider<Object>
                                  )
                              ),
                              child: isEdit?value!.roomProfileImageUrl!=null?Text(''):Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.image_outlined),
                                    Text(AppLocalizations.of(context)!.translate('add_room_image'),textAlign: TextAlign.center,)
                                  ],
                                ),
                              ):_imageUrl!=null?Text(''):Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.image_outlined),
                                    Text(AppLocalizations.of(context)!.translate('add_room_image'),textAlign: TextAlign.center,)
                                  ],
                                ),
                              )
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(right:16),
                          child: TextFormField(
                            initialValue: isEdit ? value!.roomName : "",
                            validator: validateTextField,
                            style: styleElements.subtitle1ThemeScalable(context).copyWith(
                                color: HexColor(AppColors.appColorBlack65)
                            ),
                            textCapitalization: TextCapitalization.sentences,
                            onSaved: (value) {
                              roomName = value;
                            },
                            textAlignVertical: TextAlignVertical.center,
                            maxLines: 3,
                            maxLength: 80,
                            minLines: 3,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: HexColor(AppColors.appColorBlack35))
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: HexColor(AppColors.appMainColor))
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: HexColor(AppColors.appColorBlack35))
                              ),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: HexColor(AppColors.appMainColor))
                              ),
                              disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: HexColor(AppColors.appColorBlack35))
                              ),
                              contentPadding:EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 15.0),
                              hintText:AppLocalizations.of(context)!.translate('name_room'),
                              hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 12, bottom: 16, left: 16, right: 16),
                    child: Container(
                      child: TextFormField(
                        initialValue: isEdit ? value!.roomDescription : "",
                        keyboardType: TextInputType.multiline,
                        textCapitalization: TextCapitalization.sentences,
                        style: styleElements.subtitle1ThemeScalable(context).copyWith(
                            color: HexColor(AppColors.appColorBlack65)
                        ),
                        maxLines: null,
                        minLines: 4,
                        onSaved: (value) {
                          description = value;
                        },
                        scrollPadding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: HexColor(AppColors.appColorBlack35))
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: HexColor(AppColors.appMainColor))
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: HexColor(AppColors.appColorBlack35))
                          ),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: HexColor(AppColors.appMainColor))
                          ),
                          disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: HexColor(AppColors.appColorBlack35))
                          ),
                          contentPadding:
                          EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          hintText: "Describe the purpose of the club(Optional)",
                          hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

      ],
    );

  }



  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    setSharedPreferences();
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: TricycleAppBar().getCustomAppBar(context,
              actions: [
                TricycleTextButton(
                  onPressed: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => SelectMembersPage(roomId: 800, selectedRoomType: roomPrivacyKey.currentState.selectedTypeCode,callback:callback)))
                    //     .then((value) {
                    //   if (value == Strings.success_code) {
                    //     Navigator.pop(context,Strings.success_code);
                    //   }
                    // });
                    if (isEdit) {
                      updatRoom();
                    } else {
                      if(isRoomCreated){
                       updatRoom();
                      }else {
                        createRoom();
                      }
                    }
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
              appBarTitle:  isEdit
                  ? AppLocalizations.of(context)!.translate("update_room")
                  : AppLocalizations.of(context)!.translate("create_room"),
              onBackButtonPress: (){  Navigator.pop(context);}),
          body: Form(
            key: formKey,
            child:
            _body(),
          )),
    );
  }

  Future<void> createRoom() async {
    if (formKey.currentState!.validate()) {
      if (roomPrivacyKey.currentState!.selectedTypeCode!=null && roomPrivacyKey.currentState!.selectedTypeCode!.isNotEmpty) {
        formKey.currentState!.save();

        CreateRoomPayload payload = CreateRoomPayload();
        payload.roomPrivacyType = roomPrivacyKey.currentState!.selectedTypeCode;
        payload.roomTopics = roomTopicKey.currentState!.getSelectedList();
        payload.roomStatus = "A";
        payload.isSharable= true;
        payload.roomType = ROOM_TYPE.COMMUNITYROOM.type;
        payload.roomDescription = description;
        payload.roomName = roomName;
        payload.roomOwnerTypeId = prefs.getInt(Strings.userId);
        payload.roomOwnerType = prefs.getString(Strings.ownerType);
        payload.roomCreatedById = prefs.getInt(Strings.userId);
        payload.roomCreatedByType = prefs.getString(Strings.ownerType);
        payload.roomProfileImageUrl = _imageUrl;
        payload.institutionId = prefs.getInt(Strings.instituteId);

        var body = jsonEncode(payload);
        Calls().call(body, context, Config.CREATE_ROOM).then((value) async {
          var res = CreateRoomResponse.fromJson(value);
          if (res.statusCode == Strings.success_code) {
            ToastBuilder().showToast("Successfully Created", context,HexColor(AppColors.information));
            isRoomCreated = true;
            this.value = RoomListItem(id:res.rows!.id);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SelectMembersPage(roomId: res.rows!.id, selectedRoomType: roomPrivacyKey.currentState!.selectedTypeCode,callback:callback)))
                .then((value) {
              if (value == Strings.success_code) {
                Navigator.pop(context,Strings.success_code);
              }
            });
          } else {
            ToastBuilder().showToast(res.message!, context,HexColor(AppColors.information));
          }
        }).catchError((onError) {
          print(onError);
        });
      } else {
        ToastBuilder().showToast("Select a club type", context,HexColor(AppColors.information));
      }
    }
  }

  Future<void> updatRoom() async {
    if (formKey.currentState!.validate()) {
      if (roomPrivacyKey.currentState!.selectedTypeCode!=null && roomPrivacyKey.currentState!.selectedTypeCode!.isNotEmpty) {
        formKey.currentState!.save();
        CreateRoomPayload payload = CreateRoomPayload();
        payload.roomPrivacyType = roomPrivacyKey.currentState!.selectedTypeCode;
        payload.roomTopics = roomTopicKey.currentState!.getSelectedList();
        payload.isSharable= true;
        payload.roomStatus = "A";
        payload.roomDescription = description;
        payload.roomType = ROOM_TYPE.COMMUNITYROOM.type;
        payload.roomName = roomName;
        payload.roomOwnerTypeId = prefs.getInt(Strings.instituteId);
        payload.roomCreatedById = prefs.getInt(Strings.userId);
        payload.roomOwnerType = "institution";
        payload.roomCreatedByType = "person";
        payload.institutionId = prefs.getInt(Strings.instituteId);
        payload.id = value!.id;
        payload.roomProfileImageUrl = _imageUrl;
        var body = jsonEncode(payload);
        Calls().call(body, context, Config.UPDATEROOM).then((value) async {
          var res = CreateRoomResponse.fromJson(value);
          if (res.statusCode == Strings.success_code) {
            ToastBuilder().showToast("Successfully Updated", context,HexColor(AppColors.information));
            this.value!.roomStatus ='A';
            this.value!.roomDescription= description;
            this.value!.roomName = roomName;
            this.value!.roomProfileImageUrl = _imageUrl;
            if(!isEdit && isRoomCreated){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SelectMembersPage(roomId: res.rows!.id, selectedRoomType: roomPrivacyKey.currentState!.selectedTypeCode,callback:callback)))
                  .then((value) {
                if (value == Strings.success_code) {
                  Navigator.pop(context,Strings.success_code);
                }
              });
            }else {
              Navigator.pop(context);
            }
          } else {
            ToastBuilder().showToast(res.message!, context,HexColor(AppColors.information));
          }
        }).catchError((onError) {
          print(onError);
        });
      } else {
        ToastBuilder().showToast("Select a club type", context,HexColor(AppColors.information));
      }
    }
  }

  Future<void> _showSelectionDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(AppLocalizations.of(context)!.translate('select_an_option')
                // AppLocalizations.of(context).translate('from_where_picture')
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: Text(
                          AppLocalizations.of(context)!.translate('gallery')),
                      onTap: () {
                        Navigator.pop(context, null);
                        // if(type == 'image') {
                        imagePicker("gallery");
                        // }else{
                        //   videoPicker("gallery");
                        // }
                        // _profilePicker("Gallery");
                      },
                    ),
                    Padding(padding: EdgeInsets.all(16.0)),
                    GestureDetector(
                      child: Text(
                          AppLocalizations.of(context)!.translate('camera')),
                      onTap: () {
                        Navigator.pop(context, null);
                        // if(type == 'image') {
                        imagePicker("camera");
                        // }else{
                        //   videoPicker("camera");
                        // }
                      },
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
    prefs = await SharedPreferences.getInstance();
    if(type=="gallery"){
      pickedFile = await ImagePickerAndCropperUtil().pickImage(context);
    }else{
      pickedFile = await ImagePickerAndCropperUtil().pickImageCamera(context);
    }
    // File pickedFile = await ImagePickerAndCropperUtil().pickImage(context);
    var croppedFile = await ImagePickerAndCropperUtil().cropFile(
        context, pickedFile!);
    if (croppedFile != null) {
      await pr.show();
      var contentType = ImagePickerAndCropperUtil().getMimeandContentType(
          croppedFile.path);
      await UploadFile(
          baseUrl: Config.BASE_URL,
          context: context,
          token: prefs.getString("token"),
          contextId: '',
          contextType: CONTEXTTYPE_ENUM.PROFILE.type,
          ownerId: prefs.getInt(Strings.userId).toString(),
          ownerType: OWNERTYPE_ENUM.PERSON.type,
          file: croppedFile,
          subContextId: '',
          subContextType: SUBCONTEXTTYPE_ENUM.ROOM.type,
          mimeType: contentType[1],
          onProgressCallback: (int value){
            pr.update(progress:value.toDouble());
          },
          contentType: contentType[0])
          .uploadFile()
          .then((value) async {
        await pr.hide();
        var imageResponse = ImageUpdateResponse.fromJson(value);
        setState(() {
          _imageUrl = imageResponse.rows!.fileUrl;
          _thumbnailUrl = imageResponse.rows!.fileThumbnailUrl;
          if(isEdit) this.value!.roomProfileImageUrl=imageResponse.rows!.fileThumbnailUrl;
        });
        await pr.hide();
      }).catchError((onError) async {
        await pr.hide();
        print(onError.toString());
      });
    }else{
      await pr.hide();
    }
  }
}
