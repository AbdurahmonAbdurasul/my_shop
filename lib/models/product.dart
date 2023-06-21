import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageURL;
  bool isFavourite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageURL,
    this.isFavourite = false,
  });

  Future<void> toggleisFavourite(String token, String userId) async {
    final oldFavourite = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();

    final url = Uri.parse(
        "https://flutter-app-5a0b8-default-rtdb.firebaseio.com/userFavourites/$userId/$id.json?auth=$token");
    try {
      final response = await http.put(
        url,
        body: jsonEncode(
          isFavourite,
        ),
      );
      if (response.statusCode >= 400) {
        isFavourite = oldFavourite;
        notifyListeners();
      }
    } catch (e) {
      isFavourite = oldFavourite;
      notifyListeners();
    }
  }
}
