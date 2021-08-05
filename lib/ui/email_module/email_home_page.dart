import 'dart:convert';
import 'dart:math';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/app_buttons.dart';
import 'package:oho_works_app/enums/folder_type_enums.dart';
import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/mixins/someCommonMixins.dart';
import 'package:oho_works_app/models/email_module/create_folder.dart';
import 'package:oho_works_app/models/email_module/email_list_modules.dart';
import 'package:oho_works_app/models/email_module/email_user_create.dart';
import 'package:oho_works_app/ui/dialogs/delete_confirmation_dilog.dart';
import 'package:oho_works_app/ui/email_module/email_card.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oho_works_app/components/paginator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../settings.dart';
import 'email_create_page.dart';
import 'email_detail_page.dart';
import 'outbox_page.dart';

class EmailHomePage extends StatefulWidget {
  @override
  _EmailHomePage createState() => _EmailHomePage();
}

class _EmailHomePage extends State<EmailHomePage> {
  TextStyleElements? styleElements;
  List<EmailListItem> emailList = [];
  SharedPreferences prefs = locator<SharedPreferences>();
  String folderType = FOLDER_TYPE_ENUM.INBOX.type;
  GlobalKey<PaginatorState> paginatorKey = GlobalKey();
  String? searchVal;

  void refresh() {
    emailList.clear();
    paginatorKey.currentState!.changeState(resetState: true);
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return WillPopScope(
      onWillPop: _onWillpop,
      child: SafeArea(
          child: Scaffold(
            appBar: OhoAppBar().getCustomAppBarWithSearch(context,
                appBarTitle: folderType == FOLDER_TYPE_ENUM.INBOX.type
                    ? AppLocalizations.of(context)!.translate('')
                    : folderType,
                centerTitle: false,
                titleWidget: folderType == FOLDER_TYPE_ENUM.INBOX.type
                    ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      prefs.getString(Strings.mailUsername)!,
                      style: styleElements!
                          .headline6ThemeScalable(context)
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      color: HexColor(AppColors.appColorBlack85),
                    )
                  ],
                )
                    : null, onSearchValueChanged: (value) {
                  searchVal = value;
                  refresh();
                },
                hintText: 'Search mail',
                actions: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                            return EmailCreatePage();
                          }));
                    },
                    child: Container(
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
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.segment,
                        color: HexColor(AppColors.appColorBlack85),
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            enableDrag: true,
                            isScrollControlled: true,
                            context: context,
                            builder: (BuildContext context) {
                              return EmailOptionsSheet(
                                folderCallback: (value) {
                                  if(value == 'setting_callback'){
                                    print("setting callback");
                                    showManageEmailSheet(false);
                                  }else {
                                    setState(() {
                                      folderType = value;
                                    });
                                    refresh();
                                  }
                                },
                              );
                            });
                      }),

                  // _getSimplePopup(),
                  SizedBox(
                    width: 16,
                  )
                ],
                onBackButtonPress: _onBackPressed),
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
            body: RefreshIndicator(
              onRefresh: onRefresh,
              child: Paginator<EmailListResponse>.listView(
                key: paginatorKey,
                pageLoadFuture: fetchEmails,
                pageItemsGetter: listItemsGetter,
                listItemBuilder: listItemGetter,
                loadingWidgetBuilder: CustomPaginator(context).loadingWidgetMaker,
                errorWidgetBuilder: CustomPaginator(context).errorWidgetMaker,
                emptyListWidgetBuilder:
                CustomPaginator(context).emptyListWidgetMaker,
                totalItemsGetter: CustomPaginator(context).totalPagesGetter,
                pageErrorChecker: CustomPaginator(context).pageErrorChecker,
              ),
            ),
          )),
    );
  }
  void showManageEmailSheet(bool isAdmin) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12))),
        builder: (BuildContext context) {
          return ManageEmailAccountSheet(isAdmin);
        });
  }

  Future<EmailListResponse> fetchEmails(int page) async {
    var body = jsonEncode({
      "username": prefs.getString(Strings.mailUsername),
      "folder": folderType,
      "search_val": searchVal
    });
    var value = await Calls()
        .call(body, context, Config.EMAIL_INBOX, isMailToken: true);
    return EmailListResponse.fromJson(value);
  }

  List? listItemsGetter(EmailListResponse? pageData) {
    pageData!.rows!.forEach((element) {
      element.color =
      AppColors.colorsList[Random().nextInt(AppColors.colorsList.length)];
    });
    emailList.addAll(pageData.rows!);
    return pageData.rows;
  }

  Widget listItemGetter(itemData, int index) {
    EmailListItem item = itemData;
    return TricycleEmailCard(
        isDetailPage: false,
        emailItem: item,
        folderType: folderType,
        deleteCallback: () {
          deleteCallback(item);
        },
        moveCallback: () {
          moveCallback(item);
        },
        archiveCallback: () {
          moveToFolder(folderType, FOLDER_TYPE_ENUM.ARCHIVED.type, item.uid!);
        },
        replyAllCallback: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
                return EmailCreatePage(
                  isReply: true,
                  isForward: false,
                  replyUid: emailList[index].uid,
                  subject: emailList[index].subject,
                  senderDetails: emailList[index].fromValues!,
                  replyContent: emailList[index].html,
                  date: emailList[index].date,
                  toValues: emailList[index].toValues,
                  isReplyAll: true,
                );
              }));
        },
        replyCallback: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
                return EmailCreatePage(
                  isReply: true,
                  isForward: false,
                  replyUid: emailList[index].uid,
                  subject: emailList[index].subject,
                  senderDetails: emailList[index].fromValues!,
                  replyContent: emailList[index].html,
                  date: emailList[index].date,
                );
              }));
        },
        forwardCallback: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
                return EmailCreatePage(
                  isReply: true,
                  isForward: true,
                  replyUid: emailList[index].uid,
                  subject: emailList[index].subject,
                  senderDetails: emailList[index].fromValues!,
                  replyContent: emailList[index].html,
                  date: emailList[index].date,
                );
              }));
        },
        onClick: () {
          if(folderType == FOLDER_TYPE_ENUM.DRAFT.type){
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) {
                  return EmailCreatePage(
                    toValues: emailList[index].toValues,
                    subject: emailList[index].subject,
                    ccValues: emailList[index].ccValues,
                    replyContent: emailList[index].html,
                    isDraft: true,
                    draftId: emailList[index].uid,
                    draftSaveCallback:(String uid){
                      deleteEmail(uid);
                    }
                  );
                }));
          }else {
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) {
                  return EmailDetailPage(
                      subject: emailList[index].subject,
                      uid: emailList[index].uid,
                      folderType: folderType,
                      seenCallback: () {
                        setState(() {
                          try {
                            emailList[index].flags!.add("\\Seen");
                          } catch (onError) {
                            print(onError.toString());
                          }
                        });
                      }
                  );
                })).then((value) {
              if (value != null && value) {
                refresh();
              }
            });
          }
        });
  }

  void moveCallback(EmailListItem item) async {
    FolderCreateRequest payload = FolderCreateRequest();
    payload.username = prefs.getString(Strings.mailUsername)!;
    List<String> listOfFolders = [];
    Calls()
        .call(jsonEncode(payload), context, Config.EMAIL_FOLDER_LIST,
        isMailToken: true)
        .then((value) {
      listOfFolders.addAll(FOLDER_TYPE_ENUM.ALL.list);
      var res = FolderListResponse.fromJson(value);
      res.rows!.removeWhere((element) {
        return FOLDER_TYPE_ENUM.ALL.list.contains(element.name);
      });
      res.rows!.forEach((element) {
        listOfFolders.add(element.name!);
      });
      if (listOfFolders.contains(folderType)) {
        listOfFolders.remove(folderType);
      }
      showDialog(
          builder: (BuildContext context) {
            return FolderSelectionDialog(
              folderCallback: (value) {
                moveToFolder(folderType, value, item.uid!);
              },
              folderList: listOfFolders,
            );
          },
          context: context);
    });
  }

  void moveToFolder(
      String folderType, String destinationFolder, String uid) async {
    MoveFolderRequest payload = MoveFolderRequest();
    payload.folder = folderType;
    payload.moveToFolder = destinationFolder;
    payload.username = prefs.getString(Strings.mailUsername)!;
    payload.uidsList = [uid];
    Calls()
        .call(jsonEncode(payload), context, Config.EMAIL_MOVE_FOLDER,
        isMailToken: true)
        .then((value) {
      var res = CreateEmailUserResponse.fromJson(value);
      if (res.statusCode == Strings.success_code) {
        refresh();
      }
    });
  }

  void deleteCallback(EmailListItem item) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return DeleteConfirmationDilog(
            showCancelButton: true,
            cancelButton: () {},
            note: folderType != FOLDER_TYPE_ENUM.TRASH.type
                ? AppLocalizations.of(context)!.translate('move_to_trash')
                : AppLocalizations.of(context)!.translate('delete_confirmation'),
            updateButton: () async {
              if (folderType != FOLDER_TYPE_ENUM.TRASH.type) {
                moveToFolder(folderType, "Trash", item.uid!);
              } else {
                deleteEmail(item.uid!);
              }
            },
          );
        });
  }

  void deleteEmail(String uid) async {
    MoveFolderRequest payload = MoveFolderRequest();
    payload.folder = folderType;
    payload.username = prefs.getString(Strings.mailUsername)!;
    payload.uidsList = [uid];
    Calls()
        .call(jsonEncode(payload), context, Config.EMAIL_DELETE,
        isMailToken: true)
        .then((value) {
      var res = CreateEmailUserResponse.fromJson(value);
      if (res.statusCode == Strings.success_code) {
        refresh();
      }
    });
  }

  void _onBackPressed() {
    if (folderType == FOLDER_TYPE_ENUM.INBOX.type) {
      Navigator.pop(context);
    } else {
      setState(() {
        folderType = FOLDER_TYPE_ENUM.INBOX.type;
        refresh();
      });
    }
  }

  Future<bool> _onWillpop() {
    if (folderType == FOLDER_TYPE_ENUM.INBOX.type) {
      return Future.value(true);
    } else {
      setState(() {
        folderType = FOLDER_TYPE_ENUM.INBOX.type;
        refresh();
      });
      return Future.value(false);
    }
  }

  Future<void> onRefresh() async {
    refresh();
    await new Future.delayed(new Duration(milliseconds: 600));
    return null;
  }
}

class FolderSelectionDialog extends StatelessWidget {
  final List<String>? folderList;
  final Function(String)? folderCallback;

  FolderSelectionDialog({this.folderList, this.folderCallback});

  @override
  Widget build(BuildContext context) {
    var styleElements = TextStyleElements(context);
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.only(top: 12.0, bottom: 16, left: 8, right: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Select folder',
                  style: styleElements
                      .subtitle1ThemeScalable(context)
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              ListView.builder(
                itemCount: folderList!.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      folderCallback!(folderList![index]);
                      Navigator.pop(context);
                    },
                    child: ListTile(
                      title: Text(folderList![index]),
                    ),
                  );
                },
              )
            ],
          ),
        ));
  }
}

class EmailOptionsSheet extends StatefulWidget {
  final Function(String)? folderCallback;

  EmailOptionsSheet({@required this.folderCallback});

  @override
  _EmailOptionsSheet createState() => _EmailOptionsSheet();
}

class _EmailOptionsSheet extends State<EmailOptionsSheet> {
  SharedPreferences prefs = locator<SharedPreferences>();
  List<FolderListItem> folderList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      fetchFolderList();
    });
  }

  void fetchFolderList() async {
    FolderCreateRequest payload = FolderCreateRequest();
    payload.username = prefs.getString(Strings.mailUsername)!;
    Calls()
        .call(jsonEncode(payload), context, Config.EMAIL_FOLDER_LIST,
        isMailToken: true)
        .then((value) {
      var res = FolderListResponse.fromJson(value);
      if (res.statusCode == Strings.success_code) {
        if (res.rows != null && res.rows!.length > 0) {
          setState(() {
            folderList = res.rows!;
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
        }
      }
    });
  }

  Widget simplePopup(FolderListItem item) {
    return PopupMenuButton<String>(
      padding: EdgeInsets.only(right: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      itemBuilder: (context) => getItems(),
      onSelected: (value) {
        switch (value) {
          case 'edit':
            {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AddFolderDialog(
                        renameCallback: renameFolder,
                        rename: true,
                        folderName: item.name);
                  });
              break;
            }
          case 'delete':
            {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DeleteConfirmationDilog(
                      showCancelButton: true,
                      updateButton: () {
                        deleteFolder(item.name!);
                      },
                      cancelButton: () {},
                    );
                  });
              break;
            }
        }
      },
      child: Icon(Icons.more_vert),
    );
  }

  List<PopupMenuEntry<String>> getItems() {
    List<PopupMenuEntry<String>> popupmenuList = [];
    popupmenuList.add(
      PopupMenuItem(
        value: 'edit',
        child: Row(children: [
          Icon(Icons.edit_outlined),
          SizedBox(
            width: 8,
          ),
          Text(
            'Edit',
          )
        ]),
      ),
    );
    popupmenuList.add(
      PopupMenuItem(
        value: 'delete',
        child: Row(children: [
          Icon(Icons.delete_outline),
          SizedBox(
            width: 8,
          ),
          Text(
            'Delete',
          )
        ]),
      ),
    );
    return popupmenuList;
  }

  @override
  Widget build(BuildContext context) {
    var styleElements = TextStyleElements(context);
    return Container(
      padding: EdgeInsets.only(left: 24),
      child: isLoading
          ? CustomPaginator(context).loadingWidgetMaker()
          : SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 16.0),
              child: Row(children: [
                Text(
                  prefs.getString(Strings.mailUsername)!,
                  style: styleElements
                      .subtitle1ThemeScalable(context)
                      .copyWith(
                      color: HexColor(AppColors.appMainColor),
                      fontWeight: FontWeight.bold),
                ),
                Spacer(),
                IconButton(
                  onPressed: () {
                    print("*@!@#@#@@#@#@#@#@#@#@#@#");
                    Navigator.pop(context);
                    widget.folderCallback!('setting_callback');
                  },
                  icon: Icon(Icons.settings),
                ),
                SizedBox(
                  width: 16,
                )
              ]),
            ),
            folderList.any((element) {
              return element.name == FOLDER_TYPE_ENUM.INBOX.type;
            })
                ? InkWell(
              onTap: () {
                widget.folderCallback!(FOLDER_TYPE_ENUM.INBOX.type);
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16, top: 12, bottom: 12),
                child: Row(children: [
                  Icon(
                    Icons.mail_outline_rounded,
                    color: HexColor(AppColors.appColorBlack85),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Text('Inbox',
                        style: styleElements
                            .subtitle1ThemeScalable(context)
                            .copyWith(
                            fontWeight: FontWeight.normal)),
                  ),
                  Visibility(
                    visible: folderList.any((element) {
                      return element.name ==
                          FOLDER_TYPE_ENUM.INBOX.type;
                    })
                        ? folderList.singleWhere((element) {
                      return element.name ==
                          FOLDER_TYPE_ENUM.INBOX.type;
                    }).unseen! >
                        0
                        : false,
                    child: Container(
                      margin: EdgeInsets.only(right: 8),
                      padding: EdgeInsets.only(left: 5, right: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: HexColor(AppColors.appMainColor),
                      ),
                      child: Center(
                        child: Text(
                          folderList
                              .singleWhere((element) {
                            return element.name ==
                                FOLDER_TYPE_ENUM.INBOX.type;
                          })
                              .unseen
                              .toString(),
                          style: styleElements
                              .bodyText2ThemeScalable(context)
                              .copyWith(
                              color: HexColor(
                                  AppColors.appColorWhite),
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            )
                : Container(),
            folderList.any((element) {
              return element.name == FOLDER_TYPE_ENUM.SENT.type;
            })
                ? InkWell(
              onTap: () {
                widget.folderCallback!(FOLDER_TYPE_ENUM.SENT.type);
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16, top: 12, bottom: 12),
                child: Row(children: [
                  Icon(
                    Icons.send_outlined,
                    color: HexColor(AppColors.appColorBlack85),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Text('Sent',
                        style: styleElements
                            .subtitle1ThemeScalable(context)
                            .copyWith(
                            fontWeight: FontWeight.normal)),
                  ),
                  // Visibility(
                  //   visible: folderList.any((element) {
                  //     return element.name == FOLDER_TYPE_ENUM.SENT.type;
                  //   })
                  //       ? folderList.singleWhere((element) {
                  //     return element.name ==
                  //         FOLDER_TYPE_ENUM.SENT.type;
                  //   }).unseen >
                  //       0
                  //       : false,
                  //   child: Container(
                  //     margin: EdgeInsets.only(right: 8),
                  //     padding: EdgeInsets.only(left: 5, right: 4),
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(4),
                  //       color: HexColor(AppColors.appMainColor),
                  //     ),
                  //     child: Center(
                  //       child: Text(
                  //         folderList
                  //             .singleWhere((element) {
                  //           return element.name ==
                  //               FOLDER_TYPE_ENUM.SENT.type;
                  //         })
                  //             .unseen
                  //             .toString(),
                  //         style: styleElements
                  //             .bodyText2ThemeScalable(context)
                  //             .copyWith(
                  //             color:
                  //             HexColor(AppColors.appColorWhite),
                  //             fontWeight: FontWeight.normal),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ]),
              ),
            )
                : Container(),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                      return OutBoxPage();
                    }));
              },
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16, top: 12, bottom: 12),
                child: Row(children: [
                  Icon(
                    Icons.forward_to_inbox,
                    color: HexColor(AppColors.appColorBlack85),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Text('Outbox',
                        style: styleElements
                            .subtitle1ThemeScalable(context)
                            .copyWith(fontWeight: FontWeight.normal)),
                  ),
                ]),
              ),
            ),
            folderList.any((element) {
              return element.name == FOLDER_TYPE_ENUM.DRAFT.type;
            })
                ? InkWell(
              onTap: () {
                widget.folderCallback!(FOLDER_TYPE_ENUM.DRAFT.type);
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16, top: 12, bottom: 12),
                child: Row(children: [
                  Icon(
                    Icons.edit_outlined,
                    color: HexColor(AppColors.appColorBlack85),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Text('Draft',
                        style: styleElements
                            .subtitle1ThemeScalable(context)
                            .copyWith(
                            fontWeight: FontWeight.normal)),
                  ),
                  // Visibility(
                  //   visible: folderList.any((element) {
                  //     return element.name ==
                  //         FOLDER_TYPE_ENUM.DRAFT.type;
                  //   })
                  //       ? folderList.singleWhere((element) {
                  //     return element.name ==
                  //         FOLDER_TYPE_ENUM.DRAFT.type;
                  //   }).unseen >
                  //       0
                  //       : false,
                  //   child: Container(
                  //     margin: EdgeInsets.only(right: 8),
                  //     padding: EdgeInsets.only(left: 5, right: 4),
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(4),
                  //       color: HexColor(AppColors.appMainColor),
                  //     ),
                  //     child: Center(
                  //       child: Text(
                  //         folderList
                  //             .singleWhere((element) {
                  //           return element.name ==
                  //               FOLDER_TYPE_ENUM.DRAFT.type;
                  //         })
                  //             .unseen
                  //             .toString(),
                  //         style: styleElements
                  //             .bodyText2ThemeScalable(context)
                  //             .copyWith(
                  //             color:
                  //             HexColor(AppColors.appColorWhite),
                  //             fontWeight: FontWeight.normal),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ]),
              ),
            )
                : Container(),
            folderList.any((element) {
              return element.name == FOLDER_TYPE_ENUM.SPAM.type;
            })
                ? InkWell(
              onTap: () {
                widget.folderCallback!(FOLDER_TYPE_ENUM.SPAM.type);
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16, top: 12, bottom: 12),
                child: Row(children: [
                  Icon(
                    Icons.thumb_down_alt_outlined,
                    color: HexColor(AppColors.appColorBlack85),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Text('Spam',
                        style: styleElements
                            .subtitle1ThemeScalable(context)
                            .copyWith(
                            fontWeight: FontWeight.normal)),
                  ),
                  // Visibility(
                  //   visible: folderList.any((element) {
                  //     return element.name ==
                  //         FOLDER_TYPE_ENUM.SPAM.type;
                  //   })
                  //       ? folderList.singleWhere((element) {
                  //     return element.name ==
                  //         FOLDER_TYPE_ENUM.SPAM.type;
                  //   }).unseen >
                  //       0
                  //       : false,
                  //   child: Container(
                  //     margin: EdgeInsets.only(right: 8),
                  //     padding: EdgeInsets.only(left: 5, right: 4),
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(4),
                  //       color: HexColor(AppColors.appMainColor),
                  //     ),
                  //     child: Center(
                  //       child: Text(
                  //         folderList
                  //             .singleWhere((element) {
                  //           return element.name ==
                  //               FOLDER_TYPE_ENUM.SPAM.type;
                  //         })
                  //             .unseen
                  //             .toString(),
                  //         style: styleElements
                  //             .bodyText2ThemeScalable(context)
                  //             .copyWith(
                  //             color: HexColor(
                  //                 AppColors.appColorWhite),
                  //             fontWeight: FontWeight.normal),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ]),
              ),
            )
                : Container(),
            folderList.any((element) {
              return element.name == FOLDER_TYPE_ENUM.ARCHIVED.type;
            })
                ? InkWell(
              onTap: () {
                widget
                    .folderCallback!(FOLDER_TYPE_ENUM.ARCHIVED.type);
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16, top: 12, bottom: 12),
                child: Row(children: [
                  Icon(
                    Icons.archive_outlined,
                    color: HexColor(AppColors.appColorBlack85),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Text('Archived',
                        style: styleElements
                            .subtitle1ThemeScalable(context)
                            .copyWith(
                            fontWeight: FontWeight.normal)),
                  ),
                  // Visibility(
                  //   visible: folderList.any((element) {
                  //     return element.name ==
                  //         FOLDER_TYPE_ENUM.ARCHIVED.type;
                  //   })
                  //       ? folderList.singleWhere((element) {
                  //     return element.name ==
                  //         FOLDER_TYPE_ENUM.ARCHIVED.type;
                  //   }).unseen >
                  //       0
                  //       : false,
                  //   child: Container(
                  //     margin: EdgeInsets.only(right: 8),
                  //     padding: EdgeInsets.only(left: 5, right: 4),
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(4),
                  //       color: HexColor(AppColors.appMainColor),
                  //     ),
                  //     child: Center(
                  //       child: Text(
                  //         folderList
                  //             .singleWhere((element) {
                  //           return element.name ==
                  //               FOLDER_TYPE_ENUM.ARCHIVED.type;
                  //         })
                  //             .unseen
                  //             .toString(),
                  //         style: styleElements
                  //             .bodyText2ThemeScalable(context)
                  //             .copyWith(
                  //             color: HexColor(
                  //                 AppColors.appColorWhite),
                  //             fontWeight: FontWeight.normal),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ]),
              ),
            )
                : Container(),
            folderList.any((element) {
              return element.name == FOLDER_TYPE_ENUM.TRASH.type;
            })
                ? InkWell(
              onTap: () {
                widget.folderCallback!(FOLDER_TYPE_ENUM.TRASH.type);
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16, top: 12, bottom: 12),
                child: Row(children: [
                  Icon(
                    Icons.delete_outline_rounded,
                    color: HexColor(AppColors.appColorBlack85),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Text('Trash',
                        style: styleElements
                            .subtitle1ThemeScalable(context)
                            .copyWith(
                            fontWeight: FontWeight.normal)),
                  ),
                  // Visibility(
                  //   visible: folderList.any((element) {
                  //     return element.name ==
                  //         FOLDER_TYPE_ENUM.TRASH.type;
                  //   })
                  //       ? folderList.singleWhere((element) {
                  //     return element.name ==
                  //         FOLDER_TYPE_ENUM.TRASH.type;
                  //   }).unseen >
                  //       0
                  //       : false,
                  //   child: Container(
                  //     margin: EdgeInsets.only(right: 8),
                  //     padding: EdgeInsets.only(left: 5, right: 4),
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(4),
                  //       color: HexColor(AppColors.appMainColor),
                  //     ),
                  //     child: Center(
                  //       child: Text(
                  //         folderList
                  //             .singleWhere((element) {
                  //           return element.name ==
                  //               FOLDER_TYPE_ENUM.TRASH.type;
                  //         })
                  //             .unseen
                  //             .toString(),
                  //         style: styleElements
                  //             .bodyText2ThemeScalable(context)
                  //             .copyWith(
                  //             color: HexColor(
                  //                 AppColors.appColorWhite),
                  //             fontWeight: FontWeight.normal),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ]),
              ),
            )
                : Container(),
            folderList.any((element) {
              return element.name == FOLDER_TYPE_ENUM.JUNK.type;
            })
                ? InkWell(
              onTap: () {
                widget.folderCallback!(FOLDER_TYPE_ENUM.JUNK.type);
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16, top: 12, bottom: 12),
                child: Row(children: [
                  Icon(
                    Icons.delete_outline_rounded,
                    color: HexColor(AppColors.appColorBlack85),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Text('Junk',
                        style: styleElements
                            .subtitle1ThemeScalable(context)
                            .copyWith(
                            fontWeight: FontWeight.normal)),
                  ),
                  Visibility(
                    visible: folderList.any((element) {
                      return element.name ==
                          FOLDER_TYPE_ENUM.TRASH.type;
                    })
                        ? folderList.singleWhere((element) {
                      return element.name ==
                          FOLDER_TYPE_ENUM.JUNK.type;
                    }).unseen! >
                        0
                        : false,
                    child: Container(
                      margin: EdgeInsets.only(right: 8),
                      padding: EdgeInsets.only(left: 5, right: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: HexColor(AppColors.appMainColor),
                      ),
                      child: Center(
                        child: Text(
                          folderList
                              .singleWhere((element) {
                            return element.name ==
                                FOLDER_TYPE_ENUM.JUNK.type;
                          })
                              .unseen
                              .toString(),
                          style: styleElements
                              .bodyText2ThemeScalable(context)
                              .copyWith(
                              color: HexColor(
                                  AppColors.appColorWhite),
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            )
                : Container(),
            Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 16, top: 6, bottom: 6),
              child: Row(children: [
                Text(
                  'Folders',
                  style: styleElements
                      .bodyText2ThemeScalable(context)
                      .copyWith(
                      color: HexColor(AppColors.appColorBlack65),
                      fontWeight: FontWeight.normal),
                ),
                Spacer(),
                IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AddFolderDialog(
                            addCallback: addFolder,
                          );
                        });
                  },
                  icon: Icon(Icons.add_box_outlined),
                )
              ]),
            ),
            Visibility(
              visible: folderList.length > 0,
              child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 16, top: 0, bottom: 0),
                  child: ListView.builder(
                    itemCount: folderList.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext listContext, int index) {
                      if (FOLDER_TYPE_ENUM.ALL.list
                          .contains(folderList[index].name)) {
                        return Container();
                      } else {
                        return InkWell(
                          onTap: () {
                            widget.folderCallback!(folderList[index].name!);
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 0.0,
                                right: 16,
                                top: 12,
                                bottom: 12),
                            child: Row(children: [
                              Icon(
                                folderList[index].name ==
                                    FOLDER_TYPE_ENUM.TRASH.type
                                    ? Icons.delete_outline_rounded
                                    : Icons.folder_open_rounded,
                                color:
                                HexColor(AppColors.appColorBlack85),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: Text(folderList[index].name!,
                                    style: styleElements
                                        .subtitle1ThemeScalable(context)
                                        .copyWith(
                                        fontWeight:
                                        FontWeight.normal)),
                              ),
                              Visibility(
                                visible: folderList[index].unseen! > 0,
                                child: Container(
                                  margin: EdgeInsets.only(right: 8),
                                  padding:
                                  EdgeInsets.only(left: 5, right: 4),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(4),
                                    color:
                                    HexColor(AppColors.appMainColor),
                                  ),
                                  child: Center(
                                    child: Text(
                                      folderList[index].unseen.toString(),
                                      style: styleElements
                                          .bodyText2ThemeScalable(context)
                                          .copyWith(
                                          color: HexColor(AppColors
                                              .appColorWhite),
                                          fontWeight:
                                          FontWeight.normal),
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                  visible: !folderList[index]
                                      .name!
                                      .isFolderType,
                                  child: simplePopup(folderList[index]))
                            ]),
                          ),
                        );
                      }
                    },
                  )),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(
            //       left: 16.0, right: 16, top: 16, bottom: 16),
            //   child: Row(children: [
            //     Text(
            //       'Labels',
            //       style: styleElements
            //           .bodyText2ThemeScalable(context)
            //           .copyWith(
            //           color: HexColor(AppColors.appColorBlack65),
            //           fontWeight: FontWeight.normal),
            //     ),
            //   ]),
            // ),
            // Padding(
            //   padding: const EdgeInsets.only(
            //       left: 16.0, right: 16, top: 12, bottom: 12),
            //   child: Row(children: [
            //     Icon(
            //       Icons.mail_outline_rounded,
            //       color: HexColor(AppColors.appColorBlack85),
            //     ),
            //     SizedBox(
            //       width: 8,
            //     ),
            //     Text('Unread',
            //         style: styleElements
            //             .subtitle1ThemeScalable(context)
            //             .copyWith(fontWeight: FontWeight.normal))
            //   ]),
            // ),
            // Padding(
            //   padding: const EdgeInsets.only(
            //       left: 16.0, right: 16, top: 12, bottom: 12),
            //   child: Row(children: [
            //     Icon(
            //       Icons.flag_outlined,
            //       color: HexColor(AppColors.appColorBlack85),
            //     ),
            //     SizedBox(
            //       width: 8,
            //     ),
            //     Text('Flagged',
            //         style: styleElements
            //             .subtitle1ThemeScalable(context)
            //             .copyWith(fontWeight: FontWeight.normal))
            //   ]),
            // ),
            // Padding(
            //   padding: const EdgeInsets.only(
            //       left: 16.0, right: 16, top: 12, bottom: 12),
            //   child: Row(children: [
            //     Icon(
            //       Icons.label_outline_rounded,
            //       color: HexColor(AppColors.appColorBlack85),
            //     ),
            //     SizedBox(
            //       width: 8,
            //     ),
            //     Text('Important',
            //         style: styleElements
            //             .subtitle1ThemeScalable(context)
            //             .copyWith(fontWeight: FontWeight.normal))
            //   ]),
            // ),
            // Padding(
            //   padding: const EdgeInsets.only(
            //       left: 16.0, right: 16, top: 12, bottom: 12),
            //   child: Row(children: [
            //     Icon(
            //       Icons.bookmark_border_rounded,
            //       color: HexColor(AppColors.appColorBlack85),
            //     ),
            //     SizedBox(
            //       width: 8,
            //     ),
            //     Text(
            //       'Bookmarked',
            //       style: styleElements
            //           .subtitle1ThemeScalable(context)
            //           .copyWith(fontWeight: FontWeight.normal),
            //     )
            //   ]),
            // ),
          ],
        ),
      ),
    );
  }

  renameFolder(String folder, String destination) async {
    FolderCreateRequest payload = FolderCreateRequest();
    payload.username = prefs.getString(Strings.mailUsername)!;
    payload.folder = folder;
    payload.destinationFolder = destination;
    Calls()
        .call(jsonEncode(payload), context, Config.EMAIL_FOLDER_RENAME,
        isMailToken: true)
        .then((value) {
      var res = CreateEmailUserResponse.fromJson(value);
      if (res.statusCode == Strings.success_code) {
        fetchFolderList();
      }
    });
  }

  deleteFolder(String folder) async {
    FolderCreateRequest payload = FolderCreateRequest();
    payload.username = prefs.getString(Strings.mailUsername)!;
    payload.folder = folder;
    Calls()
        .call(jsonEncode(payload), context, Config.EMAIL_FOLDER_DELETE,
        isMailToken: true)
        .then((value) {
      var res = CreateEmailUserResponse.fromJson(value);
      if (res.statusCode == Strings.success_code) {
        fetchFolderList();
      }
    });
  }

  addFolder(String folder) async {
    FolderCreateRequest payload = FolderCreateRequest();
    payload.username = prefs.getString(Strings.mailUsername)!;
    payload.folder = folder;
    Calls()
        .call(jsonEncode(payload), context, Config.EMAIL_FOLDER_CREATE,
        isMailToken: true)
        .then((value) {
      var res = CreateEmailUserResponse.fromJson(value);
      if (res.statusCode == Strings.success_code) {
        fetchFolderList();
      }
    });
  }
}

class AddFolderDialog extends StatelessWidget with CommonMixins {
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController folderController = TextEditingController();
  final Function(String)? addCallback;
  final Function(String, String)? renameCallback;
  final bool rename;
  final folderName;

  AddFolderDialog(
      {this.addCallback,
        this.rename = false,
        this.renameCallback,
        this.folderName}) {
    if (rename) {
      folderController.text = folderName;
    }
  }

  @override
  Widget build(BuildContext context) {
    var styleElements = TextStyleElements(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                rename ? "Rename Folder" : 'Add Folder',
                style: styleElements
                    .subtitle1ThemeScalable(context)
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                padding: EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: HexColor(AppColors.appColorBackground),
                ),
                child: TextFormField(
                  validator: validateTextField,
                  controller: folderController,
                  onSaved: (value) {},
                  decoration: InputDecoration(
                      hintText: "Folder",
                      contentPadding:
                      EdgeInsets.only(left: 12, top: 16, bottom: 8),
                      border: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      labelText: "Enter the folder name"),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Spacer(),
                  appTextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      AppLocalizations.of(context)!.translate('cancel'),
                      style: styleElements
                          .captionThemeScalable(context)
                          .copyWith(color: HexColor(AppColors.appMainColor)),
                    ),
                    shape: StadiumBorder(),
                  ),
                  appTextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      if (rename) {
                        renameCallback!(folderName, folderController.text);
                      } else {
                        addCallback!(folderController.text);
                      }
                    },
                    child: Text(
                      AppLocalizations.of(context)!
                          .translate(rename ? 'rename' : 'add'),
                      style: styleElements
                          .captionThemeScalable(context)
                          .copyWith(color: HexColor(AppColors.appMainColor)),
                    ),
                    shape: StadiumBorder(),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
