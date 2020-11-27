import 'package:flutter/material.dart';
import 'package:shop_ss/providers/product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
        id: 'p1',
        title: 'Red shirt',
        description: 'A red shirt - pretty red',
        price: 29.99,
        imageUrl:
            'https://www.lifesizecutouts.com.au/media/catalog/product/cache/2/image/650x650/9df78eab33525d08d6e5fb8d27136e95/e/m/eminemin-red-shirt-cutout-ref.jpg'),
    Product(
      id: 'p2',
      title: 'Trouser',
      description: 'A very nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://www.cottonking.com/2929-home_default/trouser-non-pleated-31793.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Scarf yellow',
      description: 'Warm and cozy - just like your bhoji',
      price: 19.99,
      imageUrl:
          'https://i.etsystatic.com/16164457/d/il/d29afe/1346737370/il_340x270.1346737370_67pk.jpg?version=0',
    ),
    Product(
      id: 'p4',
      title: 'A pan',
      description: 'For headshot purpose',
      price: 49.99,
      imageUrl:
          'https://images-na.ssl-images-amazon.com/images/I/51rgqqbXSaL._SX425_.jpg',
    )
  ];

  var _isFavourite = false;

  List<Product> get fav {
    return _items.where((element) => element.isFavourite).toList();
  }

  List<Product> get items {
    if (_isFavourite) {
      return _items.where((element) => element.isFavourite).toList();
    }
    return [..._items];
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  void showFavourites() {
    // _isFavourite = true;
    // notifyListeners();
  }

  void showAll() {
    // _isFavourite = false;
    // notifyListeners();
  }

  void addProduct(Product prod) {
    final product = Product(
      id: DateTime.now().toString(),
      title: prod.title,
      description: prod.description,
      price: prod.price,
      imageUrl: prod.imageUrl,
    );
    _items.add(product);
    notifyListeners();
  }

  void updateProduct(String id, Product prod) {
    final index = _items.indexWhere((element) => element.id == id);
    if (index >= 0) {
      _items[index] = prod;
      notifyListeners();
    } else {
      print('...');
    }
  }

  void deleteProduct(String id) {
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}
