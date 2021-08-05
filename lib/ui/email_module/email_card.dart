import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:html/parser.dart';
import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/appHtmlViewer.dart';
import 'package:oho_works_app/components/commonComponents.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/enums/folder_type_enums.dart';
import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/models/email_module/email_bookmark_read.dart';
import 'package:oho_works_app/models/email_module/email_list_modules.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:oho_works_app/utils/utility_class.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../language_update.dart';
import 'email_attachment.dart';
import 'email_header.dart';

class TricycleEmailCard extends StatefulWidget {
  final bool isDetailPage;
  final EmailListItem? emailItem;
  final Function? onClick;
  final VoidCallback? replyCallback;
  final VoidCallback? forwardCallback;
  final VoidCallback? replyAllCallback;
  final bool showFooter;
  final Function? moveCallback;
  final VoidCallback? deleteCallback;
  final Function? printCallback;
  final Function? archiveCallback;
  final bool isOutbox;
  final Function? sendAgain;
  final String? folderType;

  TricycleEmailCard(
      {this.isDetailPage = false,
        this.emailItem,
        this.onClick,
        this.replyCallback,
        this.forwardCallback,
        this.showFooter = true,
        this.moveCallback,
        this.deleteCallback,
        this.printCallback,
        this.archiveCallback,
        this.isOutbox = false,
        this.sendAgain,
        this.folderType,
        this.replyAllCallback});

  @override
  _TricycleEmailCard createState() =>
      _TricycleEmailCard(isDetailPage: isDetailPage, emailItem: emailItem);
}

class _TricycleEmailCard extends State<TricycleEmailCard> {
  SharedPreferences prefs = locator<SharedPreferences>();
  TextStyleElements? styleElements;
  bool isDetailPage;
  EmailListItem? emailItem;
  FlutterTts tts = FlutterTts();
  bool isPlaying = false;
  String inputLan = "en";
  String? textToSpeech;

  String? outPutLan;

  _TricycleEmailCard({this.isDetailPage = false, this.emailItem});

  @override
  void initState() {
    super.initState();
    outPutLan = prefs.getString(Strings.translation_code)!=null ?prefs.getString(Strings.translation_code) :null;
    tts.setCompletionHandler(() {
      setState(() {
        isPlaying = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return appCard(
      padding: EdgeInsets.only(top: 8),
      onTap: widget.isDetailPage
          ? null
          : () {
        widget.onClick!();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EmailCardHeader(
              archiveCallback: widget.archiveCallback,
              emailItem: emailItem,
              isOutbox: widget.isOutbox,
              sendAgain: widget.sendAgain,
              isDetailPage: widget.isDetailPage,
              moveCallback: widget.moveCallback,
              folderType: widget.folderType,
              printCallback: () async {
                await Printing.layoutPdf(
                    onLayout: (PdfPageFormat format) async =>
                    await Printing.convertHtml(
                      format: PdfPageFormat.a4,
                      html: emailItem!.html!,
                    ));
              },
              markCallback: () {
                Future.microtask(() {
                  setState(() {});
                });
              }),
          Padding(
            padding: EdgeInsets.only(left: 20.0, right: 16, top: 8, bottom: 8),
            child: Row(
              children: [
                Visibility(
                  visible: !widget.isDetailPage,
                  child: Visibility(
                    visible: widget.folderType != FOLDER_TYPE_ENUM.SENT.type,
                    child: Visibility(
                      visible: !emailItem!.flags!.contains("\\Seen"),
                      child: Container(
                        height: 12,
                        width: 12,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: HexColor(AppColors.appMainColor)),
                      ),
                    ),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: EdgeInsets.only(left: 8.0, bottom: 0, top: 4),
                  child: Text(
                    timeago.format(
                        DateTime.fromMillisecondsSinceEpoch(emailItem!.date!)),
                    style: styleElements!.captionThemeScalable(context).copyWith(
                        fontSize: 10,
                        color: HexColor(AppColors.appColorBlack35)),
                  ),
                ),
              ],
            ),
          ),
          // Container(
          //   height: 56,
          //   child: ListView.builder(
          //     itemBuilder: (BuildContext context, int index) {
          //       return Chip(label: Text("hello"),);
          //     },
          //   ),
          // ),
          Visibility(
            visible: widget.isDetailPage,
            child: EmailAttachmentWidget(
              isDetailPage: widget.isDetailPage,
              attachments: emailItem!.attachments,
              downLoadCallback: (int index) {
                downloadAction(index);
              },
            ),
          ),
          // Visibility(
          //   visible: widget.isDetailPage &&
          //       (emailItem.attachments != null &&
          //           emailItem.attachments.length > 0),
          //   child: Padding(
          //     padding: EdgeInsets.only(left: 8.0, right: 16, top: 0, bottom: 0),
          //     child: Container(
          //       height: 88,
          //       child: ListView.builder(
          //         scrollDirection: Axis.horizontal,
          //         itemCount: emailItem.attachments.length,
          //         itemBuilder: (BuildContext context, int index) {
          //           return InkWell(
          //             onTap: () async{
          //               // var string  = await _createFileFromString(emailItem.attachments[index].payload,emailItem.attachments[index].filename);
          //               FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          //               FlutterLocalNotificationsPlugin();
          //               var notificationData = {"data":"Data"};
          //               // var redirect = notificationData['type'];
          //               // var basicData = {"notification"};
          //               var androidDetails = AndroidNotificationDetails(
          //                   'id', 'channel ', 'description',
          //                   priority: Priority.high, importance: Importance.high);
          //               var iOSDetails = IOSNotificationDetails();
          //               var platformDetails =
          //               new NotificationDetails(android: androidDetails, iOS: iOSDetails);
          //               await flutterLocalNotificationsPlugin.show(
          //                   0,
          //                   emailItem.attachments[index].filename,
          //                   "Download complete",
          //                   platformDetails,
          //                   payload: jsonEncode(notificationData));
          //             },
          //             child: Container(
          //               height: 72,
          //               width: 72,
          //               child: getChild(emailItem.attachments[index]),
          //               margin: EdgeInsets.all(8),
          //             ),
          //           );
          //         },
          //       ),
          //     ),
          //   ),
          // ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                  visible: widget.isDetailPage,
                  child: EmailSideMenu(
                    translateCallback: translateCallback,
                    ttsCallback: ttsCallback,
                    isPlaying: isPlaying,
                  )),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 12, right: 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          emailItem!.subject!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: styleElements!
                              .subtitle1ThemeScalable(context)
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 0.0, bottom: 6),
                        child: Row(
                          children: [
                            Visibility(
                              visible: false,
                              child: Container(
                                height: 36,
                                width: 36,
                                margin: EdgeInsets.only(right: 0),
                                color: Colors.primaries[
                                Random().nextInt(Colors.primaries.length)],
                              ),
                            ),
                            Expanded(
                              child: widget.isDetailPage
                                  ? appHtmlViewer(
                                isDetailPage: widget.isDetailPage,
                                sourceString: (emailItem!.html != null &&
                                    emailItem!.html!.isNotEmpty)
                                    ? emailItem!.html
                                    : emailItem!.text,
                                isEmail: true,
                              )
                                  : Padding(
                                padding: EdgeInsets.only(
                                    top: 8.0, left: 8, right: 8),
                                child: Text(
                                  (emailItem!.html!.isNotEmpty)
                                      ? parse(emailItem!.html)
                                      .documentElement!
                                      .text
                                      : emailItem!.text!,
                                  style: styleElements!
                                      .bodyText2ThemeScalable(context),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            // Expanded(
                            //   child: Text(,
                            //     style: styleElements.bodyText2ThemeScalable(context),
                            //     maxLines: widget.isDetailPage?null:2,
                            //     overflow: widget.isDetailPage?null:TextOverflow.ellipsis,
                            //   ),
                            // )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          widget.showFooter
              ? EmailCardFooter(
            replyCallback: widget.replyCallback,
            forwardCallback: widget.forwardCallback,
            replyAllCallback: widget.replyAllCallback,
            bookmarkCallback: bookmarkCallback,
            deleteCallback: widget.deleteCallback,
            isBookmarked: emailItem!.flags!.contains("\\Flagged"),
          )
              : Container(
            height: 16,
          )
        ],
      ),
    );
  }

  // Future<String> _createFileFromString(String payload, String filename) async {
  //   print("*********DOwNLOADING*********");
  //   Uint8List bytes = base64.decode(payload);
  //
  //   String dir = Platform.isIOS?(await getApplicationDocumentsDirectory()).path:"/storage/emulated/0/Download";
  //   // for(Directory path in dir){
  //   //   print("PATHHHH-----${path.path}");
  //   // }
  //   File file = File("$dir/" +"Tricycle/"+ filename);
  //   await file.writeAsBytes(bytes);
  //   return file.path;
  // }

  void bookmarkCallback() {
    BookmarkReadRequest request = BookmarkReadRequest();
    request.username = prefs.getString(Strings.mailUsername)!;
    request.folder = "INBOX";
    request.uidsList = [emailItem!.uid!];
    request.flag = "Flagged";
    if (emailItem!.flags!.contains("\\Flagged")) {
      emailItem!.flags!.remove("\\Flagged");
      Calls().call(jsonEncode(request), context, Config.EMAIL_FLAG_REMOVE,
          isMailToken: true);
    } else {
      emailItem!.flags!.add("\\Flagged");
      Calls().call(jsonEncode(request), context, Config.EMAIL_FLAG_SET,
          isMailToken: true);
    }
    Future.microtask(() {
      setState(() {});
    });
  }

  Widget getChild(Attachments attachment) {
    if (attachment.contentType!.contains("image")) {
      var bytes = base64Decode(attachment.payload!);
      return Stack(fit: StackFit.expand, children: [
        Image.memory(bytes, fit: BoxFit.fill),
        Container(
          decoration: BoxDecoration(
              color: HexColor(AppColors.appColorBlack10).withOpacity(0.3)),
        ),
        Center(
          child: Icon(
            Icons.download_rounded,
            size: 30,
            color: HexColor(AppColors.appColorWhite),
          ),
        )
      ]);
    } else {
      return Stack(fit: StackFit.expand, children: [
        Container(
          decoration: BoxDecoration(
              color: HexColor(AppColors.appColorBlack10).withOpacity(0.3)),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 4, bottom: 4),
            child: Icon(
              attachment.contentType!.contains("video")
                  ? Icons.videocam_outlined
                  : Icons.file_copy_outlined,
              color: HexColor(AppColors.appMainColor),
              size: 16,
            ),
          ),
        ),
        Center(
          child: Icon(
            Icons.download_rounded,
            size: 30,
            color: HexColor(AppColors.appColorWhite),
          ),
        )
      ]);
    }
  }

  Future _stop() async {
    await tts.stop();
  }

  @override
  void dispose() {
    super.dispose();
    _stop();
  }

  void translateCallback() async {
    if (prefs.getBool(Strings.isTranslationLanguageSet) == null ||
        !prefs.getBool(Strings.isTranslationLanguageSet)!) {
      var result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => UpdateLanguagePage(true, null, true)));
      if (result != null && result['code'] != null) {
        outPutLan = result['code'];
        translate(outPutLan!);
      } else {
        ToastBuilder().showToast(
            AppLocalizations.of(context)!
                .translate("select_translation_language"),
            context,
            HexColor(AppColors.information));
      }
    } else {
      translate(outPutLan!);
    }
  }

  void translate(String outPutCode) {
    print(outPutCode +
        "---------------------------------------------------------------------------------");
    String html = emailItem!.html!;

    Utility()
        .translate(context, html, inputLan, outPutCode, "html")
        .then((value) {
      print(value);
      setState(() {
        emailItem!.html = value!;
      });
    });
    _toggleLanguage();
  }

  _toggleLanguage() {
    setState(() {
      var temp = inputLan;
      inputLan = outPutLan!;
      outPutLan = temp;
    });
  }

  void ttsCallback() async {
    if (!isPlaying) {
      tts.stop();
      var text = "";
      var html = emailItem!.html;
      print(html);
      text = parse(html).documentElement!.text;
      print(text);
      tts.setLanguage("en-IN");
      tts.setPitch(1);
      tts.speak(text);
      setState(() {
        textToSpeech = text;
      });
      pausePlay();
    } else {
      pausePlay();
    }
  }

  void pausePlay() async {
    if (isPlaying) {
      print("pausing----------------------------");
      await tts.stop();
      setState(() {
        isPlaying = false;
      });
    } else {
      print("play----------------------------");
      await tts.speak(textToSpeech!);
      setState(() {
        isPlaying = true;
      });
    }
  }

  void downloadAction(int index) async {
    var path = await _createFileFromString(emailItem!.attachments![index].payload!, emailItem!.attachments![index].filename!);
    print(path+"""""""""""""""""""""""""""""""""""""""""""");
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    var notificationData = {"data": "Data"};
    var androidDetails = AndroidNotificationDetails(
        'id', 'channel ', 'description',
        priority: Priority.high, importance: Importance.high);
    var iOSDetails = IOSNotificationDetails();
    var platformDetails =
    new NotificationDetails(android: androidDetails, iOS: iOSDetails);
    await flutterLocalNotificationsPlugin.show(
        0,
        emailItem!.attachments![index].filename,
        "Download complete",
        platformDetails,
        payload: jsonEncode(notificationData));
  }

  Future<String> _createFileFromString(String payload, String filename) async {
    print("*********DOwNLOADING*********");
    filename = filename.replaceAll(" ", "");
    Uint8List bytes = base64.decode(payload);
    String dir = Platform.isIOS
        ? (await getApplicationDocumentsDirectory()).path
        : "/storage/emulated/0/Download";
    // for(Directory path in dir){
    //   print("PATHHHH-----${path.path}");
    // }
    File file = File("$dir/Tricycle"+Platform.pathSeparator+filename);
    if(await Permission.storage.request().isGranted){
      print("*************GRANTED**********************");
      if(!file.existsSync()){
        print("*************DON'T EXIST*****************");
        file.createSync(recursive: true);
      }
      await file.writeAsBytes(bytes);
    }
    return file.path;
  }
}

class EmailSideMenu extends StatelessWidget {
  final VoidCallback? ttsCallback;
  final VoidCallback? translateCallback;
  final bool isPlaying;

  EmailSideMenu(
      {this.ttsCallback, this.translateCallback, this.isPlaying = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 4),
      decoration: BoxDecoration(
        color: HexColor(AppColors.appColorWhite),
        boxShadow: [CommonComponents().getShadowforBoxSideCard()],
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(12), bottomRight: Radius.circular(12)),
      ),
      child: Column(
        children: [
          Visibility(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.0),
              child: IconButton(
                icon: Icon(
                  isPlaying
                      ? Icons.pause_circle_outline_rounded
                      : Icons.play_circle_outline_rounded,
                  color: HexColor(AppColors.appColorBlack35),
                ),
                onPressed: ttsCallback,
              ),
            ),
          ),
          Visibility(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.0),
              child: IconButton(
                icon: Icon(
                  Icons.g_translate_rounded,
                  color: HexColor(AppColors.appColorBlack35),
                ),
                onPressed: translateCallback,
              ),
            ),
          ),
          Visibility(
            visible: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.0),
              child: IconButton(
                icon: Icon(
                  Icons.search,
                  color: HexColor(AppColors.appColorBlack35),
                ),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
