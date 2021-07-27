import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/paginator.dart';
import 'package:oho_works_app/components/tricycle_buttons.dart';
import 'package:oho_works_app/components/tricycle_user_list_tile.dart';
import 'package:oho_works_app/components/tricycleavatar.dart';
import 'package:oho_works_app/enums/resolutionenums.dart';
import 'package:oho_works_app/enums/serviceTypeEnums.dart';
import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/models/Settings_module/admin_models.dart';
import 'package:oho_works_app/models/personal_profile.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'add_institute_admin_page.dart';

class InstituteAdminListPage extends StatefulWidget {
  @override
  InstituteAdminListPageState createState() => InstituteAdminListPageState();
}

class InstituteAdminListPageState extends State<InstituteAdminListPage> {
  late Permissions selectedInstituteId;
  Iterable<Permissions>? filteredList;
  SharedPreferences? prefs = locator<SharedPreferences>();
  TextEditingController searchController = TextEditingController();
  List<AdminListItem> adminsList = [];
  GlobalKey<PaginatorState> paginatorKey = GlobalKey();
  String? searchVal;
  late TextStyleElements styleElements;
  BuildContext? sctx;

  @override
  void initState() {
    var data =
    Persondata.fromJson(jsonDecode(prefs!.getString(Strings.basicData)!));
    filteredList = data.permissions!.where((element) {
      return element.roleCode == 'ADMIN';
    });
    selectedInstituteId = filteredList!.elementAt(0);
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      if(filteredList!.length>1) {
        showBottomSheet();
      }
    });
  }

  void showBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        builder: (BuildContext context) {
          return _BottomSheetInstitute(filteredList, selectedInstituteId.id,
                  (Permissions permission) {
                if (selectedInstituteId.id != permission.id) {
                  selectedInstituteId = permission;
                  paginatorKey.currentState!.changeState(resetState: true);
                  setState(() {
                    searchController.text = "";
                  });
                }
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    this.sctx = context;
    styleElements = TextStyleElements(context);
    return SafeArea(
      child: Scaffold(
        appBar: TricycleAppBar().getCustomAppBarWithSearch(context,
            appBarTitle:
            AppLocalizations.of(context)!.translate('entity_admins'),
            onBackButtonPress: () {
              Navigator.pop(context);
            },
            actions: [
              IconButton(
                icon: Icon(Icons.add,color: HexColor(AppColors.appColorBlack65),),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddInstituteAdminPage(
                            selectedInstituteId: selectedInstituteId.id),
                      ));
                },
              )
            ],
            onSearchValueChanged: (value) {
              searchVal = value;
              if (paginatorKey.currentState != null) {
                paginatorKey.currentState!.changeState(resetState: true);
              }
            },
            controller: searchController),
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: Visibility(
                  visible: filteredList!.length>1,
                  child: TricycleListCard(
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 4.0, left: 8,bottom: 8),
                              child: Text(AppLocalizations.of(context)!.translate('select_entity')),
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.all(0),
                              leading: TricycleAvatar(
                                key: UniqueKey(),
                                imageUrl: Config.BASE_URL +
                                    selectedInstituteId.profileImage!,
                                isFullUrl: true,
                                service_type: SERVICE_TYPE.INSTITUTION,
                                resolution_type: RESOLUTION_TYPE.R64,
                                size: 56,
                              ),
                              title: Text(
                                selectedInstituteId.name!,
                                style: styleElements.subtitle1ThemeScalable(context),
                              ),
                              trailing: TricycleTextButton(
                                onPressed: () {
                                  showBottomSheet();
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.translate('change'),
                                  style: styleElements
                                      .captionThemeScalable(context)
                                      .copyWith(
                                      color: HexColor(AppColors.appMainColor)),
                                ),
                                shape: RoundedRectangleBorder(),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            )
                          ])),
                ),
              )
            ];
          },
          body: TricycleListCard(
            child: Paginator<AdminListResponse>.listView(
              key: paginatorKey,
              pageLoadFuture: fetchData,
              pageItemsGetter: listItemsGetter,
              listItemBuilder: listItemBuilder,
              loadingWidgetBuilder: CustomPaginator(context).loadingWidgetMaker,
              errorWidgetBuilder: CustomPaginator(context).errorWidgetMaker,
              emptyListWidgetBuilder:
              CustomPaginator(context).emptyListWidgetMaker,
              totalItemsGetter: CustomPaginator(context).totalPagesGetter,
              pageErrorChecker: CustomPaginator(context).pageErrorChecker,
            ),
          ),
        ),
      ),
    );
  }

  List<AdminListItem>? listItemsGetter(AdminListResponse? pageData) {
    adminsList.addAll(pageData!.rows!);
    return pageData.rows;
  }

  Future<AdminListResponse> fetchData(int page) async {
    var body = jsonEncode({
      "institution_id": selectedInstituteId.id,
      "search_val": searchVal,
      "page_number": page,
      "page_size": 10
    });
    var response = await Calls().call(body, context, Config.ADMIN_LIST);
    return AdminListResponse.fromJson(response);
  }

  Widget listItemBuilder(itemData, int index) {
    AdminListItem item = itemData;
    return TricycleUserListTile(
      imageUrl: item.profileImage,
      title: item.personName,
      subtitle1: item.institutionName,
      trailingWidget: TricycleTextButton(
        onPressed: () {
          removeAdmin(item, index);
        },
        child: Text(
          AppLocalizations.of(context)!.translate('remove'),
          style: styleElements
              .captionThemeScalable(context)
              .copyWith(color: HexColor(AppColors.appMainColor)),
        ),
      ),
    );
  }

  void removeAdmin(AdminListItem item, int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AdminAddRemoveDialog(
            okCallback: () {
              var body = jsonEncode({"id": item.id});
              Calls().call(body, context, Config.ADMIN_REMOVE).then((value) {
                var response = RemoveAdminResponse.fromJson(value);
                if (response.statusCode == Strings.success_code) {
                  ToastBuilder()
                      .showToast(response.rows!, sctx, HexColor(AppColors.information));
                  paginatorKey.currentState!.changeState(resetState: true);
                }
              });
            },
            cancelCallback: () {},
            message: AppLocalizations.of(context)!.translate('remove_admin_message',arguments: {"name":item.personName}),
          );
        });
  }
}

class _BottomSheetInstitute extends StatelessWidget {
  final Iterable<Permissions>? filteredList;
  final Function(Permissions permission) onClickCallback;
  final int? selectedId;

  _BottomSheetInstitute(
      this.filteredList, this.selectedId, this.onClickCallback);

  @override
  Widget build(BuildContext context) {
    var styleElements = TextStyleElements(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12.0, left: 8, bottom: 12),
          child: Text(
            AppLocalizations.of(context)!.translate('select_entity'),
            style: styleElements.headline6ThemeScalable(context),
          ),
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: filteredList!.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                    onTap: () {
                      onClickCallback(filteredList!.elementAt(index));
                      Navigator.pop(context);
                    },
                    child: TricycleUserListTile(
                        imageUrl: Config.BASE_URL +
                            filteredList!.elementAt(index).profileImage!,
                        isPerson: false,
                        isFullImageUrl: true,
                        title: filteredList!.elementAt(index).name,
                        trailingWidget: Visibility(
                            visible:
                            selectedId == filteredList!.elementAt(index).id,
                            child: Icon(
                              Icons.check_circle_rounded,
                              color: HexColor(AppColors.appColorGreen),
                            ))));
              },
            ),
          ),
        ),
        SizedBox(
          height: 16,
        ),
      ],
    );
  }
}

class AdminAddRemoveDialog extends StatelessWidget {
  final String? message;
  final Function? okCallback;
  final Function? cancelCallback;

  AdminAddRemoveDialog({this.message, this.okCallback, this.cancelCallback});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.only(top: 16.0, bottom: 16, left: 16, right: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message!,
              style: TextStyleElements(context).subtitle1ThemeScalable(context),
            ),
            Row(
              children: [
                Spacer(),
                TricycleTextButton(
                  onPressed:(){
                    Navigator.pop(context);
                    cancelCallback!();
                  },
                  child: Text(
                    AppLocalizations.of(context)!.translate('cancel'),
                    style: TextStyleElements(context)
                        .captionThemeScalable(context)
                        .copyWith(color: HexColor(AppColors.appMainColor)),
                  ),
                ),
                SizedBox(width: 8,),
                TricycleTextButton(
                  onPressed: (){
                    Navigator.pop(context);
                    okCallback!();
                    },
                  child: Text(
                    AppLocalizations.of(context)!.translate('ok'),
                    style: TextStyleElements(context)
                        .captionThemeScalable(context)
                        .copyWith(color: HexColor(AppColors.appMainColor)),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
