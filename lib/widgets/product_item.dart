import 'package:flutter/material.dart';
import 'package:shop_ss/providers/auth.dart';
import 'package:shop_ss/providers/cart.dart';
import 'package:shop_ss/providers/product.dart';
import 'package:shop_ss/screens/product_detail_screen.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;

  // ProductItem(this.id, this.imageUrl, this.title);

  @override
  Widget build(BuildContext context) {
    final prod = Provider.of<Product>(context, listen: false);
    final crt = Provider.of<Cart>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: prod.id,
            );
          },
          child: Image.network(
            prod.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (context, prod, child) => IconButton(
              icon: Icon(
                prod.isFavourite ? Icons.favorite : Icons.favorite_border,
              ),
              onPressed: () => prod.toggleFavourote(auth.token, auth.userId),
              color: Theme.of(context).accentColor,
            ),
          ),
          title: Text(
            prod.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.shopping_cart,
            ),
            color: Theme.of(context).accentColor,
            onPressed: () {
              crt.addItem(prod.id, prod.price, prod.title);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Item added',
                    //textAlign: TextAlign.center,
                  ),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      crt.removeSingleItem(prod.id);
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
