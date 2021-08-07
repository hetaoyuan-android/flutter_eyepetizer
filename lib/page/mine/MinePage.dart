import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:leo_eyepetizer/page/mine/watch_history_page.dart';
import 'package:leo_eyepetizer/utils/cache_manager.dart';
import 'package:leo_eyepetizer/utils/navigator_util.dart';

class MinePage extends StatefulWidget {
  @override
  _MinePageState createState() => _MinePageState();
}

class _MinePageState extends State<MinePage>
    with AutomaticKeepAliveClientMixin {
  File _imageFile;
  final picker = ImagePicker();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _getAvatarPath();
  }

  /// 获取缓存头像
  void _getAvatarPath() {
    var userAvatarPath =
        CacheManager.getInstance().get<String>("user_avatar_path");
    if (userAvatarPath != null && userAvatarPath.isNotEmpty) {
      setState(() {
        _imageFile = File(userAvatarPath);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // 可以移除元素的pandding，注意:要指定移除哪个方向的padding
    return MediaQuery.removePadding(
      context: context,
      // 移除上面的padding
      removeTop: true,
      child: ListView(
        children: <Widget>[
          // 头像
          _head(),
          // 中间的收藏、评论
          _like(),
          // 分割线
          _divider(),
          // 几个设置的widget
          //... 散布运算符，将列表的所有元素插入另一个列表
          ..._listSetting()
        ],
      ),
    );
  }

  /// 头像设置
  Widget _head() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // 高斯模糊背景
        //... 散布运算符，将列表的所有元素插入另一个列表
        ..._headBackground(),
        // 内容
        _headContent(),
      ],
    );
  }

  // 头部的背景
  List<Widget> _headBackground() {
    return [
      Positioned.fill(
        child: Image(
          image: _avatarImage(),
          fit: BoxFit.cover,
        ),
      ),
      Positioned.fill(
        // 高斯模糊
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            color: Colors.white.withOpacity(0.0),
          ),
        ),
      ),
    ];
  }

  // 头像
  ImageProvider _avatarImage() {
    return _imageFile == null
        ? AssetImage('images/ic_img_avatar.png')
        : FileImage(_imageFile);
  }

  // 头部内容
  Widget _headContent() {
    return Column(
      children: [
        GestureDetector(
          child: Padding(
            padding: EdgeInsets.only(top: 45),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 44,
              backgroundImage: _avatarImage(),
            ),
          ),
          onTap: () {
            // 选择图片
            _showSelectPhotoDialog(context);
          },
        ),
        Padding(
          padding: EdgeInsets.only(top: 20),
          child: Text(
            '享学',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              '查看个人主页 >',
              style: TextStyle(fontSize: 12, color: Colors.black26),
            )),
      ],
    );
  }

  // 点击头像后弹出dialog
  void _showSelectPhotoDialog(BuildContext context) {
    // 类似Android 的 BottomSheetDialog，最多半个屏幕高
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          // 最小尺寸，跟内容的高度一样
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _bottomWidget('拍照', () {
              // TODO：路由出栈
              back();
              _getImage(ImageSource.camera);
            }),
            _bottomWidget('相册', () {
              back();
              _getImage(ImageSource.gallery);
            }),
            _bottomWidget('取消', () {
              back();
            }),
          ],
        );
      },
    );
  }

// dialog文本
  Widget _bottomWidget(String text, VoidCallback callback) {
    return ListTile(
        title: Text(text, textAlign: TextAlign.center), onTap: callback);
  }

//模拟头像选择修改，目前存储在本地，实际开发应当上传到云存储平台
  void _getImage(ImageSource source) async {
    // 从相册获取或者拍照
    var imageFile = await picker.pickImage(source: source);
    setState(() {
      _imageFile = File(imageFile.path);
    });
    // 将图片的路径缓存起来
    CacheManager.getInstance().set("user_avatar_path", _imageFile.path);
  }

  /// 中间的收藏、评论
  Widget _like() {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _imageAndText('images/icon_like_grey.png', '收藏'),
          Container(
            width: 0.5,
            height: 40,
            decoration: BoxDecoration(color: Colors.grey),
          ),
          _imageAndText('images/icon_comment_grey.png', '评论'),
        ],
      ),
    );
  }

// 图片与文本组合
  Widget _imageAndText(String image, String text) {
    return Row(
      children: <Widget>[
        Image.asset(image, width: 20, height: 20),
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text(
            text,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ),
      ],
    );
  }

  /// 分割线
  Widget _divider() {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Container(
        height: 0.5,
        decoration: BoxDecoration(color: Colors.grey),
      ),
    );
  }

  _listSetting() {
    return [
      _setting('我的消息'),
      _setting('我的记录'),
      _setting('我的缓存'),
      _setting(
        '观看记录',
        callback: () {
          // TODO：跳转到 WatchHistoryPage
          toPage(WatchHistoryPage());
        },
      ),
      _setting('意见反馈')
    ];
  }

// 设置
  Widget _setting(String text, {VoidCallback callback}) {
    return InkWell(
      onTap: callback,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: 30),
        child: Text(
          text,
          style: TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ),
    );
  }

}
