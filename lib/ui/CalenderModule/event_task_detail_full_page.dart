import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/tricycle_buttons.dart';
import 'package:oho_works_app/enums/resolutionenums.dart';
import 'package:oho_works_app/enums/serviceTypeEnums.dart';
import 'package:oho_works_app/models/review_rating_comment/noteslistmodel.dart';
import 'package:oho_works_app/ui/CalenderModule/task_completion_dialog.dart';
import 'package:oho_works_app/ui/commentItem.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/utility_class.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class EventTaskFullDetailPage extends StatefulWidget {
  final String type;
  EventTaskFullDetailPage({this.type});
  @override
  EventTaskFullDetailPageState createState() => EventTaskFullDetailPageState();
}

class EventTaskFullDetailPageState extends State<EventTaskFullDetailPage> {
TextStyleElements styleElements;


  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    final titleProgressWidget = TricycleListCard(
      padding: EdgeInsets.only(left: 12,right: 16,top: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Want to finish learning Hindi',style: styleElements.subtitle1ThemeScalable(context),),
            Text('Target date: 20 Sep 2020',style: styleElements.bodyText2ThemeScalable(context),),
            Padding(
              padding: EdgeInsets.only(top: 16,bottom: 16),
              child: LinearPercentIndicator(
                linearStrokeCap: LinearStrokeCap.roundAll,
                animation: true,
                animationDuration: 500,
                lineHeight: 6,
                percent: 0.5,
                backgroundColor: HexColor(AppColors.pollBackground),
                progressColor: HexColor(AppColors.appMainColor).withOpacity(0.75),
              ),
            ),
          ],
        )
    );
    final attachmentsWidget = TricycleListCard(
      padding: EdgeInsets.only(left: 12,right: 16,top: 12,bottom: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Attachments',style: styleElements.headline6ThemeScalable(context).copyWith(
            fontWeight: FontWeight.bold
          ),),
          SizedBox(
            height: 60,
            child: ListView.builder(
              padding: EdgeInsets.all(4),
              itemCount: 2,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
              return Container(height: 60,width: 60,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(
                      Utility().getUrlForImage('', RESOLUTION_TYPE.R128, SERVICE_TYPE.CLASS)
                    )
                  ),
                borderRadius: BorderRadius.circular(12)
              ),);
            },),
          )
        ],
      ),
    );

    final checkPointsWidget = TricycleListCard(
        padding: EdgeInsets.only(left: 12,right: 16,top: 12,bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Checkpoints',style: styleElements.headline6ThemeScalable(context).copyWith(
              fontWeight: FontWeight.bold
            ),),
            ListView.builder(
              itemCount: 3,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return CheckboxListTile(
                  contentPadding: EdgeInsets.all(0),
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (bool value) {  },
                  value: false,
                  tristate: true,
                  title: Text('hello hello hello'),

                );
              },
            ),
            Row(
              children: [
                Spacer(),
                TricycleTextButton(onPressed: (){

                }, child: Text('cancel',style: styleElements.captionThemeScalable(context).copyWith(
                      color: HexColor(AppColors.appMainColor)
                    ),)),
                SizedBox(width: 16,),
                TricycleTextButton(onPressed: (){
                  showDialog(
                      context: context,
                      useSafeArea: true,
                      builder: (context) => TaskCompletionDialog());
                },
                    shape: StadiumBorder(),
                    color:  HexColor(AppColors.appMainColor),
                    child: Text('finish',style: styleElements.captionThemeScalable(context).copyWith(
                    color: HexColor(AppColors.appColorWhite)
                ),))
              ],
            )
          ],
        )
    );

    final progressJournalWidget =  TricycleListCard(
        padding: EdgeInsets.only(left: 12,right: 16,top: 12,bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Progress journal',style: styleElements.headline6ThemeScalable(context).copyWith(
              fontWeight: FontWeight.bold
            ),),
            ListView.builder(
              itemCount: 3,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return CommentItemCard(
                  isAnswer: false,
                  key: UniqueKey(),
                  data: NotesListItem(
                      noteContent: 'My objectives are This is about me, I’m the best candidate of the Asdasd asdasasdasd asdas. Asdas. Asdas asd Asdasda asdas Asda aasde. Aard..',
                      notesCreatedByName: "Kunal Manocha",
                      createdDate: DateTime.now().toString(),
                      notesCreatedByProfile: '',
                      noteCreatedById: 1002.toString(),
                      noteCreatedByType: 'person'
                  ),
                );
              },
            ),
          ],
        )
    );
    return SafeArea(
      child: Scaffold(
        appBar: TricycleAppBar().getCustomAppBar(context,
            appBarTitle: getTitle(), onBackButtonPress: () {
              Navigator.pop(context);
            }),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 56),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: titleProgressWidget,),
                  SliverToBoxAdapter(child: attachmentsWidget,),
                  SliverToBoxAdapter(child: checkPointsWidget,),
                  SliverToBoxAdapter(child: progressJournalWidget,)
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: TricycleTextButton(onPressed: (){},

                  shape: RoundedRectangleBorder(),
                  color: HexColor(AppColors.appMainColor),
                  child: Text('update Progress',style: styleElements.subtitle1ThemeScalable(context).copyWith(
                    color: HexColor(AppColors.appColorWhite)
                  ),)),
            )
          ],
        ),
      ),
    );
  }

  String getTitle() {
    return "Event Detail Page";
  }
}
