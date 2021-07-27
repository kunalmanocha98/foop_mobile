

import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/appProgressButton.dart';
import 'package:oho_works_app/e_learning_module/model/learner_list_response.dart';
import 'package:oho_works_app/e_learning_module/ui/topic_type_page.dart';
import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/models/e_learning/topic_list.dart';
import 'package:oho_works_app/models/post/postcreate.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'learner_category_page.dart';


// ignore: must_be_immutable
class CreateTopicPage extends StatefulWidget {
  final PostCreatePayload? createLessonData;

  const CreateTopicPage({Key? key, this.createLessonData}) : super(key: key);
  _CreateTopicPage createState() => _CreateTopicPage();


}

class _CreateTopicPage extends State<CreateTopicPage> {
  late BuildContext context;
  late TextStyleElements styleElements;
  GlobalKey<appProgressButtonState> progressButtonKey = GlobalKey();
  GlobalKey<appProgressButtonState> progressButtonKeyNext = GlobalKey();
  TopicListItem? topicType;
  List<LearnerListItem>? learnerItem;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!
        .addPostFrameCallback((_) =>   showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            )),
        isScrollControlled: true,
        builder: (BuildContext context) {
          return CommentSheet(nameCallBack: (name){

            widget.createLessonData!.lessonTopic!.title=name;
            setState(() {

            });
          },);
        }));


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
            appBarTitle:
            AppLocalizations.of(context)!.translate('topic_detail'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(top:16.0,left: 16.0,right: 16.0),
                child: InkWell(
                  onTap: (){
                    if(widget.createLessonData!.lessonTopic!.title!=null)
                      {
                          if(widget.createLessonData!.lessonTopic!.title!=null)
                     {
                       if(widget.createLessonData!.learnerItem!=null)


                       { Navigator.pop(context, widget.createLessonData);}
                       else
                       {
                         ToastBuilder().showToast(
                             AppLocalizations.of(context)!
                                 .translate("topic_group"),
                             context,
                             HexColor(AppColors.information));
                       }

                     }
                          else
                            {
                              ToastBuilder().showToast(
                                  AppLocalizations.of(context)!
                                      .translate("topic_type_required"),
                                  context,
                                  HexColor(AppColors.information));
                            }
                      }
                    else
                      {
                        ToastBuilder().showToast(
                            AppLocalizations.of(context)!
                                .translate("topic_name_required"),
                            context,
                            HexColor(AppColors.information));
                      }
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
            onBackButtonPress: () {
              Navigator.pop(context, widget.createLessonData);
            },
          ),
          body: Stack(

            children: [Container(
                child: Container(
                    margin: const EdgeInsets.only(
                        left: 16, right: 16,top: 20, bottom: 16),
                    child: ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left :16.0,bottom: 8.0),
                          child: Text(
                              widget.createLessonData!=null&&   widget.createLessonData!.lessonTopic!.title!=null?widget.createLessonData!.lessonTopic!.title!:
                            AppLocalizations.of(context)!.translate('topic_name'),
                            style: styleElements
                                .headline6ThemeScalable(context)
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Visibility(
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            child: appCard(

                              child: ListTile(
                                  tileColor: HexColor(AppColors.listBg),
                                  title: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .translate("topic_type"),
                                      style: styleElements
                                          .subtitle1ThemeScalable(context),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  subtitle: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text((topicType!=null)? topicType!.topicName!:
                                      AppLocalizations.of(context)!
                                          .translate("select_topic_type"),
                                      style: styleElements
                                          .bodyText2ThemeScalable(context),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  trailing: Visibility(
                                    visible: topicType!=null,
                                    child: Icon(
                                      Icons.check_circle,
                                      color: HexColor(AppColors.appColorGreen),
                                      size: 20,
                                    ),
                                  )),
                            ),
                            onTap: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TopicTypePage(
                                      selectedItem: topicType,
                                    ),
                                  )).then((value){
                                    if(value!=null){
                                      setState(() {
                                        topicType = value;
                                        if(topicType!=null && topicType!.topicCode!=value.topicCode)
                                          {learnerItem!.clear();}

                                        widget.createLessonData!.lessonTopic!.topic=value;

                                        setState(() {

                                        });
                                      });
                                    }
                              });
                            },
                          ),
                        ),
                        Opacity(
                          opacity:topicType!=null ?1.0:0.25,
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            child: appCard(

                              child: ListTile(
                                  tileColor: HexColor(AppColors.listBg),
                                  title: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      topicType!=null && topicType!.topicCode=="academic"?
                                      AppLocalizations.of(context)!
                                          .translate("learners_department_group"):
                                      AppLocalizations.of(context)!
                                          .translate("learners_department_group_age"),
                                      style: styleElements
                                          .subtitle1ThemeScalable(context),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  subtitle: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      topicType!=null && topicType!.topicCode=="academic"?
                                      AppLocalizations.of(context)!
                                          .translate("l_department_group"):
                                      AppLocalizations.of(context)!
                                          .translate("l_department_group_age"),
                                      style: styleElements
                                          .bodyText2ThemeScalable(context),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  trailing: Visibility(
                                    visible: learnerItem!=null && learnerItem!.isNotEmpty,
                                    child: Icon(
                                      Icons.check_circle,
                                      color: HexColor(AppColors.appColorGreen),
                                      size: 20,
                                    ),
                                  )),
                            ),
                            onTap: () async {

                              if(topicType!=null)
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LearnerCategoryPage(
                                      topicListItem: topicType,
                                    ),
                                  )).then((value){
                                if(value!=null){
                                  setState(() {
                                    widget.createLessonData!.learnerItem=value;
                                    learnerItem = value;
                                  });
                                }
                              });

                            },
                          ),
                        ),


                      ],
                    ))),

          ],

          )),
    );
  }


  _CreateTopicPage();
}

class CommentSheet extends StatefulWidget {

final Function(String name)? nameCallBack;

  const CommentSheet({Key? key, this.nameCallBack}) : super(key: key);

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
        style: styleElements.subtitle1ThemeScalable(context).copyWith(
            color: HexColor(AppColors.appColorBlack65)
        ),

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
          hintText: AppLocalizations.of(context)!.translate('give_topic_name'),
          hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color: HexColor(AppColors.appColorBlack35)),
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
              padding: const EdgeInsets.only(top:20.0),
              child: Text(
                AppLocalizations.of(context)!.translate('topic_name'),
                style: styleElements
                    .subtitle1ThemeScalable(context)
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:20.0,left: 16.0,right: 16.0),
              child: InkWell(
                onTap: (){
                  if(lastNameController.text!=null && lastNameController.text.isNotEmpty)
              {
                Navigator.of(context).pop();
                widget.nameCallBack!(lastNameController.text);}
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
          padding: const EdgeInsets.only(left:45.0,right: 45.0,top: 30),
          child: name,
        ),
        Padding(
          padding: const EdgeInsets.only(left:45.0,right: 45.0,top: 20,bottom: 100),
          child: Text(
            AppLocalizations.of(context)!.translate('topic_detail_dec'),
            style: styleElements
                .bodyText1ThemeScalable(context)
               ,
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).viewInsets.bottom,
        )
      ],
    );
  }


}