import 'package:leo_eyepetizer/http/Url.dart';
import 'package:leo_eyepetizer/http/http_manager.dart';
import 'package:leo_eyepetizer/model/discovery/category_model.dart';
import 'package:leo_eyepetizer/utils/toast_util.dart';
import 'package:leo_eyepetizer/viewmodel/base_viewmodel.dart';
import 'package:leo_eyepetizer/widget/loading_state_widget.dart';

class CategoryViewModel extends BaseViewModel {
  List<CategoryModel> list = [];

  @override
  void refresh() async {
    HttpManager.getData(
      Url.categoryUrl,
      success: (result) {
        list = (result as List)
            .map((model) => CategoryModel.fromJson(model))
            .toList();
        viewState = ViewState.done;
      },
      fail: (e) {
        LeoToast.showError(e.toString());
        viewState = ViewState.error;
      },
      complete: () => notifyListeners(),
    );
  }
}