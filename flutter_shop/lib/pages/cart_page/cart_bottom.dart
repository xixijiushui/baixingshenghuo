import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import 'package:flutter_shop/provide/cart.dart';

class CartBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.0),
      color: Colors.white,
      child: Provide<CartProvide>(
        builder: (context, child, cartProvide) {
          return Row(
            children: <Widget>[
              _selectAllBtn(context),
              _allPriceArea(context),
              _goButton(context),
            ],
          );
        },
      ),
    );
  }

  Widget _selectAllBtn(context) {
    bool isAllCheck = Provide.value<CartProvide>(context).isAllCheck;
    return Container(
      child: Row(
        children: <Widget>[
          Checkbox(
            value: isAllCheck,
            activeColor: Colors.pink,
            onChanged: (bool val) {
              Provide.value<CartProvide>(context).changeAllCheckBtnState(val);
            },
          ),
          Text('全选')
        ],
      ),
    );
  }

  Widget _allPriceArea(context) {
    double allPrice = Provide.value<CartProvide>(context).allPrice;
    return Container(
      width: ScreenUtil().setWidth(430),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                alignment: Alignment.centerRight,
                width: ScreenUtil().setWidth(230),
                child: Text(
                  '合计:',
                  style: TextStyle(fontSize: ScreenUtil().setSp(36)),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                width: ScreenUtil().setWidth(200),
                child: Text(
                  '¥ $allPrice',
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(36), color: Colors.red),
                ),
              )
            ],
          ),
          Container(
            width: ScreenUtil().setWidth(430),
            alignment: Alignment.centerRight,
            child: Text(
              '满10元免配送费, 预购免配送费',
              style: TextStyle(
                  color: Colors.black38, fontSize: ScreenUtil().setSp(22)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _goButton(context) {
    int allCount = Provide.value<CartProvide>(context).allGoodsCount;
    return Container(
      width: ScreenUtil().setWidth(160),
      padding: EdgeInsets.only(left: 10.0),
      child: InkWell(
        onTap: () {},
        child: Container(
          padding: EdgeInsets.all(10.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.red, borderRadius: BorderRadius.circular(3.0)),
          child: Text(
            '结算($allCount)',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
