import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:flutter/material.dart';

class EdufluencerSpecialistSubjectCard extends StatefulWidget{
  @override
  EdufluencerSpecialistSubjectCardState createState() => EdufluencerSpecialistSubjectCardState();
}

class EdufluencerSpecialistSubjectCardState extends State<EdufluencerSpecialistSubjectCard>{
  TextStyleElements styleElements;
  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return TricycleListCard(
      padding: EdgeInsets.only(top: 16,bottom: 16,left: 24,right: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(AppLocalizations.of(context).translate('specialist_in'),
          style: styleElements.headline6ThemeScalable(context).copyWith(
            fontWeight: FontWeight.bold
          ),),

          Container(
            height: 70,
            child: Center(
              child: ListView.builder(
                itemCount: 5,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return Chip(
                    label: Text("Index $index"),
                    padding: EdgeInsets.all(8),
                  );
                },),
            ),
          )
        ],
      ),
    );
  }

}