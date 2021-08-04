
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leo_eyepetizer/config/string.dart';
import 'package:leo_eyepetizer/model/common_item.dart';
import 'package:leo_eyepetizer/utils/cache_image.dart';
import 'package:leo_eyepetizer/utils/date_util.dart';
import 'package:leo_eyepetizer/utils/navigator_util.dart';

class FollowItemWidget extends StatelessWidget {
  final Item item;

  const FollowItemWidget({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        children: <Widget>[
          // 视频作者介绍
          _videoAuthor(),
          // 作者作品
          Container(
            height: 230,
            child: ListView.builder(
              itemCount: item.data.itemList.length,
              // 滑动方向：水平
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                // 单个视频介绍
                return _inkWell(
                  context,
                  item: item.data.itemList[index],
                  last: index == item.data.itemList.length - 1,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 单个视频介绍
  Widget _inkWell(BuildContext context, {Item item, bool last}) {
    return InkWell(
      onTap: () => toNamed('/detail', item.data),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: EdgeInsets.only(left: 15, right: last ? 15 : 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // 视频图片
            _videoImage(item),
            _videoName(item),
            _videoTime(item),
          ],
        ),
      ),
    );
  }

  /// 视频上线时间
  Widget _videoTime(item) {
    return Container(
      child: Text(
        formatDateMsByYMDHM(item.data.author.latestReleaseTime),
        style: TextStyle(fontSize: 12, color: Colors.black26),
      ),
    );
  }

  /// 视频名称
  Widget _videoName(item) {
    return Container(
      width: 300,
      padding: EdgeInsets.only(top: 3, bottom: 3),
      child: Text(item.data.title,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis),
    );
  }

  /// 视频图片
  Widget _videoImage(item) {
    return Stack(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Hero(
            tag: '${item.data.id}${item.data.time}',
            child: cacheImage(
              item.data.cover.feed,
              width: 300,
              height: 180,
            ),
          ),
        ),
        // 类型小图标
        Positioned(
          right: 8,
          top: 8,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(color: Colors.white54),
              alignment: AlignmentDirectional.center,
              child: Text(
                item.data.category,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }



  /// 视频作者介绍
  Widget _videoAuthor() {
    return Container(
      // 设置左上右下间距
      padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
      // 类似Android 水平的 LinearLayout
      child: Row(
        children: <Widget>[
          // 剪切椭圆
          ClipOval(
            child: cacheImage(item.data.header.icon, width: 40, height: 40),
          ),
          // 类似 weight，权重
          Expanded(
            flex: 1,
            child: Container(
              // 设置左右间距
              padding: EdgeInsets.only(left: 10, right: 10),
              // 类似 垂直 LinearLayout
              child: Column(
                // 交叉轴对齐设置：即水平方向的对齐设置
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    item.data.header.title,
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 3),
                    child: Text(
                      item.data.header.description,
                      style: TextStyle(color: Colors.black26, fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 剪切圆角矩形
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Container(
              // 设置上下左右的间距都是5
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(color: Color(0xFFF4F4F4)),
              child: Text(
                LeoString.add_follow,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

}