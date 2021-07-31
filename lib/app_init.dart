import 'package:flutter_splash_screen/flutter_splash_screen.dart';
import 'package:leo_eyepetizer/http/Url.dart';

class AppInit {
  AppInit._();

  static Future<void> init() async {
    Url.baseUrl = 'http://baobab.kaiyanapp.com/api/';
    Future.delayed(Duration(milliseconds: 2000), () {
      FlutterSplashScreen.hide();
    });
  }
}
