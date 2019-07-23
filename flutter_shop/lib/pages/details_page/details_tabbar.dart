import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shop/provide/details_info.dart';

class DetailsTabbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provide<DetailsInfoProvide>(
      builder: (context, child, detailsInfoProvide) {
        var isLeft = detailsInfoProvide.isLeft;
        var isRight = detailsInfoProvide.isRight;
        return Container(
          margin: EdgeInsets.only(top: 15.0),
          child: Row(
            children: <Widget>[
              _myTabbarLeft(context, isLeft),
              _myTabbarRight(context, isRight),
            ],
          ),
        );
      },
    );
  }

  Widget _myTabbarLeft(BuildContext context, bool isLeft) {
    return InkWell(
      onTap: () {
        Provide.value<DetailsInfoProvide>(context).changeLeftAndRight('left');
      },
      child: Container(
        padding: EdgeInsets.all(10.0),
        alignment: Alignment.center,
        width: ScreenUtil().setWidth(375),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom: BorderSide(
                  color: isLeft ? Colors.pink : Colors.black12, width: 0.5)),
        ),
        child: Text(
          '详情',
          style: TextStyle(color: isLeft ? Colors.pink : Colors.black),
        ),
      ),
    );
  }

  Widget _myTabbarRight(BuildContext context, bool isRight) {
    return InkWell(
      onTap: () {
        Provide.value<DetailsInfoProvide>(context).changeLeftAndRight('right');
      },
      child: Container(
        padding: EdgeInsets.all(10.0),
        alignment: Alignment.center,
        width: ScreenUtil().setWidth(375),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom: BorderSide(
                  color: isRight ? Colors.pink : Colors.black12, width: 0.5)),
        ),
        child: Text(
          '评论',
          style: TextStyle(color: isRight ? Colors.pink : Colors.black),
        ),
      ),
    );
  }
}
