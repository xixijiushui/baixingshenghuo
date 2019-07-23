import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_shop/model/details.dart';
import 'package:flutter_shop/service/service_method.dart';

class DetailsInfoProvide with ChangeNotifier {
  DetailsModel goodsInfoModel = null;

  bool isLeft = true;
  bool isRight = false;

  // tabbar切换
  changeLeftAndRight(String changeState) {
    if (changeState == 'left') {
      isLeft = true;
      isRight = false;
    } else {
      isRight = true;
      isLeft = false;
    }
    notifyListeners();
  }

  // 从后台获取商品数据
  getGoodsInfo(String id) async {
    var formData = {'goodId': id};
    await request('getGoodDetailById', formData: formData).then((val) {
      var responseData = json.decode(val.toString());
      goodsInfoModel = DetailsModel.fromJson(responseData);
      notifyListeners();
    });
  }
}