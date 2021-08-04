import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:leo_eyepetizer/model/discovery/recommend_model.dart';
import 'package:leo_eyepetizer/utils/navigator_util.dart';
import 'package:leo_eyepetizer/widget/video/video_play_widget.dart';

class RecommendVideoPage extends StatefulWidget {
  final RecommendItem item;

  const RecommendVideoPage({Key key, this.item}) : super(key: key);

  @override
  _RecommendVideoPageState createState() => _RecommendVideoPageState();
}

class _RecommendVideoPageState extends State<RecommendVideoPage>
    with WidgetsBindingObserver {
  final GlobalKey<VideoPlayWidgetState> videoKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      videoKey.currentState.pause();
    } else if (state == AppLifecycleState.resumed) {
      videoKey.currentState.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    // AnnotatedRegion：改变状态栏内容的颜色
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(color: Colors.black),
          child: Stack(
            children: <Widget>[
              // Align：控制子View的位置，默认居中对齐
              Align(
                child: VideoPlayWidget(
                  key: videoKey,
                  // 播放url
                  url: widget.item.data.content.data.playUrl,
                  // 视频的纵横比
                  aspectRatio: _getAspectRatio(),
                  // 是否允许全屏
                  allowFullScreen: !(widget.item.data.content.data.height >
                      widget.item.data.content.data.width),
                ),
              ),
              // 向下的箭头
              _arrowDown(context),
            ],
          ),
        ),
      ),
    );
  }

  double _getAspectRatio() {
    double aspectRatio = 16 / 9;
    bool allowFullScreen = widget.item.data.content.data.height >
        widget.item.data.content.data.width;
    if (allowFullScreen) {
      final size = MediaQuery.of(context).size;
      final width = size.width;
      final height = size.height;
      aspectRatio = width / height;
    }
    return aspectRatio;
  }

  /// 向下的箭头
  Widget _arrowDown(context) {
    return Positioned(
      left: 10,
      // 加上导航栏的高度
      top: MediaQuery.of(context).padding.top + 10,
      child: GestureDetector(
        // TODO:路由出栈
        onTap: () => back(),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey, borderRadius: BorderRadius.circular(12)),
          width: 24,
          height: 24,
          child: Icon(Icons.keyboard_arrow_down, size: 20),
        ),
      ),
    );
  }
}