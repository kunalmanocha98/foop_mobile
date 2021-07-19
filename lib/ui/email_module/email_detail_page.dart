import 'dart:convert';

import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/models/email_module/email_list_modules.dart';
import 'package:oho_works_app/ui/email_module/email_card.dart';
import 'package:oho_works_app/ui/email_module/email_header.dart';
import 'package:flutter/material.dart';

class EmailDetailPage extends StatefulWidget{
  final String subject;
  EmailDetailPage({this.subject});
  @override
  _EmailDetailPage createState() => _EmailDetailPage();
}
class _EmailDetailPage extends State<EmailDetailPage>{
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: TricycleAppBar().getCustomAppBar(
            context,
            appBarTitle: widget.subject,
            onBackButtonPress: (){
              Navigator.pop(context);
            },
          actions: [
            EmailCardHeaderState().simplePopup()
          ]
        ),
        body:ListView.builder(
          itemCount: 2,
          itemBuilder: (BuildContext context, int index) {
            return TricycleEmailCard(
              isDetailPage: true,
              emailItem: EmailListItem.fromJson(jsonDecode(jsonEncode({
                "uid": "39",
                "subject": "SMTP e-mail test",
                "from": "durga@tricycle.net",
                "to": [
                  "prasad@tricycle.net",
                  "mohan@tricycle.net",
                  "sohan@tricycle.net",
                  "kanye@tricycle.net",
                  "eminem@tricycle.net"
                ],
                "cc": ["loni@tricycle.net",],
                "reply_to": [],
                "from_values": {
                  "email": "durga@tricycle.net",
                  "name": "From Person",
                  "full": "From Person <durga@tricycle.net>"
                },
                "to_values": [
                  {
                    "email": "prasad@tricycle.net",
                    "name": "To Person",
                    "full": "To Person <prasad@tricycle.net>"
                  }
                ],
                "cc_values": [  {
                  "email": "prasad@tricycle.net",
                  "name": "To Person",
                  "full": "To Person <prasad@tricycle.net>"
                }],
                "reply_to_values": [
                  {
                    "email": "prasad@tricycle.net",
                    "name": "To Person",
                    "full": "To Person <prasad@tricycle.net>"
                  }],
                "date": 1625900717706,
                "date_str": "",
                "text": "This is a test e-mail message. This is a test e-mail message. This is a test e-mail message. This is a test e-mail message. This is a test e-mail message. This is a test e-mail message. This is a test e-mail message. This is a test e-mail message. This is a test e-mail message. This is a test e-mail message. This is a test e-mail message. This is a test e-mail message.",
                "html": "",
                "flags": [
                  "\\Seen"
                ],
                "size_rfc822": 433,
                "size": 422,
                "attachments": []
              }))),
            );
          },)
      ),
    );
  }

}