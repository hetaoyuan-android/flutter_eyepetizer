import 'package:flutter/material.dart';
import 'package:leo_eyepetizer/config/color.dart';
import 'package:leo_eyepetizer/model/discovery/news_model.dart';
import 'package:leo_eyepetizer/page/web_page.dart';
import 'package:leo_eyepetizer/state/base_list_state.dart';
import 'package:leo_eyepetizer/utils/cache_image.dart';
import 'package:leo_eyepetizer/utils/navigator_util.dart';
import 'package:leo_eyepetizer/viewmodel/discovery/news_viewmodel.dart';

const TEXT_CARD_TYPE = "textCard";
const INFORMATION_CARD_TYPE = "informationCard";

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState
    extends BaseListState<NewsItemModel, NewsViewModel, NewsPage> {
  @override
  NewsViewModel get viewModel => NewsViewModel();

  @override
  Widget getContentChild(NewsViewModel model) =>
      ListView.builder(
        itemBuilder: (context, index) {
          if (model.itemList[index].type == TEXT_CARD_TYPE) {
            // 资讯时间
            return _itemTitle(model.itemList[index]);
          } else {
            // 资讯内容
            return _itemContent(model.itemList[index]);
          }
        },
        itemCount: model.itemList.length,
      );

  /// 资讯时间
  Widget _itemTitle(item) {
    return Container(
      padding: EdgeInsets.only(left: 10, top: 5),
      child: Text(
        item.data.text,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Color(0xff3f3f3f),
        ),
      ),
    );
  }

  /// 资讯内容
  Widget _itemContent(item) {
    return GestureDetector(
      onTap: () {
        // "eyepetizer://webview/?title=%e6%af%8f%e6%97%a5%e6%96%b0%e9%b2%9c%e8%b5%84%e8%ae%af&
        // url=https%3a%2f%2fwww.kaiyanapp.com%2fnew_article.html%3fnid%3d2617%26shareable%3dtrue%26rid%3d947"
        String url = Uri.decodeComponent(
            item.data.actionUrl.substring(item.data.actionUrl.indexOf("url")));
        // url=https://www.kaiyanapp.com/new_article.html?nid=2617&shareable=true&rid=947
        print("actionUrl = $url");

        // 去掉前面的 'url='
        url = url.substring(4, url.length);
        // https://www.kaiyanapp.com/new_article.html?nid=2617&shareable=true&rid=947
        print("actionUrl = $url");

        // TODO:跳转 WebPage
        toPage(WebPage(url: url));
      },
      child: Padding(
        padding: EdgeInsets.all(10),
        // PhysicalModel：将其子控件裁剪为一个形状，可以设置阴影值及颜色
        child: PhysicalModel(
          // 背景色
          color: Color(0xFFEDEDED),
          // 抗锯齿
          clipBehavior: Clip.antiAlias,
          // 圆角矩形
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // 图片：backgroundImage
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: cacheImage(
                    item.data.backgroundImage,
                    width: MediaQuery.of(context).size.width,
                    height: 140,
                    // 充满：可能会改变图片的宽高比
                    fit: BoxFit.fill,
                  ),
                ),
                // 文字：titleList
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _getTitleList(item.data.titleList),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 将 List<String> 转成 List<Widget>
  List<Widget> _getTitleList(List<String> titleList) {
    return titleList.map((title) {
      return Padding(
        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: Text(title,
            style: TextStyle(color: LeoColor.desTextColor, fontSize: 12),
            // 做多显示三行
            maxLines: 3,
            // 超出的部分，省略号处理
            overflow: TextOverflow.ellipsis),
      );
    }).toList();
  }

}