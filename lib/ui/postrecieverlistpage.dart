import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/tricycleProgressButton.dart';
import 'package:oho_works_app/components/tricycle_user_list_tile.dart';
import 'package:oho_works_app/enums/postRecipientType.dart';
import 'package:oho_works_app/models/post/postcreate.dart';
import 'package:oho_works_app/models/post/postreceiver.dart';
import 'package:oho_works_app/ui/dialogs/tricycleAlertDialog.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/scrach_card_dialogue.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/material.dart';
import 'package:oho_works_app/components/paginator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'RegisterInstitutions/models/scratch_card_response.dart';
import 'RegisterInstitutions/models/scratch_data.dart';

class PostReceiverListPage extends StatefulWidget {
  final PostCreatePayload? payload;
  final PostReceiverListItem? selectedReceiverData;
  final PostCreatePayload? createLessonData;
  final Function? callBack;
  final List<PostCreatePayload?>? list;

  PostReceiverListPage(
      { this.payload,
        this.list,
        required this.selectedReceiverData,
        this.createLessonData,
        this.callBack});

  @override
  _PostReceiverListPage createState() => _PostReceiverListPage(
      payload: payload, selectedReceiverData: selectedReceiverData);
}

class _PostReceiverListPage extends State<PostReceiverListPage> {
  String? searchVal;
  SharedPreferences? prefs;
  PostCreatePayload? payload;
  PostReceiverListItem? selectedReceiverData;
  late TextStyleElements styleElements;
  GlobalKey<PaginatorState> paginatorKey = GlobalKey();
  List<PostReceiverListItem?> recList = [];
  List<PostReceiverListItem?> _selectedList = [];
  List<PostRecipientDetailItem> receiverDetailItem = [];
  PostCreatePayload postCreatePayload = PostCreatePayload();
  bool isPrivateSelected = false;

  GlobalKey<TricycleProgressButtonState> progressButtonKey = GlobalKey();

  _PostReceiverListPage({this.payload, this.selectedReceiverData});

  refresh() {
    recList.clear();
    paginatorKey.currentState!.changeState(resetState: true);
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return SafeArea(
      child: Scaffold(
        appBar: TricycleAppBar().getCustomAppBarWithSearch(context,
            appBarTitle: AppLocalizations.of(context)!.translate('receivers'),
            onBackButtonPress: () {
              Navigator.pop(context);
            }, onSearchValueChanged: (text) {
              searchVal = text;
              refresh();
            }),
        body: Column(children: [
          Expanded(
            child: Paginator.listView(
                key: paginatorKey,
                padding: EdgeInsets.only(top: 16),
                scrollPhysics: BouncingScrollPhysics(),
                pageLoadFuture: getReceiverList,
                pageItemsGetter: listItemsGetter,
                listItemBuilder: listItemBuilder,
                loadingWidgetBuilder:
                CustomPaginator(context).loadingWidgetMaker,
                errorWidgetBuilder: CustomPaginator(context).errorWidgetMaker,
                emptyListWidgetBuilder:
                CustomPaginator(context).emptyListWidgetMaker,
                totalItemsGetter: CustomPaginator(context).totalPagesGetter,
                pageErrorChecker: CustomPaginator(context).pageErrorChecker),
          ),
          Align(


              alignment: Alignment.bottomCenter,
              child: Container(
                height: 60,
                color: HexColor(AppColors.appColorWhite),
                child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: TricycleProgressButton(
                        key: progressButtonKey,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(
                                color: HexColor(AppColors.appMainColor))),
                        onPressed: () async {
                          if (_selectedList.length > 0) {
                            if (widget.list != null && widget.list!.isNotEmpty)
                              for (int i = 0; i < widget.list!.length; i++) {
                                 createPost(getPayload(), widget.list![i]!,
                                    i == widget.list!.length - 1 ? true : false);
                              }
                            else
                              createPost(getPayload(), payload!, true);
                            // Navigator.pop(context, getPayload());
                          } else {
                            ToastBuilder().showToast(
                                AppLocalizations.of(context)!
                                    .translate('please_select_atleast'),
                                context,
                                HexColor(AppColors.information));
                          }
                        },
                        color: HexColor(AppColors.appColorWhite),
                        child: Text(
                            AppLocalizations.of(context)!.translate("post"),
                            style: styleElements
                                .buttonThemeScalable(context)
                                .copyWith(
                                color: HexColor(AppColors.appMainColor))),
                      ),
                    )),
              ))
        ]),
      ),
    );
  }

  Future<PostReceiverResponse> getReceiverList(int page) async {
    prefs ??= await SharedPreferences.getInstance();
    if (selectedReceiverData == null) {
      PostReceiverRequest payload = PostReceiverRequest();
      payload.pageSize = 10;
      payload.pageNumber = page;
      payload.institutionId = prefs!.getInt(Strings.instituteId);
      payload.type = "post";
      payload.searchVal = searchVal;
      payload.postType = widget.list != null && widget.list!.isNotEmpty
          ? widget.list![0]!.postType
          : this.payload!.postType;
      var data = jsonEncode(payload);
      var value = await Calls().call(data, context, Config.POST_RECEIVER_LIST);
      return PostReceiverResponse.fromJson(value);
    } else {
      PostReceiverResponse response = PostReceiverResponse();
      List<PostReceiverListItem?> list = [];
      list.add(selectedReceiverData);
      _selectedList.add(selectedReceiverData);
      response.rows = list;
      response.total = 1;
      response.statusCode = "S10001";
      response.message = 'SUCCESS';
      return response;
    }
  }

  List<PostReceiverListItem?>? listItemsGetter(PostReceiverResponse ?response) {
    response!.rows!.forEach((element) {
      if (_selectedList.any((selectedItem) {
        return selectedItem!.recipientTypeReferenceId ==
            element!.recipientTypeReferenceId &&
            selectedItem.recipientTypeCode == element.recipientTypeCode;
      })) {
        element!.isSelected = true;
      }
    });
    recList.addAll(response.rows!);
    // for (int i = 0; i < recList.length; i++) {
    //   for (int j = 0; j < _selectedList.length; j++) {
    //     if (recList[i].recipientTypeCode == _selectedList[j].recipientTypeCode) {
    //       recList[i].isSelected = true;
    //       break;
    //     }
    //   }
    // }
    return response.rows;
  }

  Widget listItemBuilder(value, int index) {
    PostReceiverListItem item = value;
    return Container(
      child: TricycleCard(
        padding: EdgeInsets.only(top: 8, bottom: 8),
        margin: EdgeInsets.only(top: 1, bottom: 1, left: 8, right: 8),
        child: TricycleUserListTile(
          imageUrl: (item.recipientImage != null)
              ? Config.BASE_URL + item.recipientImage!
              : 'assets/appimages/userplaceholder.jpg',
          isFullImageUrl: true,
          title: item.recipientType,
          subtitle1: item.recipientTypeDescription,
          trailingWidget: Checkbox(
              value: item.isSelected ??= false,
              onChanged: (value) {
                changeSelection(value, item, index);
              }),
        ),
      ),
    );
  }

  void changeSelection(bool? value, PostReceiverListItem item, int index) {
    if (item.isAllowed != null && item.isAllowed!) {
      if (item.recipientTypeCode!.toLowerCase() ==
          POST_RECIPIENT_TYPE.PRIVATE.type) {
        if (value!) {
          _selectedList.clear();
          _selectedList.add(item);
          isPrivateSelected = true;
        } else {
          _selectedList.remove(item);
          isPrivateSelected = false;
        }
        for (int i = 0; i < recList.length; i++) {
          recList[i]!.isSelected = false;
        }
        setState(() {
          recList[index]!.isSelected = value;
        });
      } else {
        if (value!) {
          if (isPrivateSelected) {
            _selectedList.clear();
            _selectedList.add(item);
          } else {
            _selectedList.add(item);
          }
        } else {
          _selectedList.remove(item);
        }
        if (isPrivateSelected) {
          for (int i = 0; i < recList.length; i++) {
            recList[i]!.isSelected = false;
          }
          isPrivateSelected = false;
        }
        setState(() {
          recList[index]!.isSelected = value;
        });
      }
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return TricycleDialog(
              message: item.allowedMsg,
            );
          });
    }
  }

  List<String?> getTypeCode() {
    List<String?> typeCode = [];
    for (int i = 0; i < _selectedList.length; i++) {
      typeCode.add(_selectedList[i]!.recipientTypeCode);
    }
    return typeCode;
  }

  PostCreatePayload getPayload() {
    postCreatePayload.postRecipientType = getTypeCode();
    postCreatePayload.postRecipientDetails = getDetails();
    return postCreatePayload;
  }

  List<PostRecipientDetailItem> getDetails() {
    List<PostRecipientDetailItem> detail = [];
    for (int i = 0; i < _selectedList.length; i++) {
      if (_selectedList[i]!.recipientTypeReferenceId != null) {
        if (_selectedList[i]!.recipientTypeCode ==
            POST_RECIPIENT_TYPE.CLASS.type ||
            _selectedList[i]!.recipientTypeCode ==
                POST_RECIPIENT_TYPE.STAFF.type ||
            _selectedList[i]!.recipientTypeCode ==
                POST_RECIPIENT_TYPE.COMMUNITY.type ||
            _selectedList[i]!.recipientTypeCode ==
                POST_RECIPIENT_TYPE.PARENT.type) {
          detail.add(PostRecipientDetailItem(
              type: POST_RECIPIENT_TYPE.ROOM.type,
              id: _selectedList[i]!.recipientTypeReferenceId));
        } else if (_selectedList[i]!.recipientTypeCode ==
            POST_RECIPIENT_TYPE.INSTITUTION.type) {
          postCreatePayload.postInstitutionId =
              _selectedList[i]!.recipientTypeReferenceId;
          detail.add(PostRecipientDetailItem(
              type: POST_RECIPIENT_TYPE.INSTITUTION.type,
              id: _selectedList[i]!.recipientTypeReferenceId));
        } else {
          detail.add(PostRecipientDetailItem(
              type: _selectedList[i]!.recipientTypeCode,
              id: _selectedList[i]!.recipientTypeReferenceId));
        }
      }
    }
    return detail;
  }

  void updatePost(PostCreatePayload postCreatePayload,
      PostCreatePayload payload, bool isFinalCall) async {
    progressButtonKey.currentState!.show();
    payload.postStatus="posted";
    payload.postRecipientType = postCreatePayload.postRecipientType;
    payload.postRecipientDetails = postCreatePayload.postRecipientDetails;
    var body = jsonEncode(payload);
    Calls().call(body, context, Config.UPDATE_POST).then((value) {
      progressButtonKey.currentState!.hide();
      var res = PostCreateResponse.fromJson(value);
      if (res.statusCode == Strings.success_code) {
        if (isFinalCall) {
          Navigator.pop(context, true);
          if (widget.callBack != null) widget.callBack!();
        }
      } else {
        ToastBuilder()
            .showToast(res.message!, context, HexColor(AppColors.information));
      }
    }).catchError((onError) {
      progressButtonKey.currentState!.hide();
      print(onError);
    });
  }

  void createPost(PostCreatePayload postCreatePayload,
      PostCreatePayload payload, bool isFinalCall) async {
    progressButtonKey.currentState!.show();

    payload.postRecipientType = postCreatePayload.postRecipientType;
    payload.postRecipientDetails = postCreatePayload.postRecipientDetails;
   if( payload.postType=="lesson"&& payload.id!=null)
     payload.postStatus="posted";
    var body = jsonEncode(payload);
    Calls().call(body, context,payload.postType=="lesson"&& payload.id!=null?Config.UPDATE_POST: Config.CREATE_POST).then((value) {
      progressButtonKey.currentState!.hide();
      var res = PostCreateResponse.fromJson(value);
      if (res.statusCode == Strings.success_code) {
        // ToastBuilder()
        //     .showToast("success", context, HexColor(AppColors.success));
        // if(payload.postType == 'news'){
        //   getScratchCardData(res.rows.id);
        // }else {

        if (isFinalCall ) {

          print("here--------------------");
          Navigator.pop(context, true);
          if (widget.callBack != null) widget.callBack!();
        }
        // }
      } else {
        ToastBuilder()
            .showToast(res.message!, context, HexColor(AppColors.information));
      }
    }).catchError((onError) {
      progressButtonKey.currentState!.hide();
      print(onError);
    });
  }

  void getScratchCardData(int id) async {
    progressButtonKey.currentState!.show();
    ScratchCardEntity scratchCardEntity = ScratchCardEntity();
    scratchCardEntity.allPersonsId = prefs!.getInt("userId");
    scratchCardEntity.scratchCardContextId = id;
    scratchCardEntity.scratchCardContext = "post";
    scratchCardEntity.scratchCardSubContext = "post";
    scratchCardEntity.scratchCardSubContextId = id;
    Calls()
        .call(jsonEncode(scratchCardEntity), context, Config.CARD_ALLOCATE)
        .then((value) async {
      progressButtonKey.currentState!.hide();
      if (value != null) {
        var data = ScratchCardResult.fromJson(value);
        if (data.statusCode == Strings.success_code) {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) => ScratchCardDialogue(
                prefs!.getInt("userId"),
                data.rows!.id,
                data.rows!.scratchCardValue,
                data.rows!.scratchCardRewardType,
                fromPage: 'post',
                callBack: () {
                  Navigator.pop(context, true);
                },
              ));
        }
      }
    }).catchError((onError) {
      progressButtonKey.currentState!.hide();
      ToastBuilder().showToast(
          onError.toString(), context, HexColor(AppColors.information));
    });
  }
}
