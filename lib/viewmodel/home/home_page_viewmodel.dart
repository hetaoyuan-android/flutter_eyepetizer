import 'package:leo_eyepetizer/http/Url.dart';
import 'package:leo_eyepetizer/http/http_manager.dart';
import 'package:leo_eyepetizer/model/common_item.dart';
import 'package:leo_eyepetizer/model/issue_model.dart';
import 'package:leo_eyepetizer/model/paging_model.dart';
import 'package:leo_eyepetizer/utils/toast_util.dart';
import 'package:leo_eyepetizer/viewmodel/base_change_notifier.dart';
import 'package:leo_eyepetizer/viewmodel/base_list_viewmodel.dart';
import 'package:leo_eyepetizer/widget/loading_state_widget.dart';

class HomePageViewModel extends BaseListViewModel<Item, IssueEntity> {
  List<Item> bannerList = [];
  

  @override
  String getUrl() => Url.feedUrl;

  @override
  IssueEntity getModel(Map<String, dynamic> json) => IssueEntity.fromJson(json);

  @override
  void getData(List<Item> list) {
    bannerList = list;
    itemList.clear();
    //banner占位，后面接list列表
    itemList.add(Item());
  }

  @override
  void removeUselessData(List<Item> list) {
    list.removeWhere((item){
      //移除banner2的数据
      return item.type == "banner2";
    });
  }

  @override
  void doExtraAfterRefresh() async{
    // 此处调用加载更多，是为了获取首次列表数据，因为第一个列表数据用来做banner数据了。
    await loadMore();
  }

}
