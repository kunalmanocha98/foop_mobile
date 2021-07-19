import 'package:oho_works_app/components/tricycleavatar.dart';
import 'package:oho_works_app/enums/resolutionenums.dart';
import 'package:oho_works_app/enums/serviceTypeEnums.dart';
import 'package:oho_works_app/models/email_module/email_list_modules.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/follow_unfollow_block_remove_unblock_button.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/utility_class.dart';
import 'package:flutter/material.dart';

class EmailCardHeader extends StatefulWidget {
  final String imageUrl;
  final EmailListItem emailItem;

  EmailCardHeader({this.imageUrl, this.emailItem});

  @override
  EmailCardHeaderState createState() =>
      EmailCardHeaderState(emailItem: emailItem);
}

class EmailCardHeaderState extends State<EmailCardHeader> {
  TextStyleElements styleElements;
  bool isExpanded = false;
  EmailListItem emailItem;

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
            child: TricycleAvatar(
              key: UniqueKey(),
              resolution_type: RESOLUTION_TYPE.R64,
              service_type: SERVICE_TYPE.PERSON,
              imageUrl: widget.imageUrl,
              name: emailItem.fromValues.name,
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
                        emailItem.fromValues.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: styleElements
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
                      style: styleElements.captionThemeScalable(context),
                      children: [
                        TextSpan(
                            text: getTo(),
                            style: styleElements.captionThemeScalable(context))
                      ])),
                ),
                Visibility(
                  visible: isExpanded && (getCc() != null),
                  child: Text.rich(TextSpan(
                      text: "Cc: ",
                      style: styleElements.captionThemeScalable(context),
                      children: [
                        TextSpan(
                            text: getCc(),
                            style: styleElements.captionThemeScalable(context))
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
                                    emailItem.date))
                            : "To: ${emailItem.to[0]}",
                        style: styleElements
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
              GenericFollowUnfollowButton(
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
              simplePopup(),
            ],
          )
        ],
      ),
    );
  }

  String getTo() {
    String value = "";
    if (emailItem.to != null && emailItem.to.length > 0) {
      value = emailItem.to.join(", ");
      return value;
    } else {
      return null;
    }
  }

  String getCc() {
    String value = "";
    if (emailItem.cc != null && emailItem.cc.length > 0) {
      for (var item in emailItem.cc) {
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
          case 'delete':
            {
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

  static List<PopupMenuEntry<String>> getItems() {
    List<PopupMenuEntry<String>> popupmenuList = [];
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
    popupmenuList.add(
      PopupMenuItem(
        value: 'mark_read',
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
        value: 'mark_read',
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
        value: 'mark_read',
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
    popupmenuList.add(
      PopupMenuItem(
        value: 'mark_read',
        child: Row(children: [
          Icon(Icons.share_outlined),
          SizedBox(
            width: 8,
          ),
          Text(
            'Share',
          )
        ]),
      ),
    );
    popupmenuList.add(
      PopupMenuItem(
        value: 'mark_read',
        child: Row(children: [
          Icon(Icons.mic_none_rounded),
          SizedBox(
            width: 8,
          ),
          Text(
            'Start a conversation',
          )
        ]),
      ),
    );
    return popupmenuList;
  }
}

class EmailCardFooter extends StatelessWidget {
  final Function replyCallback;
  final Function replyAllCallback;
  final Function forwardCallback;
  final Function deleteCallback;
  final Function bookmarkCallback;

  EmailCardFooter(
      {this.replyAllCallback,
      this.replyCallback,
      this.forwardCallback,
      this.deleteCallback,
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
              icon: Icon(
                Icons.bookmark_outline_rounded,
                color: HexColor(AppColors.appColorBlack35),
              ),
              onPressed: bookmarkCallback,
            ),
          ),
        ),
      ],
    );
  }
}
