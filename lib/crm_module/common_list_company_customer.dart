import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/appProgressButton.dart';
import 'package:oho_works_app/components/app_user_list_tile.dart';
import 'package:oho_works_app/components/searchBox.dart';
import 'package:oho_works_app/enums/postRecipientType.dart';
import 'package:oho_works_app/models/post/postcreate.dart';
import 'package:oho_works_app/models/post/postreceiver.dart';
import 'package:oho_works_app/ui/dialogs/appAlertDialog.dart';
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

import 'createCompanyPage.dart';
import 'create_customer_contact.dart';



class CommonCompanyCustomerPage extends StatefulWidget {

 String? type;
 String? from;
  CommonCompanyCustomerPage(
      this.type,
      this.from
      );

  @override
  _CommonCompanyCustomerPage createState() => _CommonCompanyCustomerPage(
      );
}

class _CommonCompanyCustomerPage extends State<CommonCompanyCustomerPage> {
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
  GlobalKey<appProgressButtonState> progressButtonKey = GlobalKey();
  _CommonCompanyCustomerPage({this.payload, this.selectedReceiverData});

  refresh() {
    recList.clear();
    paginatorKey.currentState!.changeState(resetState: true);
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return SafeArea(
      child: Scaffold(

        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: Row(
                  children: [
                    Expanded(
                      child: SearchBox(
                        onvalueChanged: (s){},
                        hintText: AppLocalizations.of(context)!.translate('search'),
                      ),
                    ),
                    InkWell(
                      onTap: (){

                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: InkWell(
                          onTap: (){

                            widget.type=="S"?
                            Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return CreateCompanyPage(
                                    type: 'talk',
                                    standardEventId: 5,
                                    title: "",
                                  );
                                })):Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return CreateContactPage(
                                    type: 'talk',

                                    title: "",
                                  );
                                }));
                          },
                          child: Row(
                            children: [

                              Icon(
                                Icons.add,
                                color: HexColor(AppColors.appColorBlack65),
                              ),
                              Text(
                                AppLocalizations.of(context)!.translate('new'),
                                textAlign: TextAlign.center,
                                style: styleElements
                                    .subtitle1ThemeScalable(context)
                                    .copyWith(
                                    color: HexColor(AppColors.appColorBlack65)),
                              ),

                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            ];
          },
          body: appCard(
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
        ),
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
      payload.postType = "feed";
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
      child:  appUserListTile(
        imageUrl: (item.recipientImage != null)
            ? Config.BASE_URL + item.recipientImage!
            : 'assets/appimages/userplaceholder.jpg',
        isFullImageUrl: true,
        title: item.recipientType,
        subtitle1: item.recipientTypeDescription,
        trailingWidget:widget.from!=null && widget.from=="home"?
        _simplePopup():

        Checkbox(
            value: item.isSelected ??= false,
            onChanged: (value) {
              changeSelection(value, item, index);
            }),
      )
    );
  }  List<PopupMenuEntry<String>> getItems(String? name) {
    List<PopupMenuEntry<String>> popupmenuList = [];


    popupmenuList.add(
      PopupMenuItem(
        value: 'delete',
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left:8.0,right: 16),
              child: Icon(Icons.edit_outlined,color: HexColor(AppColors.appColorBlack35),),
            ),
            Text(name=="P"?
           AppLocalizations.of(context)!.translate("Edit_Payment")
            : AppLocalizations.of(context)!.translate("edit")



            ),
          ],
        ),
      ),
    );


    popupmenuList.add(
      PopupMenuItem(
        value: 'delete',
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left:8.0,right: 16),
              child: Icon(Icons.shopping_bag_outlined,color: HexColor(AppColors.appColorBlack35),),
            ),
            Text(
              AppLocalizations.of(context)!.translate("Create_opportunity")

              ,
            ),
          ],
        ),
      ),
    );


    popupmenuList.add(
      PopupMenuItem(
        value: 'delete',
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left:8.0,right: 16),
              child: Icon(Icons.shopping_cart_outlined,color: HexColor(AppColors.appColorBlack35),),
            ),
            Text(
              AppLocalizations.of(context)!.translate("Create_Sales_Order")
            ),
          ],
        ),
      ),
    );

    popupmenuList.add(
      PopupMenuItem(
        value: 'delete',
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left:8.0,right: 16),
              child: Icon(Icons.receipt,color: HexColor(AppColors.appColorBlack35),),
            ),
            Text(

              AppLocalizations.of(context)!.translate("Create_invoice")
            ),
          ],
        ),
      ),
    );


    popupmenuList.add(
      PopupMenuItem(
        value: 'delete',
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left:8.0,right: 16),
              child: Icon(Icons.shopping_cart_outlined,color: HexColor(AppColors.appColorBlack35),),
            ),
            Text(
              AppLocalizations.of(context)!.translate("Create_purchase_order")

              ,
            ),
          ],
        ),
      ),
    );



    popupmenuList.add(
      PopupMenuItem(
        value: 'delete',
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left:8.0,right: 16),
              child: Icon(Icons.mail_outline,color: HexColor(AppColors.appColorBlack35),),
            ),
            Text(   AppLocalizations.of(context)!.translate("_email")
            ),
          ],
        ),
      ),
    );

    popupmenuList.add(
      PopupMenuItem(
        value: 'delete',
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left:8.0,right: 16),
              child: Icon(Icons.call_outlined,color: HexColor(AppColors.appColorBlack35),),
            ),
            Text(AppLocalizations.of(context)!.translate("call")
            ),
          ],
        ),
      ),
    );


    popupmenuList.add(
      PopupMenuItem(
        value: 'delete',
        child: Row(
          children: [
            Padding(
                padding: const EdgeInsets.only(left:8.0,right: 16),
                child: SizedBox(
                    height: 20,width: 20,
                    child: Image(image: AssetImage('assets/appimages/whatsapp.png'),))
            ),
            Text(AppLocalizations.of(context)!.translate("whatsapp")
            ),
          ],
        ),
      ),
    );
    return popupmenuList;
  }
  Widget _simplePopup() {
    // var name = headerData.title;
    return PopupMenuButton<String>(
      padding: EdgeInsets.only(right: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      itemBuilder: (context) => getItems(widget.type),
      onSelected: (value) {
        switch (value) {
          case 'delete':
            {



              break;
            }
          case 'edit':
            {

              break;
            }
          case 'hide':
            {

              break;
            }
          case 'unfollow':
            {

              break;
            }
          case 'block':
            {

              break;
            }
          case 'topic':{

            break;
          }
          case 'report':
            {

              break;
            }
        }
      },
      icon: Icon(
        Icons.more_vert,
        color:  HexColor(AppColors.appColorBlack65),
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
            return appDialog(
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


}
