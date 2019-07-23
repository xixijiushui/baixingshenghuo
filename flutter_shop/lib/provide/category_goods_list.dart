import 'package:flutter/material.dart';
import 'package:flutter_shop/model/category_goods_list.dart';

class CategoryGoodsListProvide with ChangeNotifier {
  List<CategoryListData> goodsList = [];

  // 点击大类更换商品列表
  getGoodsList(List<CategoryListData> list) {
    goodsList = list;
    notifyListeners();
  }

  addGoodsList(List<CategoryListData> list) {
    goodsList.addAll(list);
    notifyListeners();
  }
}