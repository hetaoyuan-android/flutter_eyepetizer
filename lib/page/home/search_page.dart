import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:leo_eyepetizer/config/string.dart';
import 'package:leo_eyepetizer/plugin/speech_plugin.dart';
import 'package:leo_eyepetizer/utils/navigator_util.dart';
import 'package:leo_eyepetizer/viewmodel/home/search_viewmodel.dart';
import 'package:leo_eyepetizer/widget/home/search_item_widget.dart';
import 'package:leo_eyepetizer/widget/loading_state_widget.dart';
import 'package:leo_eyepetizer/widget/provider_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        //SafeArea:适配各种异型屏幕
        child: SafeArea(
          child: ProviderWidget<SearchViewModel>(
            model: SearchViewModel(),
            onModelInit: (model) => model.getKeyWords(),
            builder: (context, model, child) {
              return Column(
                children: <Widget>[
                  // 搜索界面的topbar
                  _searchBar(model, context),
                  Expanded(
                    flex: 1,
                    child: Stack(
                      children: <Widget>[
                        // 热搜关键字提示
                        _keyWordWidget(model),
                        // 搜索到的视频
                        _searchVideoWidget(model),
                        // 搜索内容为空时显示的 Widget
                        _emptyWidget(model)
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  /// 搜索界面的topbar
  Widget _searchBar(SearchViewModel model, BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10, right: 16),
      child: Row(
        children: <Widget>[
          // 返回箭头
          _arrowBack(),
          // 输入框
          _inputBox(model),
          // 麦克风图标
          _micro(model),
        ],
      ),
    );
  }

  // 返回箭头
  Widget _arrowBack() {
    return // 返回箭头
        IconButton(
      icon: Icon(
        Icons.arrow_back,
        size: 20,
        color: Colors.black26,
      ),
      onPressed: () => back(),
    );
  }

  // 输入框
  Widget _inputBox(SearchViewModel model) {
    return Expanded(
      child: ConstrainedBox(
        //通过ConstrainedBox修改TextField的高度
        constraints: BoxConstraints(maxHeight: 30),
        // TextField:文本输入框
        child: TextField(
          // 自动聚焦
          autofocus: true,
          // 提交时，配合 textInputAction
          onSubmitted: (value) {
            model.query = value;
            model.loadMore(loadMore: false);
          },
          // 键盘按钮
          textInputAction: TextInputAction.search,
          // 输入框装饰器
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(bottom: 15),
            // 位于输入框内部起始位置的图标
            prefixIcon: Icon(Icons.search, size: 20, color: Colors.black26),
            // 相当于输入框的背景颜色
            fillColor: Color(0x0D000000),
            // 如果为true，则输入使用fillColor指定的颜色填充
            filled: true,
            // OutlineInputBorder:外边线
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(20),
            ),
            // 提示文本，位于输入框内部
            hintText: LeoString.interest_video,
            // hintText的样式
            hintStyle: TextStyle(fontSize: 13),
          ),
        ),
      ),
    );
  }

  // 麦克风图标
  Widget _micro(SearchViewModel model) {
    return Offstage(
      // Android平台则显示
      offstage: !Platform.isAndroid,
      child: IconButton(
        icon: Icon(Icons.keyboard_voice, color: Colors.black26),
        onPressed: () {
          // 点击语音搜索
          _showSpeechDialog(model);
          _toastTime();
        },
      ),
    );
  }

  /// 点击语音搜索
  _showSpeechDialog(SearchViewModel model) {
    // result：关键字
    SpeechPlugin.start().then((result) {
      if (result.isNotEmpty) {
        _hideTextInput();
        model.query = result;
        model.loadMore(loadMore: false);
      }
    });
  }

  void _toastTime() async {
    SpeechPlugin.getAndroidTime()
        .then((value) => SpeechPlugin.showToast(value));
  }

  /// 热搜关键字提示
  Widget _keyWordWidget(SearchViewModel model) {
    return Offstage(
      // false 的时候显示
      offstage: model.hideKeyWord,
      child: Column(
        children: <Widget>[
          // 热搜关键字文本
          Padding(
            padding: EdgeInsets.only(top: 25),
            child: Center(
              child: Text(
                LeoString.hot_key_word,
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          ),
          // 热搜关键字
          Padding(
            padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
            // Wrap：可以为子控件进行水平或者垂直方向布局，可以使子控件自动换行
            child: Wrap(
              // 子控件在主轴上的对齐方式
              alignment: WrapAlignment.center,
              // 主轴上子控件中间的间距
              spacing: 6,
              // 交叉轴上子控件之间的间距
              runSpacing: 10,
              children: _keyWordWidgets(model),
            ),
          ),
        ],
      ),
    );
  }

  // 热搜关键字
  List<Widget> _keyWordWidgets(SearchViewModel model) {
    return model.keyWords.map((keyword) {
      return GestureDetector(
        onTap: () {
          // 隐藏键盘
          _hideTextInput();
          model.query = keyword;
          model.loadMore(loadMore: false);
        },
        child: Container(
          padding: EdgeInsets.fromLTRB(14, 8, 14, 8),
          decoration: BoxDecoration(
            color: Color(0x1A000000),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            keyword,
            style: TextStyle(fontSize: 12, color: Colors.black45),
          ),
        ),
      );
    }).toList();
  }

  // 隐藏键盘
  _hideTextInput() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  /// 搜索内容为空时显示的 Widget
  Widget _emptyWidget(SearchViewModel model) {
    return Offstage(
      offstage: model.hideEmpty,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.sentiment_dissatisfied, size: 60, color: Colors.black54),
            Padding(
              padding: EdgeInsets.only(top: 5),
              child: Text(
                LeoString.no_data,
                style: TextStyle(fontSize: 15, color: Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 搜索到的视频
  Widget _searchVideoWidget(SearchViewModel model) {
    return Offstage(
      offstage: model.dataList == null || model.dataList.length == 0,
      child: LoadingStateWidget(
        viewState: model.viewState,
        retry: model.retry,
        child: Column(
          children: <Widget>[
            // 搜索结果统计文本
            Container(
              margin: EdgeInsets.only(top: 20, bottom: 20),
              child: Text(
                '— 「${model.query}」搜索结果共${model.total}个 —',
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            // 显示搜索结果
            Expanded(
              flex: 1,
              child: SmartRefresher(
                // 是否可以下拉
                enablePullDown: false,
                // 是否可以上拉
                enablePullUp: true,
                // 加载更多时回调
                onLoading: model.loadMore,
                controller: model.refreshController,
                child: ListView.builder(
                  itemCount: model.dataList.length,
                  itemBuilder: (context, index) {
                    return SearchItemWidget(item: model.dataList[index]);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
