import 'package:flutter/material.dart';
import 'package:leo_eyepetizer/config/string.dart';
import 'package:leo_eyepetizer/http/Url.dart';
import 'package:leo_eyepetizer/http/http_manager.dart';
import 'package:leo_eyepetizer/model/tab_info_model.dart';
import 'package:leo_eyepetizer/page/hot/hot_list_page.dart';
import 'package:leo_eyepetizer/utils/toast_util.dart';
import 'package:leo_eyepetizer/widget/app_bar.dart';
import 'package:leo_eyepetizer/widget/tab_bar.dart';

class HotPage extends StatefulWidget {
  @override
  _HotPageState createState() => _HotPageState();
}

class _HotPageState extends State<HotPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController _tabController;
  PageController _pageController;
  List<TabInfoItem> _tabList = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabList.length, vsync: this);
    _pageController = PageController();
    _loadData();
  }

  @override
  void setState(fn) {
    //判断是否渲染完成，防止数据还没有获取到，此时setState触发的控件渲染就会报错
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(LeoString.popularity_list, showBack: false),
      body: Column(
        children: <Widget>[
          tabBar(
            controller: _tabController,
            // tab 标签
            tabs: _tabList.map((TabInfoItem tabInfoItem) {
              return Tab(text: tabInfoItem.name);
            }).toList(),
            // 点击 TabBar 切换 page
            onTap: (index) => _pageController.animateToPage(
              index,
              // 切换page的时间：300ms
              duration: kTabScrollDuration,
              // 快速加速并缓慢结束的动画
              curve: Curves.ease,
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) => _tabController.index = index,
              children: _tabList.map((TabInfoItem tabInfoItem) {
                return HotListPage(apiUrl: tabInfoItem.apiUrl);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  void _loadData() {
    HttpManager.getData(
      Url.rankUrl,
      success: (result) {
        TabInfoModel tabInfoModel = TabInfoModel.fromJson(result);
        setState(() {
          _tabList = tabInfoModel.tabInfo.tabList;
          _tabController = TabController(length: _tabList.length, vsync: this);
        });
      },
      fail: (e) {
        LeoToast.showError(e.toString());
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}