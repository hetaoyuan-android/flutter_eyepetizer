import 'package:flutter/material.dart';
import 'package:leo_eyepetizer/config/color.dart';

TabBar tabBar({
  TabController controller,
  List<Widget> tabs,
  ValueChanged<int> onTap,
  double fontSize = 14,
  // 当前选中的标签字体颜色
  Color labelColor = Colors.black,
  // 未选中的标签字体颜色
  Color unselectedLabelColor = LeoColor.hitTextColor,
  // 下划线的颜色
  Color indicatorColor = Colors.black,
  // 下划线的大小
  TabBarIndicatorSize indicatorSize = TabBarIndicatorSize.label,
}) {
  return TabBar(
    // tabBar滑动
    isScrollable:false,
    controller: controller,
    tabs: tabs,
    onTap: onTap,
    labelColor: labelColor,
    unselectedLabelColor: unselectedLabelColor,
    labelStyle: TextStyle(fontSize: fontSize),
    unselectedLabelStyle: TextStyle(fontSize: fontSize),
    indicatorColor: indicatorColor,
    indicatorSize: indicatorSize,
  );
}