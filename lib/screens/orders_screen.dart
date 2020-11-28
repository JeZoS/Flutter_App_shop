import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_ss/providers/orders.dart';
import 'package:shop_ss/widgets/app_drawer.dart';
import '../widgets/order_item.dart' as ord;

class OrderScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  var _isLoading = false;
  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    Future.delayed(Duration.zero)
        .then((value) =>
            Provider.of<Orders>(context, listen: false).fetchAndSetOrders())
        .then((value) {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemBuilder: (ctx, index) =>
                  ord.OrderItem(orderData.orders[index]),
              itemCount: orderData.orders.length,
            ),
    );
  }
}
