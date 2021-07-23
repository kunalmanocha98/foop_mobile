import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/material.dart';

class PostTagComponent extends StatelessWidget{
  final String? type;
  PostTagComponent({required this.type});

  @override
  Widget build(BuildContext context) {
    var styleElements = TextStyleElements(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(8),bottomLeft: Radius.circular(8)),
        color: getColor()
      ),
      child: Padding(
        padding:  EdgeInsets.only(top:8.0,left: 8,right: 16,bottom: 8),
        child: Text(getTagTitle(),
        style: styleElements.captionThemeScalable(context).copyWith(
          color: HexColor(AppColors.appColorWhite)
        ),),
      ),
    );
  }

  Color getColor() {
    switch(type){
      case 'general':{
        return HexColor(AppColors.PostsColor);
      }
      case 'notice':{
        return HexColor(AppColors.NoticeColor);
      }
      case 'blog':{
        return HexColor(AppColors.ArticlesColor);
      }
      case 'qa':{
        return HexColor(AppColors.QAColor);
      }
      case 'poll':{
        return HexColor(AppColors.PollsColor);
      }
      case 'news':{
        return HexColor(AppColors.CampusNewsColor);
      }
      case 'assignment':{
        return HexColor(AppColors.AssignmentColor);
      }
      case 'lesson':{
        return HexColor(AppColors.LessonColor);
      }
      default:{
        return HexColor(AppColors.PostsColor);
      }
    }
  }

  String getTagTitle() {
    switch(type){
      case 'general':{
        return 'General';
      }
      case 'notice':{
          return 'Notice';
        }
      case 'blog':{
        return 'Article';
      }
      case 'qa':{
        return 'Q&A';
      }
      case 'poll':{
        return 'Poll';
      }
      case 'news':{
        return 'Campus News';
      }
      case 'assignment':{
        return 'Assignment';
      }
      case 'lesson':{
        return 'Lesson';
      }
      default:{
        return 'General';
      }
    }
  }

}