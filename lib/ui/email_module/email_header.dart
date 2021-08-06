import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/appAvatar.dart';
import 'package:oho_works_app/enums/resolutionenums.dart';
import 'package:oho_works_app/enums/serviceTypeEnums.dart';
import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/models/email_module/email_bookmark_read.dart';
import 'package:oho_works_app/models/email_module/email_list_modules.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/follow_unfollow_block_remove_unblock_button.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/utility_class.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmailCardHeader extends StatefulWidget {
  final String? imageUrl;
  final EmailListItem? emailItem;
  final Function? markCallback;
  final Function? moveCallback;
  final Function? printCallback;
  final bool isDetailPage;
  final Function? archiveCallback;
  final bool isOutbox;
  final Function? sendAgain;
  final String? folderType;
  final Function? deleteFromOutbox;

  EmailCardHeader({this.imageUrl,
    this.isOutbox = false,
    this.sendAgain,
    this.folderType,
    this.deleteFromOutbox,
    this.emailItem, this.markCallback,this.moveCallback,this.printCallback,this.isDetailPage = false,this.archiveCallback});

  @override
  EmailCardHeaderState createState() =>
      EmailCardHeaderState(emailItem: emailItem);
}

class EmailCardHeaderState extends State<EmailCardHeader> {
  TextStyleElements? styleElements;
  bool isExpanded = false;
  EmailListItem? emailItem;
  SharedPreferences prefs = locator<SharedPreferences>();

  EmailCardHeaderState({this.emailItem});

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return Container(
      padding: EdgeInsets.all(4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 8.0, right: 16),
            child: appAvatar(
              key: UniqueKey(),
              resolution_type: RESOLUTION_TYPE.R64,
              service_type: SERVICE_TYPE.PERSON,
              imageUrl: widget.imageUrl,
              name: (emailItem!.fromValues!.name!.isNotEmpty)
                  ? emailItem!.fromValues!.name
                  : emailItem!.fromValues!.email,
              color: emailItem!.color,
              size: 48,
            ),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        (emailItem!.fromValues!.name != null &&
                            emailItem!.fromValues!.name!.isNotEmpty)
                            ? emailItem!.fromValues!.name!
                            : emailItem!.fromValues!.email!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: styleElements!
                            .subtitle1ThemeScalable(context)
                            .copyWith(
                            color: HexColor(AppColors.appColorBlack85)),
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: isExpanded && (getTo() != null),
                  child: Text.rich(TextSpan(
                      text: "To: ",
                      style: styleElements!.captionThemeScalable(context),
                      children: [
                        TextSpan(
                            text: getTo(),
                            style: styleElements!.captionThemeScalable(context))
                      ])),
                ),
                Visibility(
                  visible: isExpanded && (getCc() != null),
                  child: Text.rich(TextSpan(
                      text: "Cc: ",
                      style: styleElements!.captionThemeScalable(context),
                      children: [
                        TextSpan(
                            text: getCc(),
                            style: styleElements!.captionThemeScalable(context))
                      ])),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isExpanded
                            ? Utility().getDateFormat(
                            "dd MMM yyyy",
                            DateTime.fromMillisecondsSinceEpoch(
                                emailItem!.date!))
                            : "To: ${emailItem!.to!=null ?emailItem!.to![0]:""}",
                        style: styleElements!
                            .captionThemeScalable(context)
                            .copyWith(
                            color: HexColor(AppColors.appColorBlack35)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Icon(isExpanded
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down)
                    ],
                  ),
                )
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Visibility(
                visible: false,
                child: GenericFollowUnfollowButton(
                  actionByObjectType: "person",
                  actionByObjectId: 10,
                  actionOnObjectType: "",
                  actionOnObjectId: 1,
                  engageFlag: "Follow",
                  actionFlag: "F",
                  isRoundedButton: false,
                  actionDetails: [""],
                  personName: "",
                  clicked: () {},
                  callback: (isCallSuccess) {},
                ),
              ),
              simplePopup(),
            ],
          )
        ],
      ),
    );
  }

  String? getTo() {
    String value = "";
    if (emailItem!.to!.length > 0) {
      value = emailItem!.to!.join(", ");
      return value;
    } else {
      return null;
    }
  }

  String? getCc() {
    String value = "";
    if (emailItem!.cc!.length > 0) {
      for (var item in emailItem!.cc!) {
        value = value + item + ", ";
      }
      value.substring(0, value.length - 3);
      return value;
    } else {
      return null;
    }
  }

  Widget simplePopup() {
    return PopupMenuButton<String>(
      padding: EdgeInsets.only(right: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      itemBuilder: (context) => getItems(),
      onSelected: (value) {
        switch (value) {
          case 'delete':{
              break;
            }
          case 'mark_read':{
            markasRead();
            break;
          }
          case 'mark_unread':{
            markasUnread();
            break;
          }
          case 'move':{
            widget.moveCallback!();
            break;
          }
          case 'print':{
            widget.printCallback!();
            break;
          }
          case 'archive':{
            widget.archiveCallback!();
            break;
          }
          case 'send_again':{
            widget.sendAgain!();
            break;
          }
          case 'delete_from_outbox':{
            widget.deleteFromOutbox!();
            break;
          }
        }
      },
      icon: Icon(
        Icons.more_vert,
        color: HexColor(AppColors.appColorBlack85),
      ),
    );
  }

   List<PopupMenuEntry<String>> getItems() {
    List<PopupMenuEntry<String>> popupmenuList = [];
    if(widget.isOutbox){
      popupmenuList.add(
        PopupMenuItem(
          value: 'send_again',
          child: Row(children: [
            Icon(Icons.forward_to_inbox),
            SizedBox(
              width: 8,
            ),
            Text(
              'Send Again',
            )
          ]),
        ),
      );
      popupmenuList.add(
        PopupMenuItem(
          value: 'delete_from_outbox',
          child: Row(children: [
            Icon(Icons.delete_outline_rounded),
            SizedBox(
              width: 8,
            ),
            Text(
              'Delete',
            )
          ]),
        ),
      );
    }else {
      if (emailItem!.flags!.contains("\\Seen") && !widget.isDetailPage) {
        popupmenuList.add(
          PopupMenuItem(
            value: 'mark_unread',
            child: Row(children: [
              Icon(Icons.drafts_outlined),
              SizedBox(
                width: 8,
              ),
              Text(
                'Mark as Unread',
              )
            ]),
          ),
        );
      } else {
        if (widget.isDetailPage) {
          popupmenuList.add(
            PopupMenuItem(
              value: 'mark_read',
              child: Row(children: [
                Icon(Icons.mail_outline_rounded),
                SizedBox(
                  width: 8,
                ),
                Text(
                  'Mark as Read',
                )
              ]),
            ),
          );
        }
      }
      popupmenuList.add(
        PopupMenuItem(
          value: 'move',
          child: Row(children: [
            Icon(Icons.folder_open_outlined),
            SizedBox(
              width: 8,
            ),
            Text(
              'Move message',
            )
          ]),
        ),
      );
      popupmenuList.add(
        PopupMenuItem(
          value: 'archive',
          child: Row(children: [
            Icon(Icons.archive_outlined),
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
          value: 'print',
          child: Row(children: [
            Icon(Icons.print_outlined),
            SizedBox(
              width: 8,
            ),
            Text(
              'Print',
            )
          ]),
        ),
      );
    }

    return popupmenuList;
  }

  void markasRead() {
    BookmarkReadRequest request = BookmarkReadRequest();
    request.username =  prefs.getString(Strings.mailUsername)!;
    request.folder = widget.folderType!;
    request.uidsList =[emailItem!.uid!];
    request.flag = "Seen";
    emailItem!.flags!.add("\\Seen");
    Calls().call(jsonEncode(request), context, Config.EMAIL_FLAG_SET,isMailToken:true);
    widget.markCallback!();
  }

  void markasUnread() {
    BookmarkReadRequest request = BookmarkReadRequest();
    request.username =  prefs.getString(Strings.mailUsername)!;
    request.folder = widget.folderType!;
    request.uidsList =[emailItem!.uid!];
    request.flag = "Seen";
    emailItem!.flags!.remove("\\Seen");
    Calls().call(jsonEncode(request), context, Config.EMAIL_FLAG_REMOVE,isMailToken:true);
   widget.markCallback!();
  }

}

class EmailCardFooter extends StatelessWidget {
  final VoidCallback? replyCallback;
  final VoidCallback? replyAllCallback;
  final VoidCallback? forwardCallback;
  final VoidCallback? deleteCallback;
  final VoidCallback? bookmarkCallback;
  final bool isBookmarked;

  EmailCardFooter(
      {this.replyAllCallback,
        this.replyCallback,
        this.forwardCallback,
        this.deleteCallback,
        this.isBookmarked= false,
        this.bookmarkCallback});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Visibility(
          visible: true,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: IconButton(
              icon: Icon(
                Icons.reply_outlined,
                color: HexColor(AppColors.appColorBlack35),
              ),
              onPressed: replyCallback,
            ),
          ),
        ),
        Visibility(
          visible: true,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: IconButton(
              icon: Icon(
                Icons.reply_all_outlined,
                color: HexColor(AppColors.appColorBlack35),
              ),
              onPressed: replyAllCallback,
            ),
          ),
        ),
        Visibility(
          visible: true,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: IconButton(
              icon: Icon(
                Icons.forward,
                color: HexColor(AppColors.appColorBlack35),
              ),
              onPressed: forwardCallback,
            ),
          ),
        ),
        Visibility(
          visible: true,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: IconButton(
              icon: Icon(
                Icons.delete_outline_rounded,
                color: HexColor(AppColors.appColorBlack35),
              ),
              onPressed: deleteCallback,
            ),
          ),
        ),
        Spacer(),
        Visibility(
          visible: true,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: IconButton(
                icon: isBookmarked
                    ? Icon(
                  Icons.bookmark,
                  color: HexColor(AppColors.appMainColor),
                )
                    : Icon(
                  Icons.bookmark_outline_rounded,
                  color: HexColor(AppColors.appColorBlack35),
                ),
                onPressed: bookmarkCallback),
          ),
        ),
      ],
    );
  }
}
