import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/material.dart';

class WordCounterChecker extends StatefulWidget{
  final int currentWordCount;
  final int wordLimit;
  WordCounterChecker({Key key,this.currentWordCount,@required this.wordLimit}):super(key: key);
  @override
  WordCounterCheckerState createState() => WordCounterCheckerState(currentWordCount: currentWordCount,wordLimit: wordLimit);
}
class WordCounterCheckerState extends State<WordCounterChecker>{
  int currentWordCount=0;
  final int wordLimit;
  bool isWordLimitReached= false;
  WordCounterCheckerState({this.currentWordCount,this.wordLimit});
  @override
  Widget build(BuildContext context) {
    var styleElements = TextStyleElements(context);
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children:[
          Visibility(
            visible: isWordLimitReached,
              child: Text(AppLocalizations.of(context).translate('max_word_limit_reached'),style: styleElements.captionThemeScalable(context).copyWith(color: HexColor(AppColors.appMainColor)),)),
          Spacer(),
          Text("$currentWordCount/$wordLimit",style: styleElements.captionThemeScalable(context),),
        ]
      ),
    );
  }

  void updateWidget(int wordCount){
    setState(() {
      currentWordCount = wordCount;
      isWordLimitReached = currentWordCount>wordLimit;
    });
  }

}