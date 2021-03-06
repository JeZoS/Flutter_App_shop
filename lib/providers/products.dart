import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shop_ss/models/http_exception.dart';
import 'package:shop_ss/providers/product.dart';
import 'package:http/http.dart' as http;
import "dart:convert";

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //     id: 'p1',
    //     title: 'Red shirt',
    //     description: 'A red shirt - pretty red',
    //     price: 29.99,
    //     imageUrl:
    //         'https://www.lifesizecutouts.com.au/media/catalog/product/cache/2/image/650x650/9df78eab33525d08d6e5fb8d27136e95/e/m/eminemin-red-shirt-cutout-ref.jpg'),
    // Product(
    //   id: 'p2',
    //   title: 'Trouser',
    //   description: 'A very nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://www.cottonking.com/2929-home_default/trouser-non-pleated-31793.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Scarf yellow',
    //   description: 'Warm and cozy - just like your bhoji',
    //   price: 19.99,
    //   imageUrl:
    //       'https://i.etsystatic.com/16164457/d/il/d29afe/1346737370/il_340x270.1346737370_67pk.jpg?version=0',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A pan',
    //   description: 'For headshot purpose',
    //   price: 49.99,
    //   imageUrl:
    //       'https://images-na.ssl-images-amazon.com/images/I/51rgqqbXSaL._SX425_.jpg',
    // )
  ];

  final String token;
  final String userId;

  Products(this.token, this._items, this.userId);

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

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filter = filterByUser ? 'orderBy="createrId"&equalTo="$userId"' : '';
    final url =
        'https://shop-ss.firebaseio.com/products.json?auth=$token&$filter';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      print(extractedData);
      final List<Product> loadedProducts = [];
      if (extractedData == null) {
        return;
      }
      final url1 =
          'https://shop-ss.firebaseio.com/userFavourites/$userId.json?auth=$token';
      final favouriteResponse = await http.get(url1);
      final favouriteData = json.decode(favouriteResponse.body);
      print('tofu');
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          imageUrl: prodData['imageUrl'],
          isFavourite: favouriteData == null
              ? false
              : favouriteData[prodId] == null
                  ? false
                  : favouriteData[prodId],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw errorPropertyTextConfiguration;
    }
  }

  Future<void> addProduct(Product prod) {
    final url = 'https://shop-ss.firebaseio.com/products.json?auth=$token';
    return http
        .post(
      url,
      body: json.encode({
        'title': prod.title,
        'description': prod.description,
        'imageUrl': prod.imageUrl,
        'price': prod.price,
        'createrId': userId,
      }),
    )
        .then((response) {
      final product = Product(
        id: json.decode(response.body)['name'],
        title: prod.title,
        description: prod.description,
        price: prod.price,
        imageUrl: prod.imageUrl,
      );
      _items.add(product);
      notifyListeners();
    }).catchError((error) {
      throw error;
    });
  }

  void updateProduct(String id, Product prod) async {
    final index = _items.indexWhere((element) => element.id == id);
    if (index >= 0) {
      final url =
          'https://shop-ss.firebaseio.com/products/$id.json?auth=$token';
      await http.patch(url,
          body: json.encode({
            'title': prod.title,
            'description': prod.description,
            'price': prod.price,
            'imageUrl': prod.imageUrl,
            //'isFavourite':prod.isFavourite,
          }));
      _items[index] = prod;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = 'https://shop-ss.firebaseio.com/products/$id.json?auth=$token';
    final existingProductIndex =
        _items.indexWhere((element) => element.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product');
    }
    existingProduct = null;
  }
}
