import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:my_shop/services/http_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _autoLogoutTimer;

  static const apiKey = "AIzaSyCAbLcGuTnvWdb3UoRJY4Pp41V32P3RsqM";

  bool get isAuth {
    return _token != null;
  }

  String? get userId {
    return _userId;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      //token bor
      return _token;
    }
    //token yoq
    return null;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url = Uri.parse(
      "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=$apiKey",
    );
    try {
      final response = await http.post(
        url,
        body: jsonEncode(
          {
            "email": email,
            "password": password,
            "returnSecureToken": true,
          },
        ),
      );
      final data = jsonDecode(response.body);
      if (data["error"] != null) {
        throw HttpException(data["error"]["message"]);
      }
      _token = data["idToken"];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(data["expiresIn"]),
        ),
      );
      _userId = data['localId'];
      _autoLogout();
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final userData = jsonEncode({
        "token": _token,
        "userId": _userId,
        "expiryDate": _expiryDate!.toIso8601String(),
      });
      prefs.setString("userData", userData);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, "signUp");
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, "signInWithPassword");
  }

  Future<bool> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("userData")) {
      return false;
    }
    final userData =
        jsonDecode(prefs.getString("userData")!) as Map<String, dynamic>;
    final expiryData = DateTime.parse(userData["expiryDate"]);

    if (expiryData.isBefore(DateTime.now())) {
      //token muddati tugagan
      return false;
    }
    //token muddati tugamagan
    _token = userData["token"];
    _userId = userData["userId"];
    _expiryDate = userData["expiryDate"];
    notifyListeners();
    _autoLogout();
    return true;
  }

  void logout() async {
    _token = null;
    _expiryDate = null;
    _userId = null;
    if (_autoLogoutTimer != null) {
      _autoLogoutTimer!.cancel();
      _autoLogoutTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    //prefs.remove("userData"); faqat bir malumoti ochirish
    prefs.clear();
  }

  void _autoLogout() {
    if (_autoLogoutTimer != null) {
      _autoLogoutTimer!.cancel();
    }
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _autoLogoutTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
