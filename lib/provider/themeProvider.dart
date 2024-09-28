import 'package:flutter/cupertino.dart';

class themeProvider extends ChangeNotifier{
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;
  void changeTheme(){
    _isDarkMode = !_isDarkMode;
    print(isDarkMode);
    notifyListeners();
  }
}