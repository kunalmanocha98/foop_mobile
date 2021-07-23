import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/models/email_module/email_list_modules.dart';
import 'package:oho_works_app/ui/email_module/email_card.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oho_works_app/components/paginator.dart';

class EmailHomePage extends StatefulWidget {
  @override
  _EmailHomePage createState() => _EmailHomePage();
}

class _EmailHomePage extends State<EmailHomePage> {
  late TextStyleElements styleElements;
  List<EmailListItem> emailList = [];

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return SafeArea(
        child: Scaffold(
          appBar: TricycleAppBar().getCustomAppBarWithSearch(context,
              appBarTitle: AppLocalizations.of(context)!.translate(''),
              centerTitle: false,
              titleWidget: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "John.doe@abx.xyz",
                    style: styleElements
                        .headline6ThemeScalable(context)
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: HexColor(AppColors.appColorBlack85),
                  )
                ],
              ),
              onSearchValueChanged: (value) {},
              hintText: 'Search mail',
              actions: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: HexColor(AppColors.appColorWhite)),
                  child: Icon(
                    Icons.edit,
                    color: HexColor(AppColors.appColorBlack85),
                  ),
                ),
                // IconButton(icon: Icon(Icons.edit), onPressed: (){}),
                _getSimplePopup(),
                SizedBox(
                  width: 16,
                )
              ], onBackButtonPress: () {
                Navigator.pop(context);
              }),
          // body: ListView.builder(
          //   itemCount: 10,
          //   itemBuilder: (BuildContext context, int index) {
          //     return TricycleEmailCard(
          //       emailItem: EmailListItem.fromJson(jsonDecode(jsonEncode({
          //         "uid": "39",
          //         "subject": "SMTP e-mail test",
          //         "from": "durga@tricycle.net",
          //         "to": [
          //           "prasad@tricycle.net",
          //           "mohan@tricycle.net",
          //           "sohan@tricycle.net",
          //           "kanye@tricycle.net",
          //           "eminem@tricycle.net"
          //         ],
          //         "cc": ["loni@tricycle.net"],
          //         "reply_to": [],
          //         "from_values": {
          //           "email": "durga@tricycle.net",
          //           "name": "From Person",
          //           "full": "From Person <durga@tricycle.net>"
          //         },
          //         "to_values": [
          //           {
          //             "email": "prasad@tricycle.net",
          //             "name": "To Person",
          //             "full": "To Person <prasad@tricycle.net>"
          //           }
          //         ],
          //         "cc_values": [  {
          //           "email": "prasad@tricycle.net",
          //           "name": "To Person",
          //           "full": "To Person <prasad@tricycle.net>"
          //         }],
          //         "reply_to_values": [
          //           {
          //             "email": "prasad@tricycle.net",
          //             "name": "To Person",
          //             "full": "To Person <prasad@tricycle.net>"
          //           }],
          //         "date": 1625900717706,
          //         "date_str": "",
          //         "text": "This is a test e-mail message. This is a test e-mail message. This is a test e-mail message. This is a test e-mail message. This is a test e-mail message. This is a test e-mail message. This is a test e-mail message.",
          //         "html": "",
          //         "flags": [
          //           "\\Seen"
          //         ],
          //         "size_rfc822": 433,
          //         "size": 422,
          //         "attachments": []
          //       }))),
          //     );
          //   },)
          body: Paginator<EmailListResponse>.listView(
            pageLoadFuture: fetchEmails,
            pageItemsGetter: listItemsGetter,
            listItemBuilder: listItemGetter,
            loadingWidgetBuilder: CustomPaginator(context).loadingWidgetMaker,
            errorWidgetBuilder: CustomPaginator(context).errorWidgetMaker,
            emptyListWidgetBuilder: CustomPaginator(context).emptyListWidgetMaker,
            totalItemsGetter: CustomPaginator(context).totalPagesGetter,
            pageErrorChecker: CustomPaginator(context).pageErrorChecker,
          ),
        ));
  }

  Future<EmailListResponse> fetchEmails(int page) async {
    var body =
    jsonEncode({"username": "prasad@tricycle.net", "folder": "INBOX"});
    var value = await Calls().call(
        body, context, 'https://92b0dff5c8ff.ngrok.io/api/v1/email/inbox/list',
        customToken: true,
        token:
        'Token mk6sNw6c7194by9y164RTDhq4SrH6KzZmI4PfYogf2GxbYP0mJWWiva2LaSKhhWh');
    return EmailListResponse.fromJson(value);
  }

  List? listItemsGetter(EmailListResponse? pageData) {
    emailList.addAll(pageData!.rows!);
    return pageData.rows;
  }

  Widget listItemGetter(itemData, int index) {
    EmailListItem item = itemData;
    return TricycleEmailCard(isDetailPage: false,
    emailItem: item,);
  }

  Widget _getSimplePopup() {
    return PopupMenuButton<String>(
      padding: EdgeInsets.only(right: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      itemBuilder: (context) => _getItems("Kunal Manocha"),
      onSelected: (value) {
        switch (value) {
          case 'delete':
            {
              break;
            }
        }
      },
      icon: Icon(
        Icons.segment,
        color: HexColor(AppColors.appColorBlack85),
      ),
    );
  }

  List<PopupMenuEntry<String>> _getItems(String name) {
    List<PopupMenuEntry<String>> popupmenuList = [];
    popupmenuList.add(PopupMenuItem(
      value: 'd',
      child: Row(children: [
        Text(
          'JohnDoe@gmail.com',
          style: styleElements.subtitle1ThemeScalable(context).copyWith(
              color: HexColor(AppColors.appMainColor),
              fontWeight: FontWeight.bold),
        )
      ]),
    ));
    popupmenuList.add(
      PopupMenuItem(
        value: 'mark_read',
        child: Row(children: [
          Icon(
            Icons.mail_outline_rounded,
            color: HexColor(AppColors.appColorBlack85),
          ),
          SizedBox(
            width: 8,
          ),
          Text(
            'Inbox',
          )
        ]),
      ),
    );
    popupmenuList.add(
      PopupMenuItem(
        value: 'mark_read',
        child: Row(children: [
          Icon(
            Icons.send_outlined,
            color: HexColor(AppColors.appColorBlack85),
          ),
          SizedBox(
            width: 8,
          ),
          Text(
            'Sent',
          )
        ]),
      ),
    );
    popupmenuList.add(
      PopupMenuItem(
        value: 'mark_read',
        child: Row(children: [
          Icon(
            Icons.edit_outlined,
            color: HexColor(AppColors.appColorBlack85),
          ),
          SizedBox(
            width: 8,
          ),
          Text(
            'Draft',
          )
        ]),
      ),
    );
    popupmenuList.add(
      PopupMenuItem(
        value: 'mark_read',
        child: Row(children: [
          Icon(
            Icons.thumb_down_alt_outlined,
            color: HexColor(AppColors.appColorBlack85),
          ),
          SizedBox(
            width: 8,
          ),
          Text(
            'Spam',
          )
        ]),
      ),
    );
    popupmenuList.add(
      PopupMenuItem(
        value: 'mark_read',
        child: Row(children: [
          Icon(
            Icons.archive_outlined,
            color: HexColor(AppColors.appColorBlack85),
          ),
          SizedBox(
            width: 8,
          ),
          Text(
            'Archive',
          )
        ]),
      ),
    );
    popupmenuList.add(
      PopupMenuItem(
        value: 'mark_read',
        child: Row(children: [
          Icon(
            Icons.restore_from_trash_outlined,
            color: HexColor(AppColors.appColorBlack85),
          ),
          SizedBox(
            width: 8,
          ),
          Text(
            'Trash',
          )
        ]),
      ),
    );
    popupmenuList.add(PopupMenuItem(
      value: 'd',
      child: Row(children: [
        Text(
          'Labels',
          style: styleElements.subtitle1ThemeScalable(context).copyWith(
              color: HexColor(AppColors.appColorBlack85),
              fontWeight: FontWeight.bold),
        ),
      ]),
    ));
    popupmenuList.add(
      PopupMenuItem(
        value: 'mark_read',
        child: Row(children: [
          Icon(
            Icons.mail_outline_rounded,
            color: HexColor(AppColors.appColorBlack85),
          ),
          SizedBox(
            width: 8,
          ),
          Text(
            'Unread',
          )
        ]),
      ),
    );
    popupmenuList.add(
      PopupMenuItem(
        value: 'mark_read',
        child: Row(children: [
          Icon(
            Icons.flag_outlined,
            color: HexColor(AppColors.appColorBlack85),
          ),
          SizedBox(
            width: 8,
          ),
          Text(
            'Flagged',
          )
        ]),
      ),
    );
    popupmenuList.add(
      PopupMenuItem(
        value: 'mark_read',
        child: Row(children: [
          Icon(
            Icons.label_outline_rounded,
            color: HexColor(AppColors.appColorBlack85),
          ),
          SizedBox(
            width: 8,
          ),
          Text(
            'Important',
          )
        ]),
      ),
    );
    popupmenuList.add(
      PopupMenuItem(
        value: 'mark_read',
        child: Row(children: [
          Icon(
            Icons.bookmark_border_rounded,
            color: HexColor(AppColors.appColorBlack85),
          ),
          SizedBox(
            width: 8,
          ),
          Text(
            'Bookmarked',
          )
        ]),
      ),
    );
    return popupmenuList;
  }
}
