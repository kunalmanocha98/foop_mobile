import 'dart:io';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/app_database/data_base_helper.dart';
import 'package:oho_works_app/models/email_module/compose_email.dart';
import 'package:oho_works_app/models/email_module/create_email.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:workmanager/workmanager.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async{
    var db = DatabaseHelper.instance;
    var emailList = await db.getAllEmails();
    for(EmailCreateRequest email in emailList){
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
        map['folder'] = email.folder!;
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
      }
    }
    return Future.value(true);
  });
}