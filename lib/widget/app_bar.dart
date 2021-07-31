import 'package:flutter/material.dart';

appBar(String title, {bool showBack = true, List<Widget> actions}) {
  return AppBar(
    // 明暗模式：light
    brightness: Brightness.light,
    // title位置：居中
    centerTitle: true,
    // 阴影高度：0
    elevation: 0,
    // 背景色：白色
    backgroundColor: Colors.white,
    // 导航栏最左侧Widget：是否显示返回按钮
    leading: showBack ? BackButton(color: Colors.black) : null,
    // 导航栏右侧List<Widget>
    actions: actions,
    // title文字和样式
    title: Text(
      title,
      style: TextStyle(
        fontSize: 18,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}