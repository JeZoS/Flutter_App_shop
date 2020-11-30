import 'package:flutter/material.dart';
import 'package:shop_ss/providers/auth.dart';
import 'package:shop_ss/providers/cart.dart';
import 'package:shop_ss/providers/orders.dart';
import 'package:shop_ss/screens/cart_screen.dart';
import 'package:shop_ss/screens/edit_product.dart';
import 'package:shop_ss/screens/orders_screen.dart';
import 'package:shop_ss/screens/product_detail_screen.dart';
import 'package:shop_ss/screens/products_overview_screen.dart';
import 'package:provider/provider.dart';
import 'package:shop_ss/screens/user_products_screen.dart';
import './providers/products.dart';
import './screens/auth_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Products(),
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (_) => Orders(),
        ),
        ChangeNotifierProvider(
          create: (_) => Auth(),
        )
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'My_shop',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
          home: auth.isAuth ? ProductsOverviewScreen() : AuthScreen(),
          routes: {
            '/products-overview': (ctx) => ProductsOverviewScreen(),
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.route: (ctx) => CartScreen(),
            OrderScreen.routeName: (ctx) => OrderScreen(),
            UserProductScreen.routeName: (ctx) => UserProductScreen(),
            EditProduct.routeName: (ctx) => EditProduct()
          },
        ),
      ),
    );
  }
}
