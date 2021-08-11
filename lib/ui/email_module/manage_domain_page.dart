import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/app_buttons.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/paginator.dart';
import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/mixins/someCommonMixins.dart';
import 'package:oho_works_app/models/email_module/domain_create.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'create_email_page.dart';
import 'domain_list_card.dart';

class ManageDomainPage extends StatefulWidget {
  @override
  _ManageDomainPage createState() => _ManageDomainPage();
}

class _ManageDomainPage extends State<ManageDomainPage> {
  TextStyleElements? styleElements;
  SharedPreferences prefs = locator<SharedPreferences>();
  GlobalKey<PaginatorState> paginatorKey = GlobalKey();
  bool hasDomain = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      fetchDetails();
    });
  }

  void fetchDetails() async {
    DomainCreateRequest payload = DomainCreateRequest();
    payload.ownerType = prefs.getString(Strings.ownerType)!;
    payload.ownerId = prefs.getInt(Strings.userId)!;
    var value = await Calls().call(
        jsonEncode(payload), context, Config.EMAIL_DOMAIN_LIST,
        isMailToken: true);
    var res = DomainListResponse.fromJson(value);
    if (res.rows!.length > 0) {
      setState(() {
        hasDomain = true;
      });
    } else {
      setState(() {
        hasDomain = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return SafeArea(
      child: Scaffold(
        appBar: appAppBar().getCustomAppBar(context,
            appBarTitle: AppLocalizations.of(context)!
                .translate('manage_domain'), onBackButtonPress: () {
              Navigator.pop(context);
            }, actions: [
              Visibility(
                visible: !hasDomain,
                child: appTextButton(
                  onPressed: () {
                    showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(12),
                              topLeft: Radius.circular(12))),
                      context: context,
                      builder: (BuildContext context) {
                        return AddDomainPageSheet();
                      },
                    ).then((value) {
                      if (value != null && value) {
                        refresh();
                      }
                    });
                  },
                  shape: StadiumBorder(),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(
                      Icons.add,
                      color: HexColor(AppColors.appMainColor),
                    ),
                    Text(
                      "Create",
                      style: styleElements!
                          .subtitle1ThemeScalable(context)
                          .copyWith(color: HexColor(AppColors.appMainColor)),
                    )
                  ]),
                ),
              )
            ]),
        body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverToBoxAdapter(
                  child: appListCard(
                    padding: EdgeInsets.only(
                        top: 12, left: 12, right: 12, bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Update your DNS records",
                          style: styleElements!
                              .subtitle1ThemeScalable(context)
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          "To verify your domain and set up email with us, you need To update your domain’s DNS records. The DNS records are hosted by your domain registrar (Your purchased your domain).",
                          style: styleElements!.subtitle1ThemeScalable(context),
                        ),
                        Row(
                          children: [
                            Spacer(),
                            appTextButton(
                              onPressed: () {},
                              shape: StadiumBorder(),
                              child: Text(
                                "Click for details",
                                style: styleElements!
                                    .captionThemeScalable(context)
                                    .copyWith(
                                    color:
                                    HexColor(AppColors.appMainColor)),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ];
            },
            body: Paginator<DomainListResponse>.listView(
              key: paginatorKey,
              pageLoadFuture: fetchList,
              pageItemsGetter: CustomPaginator(context).listItemsGetter,
              listItemBuilder: listItemBuilder,
              loadingWidgetBuilder: CustomPaginator(context).loadingWidgetMaker,
              errorWidgetBuilder: CustomPaginator(context).errorWidgetMaker,
              emptyListWidgetBuilder:
              CustomPaginator(context).emptyListWidgetMaker,
              totalItemsGetter: CustomPaginator(context).totalPagesGetter,
              pageErrorChecker: CustomPaginator(context).pageErrorChecker,
            )),
      ),
    );
  }

  Widget listItemBuilder(itemData, int index) {
    DomainListItem item = itemData;
    return DomainListCard(
      buyEmailCallback: () {},
      removeCallback: removeCallback,
      createEmailCallback: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
              return CreateEmailPage();
            }));
      },
      cardData: item,
    );
  }

  Future<DomainListResponse> fetchList(int page) async {
    DomainCreateRequest payload = DomainCreateRequest();
    payload.ownerType = prefs.getString(Strings.ownerType)!;
    payload.ownerId = prefs.getInt(Strings.userId)!;
    var value = await Calls().call(
        jsonEncode(payload), context, Config.EMAIL_DOMAIN_LIST,
        isMailToken: true);
    return DomainListResponse.fromJson(value);
  }

  void refresh() {
    paginatorKey.currentState!.changeState(resetState: true);
  }

  removeCallback() {
    showDialog(context: context,
      builder: (BuildContext context) {
      return RemoveDomainDialog(
        okCallback: (){

        },
      );
      },);
  }
}

class RemoveDomainDialog extends StatelessWidget {
  final Function? okCallback;
  RemoveDomainDialog({this.okCallback});
  @override
  Widget build(BuildContext context) {
    var styleElements = TextStyleElements(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
            children: [
          Text(
            AppLocalizations.of(context)!
                .translate('are_you_sure_remove_domain'),
            style: styleElements.subtitle1ThemeScalable(context),
          ),
          Row(
            children: [
              Spacer(),
              appTextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                shape: StadiumBorder(),
                child: Text(
                  AppLocalizations.of(context)!.translate('cancel').toUpperCase(),
                  style: styleElements
                      .captionThemeScalable(context)
                      .copyWith(color: HexColor(AppColors.appMainColor)),
                ),
              ),
              appTextButton(
                onPressed: (){
                  Navigator.pop(context);
                  okCallback!();
                },
                shape: StadiumBorder(),
                child: Text(
                  AppLocalizations.of(context)!.translate('ok').toUpperCase(),
                  style: styleElements
                      .captionThemeScalable(context)
                      .copyWith(color: HexColor(AppColors.appMainColor)),
                ),
              )
            ],
          )
        ]),
      ),
    );
  }
}

class AddDomainPageSheet extends StatefulWidget {
  @override
  _AddDomainPageSheet createState() => _AddDomainPageSheet();
}

class _AddDomainPageSheet extends State<AddDomainPageSheet> with CommonMixins {
  TextStyleElements? styleElements;
  SharedPreferences prefs = locator<SharedPreferences>();
  String? domain;
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);

    return Form(
      key: formKey,
      child: Container(
        padding: EdgeInsets.only(top: 16, bottom: 8, left: 8, right: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      "Add domain",
                      style: styleElements!.headline6ThemeScalable(context),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: appTextButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        createDomainPage();
                      }
                    },
                    shape: StadiumBorder(),
                    child: Text(
                      AppLocalizations.of(context)!.translate('create'),
                      style: styleElements!
                          .bodyText2ThemeScalable(context)
                          .copyWith(color: HexColor(AppColors.appMainColor)),
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: HexColor(AppColors.appColorBackground),
                ),
                child: TextFormField(
                  validator: validateWebLink,
                  onSaved: (value) {
                    domain = value;
                  },
                  decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!
                          .translate('enter_domain_page'),
                      contentPadding:
                      EdgeInsets.only(left: 12, top: 16, bottom: 8),
                      border: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      labelText: "Example: example.com, mail.example.com"),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).viewInsets.bottom > 0
                  ? MediaQuery.of(context).viewInsets.bottom
                  : 200,
            )
          ],
        ),
      ),
    );
  }

  void createDomainPage() async {
    DomainCreateRequest payload = DomainCreateRequest();
    payload.domainName = domain!;
    payload.ownerId = prefs.getInt(Strings.userId)!;
    payload.ownerType = prefs.getString(Strings.ownerType)!;
    Calls()
        .call(jsonEncode(payload), context, Config.EMAIL_DOMAIN_CREATE,
        isMailToken: true)
        .then((value) {
      var res = DomainCreateResponse.fromJson(value);
      if (res.statusCode == Strings.success_code) {
        Navigator.pop(context, true);
      } else {
        Navigator.pop(context, false);
        ToastBuilder()
            .showToast(res.message!, context, HexColor(AppColors.information));
      }
    });
  }
}
