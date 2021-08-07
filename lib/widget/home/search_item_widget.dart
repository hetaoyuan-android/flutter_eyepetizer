import 'package:flutter/material.dart';
import 'package:leo_eyepetizer/model/common_item.dart';
import 'package:leo_eyepetizer/utils/cache_image.dart';
import 'package:leo_eyepetizer/utils/date_util.dart';
import 'package:leo_eyepetizer/utils/navigator_util.dart';

class SearchItemWidget extends StatelessWidget {
  final Item item;

  const SearchItemWidget({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        toNamed('/detail', item.data);
      },
      child: Container(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            // 图片
            _videoImage(),
            Positioned(
              child: Column(
                children: <Widget>[
                  // 视频的 title
                  _videoTitle(),
                  // 视频的时长
                  _videoTime(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 图片
  Widget _videoImage() {
    return Hero(
      tag: '${item.data.id}${item.data.time}',
      child: cacheImage(
        item.data.cover.feed,
        width: double.infinity, //撑满整个屏幕
        height: 220,
      ),
    );
  }

  /// 视频的 title
  Widget _videoTitle() {
    return Text(
      item.data.title,
      maxLines: 1,
      style: TextStyle(
          fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
    );
  }

  /// 视频的时长
  Widget _videoTime() {
    return Container(
      margin: EdgeInsets.only(top: 10),
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
}