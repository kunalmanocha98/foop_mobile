import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/tricycle_buttons.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:intl/intl.dart';

class CalenderViewPage extends StatefulWidget{
  final DateTime selectedDate;
  CalenderViewPage({required this.selectedDate});
  @override
  CalenderViewPageState createState() => CalenderViewPageState(currentDate: selectedDate);
}
class CalenderViewPageState extends State<CalenderViewPage>{
  DateTime? currentDate;
  late String _currentMonth;
  DateTime? _targetDateTime;
  CalenderViewPageState({this.currentDate}){
    _currentMonth= DateFormat.yMMM().format(currentDate!);
    _targetDateTime = currentDate;
  }
  late TextStyleElements styleElements;
  CalendarCarousel? _calendarCarouselNoHeader;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    /// Example Calendar Carousel without header and custom prev & next button
    _calendarCarouselNoHeader = CalendarCarousel<Event>(
      height: 300,

      selectedDateTime: currentDate,
      targetDateTime: _targetDateTime,
      minSelectedDate: currentDate!.subtract(Duration(days: 365)),
      maxSelectedDate: currentDate!.add(Duration(days: 365)),

      markedDateCustomShapeBorder: CircleBorder(side: BorderSide(color: HexColor(AppColors.appMainColor))),

      todayBorderColor: HexColor(AppColors.appMainColor),
      thisMonthDayBorderColor: HexColor(AppColors.appColorTransparent),
      selectedDayButtonColor: HexColor(AppColors.appColorRed50),
      todayButtonColor: HexColor(AppColors.appColorTransparent),
      selectedDayBorderColor: HexColor(AppColors.appColorTransparent),

      weekendTextStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color: HexColor(AppColors.appMainColor),),
      markedDateCustomTextStyle: styleElements.bodyText1ThemeScalable(context).copyWith(color: HexColor(AppColors.appColorBlue),),
      weekdayTextStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color: HexColor(AppColors.appColorBlack65),),
      todayTextStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color: HexColor(AppColors.appColorBlack85),),
      selectedDayTextStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color: HexColor(AppColors.appColorBlack85),),
      inactiveDaysTextStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color: HexColor(AppColors.appColorLightGreen),),

      customGridViewPhysics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,

      showHeader: false,
      daysHaveCircularBorder: true,
      showOnlyCurrentMonthDate: false,
      weekFormat: false,
      isScrollable: false,
      shouldShowTransform: true,

      onDayPressed: (DateTime date, List<Event> events) {
        this.setState(() => currentDate = date);
        events.forEach((event) => print(event.title));
      },
      onCalendarChanged: (DateTime date) {
        this.setState(() {
          _targetDateTime = date;
          _currentMonth = DateFormat.yMMM().format(_targetDateTime!);
        });
      },
      onDayLongPressed: (DateTime date) {
        print('long pressed date $date');
      },
    );

    return new Scaffold(
        appBar:TricycleAppBar().getCustomAppBar(context, appBarTitle: AppLocalizations.of(context)!.translate('select_date_heading'),
            onBackButtonPress: (){Navigator.pop(context);},
        actions: [
          TricycleTextButton(
            onPressed: () {
              Navigator.pop(context,currentDate);
            },
            child: Wrap(
              direction: Axis.horizontal,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(AppLocalizations.of(context)!.translate('next'),
                  style: styleElements
                      .subtitle2ThemeScalable(context)
                      .copyWith(color: HexColor(AppColors.appMainColor)),
                ),
                Icon(Icons.keyboard_arrow_right,
                    color: HexColor(AppColors.appMainColor))
              ],
            ),
            shape: CircleBorder(),
          ),
        ]),
        body: TricycleListCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                  top: 16.0,
                  bottom: 16.0,
                  left: 16.0,
                  right: 0.0,
                ),
                child: new Row(
                  children: <Widget>[
                    Expanded(
                        child: Padding(
                          padding:  EdgeInsets.only(left:8.0),
                          child: Text(
                            _currentMonth,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24.0,
                            ),
                          ),
                        )),
                    TricycleTextButton(
                      child: Text(AppLocalizations.of(context)!.translate('prev').toUpperCase(),style: TextStyle(color: HexColor(AppColors.appMainColor)),),
                      shape: StadiumBorder(),
                      onPressed: () {
                        setState(() {
                          _targetDateTime = DateTime(_targetDateTime!.year, _targetDateTime!.month -1);
                          _currentMonth = DateFormat.yMMM().format(_targetDateTime!);
                        });
                      },
                    ),
                    TricycleTextButton(
                      child: Text(AppLocalizations.of(context)!.translate('next').toUpperCase(),style: TextStyle(color: HexColor(AppColors.appMainColor)),),
                      shape: StadiumBorder(),
                      onPressed: () {
                        setState(() {
                          _targetDateTime = DateTime(_targetDateTime!.year, _targetDateTime!.month +1);
                          _currentMonth = DateFormat.yMMM().format(_targetDateTime!);
                        });
                      },
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 8.0,bottom: 16,left: 8,right: 8),
                child: _calendarCarouselNoHeader,
              ), //
            ],
          ),
        ));
  }

}
