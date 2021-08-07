import 'package:oho_works_app/components/commonComponents.dart';
import 'package:oho_works_app/enums/resolutionenums.dart';
import 'package:oho_works_app/enums/serviceTypeEnums.dart';
import 'package:oho_works_app/messenger_module/entities/message_database.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/custom_preview_link.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/utility_class.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class appChatFooter extends StatefulWidget {
  String? hintText;
  Function(String?) onValueRecieved;
  Function(String)? onReceiveOption;
  Function(String)? onTyping;
  bool? isShowAddIcon = false;
  MessagePayloadDatabase? data;
  String? userName;
  Function()? onCrossCLicked;
  bool? isEmptyTextAccepted;
  String? linkPreviewUrl;

  appChatFooter(Key key,
      {this.hintText,
      required this.onValueRecieved,
      this.onTyping,
      this.userName,
      this.linkPreviewUrl,
      this.isEmptyTextAccepted,
      this.isShowAddIcon,
      this.onCrossCLicked,
      this.onReceiveOption,
      this.data})
      : super(key: key);

  appChatFooterState createState() => appChatFooterState(
      onValueRecieved: onValueRecieved,
      linkPreviewUrl: linkPreviewUrl,
      onTyping: onTyping,
      isEmptyTextAccepted: isEmptyTextAccepted,
      onCrossCLicked: onCrossCLicked,
      isShowAddIcon: isShowAddIcon,
      onReceiveOption: onReceiveOption,
      userName: userName,
      data: data);
}

class appChatFooterState extends State<appChatFooter> {
  bool isTyping = false;
  bool? isEmptyTextAccepted;
  Function(String)? onReceiveOption;
  String? hintText;
  String? value;
  String? linkPreviewUrl;
  MessagePayloadDatabase? data;
  bool? isShowAddIcon = false;
  Function(String?) onValueRecieved;
  Function()? onCrossCLicked;
  Function(String)? onTyping;
  TextStyleElements? styleElements;
  var controller = TextEditingController();
  String? userName;

  appChatFooterState(
      {this.hintText,
      required this.onValueRecieved,
      this.onTyping,
      this.isEmptyTextAccepted,
      this.isShowAddIcon,
      this.onCrossCLicked,
      this.linkPreviewUrl,
      this.onReceiveOption,
      this.userName,
      this.data});

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);

    return Container(
      color: HexColor(AppColors.appColorBackground),
      child: Container(
          child: Column(
        children: [
          Visibility(
              visible: linkPreviewUrl != null,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: CustomPreviewLink(context,linkPreviewUrl??"",styleElements)



              )),
          Visibility(
            visible: data != null,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Card(
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 4.0, right: 4.0, top: 4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: 8.0,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(userName ?? "",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: styleElements!
                                      .bodyText2ThemeScalable(context)
                                      .copyWith(
                                          color:
                                              HexColor(AppColors.orangeText))),
                              InkWell(
                                onTap: () {
                                  if (onCrossCLicked != null) onCrossCLicked!();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 4.0),
                                  child: Icon(
                                    Icons.cancel_outlined,
                                    color: HexColor(AppColors.appColorBlack35),
                                    size: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                            onTap: () {},
                            child: Padding(
                                padding: EdgeInsets.only(
                                    left: 8.0,
                                    right: 16.0,
                                    top: 2.0,
                                    bottom: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Visibility(
                                      visible: data != null &&
                                          data!.messageAttachmentThumbnail !=
                                              null &&
                                          data!.messageAttachmentThumbnail!
                                              .isNotEmpty,
                                      child: Container(
                                        margin:
                                            const EdgeInsets.only(right: 12),
                                        width: 68,
                                        height: 68,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image:
                                                    CachedNetworkImageProvider(
                                                  Utility().getUrlForImage(
                                                      data != null
                                                          ? data!.messageAttachmentThumbnail ??
                                                              ""
                                                          : "",
                                                      RESOLUTION_TYPE.R64,
                                                      SERVICE_TYPE.POST),
                                                ))),
                                      ),
                                    ),
                                    Flexible(
                                        child: Container(
                                            margin: const EdgeInsets.only(
                                                right: 12),
                                            child: Align(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                    data != null
                                                        ? data!.message ?? ""
                                                        : "",
                                                    maxLines: 3,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: styleElements!
                                                        .bodyText1ThemeScalable(
                                                            context))))),
                                  ],
                                )))
                      ],
                    ),
                  )),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 8, left: 16, right: 16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: HexColor(AppColors.appColorWhite),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [CommonComponents().getShadowforBox()]),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // IconButton(
                        //   onPressed: (){
                        //   },
                        //   icon: Icon(Icons.emoji_emotions_outlined),
                        // ),
                        Expanded(
                          child: TextField(
                            maxLines: 10,
                            minLines: 1,
                            focusNode: FocusNode(canRequestFocus: false),
                            textInputAction: TextInputAction.next,
                            textCapitalization: TextCapitalization.sentences,
                            style: styleElements!.subtitle1ThemeScalable(context).copyWith(
                                color: HexColor(AppColors.appColorBlack65)
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 24),
                              hintText: hintText ??= 'Type here..',
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              hintStyle: styleElements!.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35))
                            ),
                            controller: controller,
                            onChanged: (value) {
                              this.value = value;
                              if (value.isNotEmpty) {
                                setState(() {
                                  isTyping = true;
                                });
                              } else {
                                setState(() {
                                  isTyping = false;
                                });
                              }

                              if (onTyping != null) onTyping!(value);
                            },
                          ),
                        ),
                        Visibility(
                            visible: isShowAddIcon!,
                            child: popItem(
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.add),
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
                // isTyping?

                getContainer(Center(
                    child: IconButton(
                  splashRadius: 45,
                  icon: Icon(
                    Icons.send,
                    color: HexColor(AppColors.appColorBlack85),
                  ),
                  onPressed: () {
                    if (isEmptyTextAccepted != null && isEmptyTextAccepted!) {
                      print("empty"
                              "" +
                          "---------------------------------------------------------------------");
                      onValueRecieved(value);
                      value = null;
                      controller.clear();
                    } else if (value != null && value!.isNotEmpty) {
                      print(value! +
                          "---------------------------------------------------------------------");
                      onValueRecieved(value);
                      value = null;
                      controller.clear();
                    }
                  },
                )))
                // :
                // getContainer(Center(
                //     child: IconButton(
                //       splashRadius: 45,
                //       icon: Icon(Icons.mic,
                //         color: Colors.black87,),
                //       onPressed: () { },
                //     )
                // ))
              ],
            ),
          ),
        ],
      )),
    );
  }

  Widget popItem(Widget item) {
    return PopupMenuButton<String>(
        onSelected: (String value) {
          onReceiveOption!(value);
        },
        child: item,
        itemBuilder: (context) => [
              PopupMenuItem(
                  value: "Image",
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                        child: Icon(Icons.camera_alt_outlined),
                      ),
                      Text(AppLocalizations.of(context)!.translate("image"))
                    ],
                  )),
              PopupMenuItem(
                  value: "Video",
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                        child: Icon(Icons.video_call_outlined),
                      ),
                      Text(AppLocalizations.of(context)!.translate("video"))
                    ],
                  )),
              PopupMenuItem(
                  value: "File",
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                        child: Icon(Icons.insert_drive_file_outlined),
                      ),
                      Text(AppLocalizations.of(context)!.translate("file"))
                    ],
                  )),
              /*   PopupMenuItem(
                  value: "Location",
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                        child: Icon(Icons.location_on_outlined),
                      ),
                      Text(AppLocalizations.of(context).translate("location"))
                    ],
                  )),*/
            ]);
  }

  clearData() {
    setState(() {
      controller.clear();
      isTyping = false;
      value = '';
    });
  }

  Widget getContainer(Widget child) {
    return Container(
      decoration: BoxDecoration(
        color: HexColor(AppColors.appColorWhite),
        shape: BoxShape.circle,
        boxShadow: [CommonComponents().getShadowforBox()],
      ),
      margin: EdgeInsets.all(4),
      padding: EdgeInsets.all(0),
      child: Card(
        elevation: 0,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: child,
      ),
    );
  }
}
