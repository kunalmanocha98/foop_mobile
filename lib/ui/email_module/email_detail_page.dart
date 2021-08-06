import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/enums/folder_type_enums.dart';

import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/models/email_module/create_folder.dart';
import 'package:oho_works_app/models/email_module/email_bookmark_read.dart';
import 'package:oho_works_app/models/email_module/email_list_modules.dart';
import 'package:oho_works_app/models/email_module/email_user_create.dart';
import 'package:oho_works_app/ui/dialogs/delete_confirmation_dilog.dart';
import 'package:oho_works_app/ui/email_module/email_card.dart';
import 'package:oho_works_app/ui/email_module/email_header.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'email_create_page.dart';
import 'email_home_page.dart';

class EmailDetailPage extends StatefulWidget{
  final String? uid;
  final String? subject;
  final String? folderType;
  final Function? seenCallback;
  EmailDetailPage({this.subject,@required this.uid,this.folderType,this.seenCallback});
  @override
  _EmailDetailPage createState() => _EmailDetailPage(folderType: folderType);
}
class _EmailDetailPage extends State<EmailDetailPage>{
  EmailListItem? data;
  String? folderType;
  SharedPreferences prefs = locator<SharedPreferences>();
  _EmailDetailPage({this.folderType});


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: OhoAppBar().getCustomAppBar(
            context,
            appBarTitle: widget.subject,
            onBackButtonPress: (){
              Navigator.pop(context);
            },
          // actions: [
          //   EmailCardHeaderState().simplePopup()
          // ]
        ),
        body: data!=null?SingleChildScrollView(
          child: TricycleEmailCard(
            isDetailPage: true,
            emailItem: data,
            folderType: folderType,
            replyCallback:replyCallback,
            archiveCallback: (){
              moveToFolder(folderType!, FOLDER_TYPE_ENUM.ARCHIVED.type, data!.uid!);
            },
            replyAllCallback: replyAllcallback,
            forwardCallback: forwardCallback,
            deleteCallback:deleteCallback,
            moveCallback:moveCallback,

            showFooter:false,

          ),
        ):CustomPaginator(context).loadingWidgetMaker(),
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(vertical:8),
          color: HexColor(AppColors.appColorWhite),
          child: EmailCardFooter(
            replyCallback:replyCallback,
            forwardCallback: forwardCallback,
            bookmarkCallback: bookmarkCallback,
            replyAllCallback: replyAllcallback,
            isBookmarked: data!=null?data!.flags!.contains("\\Flagged"):false,
            deleteCallback: deleteCallback,
          ),
        ),
      ),
    );
  }


  void deleteCallback() {
    showDialog(
        context: context,
        builder: (BuildContext context){
          return DeleteConfirmationDilog(
            showCancelButton: true,
            cancelButton: (){},
            note: folderType!=FOLDER_TYPE_ENUM.TRASH.type?AppLocalizations.of(context)!.translate('move_to_trash'):
            AppLocalizations.of(context)!.translate('delete_confirmation'),
            updateButton: ()async{
              if(folderType!=FOLDER_TYPE_ENUM.TRASH.type) {
                moveToFolder(folderType!, "Trash", data!.uid!);
              }else{
                deleteEmail(data!);
              }
            },
          );
        }
    );
  }

  void deleteEmail(EmailListItem item) async{
    MoveFolderRequest payload = MoveFolderRequest();
    payload.folder = folderType!;
    payload.username = prefs.getString(Strings.mailUsername)!;
    payload.uidsList = [item.uid!];
    Calls().call(jsonEncode(payload), context, Config.EMAIL_DELETE,isMailToken: true).then((value){
      var res = CreateEmailUserResponse.fromJson(value);
      if(res.statusCode == Strings.success_code){
        Navigator.pop(context,true);
      }
    });
  }

  void moveCallback() async{
    FolderCreateRequest payload = FolderCreateRequest();
    payload.username = prefs.getString(Strings.mailUsername)!;
    List<String> listOfFolders = [];
    Calls()
        .call(jsonEncode(payload), context, Config.EMAIL_FOLDER_LIST,
        isMailToken: true)
        .then((value) {
      listOfFolders.addAll(FOLDER_TYPE_ENUM.ALL.list);
      var res = FolderListResponse.fromJson(value);
      res.rows!.removeWhere((element) {return FOLDER_TYPE_ENUM.ALL.list.contains(element.name);});
      res.rows!.forEach((element) {
        listOfFolders.add(element.name!);
      });
      if(listOfFolders.contains(folderType)){
        listOfFolders.remove(folderType);
      }
      showDialog(builder: (BuildContext context) {
        return FolderSelectionDialog(
          folderCallback: (value){
            moveToFolder(folderType!,value,data!.uid!);
          },
          folderList:listOfFolders ,
        );
      },context: context);
    });
  }
  void moveToFolder(String folderType, String destinationFolder, String uid,{bool isArchived=false}) async{
    MoveFolderRequest payload = MoveFolderRequest();
    payload.folder = folderType;
    payload.moveToFolder = destinationFolder;
    payload.username = prefs.getString(Strings.mailUsername)!;
    payload.uidsList = [uid];
    Calls().call(jsonEncode(payload), context, Config.EMAIL_MOVE_FOLDER,isMailToken:true).then((value) {
      var res = CreateEmailUserResponse.fromJson(value);
      if(res.statusCode == Strings.success_code){
        // if(isArchived){
          Navigator.pop(context,true);
        // }
        // refresh();
      }
    });
  }

  void replyAllcallback(){
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
          return EmailCreatePage(
            isReply: true,
            isForward: false,
            replyUid: data!.uid,
            subject: data!.subject,
            senderDetails: data!.fromValues!,
            replyContent: data!.html,
            date: data!.date,
            toValues: data!.toValues,
            folderType: widget.folderType!,
            isReplyAll: true,
          );
        }));
  }

  void replyCallback(){
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
          return EmailCreatePage(
            isReply: true,
            isForward:false,
            replyUid: data!.uid,
            subject:data!.subject,
            senderDetails:data!.fromValues!,
            replyContent: data!.html,
            folderType: widget.folderType!,
            date: data!.date,
          );
        }));
  }

  void forwardCallback(){
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
          return EmailCreatePage(
            isReply: true,
            isForward: true,
            replyUid: data!.uid,
            subject: data!.subject,
            senderDetails: data!.fromValues!,
            replyContent: data!.html,
            folderType: widget.folderType!,
            date: data!.date,
          );
        }));
  }

  void bookmarkCallback() {
    BookmarkReadRequest request = BookmarkReadRequest();
    request.username =  prefs.getString(Strings.mailUsername)!;
    request.folder = "INBOX";
    request.uidsList =[data!.uid!];
    request.flag = "Flagged";
    if(data!.flags!.contains("\\Flagged")){
      data!.flags!.remove("\\Flagged");
      Calls().call(jsonEncode(request), context, Config.EMAIL_FLAG_REMOVE,isMailToken:true);
    }else {
      data!.flags!.add("\\Flagged");
      Calls().call(jsonEncode(request), context, Config.EMAIL_FLAG_SET,
          isMailToken: true);
    }
    Future.microtask((){
      setState(() {});
    });
  }

  void fetchData({bool callRead=true}) async{
    var body = jsonEncode({
      "username":prefs.getString(Strings.mailUsername),"folder":folderType,"uid":widget.uid
    });
    Calls().call(body, context, Config.EMAIL_DETAIL,isMailToken: true).then((value) {
      var res = EmailDetailResponse.fromJson(value);
      if(res.statusCode == Strings.success_code){
        setState(() {
          data = res.rows;
          if(callRead) {
            markasRead();
          }
        });
      }
    });
  }

  void markasRead() {
    BookmarkReadRequest request = BookmarkReadRequest();
    request.username =  prefs.getString(Strings.mailUsername)!;
    request.folder = widget.folderType!;
    request.uidsList =[data!.uid!];
    request.flag = "Seen";
    Calls().call(jsonEncode(request), context, Config.EMAIL_FLAG_SET,isMailToken:true);
    widget.seenCallback!();
    fetchData(callRead: false);
  }

}