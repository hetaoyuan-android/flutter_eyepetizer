import 'dart:convert';

import 'package:leo_eyepetizer/model/common_item.dart';
import 'package:leo_eyepetizer/utils/history_repository.dart';
import 'package:leo_eyepetizer/viewmodel/base_change_notifier.dart';

class WatchHistoryViewModel extends BaseChangeNotifier {
  List<Data> itemList = [];
  List<String> watchList = [];

  void loadData() {
    watchList = HistoryRepository.loadHistoryData();
    if (watchList != null) {
      var list = watchList.map((value) {
        return Data.fromJson(json.decode(value));
      }).toList();
      itemList = list;
      notifyListeners();
    }
  }

  void remove(int index) {
    watchList.removeAt(index);
    HistoryRepository.saveHistoryData(watchList);
    loadData();
  }
}