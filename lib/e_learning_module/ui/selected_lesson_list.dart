import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/ui/LearningModule/lessons_list_page.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:flutter/material.dart';

class SelectedLessonList extends StatefulWidget{
  final bool isBookmark;
  final bool isOwnPost;
  final bool isDrafted;
  final Function callBack;
  SelectedLessonList({this.isBookmark= false,this.isOwnPost= false,this.isDrafted=false,this.callBack});
  @override
  _SelectedLessonList createState() => _SelectedLessonList();
}
class _SelectedLessonList extends State<SelectedLessonList>{
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: TricycleAppBar().getCustomAppBar(
            context,
            appBarTitle: widget.isBookmark
                ?AppLocalizations.of(context).translate('bookmarked_lessons'):
            widget.isDrafted?AppLocalizations.of(context).translate('drafted')
            :AppLocalizations.of(context).translate('lessons_by_me'),
            onBackButtonPress: (){
              Navigator.pop(context);
            }),
        body: LessonsListPage(
          headerVisible: false,
          callBack:(){
            Navigator.pop(context);
            widget.callBack();
          },
          isOwnPost: widget.isOwnPost,
          isBookmark: widget.isBookmark,
          isDrafted:  widget.isDrafted,
        ),
      ),
    );
  }

}