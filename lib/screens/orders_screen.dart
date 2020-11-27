import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_ss/providers/orders.dart';
import 'package:shop_ss/widgets/app_drawer.dart';
import '../widgets/order_item.dart' as ord;

class OrderScreen extends StatelessWidget {
  static const routeName = '/orders';
  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemBuilder: (ctx, index) => ord.OrderItem(orderData.orders[index]),
        itemCount: orderData.orders.length,
      ),
    );
  }
}
