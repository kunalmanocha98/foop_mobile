import 'dart:async';

import 'package:flutter/cupertino.dart';

class Debouncer {
  final int milliSecs;
  VoidCallback? action;
  Timer? _timer;

  Debouncer(this.milliSecs);

  run(VoidCallback action) {
    if (null != _timer) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliSecs), action);
  }
}
