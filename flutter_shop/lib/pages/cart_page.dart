import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import 'package:flutter_shop/provide/cart.dart';
import 'package:flutter_shop/pages/cart_page/cart_item.dart';
import 'package:flutter_shop/pages/cart_page/cart_bottom.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<String> testList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('购物车'),
      ),
      body: FutureBuilder(
        future: _getCartInfo(context),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // List cartList = Provide.value<CartProvide>(context).cartList;
            return Stack(
              children: <Widget>[
                Provide<CartProvide>(
                  builder: (context, child, cartProvide) {
                    return ListView.builder(
                      itemCount: cartProvide.cartList.length,
                      itemBuilder: (context, index) {
                        return CartItem(
                          cartInfoModel: cartProvide.cartList[index],
                        );
                      },
                    );
                  },
                ),
                Positioned(
                  bottom: MediaQuery.of(context).padding.bottom,
                  left: 0,
                  child: CartBottom(),
                ),
              ],
            );
          } else {
            return Text('正在加载');
          }
        },
      ),
    );
  }

  Future<String> _getCartInfo(BuildContext context) async {
    await Provide.value<CartProvide>(context).getCartInfo();
    return 'end';
  }
}
