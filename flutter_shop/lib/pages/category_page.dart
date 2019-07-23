import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_shop/provide/child_category.dart';
import 'package:flutter_shop/provide/category_goods_list.dart';
import 'package:flutter_shop/service/service_method.dart';
import 'package:flutter_shop/model/category.dart';
import 'package:flutter_shop/model/category_goods_list.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('商品分类'),
      ),
      body: Container(
        child: Row(
          children: <Widget>[
            LeftCategoryNav(),
            Column(
              children: <Widget>[
                RightCategoryNav(),
                CategoryGoodsList(),
              ],
            )
          ],
        ),
      ),
    );
  }
}

// 左侧大类导航
class LeftCategoryNav extends StatefulWidget {
  @override
  _LeftCategoryNavState createState() => _LeftCategoryNavState();
}

class _LeftCategoryNavState extends State<LeftCategoryNav> {
  List list = [];
  var listIndex = 0;

  @override
  void initState() {
    super.initState();
    _getCategory();
    _getGoodList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(180),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            width: 0.5,
            color: Colors.black26,
          ),
        ),
      ),
      child: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) => _leftInkWell(index),
      ),
    );
  }

  Widget _leftInkWell(index) {
    bool isClick = (index == listIndex);

    return InkWell(
      onTap: () {
        setState(() {
          listIndex = index;
        });
        var childList = list[index].bxMallSubDto;
        var categoryId = list[index].mallCategoryId;
        Provide.value<ChildCategory>(context)
            .getChildCategory(childList, categoryId);
        _getGoodList(categoryId: categoryId);
      },
      child: Container(
        height: ScreenUtil().setHeight(100),
        padding: EdgeInsets.only(
          left: 10,
          top: 20,
        ),
        decoration: BoxDecoration(
          color: isClick ? Color.fromRGBO(240, 240, 240, 1.0) : Colors.white,
          border: Border(bottom: BorderSide(width: 1, color: Colors.black12)),
        ),
        child: Text(
          list[index].mallCategoryName,
          style: TextStyle(fontSize: ScreenUtil().setSp(28)),
        ),
      ),
    );
  }

  void _getCategory() async {
    print('开始加载分类...');
    await request('getCategory').then((val) {
      var data = json.decode(val.toString());
      CategoryModel categoryModel = CategoryModel.fromJson(data);
      setState(() {
        list = categoryModel.data;
      });

      Provide.value<ChildCategory>(context)
          .getChildCategory(list[0].bxMallSubDto, list[0].mallCategoryId);
    });
  }

  _getGoodList({String categoryId}) {
    var data = {
      'categoryId': categoryId == null ? '4' : categoryId,
      'categorySubId': '',
      'page': 1
    };
    request('getMallGoods', formData: data).then((val) {
      var data = json.decode(val.toString());
      CategoryGoodsListModel goodsListModel =
          CategoryGoodsListModel.fromJson(data);
      Provide.value<CategoryGoodsListProvide>(context)
          .getGoodsList(goodsListModel.data);
    });
  }
}

// 右侧导航
class RightCategoryNav extends StatefulWidget {
  @override
  _RightCategoryNavState createState() => _RightCategoryNavState();
}

class _RightCategoryNavState extends State<RightCategoryNav> {
  @override
  Widget build(BuildContext context) {
    return Provide<ChildCategory>(
      builder: (context, child, childCategory) {
        return Container(
          height: ScreenUtil().setHeight(80),
          width: ScreenUtil().setWidth(570),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(width: 0.5, color: Colors.black12),
            ),
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: childCategory.childCategoryList.length,
            itemBuilder: (BuildContext context, int index) {
              return _rightInkWell(
                  index, childCategory.childCategoryList[index]);
            },
          ),
        );
      },
    );
  }

  _getGoodList(String categorySubId) {
    var data = {
      'categoryId': Provide.value<ChildCategory>(context).categoryId,
      'categorySubId': categorySubId,
      'page': 1
    };
    request('getMallGoods', formData: data).then((val) {
      var data = json.decode(val.toString());
      CategoryGoodsListModel goodsListModel =
          CategoryGoodsListModel.fromJson(data);
      if (goodsListModel.data == null) {
        Provide.value<CategoryGoodsListProvide>(context).getGoodsList([]);
      } else {
        Provide.value<CategoryGoodsListProvide>(context)
            .getGoodsList(goodsListModel.data);
      }
    });
  }

  Widget _rightInkWell(int index, BxMallSubDto item) {
    bool isCheck = (index == Provide.value<ChildCategory>(context).childIndex);
    return InkWell(
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
        child: Text(
          item.mallSubName,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: ScreenUtil().setSp(28),
            color: isCheck ? Colors.pink : Colors.black,
          ),
        ),
      ),
      onTap: () {
        Provide.value<ChildCategory>(context)
            .changeChildIndex(index, item.mallSubId);
        _getGoodList(item.mallSubId);
      },
    );
  }
}

// 右侧内容
class CategoryGoodsList extends StatefulWidget {
  @override
  _CategoryGoodsListState createState() => _CategoryGoodsListState();
}

class _CategoryGoodsListState extends State<CategoryGoodsList> {
  GlobalKey<RefreshFooterState> _footerKey =
      new GlobalKey<RefreshFooterState>();
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Provide<CategoryGoodsListProvide>(
        builder: (context, child, categoryGoodsListProvide) {
          if (categoryGoodsListProvide.goodsList.length > 0) {
            try {
              if (Provide.value<ChildCategory>(context).page == 1) {
                scrollController.jumpTo(0.0);
              }
            } catch (e) {
              print('进入页面第一次初始化');
            }
            return Container(
              width: ScreenUtil().setWidth(570),
              child: EasyRefresh(
                refreshFooter: ClassicsFooter(
                  key: _footerKey,
                  bgColor: Colors.white,
                  textColor: Colors.pink,
                  moreInfoColor: Colors.pink,
                  showMore: true,
                  noMoreText: Provide.value<ChildCategory>(context).noMoreText,
                  moreInfo: '加载中',
                  loadReadyText: '上拉加载',
                ),
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: categoryGoodsListProvide.goodsList.length,
                  itemBuilder: (context, index) {
                    return _listItemWidget(
                        categoryGoodsListProvide.goodsList, index);
                  },
                ),
                loadMore: () async {
                  if (Provide.value<ChildCategory>(context).noMoreText == '') {
                    _getMoreList();
                  } else {
                    print('没有更多了...');
                  }
                },
              ),
            );
          } else {
            return Center(
              child: Text('暂无数据'),
            );
          }
        },
      ),
    );
  }

  void _getMoreList() {
    Provide.value<ChildCategory>(context).addPage();

    var data = {
      'categoryId': Provide.value<ChildCategory>(context).categoryId,
      'categorySubId': Provide.value<ChildCategory>(context).subId,
      'page': Provide.value<ChildCategory>(context).page,
    };

    request('getMallGoods', formData: data).then((val) {
      var data = json.decode(val.toString());
      CategoryGoodsListModel goodsListModel =
          CategoryGoodsListModel.fromJson(data);

      if (goodsListModel.data == null) {
        Fluttertoast.showToast(
          msg: '已经到底了',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 2,
          backgroundColor: Colors.pink,
          textColor: Colors.white,
          fontSize: 16.0
        );
        Provide.value<ChildCategory>(context).changeNoMoreText('没有更多了');
      } else {
        Provide.value<CategoryGoodsListProvide>(context)
            .addGoodsList(goodsListModel.data);
      }
    });
  }

  Widget _goodsImage(List<CategoryListData> goodsList, index) {
    return Container(
      width: ScreenUtil().setWidth(200),
      child: Image.network(goodsList[index].image),
    );
  }

  Widget _goodsName(List<CategoryListData> goodsList, index) {
    return Container(
      padding: EdgeInsets.all(5.0),
      width: ScreenUtil().setWidth(370),
      child: Text(
        goodsList[index].goodsName,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: ScreenUtil().setSp(28)),
      ),
    );
  }

  Widget _goodsPrice(List<CategoryListData> goodsList, index) {
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      width: ScreenUtil().setWidth(370),
      child: Row(
        children: <Widget>[
          Text(
            '价格:¥${goodsList[index].presentPrice}',
            style:
                TextStyle(color: Colors.pink, fontSize: ScreenUtil().setSp(30)),
          ),
          Text(
            '¥${goodsList[index].oriPrice}',
            style: TextStyle(
                color: Colors.black26, decoration: TextDecoration.lineThrough),
          ),
        ],
      ),
    );
  }

  Widget _listItemWidget(List<CategoryListData> goodsList, int index) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(width: 0.5, color: Colors.black12)),
        ),
        child: Row(
          children: <Widget>[
            _goodsImage(goodsList, index),
            Column(
              children: <Widget>[
                _goodsName(goodsList, index),
                _goodsPrice(goodsList, index),
              ],
            )
          ],
        ),
      ),
    );
  }
}
