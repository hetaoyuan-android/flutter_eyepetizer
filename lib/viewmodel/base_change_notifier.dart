import 'package:flutter/material.dart';
import 'package:leo_eyepetizer/widget/loading_state_widget.dart';

// class BaseChangNotifier extends ChangeNotifier {
//   // 页面销毁则不发送通知
//   bool _dispose = false;
//
//   @override
//   void dispose() {
//     super.dispose();
//     _dispose = true;
//   }
//
//   // 报错：_debugAssertNotDisposed() --》
//   // https://github.com/rrousselGit/provider/issues/78
//   @override
//   void notifyListeners() {
//     if (!_dispose) {
//       super.notifyListeners();
//     }
//   }
// }

class BaseChangeNotifier with ChangeNotifier {
  ViewState viewState = ViewState.loading;

  bool _dispose = false;

  @override
  void dispose() {
    super.dispose();
    _dispose = true;
  }

  @override
  void notifyListeners() {
    if (!_dispose) {
      super.notifyListeners();
    }
  }
}
