import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:leo_eyepetizer/model/discovery/topic_model.dart';
import 'package:leo_eyepetizer/state/base_list_state.dart';
import 'package:leo_eyepetizer/utils/cache_image.dart';
import 'package:leo_eyepetizer/viewmodel/discovery/topic_page_viewmodel.dart';

class TopicPage extends StatefulWidget {
  @override
  _TopicPageState createState() => _TopicPageState();
}

class _TopicPageState
    extends BaseListState<TopicItemModel, TopicPageViewModel, TopicPage> {
  @override
  TopicPageViewModel get viewModel => TopicPageViewModel();

  @override
  Widget getContentChild(TopicPageViewModel model) => ListView.separated(
    itemCount: model.itemList.length,
    itemBuilder: (context, index) {
      return OpenContainer(
        closedBuilder: (context, action) {
          return _closedWidget(model.itemList[index]);
        },
        openBuilder: (context, action) {
          return Container(color: Colors.blue);
        },
      );
    },
    separatorBuilder: (context, index) {
      return Divider(
        height: 0.5,
      );
    },
  );

  Widget _closedWidget(item) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: ClipRRect(
        child: cacheImage(
          item.data.image,
          width: MediaQuery.of(context).size.width,
          height: 200,
        ), //充满容器，可能会被截断
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}