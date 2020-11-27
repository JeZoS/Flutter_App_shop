import 'package:flutter/material.dart';
import 'package:shop_ss/providers/cart.dart';
import 'package:shop_ss/providers/products.dart';
import 'package:shop_ss/screens/cart_screen.dart';
import 'package:shop_ss/widgets/app_drawer.dart';
import 'package:shop_ss/widgets/badge.dart';
import '../widgets/product_grid.dart';
import 'package:provider/provider.dart';

enum FilterOptions {
  Favourite,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showFavourites = false;
  var _isLoading = false;

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    //Provider.of<Products>(context, listen: false).fetchAndSetProducts();
    Future.delayed(Duration.zero).then((value) {
      Provider.of<Products>(context).fetchAndSetProducts().then((value) {
        setState(() {
          _isLoading = false;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My shop'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              if (selectedValue == FilterOptions.Favourite) {
                setState(() {
                  _showFavourites = !_showFavourites;
                });
              } else {
                setState(() {
                  _showFavourites = !_showFavourites;
                });
              }
            },
            icon: Icon(
              Icons.more_vert,
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('only Favs'),
                value: FilterOptions.Favourite,
              ),
              PopupMenuItem(
                child: Text('Show all'),
                value: FilterOptions.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.route);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(_showFavourites),
    );
  }
}
