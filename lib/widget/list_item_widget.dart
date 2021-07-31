import 'package:flutter/material.dart';
import 'package:leo_eyepetizer/model/common_item.dart';
import 'package:leo_eyepetizer/utils/cache_image.dart';

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
            // TODO:跳转详情页
          },
          child: Padding(
            padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
            // Stack:类似 FrameLayout
            child: Stack(
              children: <Widget>[
                _clipRRectImage(context),
                _categoryText(),
                // _videoTime(),
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
              // _authorHeaderImage(item),
              // Expanded:具有权重属性的组件，可以控制Row、Column、Flex的子控件如何布局的控件。
              // _videoDescription(),
              // _shareButton(),
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

  // 图片左上角显示图标，视频所属分类
  Widget _categoryText() {

  }


}
