import 'dart:async';

class ButtonTapManager {
  bool _isPressed = false;
  bool get buttonState => _isPressed;
  void buttonPressed() {
    _isPressed = true;
    Timer(Duration(milliseconds: 1000), () async {
      _isPressed = false;
    });
  }
}
