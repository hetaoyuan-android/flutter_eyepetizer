import 'package:leo_eyepetizer/http/Url.dart';
import 'package:leo_eyepetizer/model/discovery/topic_model.dart';
import 'package:leo_eyepetizer/viewmodel/base_list_viewmodel.dart';

class TopicPageViewModel extends BaseListViewModel<TopicItemModel,TopicModel>{

  @override
  String getUrl() {
    return Url.topicsUrl;
  }

  @override
  TopicModel getModel(Map<String, dynamic> json) {
    return TopicModel.fromJson(json);
  }
}