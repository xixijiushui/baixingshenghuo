import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shop/model/cart_info.dart';
import 'package:flutter_shop/pages/cart_page/cart_count.dart';
import 'package:provide/provide.dart';
import 'package:flutter_shop/provide/cart.dart';

class CartItem extends StatelessWidget {
  final CartInfoModel cartInfoModel;

  CartItem({this.cartInfoModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
      padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 0.5, color: Colors.black12)),
          color: Colors.white),
      child: Row(
        children: <Widget>[
          _cartCheckBtn(context, cartInfoModel),
          _cartImage(),
          _cartGoodsName(),
          _cartPrice(context),
        ],
      ),
    );
  }

  // 多选按钮
  Widget _cartCheckBtn(context, CartInfoModel cartInfoModel) {
    return Container(
      child: Checkbox(
        value: cartInfoModel.isCheck,
        activeColor: Colors.pink,
        onChanged: (bool val) {
          cartInfoModel.isCheck = val;
          Provide.value<CartProvide>(context).changeCheckState(cartInfoModel);
        },
      ),
    );
  }

  // 商品图片
  Widget _cartImage() {
    return Container(
      width: ScreenUtil().setWidth(150),
      padding: EdgeInsets.all(3.0),
      decoration:
          BoxDecoration(border: Border.all(width: 0.5, color: Colors.black12)),
      child: Image.network(cartInfoModel.images),
    );
  }

  // 商品名称
  Widget _cartGoodsName() {
    return Container(
      width: ScreenUtil().setWidth(300),
      padding: EdgeInsets.all(10.0),
      alignment: Alignment.topLeft,
      child: Column(
        children: <Widget>[
          Text(cartInfoModel.goodsName),
          CartCount(item: cartInfoModel,),
        ],
      ),
    );
  }

  // 商品价格
  Widget _cartPrice(context) {
    return Container(
      width: ScreenUtil().setWidth(150),
      alignment: Alignment.centerRight,
      child: Column(
        children: <Widget>[
          Text('¥${cartInfoModel.price}'),
          Container(
            child: InkWell(
              onTap: () {
                Provide.value<CartProvide>(context).deleteOneGoods(cartInfoModel.goodsId);
              },
              child: Icon(
                Icons.delete_forever,
                color: Colors.black12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
