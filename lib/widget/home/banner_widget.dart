import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:leo_eyepetizer/utils/cache_image.dart';
import 'package:leo_eyepetizer/viewmodel/home/home_page_viewmodel.dart';

class BannerWidget extends StatelessWidget {
  final HomePageViewModel model;

  const BannerWidget({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Swiper(
      autoplay: true,
      itemBuilder: (BuildContext context, int index) {
        // Stack:将子组件叠加显示,类似 FrameLayout
        return Stack(
          children: <Widget>[
            Container(
              // decoration:装饰,设置子控件的背景颜色、形状等
              decoration: BoxDecoration(
                image: DecorationImage(
                  // 网络获取图片
                  image: cachedNetworkImageProvider(
                      model.bannerList[index].data.cover.feed),
                  // 图片显示样式,类似Android缩放设置
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // banner底部透明黑条
            Positioned(
              // 默认显示内容宽度
              width: MediaQuery.of(context).size.width - 30,
              // 放于底部
              bottom: 0,
              child: Container(
                padding: EdgeInsets.fromLTRB(15, 10, 0, 10),
                // decoration:装饰,设置子控件的背景颜色、形状等
                decoration: BoxDecoration(color: Colors.black12),
                child: Text(
                  model.bannerList[index].data.title,
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            )
          ],
        );
      },
      onTap: (index) {
        print("点击了banner图。。$index}");
        // TODO：跳转 detail
      },
      itemCount: model.bannerList?.length ?? 0,
      // banner 指示器
      pagination: new SwiperPagination(
        // 位置：右下角
        alignment: Alignment.bottomRight,
        // 指示器的样式
        builder: DotSwiperPaginationBuilder(
            size: 8,
            activeSize: 8,
            activeColor: Colors.white,
            color: Colors.white24),
      ),
    );
  }
}