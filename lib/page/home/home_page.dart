import 'package:flutter/material.dart';
import 'package:leo_eyepetizer/config/string.dart';
import 'package:leo_eyepetizer/page/home/home_body_page.dart';
import 'package:leo_eyepetizer/widget/app_bar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

/// AutomaticKeepAliveClientMixin作用：切换tab后保留tab的状态，避免initState方法重复调用
/// 1.需重写 wantKeepAlive 返回 true
/// 2.必须调用 super.build(context);
class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: appBar(
        LeoString.home,
        showBack: false,
      ),
      body: HomeBodyPage(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
