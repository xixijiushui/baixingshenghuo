import 'package:flutter/material.dart';
import 'package:flutter_shop/pages/index_page.dart';
import 'package:provide/provide.dart';
import 'package:flutter_shop/provide/content.dart';
import 'package:flutter_shop/provide/child_category.dart';
import 'package:flutter_shop/provide/category_goods_list.dart';
import 'package:flutter_shop/provide/details_info.dart';
import 'package:flutter_shop/provide/cart.dart';
import 'package:flutter_shop/provide/current_index.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter_shop/routers/routes.dart';
import 'package:flutter_shop/routers/application.dart';

void main() {
  var counter = Counter();
  var childCategory = ChildCategory();
  var categoryGoodsList = CategoryGoodsListProvide();
  var detailsInfoProvide = DetailsInfoProvide();
  var cartProvide = CartProvide();
  var currentIndexProvide = CurrentIndexProvide();
  var providers = Providers();

  providers
    ..provide(Provider<Counter>.value(counter))
    ..provide(Provider<ChildCategory>.value(childCategory))
    ..provide(Provider<CategoryGoodsListProvide>.value(categoryGoodsList))
    ..provide(Provider<DetailsInfoProvide>.value(detailsInfoProvide))
    ..provide(Provider<CartProvide>.value(cartProvide))
    ..provide(Provider<CurrentIndexProvide>.value(currentIndexProvide));
  runApp(ProviderNode(child: MyApp(), providers: providers));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final router = Router();
    Routes.configureRoutes(router);
    Application.router = router;

    return Container(
      child: MaterialApp(
        title: '百姓生活+',
        onGenerateRoute: Application.router.generator,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: Colors.pink),
        home: IndexPage(),
      ),
    );
  }
}
