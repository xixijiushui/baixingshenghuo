import 'package:dio/dio.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter_shop/config/service_url.dart';

Future request(String url, {formData}) async {
  try {
    print('开始加载数据...');
    Dio dio = new Dio();
    dio.options.contentType =
        ContentType.parse("application/x-www-form-urlencoded");
    Response response;
    if (formData == null) {
      response = await dio.post(servicePath[url]);
    } else {
      response = await dio.post(servicePath[url], data: formData);
    }
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('接口出错');
    }
  } catch (e) {
    return print('Error:=======>$e');
  }
}

// 商家首页数据
Future getHomePageContent() async {
  try {
    print('开始加载首页数据...');
    Dio dio = new Dio();
    dio.options.contentType =
        ContentType.parse("application/x-www-form-urlencoded");
    var formData = {'lon': '115.02932', 'lat': '35.76189'};
    Response response =
        await dio.post(servicePath['homePageContext'], data: formData);
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('接口出错');
    }
  } catch (e) {
    return print('Error:=======>$e');
  }
}

// 获取火爆专区商品
Future getHomePageBeloConten() async {
  try {
    print('开始加载下拉列表数据...');
    Dio dio = new Dio();
    dio.options.contentType =
        ContentType.parse("application/x-www-form-urlencoded");
    var formData = {'page': 1};
    Response response =
        await dio.post(servicePath['homePageBelowConten'], data: formData);
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('接口出错');
    }
  } catch (e) {
    return print('Error:=======>$e');
  }
}
