import 'package:flutter/services.dart';

class SpeechPlugin {
  //定义与Native进行交互的MethodChannel,Android与Ios通用
  static const MethodChannel _methodChannel = MethodChannel('speech_plugin');

  static Future<String> start() async {
    return await _methodChannel.invokeMethod('start');
  }

  //通过安卓获取当前时间
  static Future<String> getAndroidTime() async {
    //通过MethodChannel对象的invokeMethod()方法调用原生方法
    var str = await _methodChannel.invokeMethod('time');
    return str;
  }

  //显示安卓土司
  static showToast(String msg) async {
    try {
      await _methodChannel.invokeMethod('toast', {'msg': msg});
    } on PlatformException catch (e) {
      print(e.toString());
    }
  }
}