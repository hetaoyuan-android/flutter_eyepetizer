
import 'package:leo_eyepetizer/http/Url.dart';
import 'package:leo_eyepetizer/model/common_item.dart';
import 'package:leo_eyepetizer/viewmodel/base_list_viewmodel.dart';

class FollowViewModel extends BaseListViewModel<Item, Issue> {
  @override
  Issue getModel(Map<String, dynamic> json) {
   return Issue.fromJson(json);
  }

  @override
  String getUrl() {
    return Url.followUrl;
  }

}