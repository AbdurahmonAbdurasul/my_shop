import 'package:flutter/material.dart';
import 'package:my_shop/services/http_exception.dart';
import '../models/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Products with ChangeNotifier {
  List<Product> _list = [
    // Product(
    //   id: "p1",
    //   title: "Lenovo Ideapad 3",
    //   description:
    //       "Ajoyib Lenovo Ideapad 3 kompyuteri.Speedy processing, great for everyday work & play 15.6 entry-level laptop you can count on FHD display, numeric keypad, physical webcam privacy shutter Speedy processing, great for everyday work & play 15.6 entry-level laptop you can count on FHD display, numeric keypad, physical webcam privacy shutter Speedy processing, great for everyday work & play 15.6 entry-level laptop you can count on FHD display, numeric keypad, physical webcam privacy shutter Speedy processing, great for everyday work & play 15.6 entry-level laptop you can count on FHD display, numeric keypad, physical webcam privacy shutter Speedy processing, great for everyday work & play 15.6 entry-level laptop you can count on FHD display, numeric keypad, physical webcam privacy shutter Speedy processing, great for everyday work & play 15.6 entry-level laptop you can count on FHD display, numeric keypad, physical webcam privacy shutter Speedy processing, great for everyday work & play 15.6 entry-level laptop you can count on FHD display, numeric keypad, physical webcam privacy shutter Speedy processing, great for everyday work & play 15.6 entry-level laptop you can count on FHD display, numeric keypad, physical webcam privacy shutter",
    //   price: 799,
    //   imageURL:
    //       "https://kattabozor.s3.eu-central-1.amazonaws.com/ri/8b8f790c1c9e2b798f2908fcc74f27b36659c1b2ca4e0bc76857359fafeb801e_gQIS6U_480l.jpg",
    // ),
    // Product(
    //   id: "p2",
    //   title: "Redmi Note 11",
    //   description: "Ajoyib Redmi Note 11 telefoni",
    //   price: 219,
    //   imageURL:
    //       "https://i01.appmifile.com/webfile/globalimg/Iris/redmi-note-11-black!800x800!85.png",
    // ),
    // Product(
    //   id: "p3",
    //   title: "Huawei Band 6",
    //   description: "Ajoyib Huawei Band 6 soati",
    //   price: 39,
    //   imageURL:
    //       "https://zoodmall.com/cdn-cgi/image/w=500,fit=contain,f=auto/https://deep-review.com/wp-content/uploads/2021/05/huawei-band-6-design-289x300.jpg",
    // ),
  ];

  String? _authToken;
  String? _userId;

  void setParams(String? authToken, String? userId) {
    _authToken = authToken;
    _userId = userId;
  }

  List<Product> get list {
    return [..._list];
  }

  List<Product> get favourite {
    return _list.where((product) => product.isFavourite).toList();
  }

  Future<void> getProductsFromFirebase([bool filterByUser = false]) async {
    String filterString =
        filterByUser ? "orderBy'creatorId'&equalTo='$_userId'" : '';
    final url = Uri.parse(
        "https://flutter-app-5a0b8-default-rtdb.firebaseio.com/products.json?auth=$_authToken&$filterString");
    try {
      final response = await http.get(url);
      if (jsonDecode(response.body) != null) {
        final favouriteUrl = Uri.parse(
            "https://flutter-app-5a0b8-default-rtdb.firebaseio.com/userFavourites/$_userId.json?auth=$_authToken");

        final favouriteResponse = await http.get(favouriteUrl);
        final favouriteData = jsonDecode(favouriteResponse.body);

        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final List<Product> loadedProducts = [];
        data.forEach((productId, productData) {
          loadedProducts.add(
            Product(
              id: productId,
              title: productData["title"],
              description: productData["description"],
              price: productData["price"],
              imageURL: productData["imageUrl"],
              isFavourite: favouriteData == null
                  ? false
                  : favouriteData[productId] ?? false,
            ),
          );
        });
        _list = loadedProducts;
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        "https://flutter-app-5a0b8-default-rtdb.firebaseio.com/products.json?auth=$_authToken");

    //return
    try {
      final response = await http.post(
        url,
        body: jsonEncode(
          {
            "title": product.title,
            "description": product.description,
            "price": product.price,
            "imageUrl": product.imageURL,
            "creatorId": _userId,
          },
        ),
      );
      //.then((response) {
      final name = (jsonDecode(response.body) as Map<String, dynamic>)["name"];
      final newProduct = Product(
        id: name,
        title: product.title,
        description: product.description,
        price: product.price,
        imageURL: product.imageURL,
      );
      _list.add(newProduct);
      notifyListeners();
      // }).catchError((error) {
      //   throw error;
      // });
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(Product updatedProduct) async {
    final productIndex =
        _list.indexWhere((product) => product.id == updatedProduct.id);
    if (productIndex >= 0) {
      try {
        final url = Uri.parse(
            "https://flutter-app-5a0b8-default-rtdb.firebaseio.com/products/${updatedProduct.id}.json?auth=$_authToken");
        await http.patch(url,
            body: jsonEncode({
              "title": updatedProduct.title,
              "description": updatedProduct.description,
              "imageUrl": updatedProduct.imageURL,
              "price": updatedProduct.price,
            }));
        _list[productIndex] = updatedProduct;
        notifyListeners();
      } catch (e) {
        rethrow;
      }
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        "https://flutter-app-5a0b8-default-rtdb.firebaseio.com/products/$id.json?auth=$_authToken");
    try {
      final deletingProduct = _list.firstWhere((product) => product.id == id);
      final productIndex = _list.indexWhere((product) => product.id == id);
      _list.removeWhere((product) => product.id == id);
      notifyListeners();

      final response = await http.delete(url);
      if (response.statusCode >= 400) {
        _list.insert(productIndex, deletingProduct);
        notifyListeners();
        throw HttpException("O'chirishda hatolik!");
      }
    } catch (e) {
      rethrow;
    }
  }

  Product findById(String productId) {
    return _list.firstWhere((product) => product.id == productId);
  }
}
