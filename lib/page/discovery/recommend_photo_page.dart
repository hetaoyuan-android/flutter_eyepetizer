import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:leo_eyepetizer/utils/cache_image.dart';
import 'package:leo_eyepetizer/utils/navigator_util.dart';
import 'package:leo_eyepetizer/viewmodel/discovery/recommend_photo_viewmodel.dart';
import 'package:leo_eyepetizer/widget/provider_widget.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class RecommendPhotoPage extends StatelessWidget {
  final List<String> galleryItems;

  const RecommendPhotoPage({Key key, this.galleryItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // AnnotatedRegion：改变状态栏内容的颜色
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(color: Colors.black),
          child: ProviderWidget<RecommendPhotoViewModel>(
            model: RecommendPhotoViewModel(),
            builder: (context, model, child) {
              return Stack(
                children: <Widget>[
                  // 图片处理
                  _photoViewGallery(model),
                  // 向下箭头
                  _arrowDown(context),
                  // 当前照片是总张数中的第几张
                  _currentIndex(context, model),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  /// 图片处理
  Widget _photoViewGallery(RecommendPhotoViewModel model) {
    return PhotoViewGallery.builder(
      builder: (BuildContext context, int index) => PhotoViewGalleryPageOptions(
        // 显示的图片
        imageProvider: cachedNetworkImageProvider(galleryItems[index]),
        // 初始缩放
        initialScale: PhotoViewComputedScale.contained * 1,
        // 最小缩放
        minScale: PhotoViewComputedScale.contained * 1,
      ),
      // loading时显示的widget
      loadingBuilder: (context, event) => Center(
        child: Container(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(),
        ),
      ),
      // 图片总数
      itemCount: galleryItems.length,
      //是否允许旋转
      enableRotation: true,
      //背景修饰
      backgroundDecoration: BoxDecoration(color: Colors.black),
      // 当page改变是回调
      onPageChanged: (index) => model.changeIndex(index),
    );
  }

  /// 向下箭头
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

  /// 当前照片是总张数中的第几张
  Widget _currentIndex(BuildContext context, RecommendPhotoViewModel model) {
    return Align(
      // 顶部居中
      alignment: Alignment.topCenter,
      child: Offstage(
        // false 显示
        offstage: galleryItems.length == 1,
        child: Container(
          margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 15),
          padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
          decoration: BoxDecoration(
              color: Colors.black54, borderRadius: BorderRadius.circular(5)),
          child: Text(
            '${model.currentIndex}/${galleryItems.length}',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
      ),
    );
  }

}