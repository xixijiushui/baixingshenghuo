import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shop/provide/details_info.dart';
import 'package:flutter_html/flutter_html.dart';

class DetailsWeb extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provide<DetailsInfoProvide>(
      builder: (context, child, detailsInfoProvide) {
        var isLeft = detailsInfoProvide.isLeft;
        if (isLeft) {
          return Container(
            child: Html(
              // data: detailsInfoProvide.goodsInfoModel.data.goodInfo.goodsDetail,
              data: detailsInfoProvide.goodsInfoModel.data.goodInfo.goodsDetail.replaceAll('width="100%"', '').replaceAll('height="auto"', ''),
            ),
          );
        } else {
          return Container(
            width: ScreenUtil().setWidth(740),
            padding: EdgeInsets.all(10.0),
            alignment: Alignment.center,
            child: Text('暂时没有数据'),
          );
        }
      },
    );
  }
}
