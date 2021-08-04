import 'package:flutter/material.dart';
import 'package:leo_eyepetizer/viewmodel/base_viewmodel.dart';
import 'package:leo_eyepetizer/widget/loading_state_widget.dart';
import 'package:leo_eyepetizer/widget/provider_widget.dart';

//通用分页State封装
abstract class BaseState<M extends BaseViewModel, T extends StatefulWidget>
    extends State<T> with AutomaticKeepAliveClientMixin {
  M get viewModel; //真实获取数据的仓库

  Widget getContentChild(M model); //真实的分页控件

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ProviderWidget<M>(
      model: viewModel,
      onModelInit: (model) => model.refresh(),
      builder: (context, model, child) {
        return LoadingStateWidget(
          viewState: model.viewState,
          retry: model.retry,
          child: getContentChild(model),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}