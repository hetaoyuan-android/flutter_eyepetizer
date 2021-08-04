import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:leo_eyepetizer/config/string.dart';
import 'package:leo_eyepetizer/utils/navigator_util.dart';

class WebPage extends StatefulWidget {
  final String url;

  const WebPage({Key key, this.url}) : super(key: key);

  @override
  _WebPageState createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  FlutterWebviewPlugin flutterWebViewPlugin = FlutterWebviewPlugin();
  String currentUrl = '';

  @override
  void initState() {
    super.initState();
    // 监听页面加载url
    flutterWebViewPlugin.onUrlChanged.listen((String url) {
      currentUrl = url;
    });
    // 监听web页加载状态
    flutterWebViewPlugin.onStateChanged.listen((event) {
      if (event.type == WebViewState.finishLoad) {

        // 根据元素的 class 属性值查询一组元素节点对象
        String js = "javascript:(function() {document.getElementsByClassName(\"share-bar-container\")[0].style.display=\'none\';" +
            "document.getElementsByClassName(\"footer-container j-footer-container\")[0].style.display=\'none\';" +
            "document.getElementsByClassName(\"kyt-promotion-bar-positioner\")[0].style.display=\'none\';" +
            "})()";
        // 在 webView 中执行 Javascript
        flutterWebViewPlugin.evalJavascript(js);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(routes: {
      //WillPopScope：处理返回键事件
      "/": (_) => WillPopScope(
        child: WebviewScaffold(
          // 默认加载地址
          url: widget.url,
          appBar: _appBar(),
          // 是否允许网页缩放
          withZoom: true,
          // 是否允许执行js代码
          withJavascript: true,
          //默认隐藏WebView
          hidden: true,
          // 是否显示滚动条
          scrollBar: false,
          // 初始显示 child
          initialChild: Container(
            child: Center(child: CircularProgressIndicator()),
          ),
        ),
        // 返回有点问题，所以这里使用 WillPopScope
        onWillPop: _onWillPop,
      ),
    });
  }

  Widget _appBar() {
    return AppBar(
      // 导航栏最左侧 Widget，返回箭头
      leading: GestureDetector(
        onTap: () {
          if (widget.url == currentUrl || currentUrl.isEmpty) {
            //TODO:退出路由
            back();
          } else {
            // webView 内部返回，在里面有过多次跳转的时候
            flutterWebViewPlugin.goBack();
          }
        },
        child: Icon(
          Icons.arrow_back,
          size: 25,
          color: Colors.black,
        ),
      ),
      // title文本：新鲜资讯
      title: new Text(
        LeoString.news_title,
        style: TextStyle(
            color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0.0,
      brightness: Brightness.light,
    );
  }

  Future<bool> _onWillPop() {
    if (widget.url == currentUrl) {
      // 在webView中跳转后，点导航栏返回有问题，需要执行 back 返回
      back();
      return Future.value(true);
    } else {
      flutterWebViewPlugin.goBack();
      return Future.value(false);
    }
  }
}