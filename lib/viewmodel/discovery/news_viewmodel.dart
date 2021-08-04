import 'dart:io';

import 'package:leo_eyepetizer/http/Url.dart';
import 'package:leo_eyepetizer/model/discovery/news_model.dart';
import 'package:leo_eyepetizer/viewmodel/base_list_viewmodel.dart';

class NewsViewModel extends BaseListViewModel<NewsItemModel, NewsModel> {

  @override
  String getUrl() {
    String deviceModel = Platform.isAndroid ? "Android" : "IOS";
    return Url.newsUrl + deviceModel;
  }

  @override
  String getNextUrl(NewsModel model) {
    String deviceModel = Platform.isAndroid ? "Android" : "IOS";
    return "${model.nextPageUrl}&vc=6030000&deviceModel=$deviceModel";
  }

  @override
  NewsModel getModel(Map<String, dynamic> json) {
    return NewsModel.fromJson(json);
  }
}