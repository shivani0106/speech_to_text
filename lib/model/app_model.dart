import 'package:flutter/material.dart';

class AppModel with ChangeNotifier {
  Map<String, dynamic> appConfig;
  bool isLoading = true;
  String message;
  bool darkTheme = false;

  Map<String, String> data = Map();

  void updateTheme(bool theme) {
    darkTheme = theme;
    notifyListeners();
  }
}

class App {
  Map<String, dynamic> appConfig;

  App(this.appConfig);
}
