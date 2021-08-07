import 'package:flutter/material.dart';
import 'package:leo_eyepetizer/model/common_item.dart';
import 'package:leo_eyepetizer/state/base_list_state.dart';
import 'package:leo_eyepetizer/viewmodel/hot/hot_list_viewmodel.dart';
import 'package:leo_eyepetizer/widget/list_item_widget.dart';

class HotListPage extends StatefulWidget {
final String apiUrl;

const HotListPage({Key key, this.apiUrl}) : super(key: key);

@override
_HotListPageState createState() => _HotListPageState();
}

class _HotListPageState
    extends BaseListState<Item, HotListViewModel, HotListPage> {
  @override
  HotListViewModel get viewModel => HotListViewModel(widget.apiUrl);

  void init() {
    // enablePullUp = false;
  }

  @override
  Widget getContentChild(HotListViewModel model) {
    return ListView.separated(
      itemCount: model.itemList.length,
      itemBuilder: (context, index) {
        return ListItemWidget(item: model.itemList[index]);
      },
      separatorBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Divider(height: 0.5),
        );
      },
    );
  }
}