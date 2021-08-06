import 'dart:io';

import 'package:flutter/material.dart';
import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/app_database/data_base_helper.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/models/email_module/compose_email.dart';
import 'package:oho_works_app/models/email_module/create_email.dart';
import 'package:oho_works_app/models/email_module/email_list_modules.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/strings.dart';

import 'email_card.dart';

class OutBoxPage extends StatefulWidget {
  @override
  _OutBoxPage createState() => _OutBoxPage();
}

class _OutBoxPage extends State<OutBoxPage> {
  bool isLoading = true;
  final db = DatabaseHelper.instance;
  List<EmailCreateRequest>? emails;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      fetchOutboxData();
    });
  }

  void fetchOutboxData() async {
    emails = await db.getAllEmails();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: OhoAppBar().getCustomAppBar(context, appBarTitle: 'Outbox',
            onBackButtonPress: () {
              Navigator.pop(context);
            }),
        body: isLoading
            ? CustomPaginator(context).loadingWidgetMaker()
            : emails!.length == 0
            ? CustomPaginator(context).emptyListWidgetMaker(null)
            : ListView.builder(
          itemCount: emails!.length,
          itemBuilder: (BuildContext context, int index) {
            return TricycleEmailCard(
              showFooter: false,
              isDetailPage: false,
              isOutbox: true,
              sendAgain: (){
                sendAgain(emails![index]);
              },
              deleteFromOutbox: (){
                deleteFromOutbox(emails![index],index);
              },
              emailItem: EmailListItem(
                  cc: emails![index].ccAddresses!.isNotEmpty
                      ? emails![index].ccAddresses!.split(",")
                      : [],
                  date: DateTime.now().millisecondsSinceEpoch,
                  from: emails![index].fromAddress!,
                  fromValues: FromValues(
                    email: emails![index].fromAddress!,
                    name: emails![index].fromAddress!,
                  ),
                  flags: [""],
                  to: emails![index].toAddresses!=null?emails![index].toAddresses!.isNotEmpty
                      ? emails![index].toAddresses!.split(",")
                      : [""]:[""],
                  html: emails![index].emailText!,
                  subject: emails![index].emailSubject!,
                  toValues: List<FromValues>.generate(
                      emails![index].toAddresses!=null?emails![index].toAddresses!.split(",").length:0,
                          (indx) {
                        return FromValues(
                          name: emails![index]
                              .toAddresses!
                              .split(",")[indx],
                            email: emails![index]
                                .toAddresses!
                                .split(",")[indx]);
                      })),
            );
          },
        ),
      ),
    );
  }

  void sendAgain(EmailCreateRequest email) async{
    var  map = Map<String,String>();
    map['person_id'] = email.personId!;
    map['username'] =  email.username!;
    map['from_address'] =  email.fromAddress!;
    map['to_addresses'] =  email.toAddresses!;
    map['cc_addresses'] =  email.ccAddresses!;
    map['bcc_addresses'] =  email.bccAddresses!;
    map['email_subject'] =  email.emailSubject!;
    map['email_text'] =  email.emailText!;
    List<File> fileList;
    if(email.files!.isNotEmpty) {
      var list = email.files!.split(",");
      fileList = List<File>.generate(list.length, (index) {
        return File(list[index]);
      });
    }else{
      fileList =[];
    }
    var value;
    if (email.originalMessageUid!=null && email.originalMessageUid!.isNotEmpty) {
      map['original_message_uid'] = email.originalMessageUid!;
      value = await Calls().callMultipartRequest(
          Config.EMAIL_REPLY,fileList , map,
          isMailToken: true);
    } else {
      value = await Calls().callMultipartRequest(
          Config.EMAIL_COMPOSE,fileList , map,
          isMailToken: true);
    }

    var res = SaveEmailResponse.fromJson(value);
    if(res.statusCode == Strings.success_code){
      await db.removeEmail(email.id!);
      fetchOutboxData();
    }
  }

  void deleteFromOutbox(EmailCreateRequest email,int index) {
    db.removeEmail(email.id!);
    setState(() {
      emails!.removeAt(index);
    });
  }
}
