import 'package:flutter/material.dart';
import 'package:flutter_shop/model/category.dart';

class ChildCategory with ChangeNotifier {
  List<BxMallSubDto> childCategoryList = [];
  int childIndex = 0; // 子类索引
  String categoryId = '4'; // 大类别索引
  String subId = ''; // 小类ID
  int page = 1; // 列表页数
  String noMoreText = ''; // 显示更多的标识

  getChildCategory(List<BxMallSubDto> list, String id) {
    // 清空内部索引
    childIndex = 0;
    categoryId = id;
    subId = '';
    page = 1;
    noMoreText = '';

    BxMallSubDto all = BxMallSubDto();
    all.mallSubId = '';
    all.mallCategoryId = '00';
    all.mallSubName = '全部';
    all.comments = 'null';
    childCategoryList = [all];
    childCategoryList.addAll(list);
    notifyListeners();
  }

  // 更改内部选中按钮索引
  changeChildIndex(int index, String id) {
    childIndex = index;
    subId = id;
    page = 1;
    noMoreText = '';
    notifyListeners();
  }

  // page增加
  addPage() {
    page++;
  }

  // 改变noMoreText数据
  changeNoMoreText(String text) {
    noMoreText = text;
    notifyListeners();
  }
}