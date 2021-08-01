import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:leo_eyepetizer/app_init.dart';
import 'package:leo_eyepetizer/http/http_manager.dart';
import 'package:leo_eyepetizer/page/video/video_detail_page.dart';
import 'package:leo_eyepetizer/tab_navigation.dart';

void main() {
  runApp(MyApp());
  //Flutter沉浸式状态栏，Platform.isAndroid 判断是否是Android手机
  if (Platform.isAndroid) {
    // setSystemUIOverlayStyle:用来设置状态栏顶部和底部样式
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 异步UI更新
    return FutureBuilder(
      future: AppInit.init(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        // HttpManager.getData(
        //   "http://baobab.kaiyanapp.com/api/v2/feed?num=1",
        //   success: (result) {
        //     print(result);
        //   },
        // );
        print(snapshot.connectionState);
        var widget = snapshot.connectionState == ConnectionState.done
            ? TabNavigation()
            : Scaffold(
                body: Center(
                  // 圈
                  child: CircularProgressIndicator(),
                ),
              );

        return GetMaterialAppWidget(child: widget);
      },
    );
  }
}

class GetMaterialAppWidget extends StatefulWidget {
  final Widget child;

  GetMaterialAppWidget({Key key, this.child}) : super(key: key);

  @override
  _GetMaterialAppWidgetState createState() => _GetMaterialAppWidgetState();
}

class _GetMaterialAppWidgetState extends State<GetMaterialAppWidget> {
  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   title: 'EyePetizer',
    //   initialRoute: '/',
    //   routes: {
    //     '/': (BuildContext context) => widget.child,
    //   },
    // );
    return GetMaterialApp(
      title: 'EyePetizer',
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => widget.child),
        GetPage(name: '/detail', page: () => VideoDetailPage()),
      ],
    );
  }
}
