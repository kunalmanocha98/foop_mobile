import 'dart:async';
import 'dart:io';

import 'package:GlobalUploadFilePkg/Enums/contexttype.dart';
import 'package:GlobalUploadFilePkg/Enums/ownertype.dart';
import 'package:GlobalUploadFilePkg/Files/GlobalUploadFilePkg.dart';
import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/app_database/data_base_helper.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/appProgressButton.dart';
import 'package:oho_works_app/components/app_buttons.dart';

import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/mixins/someCommonMixins.dart';
import 'package:oho_works_app/models/email_module/compose_email.dart';
import 'package:oho_works_app/models/email_module/create_email.dart';
import 'package:oho_works_app/models/email_module/email_list_modules.dart';
import 'package:oho_works_app/models/imageuploadrequestandresponse.dart';
import 'package:oho_works_app/ui/email_module/email_attachment.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/imagepickerAndCropper.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:oho_works_app/utils/utility_class.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:rich_editor/rich_editor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

class EmailCreatePage extends StatefulWidget {
  final bool isReply;
  final String? replyUid;
  final String? subject;
  final FromValues? senderDetails;
  final bool isForward;
  final String? replyContent;
  final bool isReplyAll;
  final bool isDraft;
  final int? date;
  final List<FromValues>? toValues;
  final List<FromValues>? ccValues;
  final List<FromValues>? bccValues;
  final String? draftId;
  final Function(String)? draftSaveCallback;



  EmailCreatePage(
      {this.isReply = false,
        this.date,
        this.isForward = false,
        this.isDraft= false,
        this.replyUid,
        this.subject,
        this.senderDetails,
        this.replyContent,
        this.isReplyAll = false,
        this.ccValues,
        this.draftId,
        this.bccValues,
        this.draftSaveCallback,
        this.toValues});

  @override
  _EmailCreatePage createState() => _EmailCreatePage(draftId:draftId);
}

class _EmailCreatePage extends State<EmailCreatePage> {
  // QuillController _controller = QuillController.basic();
  // final FocusNode _focusNode = FocusNode();
  final db = DatabaseHelper.instance;
  SharedPreferences prefs = locator<SharedPreferences>();
  GlobalKey<RichEditorState>? keyEditor = GlobalKey();
  TextStyleElements? styleElements;
  MailComposeRequest? request;
  Timer? timer;
  GlobalKey<appProgressButtonState> progressButtonKey = GlobalKey();
  String? value;
  GlobalKey<EmailAttachmentWidgetState> emailAttachmentKey = GlobalKey();
  String? draftId;
  _EmailCreatePage({this.draftId});


  @override
  void initState() {
    if (widget.isReply) {
      var date = Utility().getDateFormat(
          "dd-MMM-yyyy", DateTime.fromMillisecondsSinceEpoch(widget.date!));
      var time = Utility().getDateFormat(
          "hh:mm", DateTime.fromMillisecondsSinceEpoch(widget.date!));
      var prefix =
          "<br><br><br><br><blockquote style=\"margin: 0 0 0 40px; border: none; padding: 0px;\"> ";
      var content = widget.replyContent ?? "";
      var email =
          "<a href=\"mailto\":${widget.senderDetails!.email}>${widget.senderDetails!.email}</a>";
      var nametag = "On $date , at $time, $email wrote: <br>";
      var postfix = "</blockquote>";
      value = prefix + nametag + content + postfix;
      List<String>? to;
      List<String>? cc;
      if (widget.isForward) {
        to = null;
      } else {
        if (widget.isReplyAll) {
          to = [widget.senderDetails!.email!];
          if (widget.toValues != null && widget.toValues!.length > 0) {
            for (FromValues from in widget.toValues!) {
              if (from.email != prefs.getString(Strings.mailUsername)) {
                to.add(from.email!);
              }
            }
          }
        } else {
          to = [widget.senderDetails!.email!];
        }
      }
      request = MailComposeRequest(
          emailSubject: widget.subject!,
          to: to!.join(",")
      );
    }else if(widget.isDraft){
      value = widget.replyContent;
      List<String> to =[];
      List<String> cc =[];
      if (widget.toValues != null && widget.toValues!.length > 0) {
        for (FromValues from in widget.toValues!) {
          to.add(from.email!);
        }
      }
      if (widget.toValues != null && widget.toValues!.length > 0) {
        for (FromValues from in widget.ccValues!) {
          cc.add(from.email!);
        }
      }
      request = MailComposeRequest(
          emailSubject: widget.subject!,
          to: to.join(","),
          cc: cc.join(",")
      );
    }
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      openModalSheet();
    });
    // _controller.addListener(() {
    //   if (timer == null) {
    //     startTimer();
    //   }
    // });
  }

  @override
  void dispose() {
    if (timer != null) {
      timer!.cancel();
    }
    super.dispose();
  }

  @override
  void deactivate() {
    if (timer != null) {
      timer!.cancel();
    }
    super.deactivate();
  }

  void startTimer() {
    timer ??= Timer.periodic(Duration(seconds: 5), (timer) {
        saveDraft();
      });
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return WillPopScope(
      onWillPop: onBackPressed,
      child: SafeArea(
        child: Scaffold(
          appBar: OhoAppBar().getCustomAppBar(context,
              appBarTitle: request != null ? request!.emailSubject : 'Subject',
              onBackButtonPress: () {
            onBackPressed();
              }, actions: [
                appProgressButton(
                  key: progressButtonKey,
                  onPressed: sendData,
                  color: HexColor(AppColors.appColorTransparent),
                  elevation: 0,
                  shape: StadiumBorder(),
                  child: Text(
                    AppLocalizations.of(context)!.translate('send'),
                    style: styleElements!
                        .captionThemeScalable(context)
                        .copyWith(color: HexColor(AppColors.appMainColor)),
                  ),
                )
              ]),
          body: Container(
            child: Column(
              children: [
                getToWidget(),
                getEditor(),
                Visibility(
                  visible: true,
                  child: EmailAttachmentWidget(
                    key: emailAttachmentKey,
                  )
                ),
                // Visibility(
                //     visible: _toolbarVisible(),
                //     child: Container(
                //         height: 48,
                //         child: QuillToolbar.basic(
                //           toolbarIconSize: 24,
                //           controller: _controller,
                //           multiRowsDisplay: false,
                //           onImagePickCallback: _uploadImageCallBack,
                //         ))),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // bool _toolbarVisible() {
  //   return _keyboardIsVisible();
  // }

  // bool _keyboardIsVisible() {
  //   return !(MediaQuery.of(context).viewInsets.bottom == 0.0);
  // }

  Widget getToWidget() {
    return Container(
      padding: EdgeInsets.only(top: 16, left: 16),
      margin: EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
          color: HexColor(AppColors.appColorWhite),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12), topRight: Radius.circular(12))),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Text(
                  "To: ",
                  style: styleElements!.headline6ThemeScalable(context),
                ),
                SizedBox(
                  width: 12,
                ),
                getChips()
              ],
            ),
          ),
          IconButton(
              onPressed: openModalSheet,
              icon: Icon(
                Icons.edit_outlined,
                color: HexColor(AppColors.appColorBlack65),
              )),
          IconButton(
              onPressed: openFilePicker,
              icon: Icon(
                Icons.attach_file_rounded,
                color: HexColor(AppColors.appColorBlack65),
              )),
          SizedBox(
            width: 12,
          )
        ],
      ),
    );
  }

  Widget getChips() {
    var tos =  request!.to!.split(",");
    return Expanded(
      child: request != null
          ? Wrap(
        direction: Axis.horizontal,
        children: [
          if (tos.length > 0)
            Chip(
              label: Text(tos[0]),
              shape: StadiumBorder(),
              backgroundColor: HexColor(AppColors.appColorBackground),
            ),
          if (tos.length > 1)
            Chip(
              label: Text(tos[1]),
              shape: StadiumBorder(),
              backgroundColor: HexColor(AppColors.appColorBackground),
            ),
          if (tos.length > 2) Text("+${tos.length - 2} more")
        ],
      )
          : Container(),
    );
  }

  Widget getEditor() {
    return Expanded(
      child: Container(
          color: HexColor(AppColors.appColorWhite),
          margin: EdgeInsets.all(0),
          child: RichEditor(

            key: keyEditor,
            value: value,

            editorOptions: RichEditorOptions(
              placeholder: 'Start typing',
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
              baseFontFamily: 'sans-serif',
              barPosition: BarPosition.BOTTOM,
            ),
            getImageUrl: (image) {
              return _uploadImageCallBack(image);
            },
          )
        // QuillEditor(
        //   controller: _controller,
        //   focusNode: _focusNode,
        //   scrollController: ScrollController(),
        //   scrollable: true,
        //   enableInteractiveSelection: true,
        //   padding: EdgeInsets.all(16),
        //   autoFocus: false,
        //   readOnly: false,
        //   expands: true,
        //   placeholder: 'Write your content here...',
        //   textCapitalization: TextCapitalization.sentences,
        // ),
      ),
    );
  }

  Future<String> _uploadImageCallBack(File file) async {
    print("#####PATH###" + file.path);
    var pr = ToastBuilder()
        .setProgressDialogWithPercent(context, 'Uploading Image...');
    var contentType =
    ImagePickerAndCropperUtil().getMimeandContentType(file.path);
    var value = await UploadFile(
        baseUrl: Config.BASE_URL,
        context: context,
        token: prefs.getString("token"),
        contextId: '',
        contextType: CONTEXTTYPE_ENUM.FEED.type,
        ownerId: prefs.getInt(Strings.userId).toString(),
        ownerType: OWNERTYPE_ENUM.PERSON.type,
        file: file,
        subContextId: "",
        subContextType: "",
        onProgressCallback: (int value) {
          pr.update(progress: value.toDouble());
        },
        mimeType: contentType[1],
        contentType: contentType[0])
        .uploadFile();
    var imageResponse = ImageUpdateResponse.fromJson(value);
    return Config.BASE_URL + imageResponse.rows!.fileThumbnailUrl!;
  }

  sendData() async {
    if (request != null) {
      progressButtonKey.currentState!.show();
      var html = await keyEditor!.currentState!.getHtml();
      if (html!.isNotEmpty) {
        // var map = Map<String, String>();
        EmailCreateRequest payload = EmailCreateRequest();
        payload.personId =  prefs.getInt(Strings.userId).toString();
        payload.username = prefs.getString(Strings.mailUsername);
        payload.fromAddress = prefs.getString(Strings.mailUsername);
        payload.toAddresses = request!.to;
        payload.ccAddresses = request!.cc ?? "";
        payload.bccAddresses = request!.bcc ?? "";
        payload.emailSubject = request!.emailSubject;
        payload.emailText = html;
        if (widget.isReply) {
          payload.originalMessageUid = widget.replyUid;
        }
       payload.files = List<String>.generate(emailAttachmentKey.currentState!.fileList.length, (index) {
          return emailAttachmentKey.currentState!.fileList[index].path;
        }).join(",");

        // map['person_id'] = prefs.getInt(Strings.userId).toString();
        // map['username'] = prefs.getString(Strings.mailUsername);
        // map['from_address'] = prefs.getString(Strings.mailUsername);
        // // if(request.toAddresses!=null && request.toAddresses.isNotEmpty){
        // //   for(int i=0;i<request.toAddresses.length;i++){
        // map['to_addresses'] = request.to;
        // // }
        // // }
        // // if(request.ccAddresses!=null && request.ccAddresses.isNotEmpty){
        // //   for(int i=0;i<request.ccAddresses.length;i++){
        // map['cc_addresses'] = request.cc ?? "";
        // // }
        // // }
        // // if(request.bccAddresses!=null && request.bccAddresses.isNotEmpty){
        // //   for(int i=0;i<request.bccAddresses.length;i++){
        // map['bcc_addresses'] = request.bcc ?? "";
        // // }
        // // }
        // map['email_subject'] = request.emailSubject;
        // // var markdown = deltaToMarkdown(
        // //     jsonEncode(_controller.document.toDelta().toJson()));
        // // var html = markdownToHtml(markdown);
        // map['email_text'] = html;
        // var value;
        // if (widget.isReply) {
        //   map['original_message_uid'] = widget.replyUid;
        //   value = await Calls().callMultipartRequest(context,
        //       Config.EMAIL_REPLY, emailAttachmentKey.currentState.fileList, map,
        //       isMailToken: true);
        // } else {
        //   value = await Calls().callMultipartRequest(context,
        //       Config.EMAIL_COMPOSE, emailAttachmentKey.currentState.fileList, map,
        //       isMailToken: true);
        // }

        // var res = SaveEmailResponse.fromJson(value);
        // if (res.statusCode == Strings.success_code) {
        stopTimer();
        await db.insertEmail(payload);
        progressButtonKey.currentState!.hide();
        Workmanager().registerOneOffTask("1", "simpleTask");
        if(widget.isDraft && widget.draftSaveCallback !=null) {
          widget.draftSaveCallback!(draftId!);
        }
        Navigator.pop(context);
        // }
      } else {}
    } else {
      openModalSheet();
    }
  }

  void stopTimer(){
    if(timer!=null){
      timer!.cancel();
    }
  }

  void openModalSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      builder: (BuildContext context) {
        return ComposeEmailDetailSheet(
          request: request!,
          isReply: widget.isReply,
          callback: (value) {
            setState(() {
              request = value;
            });
            if(request!=null){
              saveDraft();
              startTimer();
            }
          },
        );
      },
    );
  }

  void saveDraft({bool pop = false,bool showToast = false}) async {
    var map = Map<String, String>();
    map['person_id'] = prefs.getInt(Strings.userId).toString();
    map['username'] = prefs.getString(Strings.mailUsername)!;
    map['from_address'] = prefs.getString(Strings.mailUsername)!;
    map['uid'] = draftId ?? "";
    // if(request.toAddresses!=null && request.toAddresses.isNotEmpty){
    //   for(int i=0;i<request.toAddresses.length;i++){
    if (request != null) map['to_addresses'] = request!.to!;
    // }
    // }
    // if(request.ccAddresses!=null && request.ccAddresses.isNotEmpty){
    //   for(int i=0;i<request.ccAddresses.length;i++){
    if (request != null) map['cc_addresses'] = request!.cc!;
    // }
    // }
    // if(request.bccAddresses!=null && request.bccAddresses.isNotEmpty){
    //   for(int i=0;i<request.bccAddresses.length;i++){
    if (request != null) map['bcc_addresses'] = request!.bcc!;
    // }
    // }
    if (request != null) map['email_subject'] = request!.emailSubject!;
    // var markdown =
    // deltaToMarkdown(jsonEncode(_controller.document.toDelta().toJson()));
    // var html = markdownToHtml(markdown);
    var html = await keyEditor!.currentState!.getHtml();
    map['email_text'] = html!;
    Calls()
        .callMultipartRequest(Config.EMAIL_DRAFT,
        emailAttachmentKey.currentState!.fileList, map,
        isMailToken: true)
        .then((value) {
      var res = SaveDraftResponse.fromJson(value);
      if (res.statusCode == Strings.success_code) {
        draftId = res.rows;
        if(showToast){
          ToastBuilder().showToast("Draft saved successfully", context, HexColor(AppColors.information));
        }
        if (pop) {
          Navigator.pop(context);
        }
      }
    });
  }

  Future<bool> onBackPressed() async {
    print("bool bool bool");
    var html = await keyEditor!.currentState!.getHtml();
    var html2 = parse(html);
    if (request != null || html2.documentElement!.text.trim().replaceAll(" ", "").isNotEmpty) {
      showSaveDialog();
      return false;
    } else {
      Navigator.pop(context);
      return false;
    }
  }

  void showSaveDialog() {
    stopTimer();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SaveDiscardDialog(
          cancelCallback: () {
            Navigator.pop(context);
          },
          saveCallback: () {
            saveDraft(pop: true,showToast: true);
          },
        );
      },
    );
  }

  void openFilePicker() async{
    var pickedFile = await ImagePickerAndCropperUtil().pickAttachments(context);
    if(pickedFile!=null) {
        emailAttachmentKey.currentState!.addFile(pickedFile);
    }
  }
}

class ComposeEmailDetailSheet extends StatefulWidget {
  final Function(MailComposeRequest)? callback;
  final MailComposeRequest? request;
  final bool isReply;

  ComposeEmailDetailSheet(
      {@required this.callback, this.request, this.isReply= false});

  @override
  _ComposeEmailDetailSheet createState() => _ComposeEmailDetailSheet();
}

class _ComposeEmailDetailSheet extends State<ComposeEmailDetailSheet>
    with CommonMixins {
  TextStyleElements? styleElements;
  GlobalKey<FormState> formKey = GlobalKey();

  String? to;
  String? cc;
  String? bcc;
  String? subject;

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return SafeArea(
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Container(
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Stack(
                children: [
                  Row(
                    children: [
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: appTextButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                              widget.callback!(MailComposeRequest(
                                  to: to!,
                                  cc: cc!,
                                  bcc: bcc!,
                                  emailSubject: widget.isReply
                                      ? widget.request!.emailSubject
                                      : subject!));
                              Navigator.pop(context);
                            }
                          },
                          shape: StadiumBorder(),
                          child: Text(
                              AppLocalizations.of(context)!.translate('next')),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 16.0),
                        child: Text(
                          "Compose email",
                          style: styleElements!.headline6ThemeScalable(context),
                        ),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: HexColor(AppColors.appColorBackground),
                          ),
                          child: Row(
                            children: [
                              Center(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 8.0, right: 4),
                                  child: Text("To:",
                                      style: styleElements!
                                          .headline6ThemeScalable(context)),
                                ),
                              ),
                              Expanded(
                                child: TextFormField(
                                  validator: validateEmails,
                                  onSaved: (value) {
                                    to = value;
                                  },
                                  initialValue: widget.request != null
                                      ? widget.request!.to
                                      : "",
                                  decoration: InputDecoration(
                                      hintText: "Email id",
                                      contentPadding: EdgeInsets.only(
                                          left: 12, top: 16, bottom: 8),
                                      border: UnderlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(12)),
                                      floatingLabelBehavior:
                                      FloatingLabelBehavior.auto,
                                      labelText:
                                      "Enter the email IDs of receivers"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: HexColor(AppColors.appColorBackground),
                          ),
                          child: Row(
                            children: [
                              Center(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 8.0, right: 4),
                                  child: Text("Cc:",
                                      style: styleElements!
                                          .headline6ThemeScalable(context)),
                                ),
                              ),
                              Expanded(
                                child: TextFormField(
                                  validator: validateEmailsWithNull,
                                  onSaved: (value) {
                                    cc = value;
                                  },
                                  decoration: InputDecoration(
                                      hintText: "Email id",
                                      contentPadding: EdgeInsets.only(
                                          left: 12, top: 16, bottom: 8),
                                      border: UnderlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(12)),
                                      floatingLabelBehavior:
                                      FloatingLabelBehavior.auto,
                                      labelText: "Email IDs to copy"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: HexColor(AppColors.appColorBackground),
                          ),
                          child: Row(
                            children: [
                              Center(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 8.0, right: 4),
                                  child: Text("Bcc:",
                                      style: styleElements!
                                          .headline6ThemeScalable(context)),
                                ),
                              ),
                              Expanded(
                                child: TextFormField(
                                  validator: validateEmailsWithNull,
                                  onSaved: (value) {
                                    bcc = value;
                                  },
                                  decoration: InputDecoration(
                                      hintText: "Email id",
                                      contentPadding: EdgeInsets.only(
                                          left: 12, top: 16, bottom: 8),
                                      border: UnderlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(12)),
                                      floatingLabelBehavior:
                                      FloatingLabelBehavior.auto,
                                      labelText:
                                      "Enter the email IDs to blind copy"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (!widget.isReply)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            padding: EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: HexColor(AppColors.appColorBackground),
                            ),
                            child: Row(
                              children: [
                                Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 8.0, right: 4),
                                    child: Text("Sub:",
                                        style: styleElements!
                                            .headline6ThemeScalable(context)),
                                  ),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    validator: validateTextField,
                                    initialValue: widget.request != null
                                        ? widget.request!.emailSubject
                                        : "",
                                    onSaved: (value) {
                                      subject = value;
                                    },
                                    decoration: InputDecoration(
                                        hintText: "Email id",
                                        contentPadding: EdgeInsets.only(
                                            left: 12, top: 16, bottom: 8),
                                        border: UnderlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(12)),
                                        floatingLabelBehavior:
                                        FloatingLabelBehavior.auto,
                                        labelText:
                                        "Enter the subject of the email"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SaveDiscardDialog extends StatelessWidget {
  final Function? cancelCallback;
  final Function? saveCallback;

  SaveDiscardDialog({this.cancelCallback, this.saveCallback});

  @override
  Widget build(BuildContext context) {
    var styleElements = TextStyleElements(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  AppLocalizations.of(context)!.translate('save_draft'),
                  style: styleElements
                      .subtitle1ThemeScalable(context)
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  'Do you want to save this in the draft folder?',
                  style: styleElements
                      .bodyText2ThemeScalable(context)
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Spacer(),
                    appTextButton(
                      onPressed: () {
                        cancelCallback!();
                        Navigator.pop(context);
                      },
                      child: Text(AppLocalizations.of(context)!.translate('cancel')),
                      shape: StadiumBorder(),
                    ),
                    appTextButton(
                      onPressed: () {
                        saveCallback!();
                        Navigator.pop(context);
                      },
                      child: Text(AppLocalizations.of(context)!.translate('save')),
                      shape: StadiumBorder(),
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
