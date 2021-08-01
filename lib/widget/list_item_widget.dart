import 'package:flutter/material.dart';
import 'package:leo_eyepetizer/model/common_item.dart';
import 'package:leo_eyepetizer/utils/cache_image.dart';
import 'package:leo_eyepetizer/utils/date_util.dart';
import 'package:leo_eyepetizer/utils/navigator_util.dart';
import 'package:leo_eyepetizer/utils/share_util.dart';

class ListItemWidget extends StatelessWidget {
  final Item item;

  // 是否显示 左上角 分类文字：默认显示
  final bool showCategory;

  // 是否显示 分割线:true:默认不显示分割线
  final bool showDivider;

  const ListItemWidget(
      {Key key, this.item, this.showCategory = true, this.showDivider = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 垂直方向的 LinearLayout
    return Column(
      children: <Widget>[
        // 视频封面图片
        // GestureDetector：手势识别 -- Inkwell
        GestureDetector(
          onTap: () {
            print('点击了,跳转详情页');
            toNamed("/detail", item.data);
          },
          child: Padding(
            padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
            // Stack:类似 FrameLayout
            child: Stack(
              children: <Widget>[
                _clipRRectImage(context),
                _categoryText(),
                _videoTime(),
              ],
            ),
          ),
        ),
        // 视频内容简介
        Container(
          decoration: BoxDecoration(color: Colors.white),
          padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
          // Row：水平布局，类似Android LinearLayout
          child: Row(
            children: <Widget>[
              _authorHeaderImage(item),
              // Expanded:具有权重属性的组件，可以控制Row、Column、Flex的子控件如何布局的控件。
              _videoDescription(),
              _shareButton(),
            ],
          ),
        ),
        // 分割线
        // Offstage:控制是否显示组件，false 显示,类似 GONE，不会占用空间
        Offstage(
          offstage: showDivider,
          child: Padding(
            padding: EdgeInsets.only(left: 15, right: 15),
            // Divider：分割线
            child: Divider(
              height: 0.5,
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }

  /// 圆角图片
  Widget _clipRRectImage(context) {
    // ClipRRect:剪切圆角矩形
    return ClipRRect(
      // Hero动画：界面跳转，关联动画
      child: Hero(
        // tag相同的两个widget，跳转时自动关联动画
        tag: '${item.data.id}${item.data.time}',
        child: cacheImage(
          item.data.cover.feed,
          width: MediaQuery.of(context).size.width,
          height: 200,
        ),
      ),
      borderRadius: BorderRadius.circular(4),
    );
  }

  /// 图片左上角显示图标，视频所属分类
  Widget _categoryText() {
    // Positioned:用于定位Stack子组件，Positioned必须是Stack的子组件
    return Positioned(
      left: 15,
      top: 10,
      // Opacity:设置透明度，类似于Android中的invisible
      child: Opacity(
        // opacity：1不透明
        opacity: showCategory ? 1.0 : 0.0, //处理控件显示或隐藏
        child: Container(
          // 也可以用：ClipRRect
          decoration: BoxDecoration(
            color: Colors.white54,
            borderRadius: BorderRadius.all(Radius.circular(22)),
          ),
          height: 44,
          width: 44,
          // 文字居中
          alignment: AlignmentDirectional.center,
          child: Text(
            item.data.category,
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
        ),
      ),
    );
  }

  /// 图片右下角显示视频总时长
  Widget _videoTime() {
    return Positioned(
      right: 15,
      bottom: 10,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          decoration: BoxDecoration(color: Colors.black54),
          padding: EdgeInsets.all(5),
          child: Text(
            formatDateMsByMS(item.data.duration * 1000),
            style: TextStyle(
                color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  /// 作者的头像
  Widget _authorHeaderImage(Item item) {
    // ClipOval:剪切椭圆，高宽一样则为圆
    return ClipOval(
      // 抗锯齿
      clipBehavior: Clip.antiAlias,
      child: cacheImage(
        item.data.author == null
            ? item.data.provider.icon
            : item.data.author.icon,
        width: 40,
        height: 40,
      ),
    );
  }

  /// 视频内容简介
  Widget _videoDescription() {
    // Expanded:相当于Android中设置 weight 权重
    return Expanded(
      flex: 1,
      child: Container(
        padding: EdgeInsets.only(left: 10),
        // 垂直的LinearLayout
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(item.data.title,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
                // 过长则省略
                overflow: TextOverflow.ellipsis),
            Padding(
                padding: EdgeInsets.only(top: 2),
                child: Text(
                    item.data.author == null
                        ? item.data.description
                        : item.data.author.name,
                    style: TextStyle(color: Color(0xff9a9a9a), fontSize: 12)))
          ],
        ),
      ),
    );
  }

  /// 分享按钮
  Widget _shareButton() {
    return IconButton(
      icon: Icon(Icons.share, color: Colors.black38),
      onPressed: () => share(item.data.title, item.data.playUrl),
    );
  }
}
