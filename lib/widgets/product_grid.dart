import 'package:flutter/material.dart';
import 'package:shop_ss/providers/products.dart';
import './product_item.dart';
import 'package:provider/provider.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavs;

  ProductGrid(this.showFavs);

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    final loadedProduct = showFavs ? productData.fav : productData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: loadedProduct.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: loadedProduct[i],
        child: ProductItem(
            // loadedProduct[i].id,
            // loadedProduct[i].imageUrl,
            // loadedProduct[i].title,
            ),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
