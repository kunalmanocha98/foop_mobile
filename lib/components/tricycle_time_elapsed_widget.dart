import 'dart:async';

import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/material.dart';

class TricycleClockTimerWidget extends StatefulWidget {
  final int? startTime;
  TricycleClockTimerWidget({Key? key, this.startTime}):super(key: key);
  @override
  TricycleClockTimerWidgetState createState() => TricycleClockTimerWidgetState(startTimeMilliseconds: startTime);
}

class TricycleClockTimerWidgetState extends State<TricycleClockTimerWidget> {
  late TextStyleElements styleElements;
  Timer? timer;
  DateTime? startTime;
  Stopwatch? stopwatch;
  TricycleClockTimerWidgetState({int? startTimeMilliseconds}){
    print("widget of timer sheet     "+(startTimeMilliseconds!=null ?startTimeMilliseconds.toString():"this is null"));
   startTime = startTimeMilliseconds!=null ? DateTime.fromMillisecondsSinceEpoch(startTimeMilliseconds) :  DateTime.now();
  }

  @override
  void initState() {
    super.initState();
    // stopwatch = Stopwatch();
    WidgetsBinding.instance!.addPostFrameCallback((_){
      if(startTime!=null) startTimer(startTime);
    });
  }

  void startTimer(DateTime? startTime) {
    // stopwatch.start();
    this.startTime = startTime;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      Future.microtask((){
        if(mounted) setState(() {});
      });
    });
  }

  @override
  void dispose() {
    if(timer!=null) {
      timer!.cancel();
    }
    // stopwatch.stop();
    super.dispose();
  }


  @override
  void deactivate() {
    if(timer!=null) {
      timer!.cancel();
    }
    super.deactivate();
  }

  String get time {
    var nowTime = DateTime.now().toUtc();
    int diff =
        nowTime.millisecondsSinceEpoch - startTime!.millisecondsSinceEpoch;
    var time = TimerTextFormatter.format(diff);
    // var nowDate = DateTime.now();
    // log('start time ${startTime.millisecondsSinceEpoch}');
    // log('now time ${nowTime.millisecondsSinceEpoch}');
    // log('$diff');
    return time;
    // var diff =  nowDate.millisecondsSinceEpoch - stopwatch.elapsedMilliseconds;
    // nowDate = DateTime.fromMillisecondsSinceEpoch(diff);
    // log(Utility().getDateFormat('HH:mm:ss', nowDate));
    // return Utility().getDateFormat('HH:mm:ss', nowDate);
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return Container(
      child: Text(
        time,
        style: styleElements
            .captionThemeScalable(context)
            .copyWith(color: HexColor(AppColors.appColorBlack65)),
      ),
    );
  }
}

class TimerTextFormatter {
  static String format(int milliseconds) {
    int hundreds = (milliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();
    int hours = (minutes / 60).truncate();

    String hoursStr = (hours % 60).toString().padLeft(2, '0');
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    // String hundredsStr = (hundreds % 100).toString().padLeft(2, '0');

    return "$hoursStr:$minutesStr:$secondsStr";
  }
}
