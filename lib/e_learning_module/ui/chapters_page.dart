import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/paginator.dart';
import 'package:oho_works_app/components/appProgressButton.dart';
import 'package:oho_works_app/e_learning_module/model/chapter_response.dart';
import 'package:oho_works_app/e_learning_module/model/create_chapter_response.dart';
import 'package:oho_works_app/e_learning_module/ui/lessons_page.dart';
import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/models/post/postcreate.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class CreateChapterPage extends StatefulWidget {
  final PostCreatePayload? createLessonData;

  const CreateChapterPage({Key? key, this.createLessonData}) : super(key: key);
  _CreateChapterPage createState() => _CreateChapterPage();
}

class _CreateChapterPage extends State<CreateChapterPage> {
late   BuildContext context;
  late TextStyleElements styleElements;
  String? searchVal;
  GlobalKey<appProgressButtonState> progressButtonKey = GlobalKey();
  GlobalKey<appProgressButtonState> progressButtonKeyNext = GlobalKey();
  GlobalKey<PaginatorState> paginatorKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  refresh() {
    paginatorKey.currentState!.changeState(resetState: true);
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    this.context = context;

    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: appAppBar().getCustomAppBar(
            context,
            appBarTitle: AppLocalizations.of(context)!.translate('chapters'),
            actions: [
              Padding(
                padding:
                    const EdgeInsets.only(top: 2.0, left: 16.0, right: 16.0),
                child: IconButton(
                  icon: Icon(Icons.add_box_outlined),
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        )),
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return CommentSheet(chapterCreateCallBack: () {
                            refresh();
                          });
                        });
                  },
                ),
              ),
            ],
            onBackButtonPress: () {
              Navigator.pop(context);
            },
          ),
          body: Stack(
            children: [
              Container(
                  child: Container(
                      margin: const EdgeInsets.only(
                          left: 16, right: 16, top: 20, bottom: 16),
                      child: Paginator.listView(
                          key: paginatorKey,
                          pageLoadFuture: fetchList,
                          pageItemsGetter:
                              CustomPaginator(context).listItemsGetter,
                          listItemBuilder: listItemBuilder,
                          loadingWidgetBuilder:
                              CustomPaginator(context).loadingWidgetMaker,
                          errorWidgetBuilder:
                              CustomPaginator(context).errorWidgetMaker,
                          emptyListWidgetBuilder:
                              CustomPaginator(context).emptyListWidgetMaker,
                          totalItemsGetter:
                              CustomPaginator(context).totalPagesGetter,
                          pageErrorChecker:
                              CustomPaginator(context).pageErrorChecker))),
            ],
          )),
    );
  }

  _CreateChapterPage();

  Widget listItemBuilder(value, int index) {
    ChapterItem item = value;
    return Visibility(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        child: appCard(
          child: ListTile(
            tileColor: HexColor(AppColors.listBg),
            title: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                item.chapterName ?? "",
                style: styleElements.subtitle1ThemeScalable(context),
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ),
        onTap: () async {
          widget.createLessonData!.chapterItem=item;
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CreateLessonsPage(createLessonData:widget.createLessonData,chapterId:item.id,chapterName: item.chapterName,),
              ));
        },
      ),
    );
  }

  Future<ChaptersResponse> fetchList(int page) async {
    var body = jsonEncode({
      "searchVal": searchVal,
      "page_number": page,
      "page_size": 10,
      "list_type": "all"
    });
    var res = await Calls().call(body, context, Config.CHAPTERS_LIST);
    var model = ChaptersResponse.fromJson(res);
    return model;
  }
}

class CommentSheet extends StatefulWidget {
  final Function? chapterCreateCallBack;

  const CommentSheet({Key? key, this.chapterCreateCallBack}) : super(key: key);

  @override
  _CommentSheet createState() => _CommentSheet();
}

class _CommentSheet extends State<CommentSheet> {
  SharedPreferences? prefs = locator<SharedPreferences>();
  final lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var styleElements = TextStyleElements(context);
    final name = TextField(
        controller: lastNameController,
        style: styleElements
            .subtitle1ThemeScalable(context)
            .copyWith(color: HexColor(AppColors.appColorBlack65)),
        keyboardType: TextInputType.name,
        textCapitalization: TextCapitalization.words,
        onChanged: (text) {
          if (text.length == 1 && text != text.toUpperCase()) {
            lastNameController.text = text.toUpperCase();
            lastNameController.selection = TextSelection.fromPosition(
                TextPosition(offset: lastNameController.text.length));
          }
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(8.0, 15.0, 20.0, 4.0),
          hintText: AppLocalizations.of(context)!.translate('give_chapter_name'),
          hintStyle: styleElements
              .bodyText2ThemeScalable(context)
              .copyWith(color: HexColor(AppColors.appColorBlack35)),
        ));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                AppLocalizations.of(context)!.translate(''),
                style: styleElements
                    .headline6ThemeScalable(context)
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(
                AppLocalizations.of(context)!.translate('name_chapter'),
                style: styleElements
                    .subtitle1ThemeScalable(context)
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0),
              child: InkWell(
                onTap: () {
                  if (lastNameController.text != null &&
                      lastNameController.text.isNotEmpty)
                    createChapter(lastNameController.text.toString());
                  else
                    ToastBuilder().showToast(
                        AppLocalizations.of(context)!
                            .translate("name_chapter_required"),
                        context,
                        HexColor(AppColors.information));
                },
                child: Text(
                  AppLocalizations.of(context)!.translate('next'),
                  style: styleElements
                      .subtitle2ThemeScalable(context)
                      .copyWith(color: HexColor(AppColors.appMainColor)),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 45.0, right: 45.0, top: 30),
          child: name,
        ),
        Padding(
          padding: const EdgeInsets.only(
              left: 45.0, right: 45.0, top: 20, bottom: 60),
          child: Text(
            AppLocalizations.of(context)!.translate('chapter_dec'),
            style: styleElements.bodyText1ThemeScalable(context),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).viewInsets.bottom,
        )
      ],
    );
  }

  void createChapter(String name) async {
    var body = jsonEncode({"chapter_name": name});
    var res = await Calls().call(body, context, Config.CREATE_CHAPTER);
    var model = CreateChaptersResponse.fromJson(res);
    if (model.statusCode == Strings.success_code) {
      Navigator.of(context).pop();
      widget.chapterCreateCallBack!();
    } else {
      ToastBuilder().showToast(
          AppLocalizations.of(context)!.translate("something_wrong"),
          context,
          HexColor(AppColors.information));
    }
  }
}
