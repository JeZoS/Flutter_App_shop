import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_ss/screens/edit_product.dart';
import 'package:shop_ss/widgets/app_drawer.dart';
import '../providers/products.dart';
import '../widgets/user_product_item.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _refresh(context) async {
    await Provider.of<Products>(context).fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    final prod = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Products',
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProduct.routeName);
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refresh(context),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            itemBuilder: (ctx, index) => Column(
              children: [
                UserProductItem(
                  prod.items[index].id,
                  prod.items[index].imageUrl,
                  prod.items[index].title,
                ),
                Divider(),
              ],
            ),
            itemCount: prod.items.length,
          ),
        ),
      ),
    );
  }
}
