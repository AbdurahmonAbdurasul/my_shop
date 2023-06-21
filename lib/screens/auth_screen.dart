import 'package:flutter/material.dart';
import 'package:my_shop/services/http_exception.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';

enum AuthMode { Login, Register }

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  static const routeName = "/auth";
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  AuthMode authMode = AuthMode.Login;
  final passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  var loading = false;
  Map<String, String> authData = {
    "email": "",
    "password": "",
  };

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text("Xatolik!"),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: const Text("Ok"),
              )
            ],
          );
        });
  }

  Future<void> submit() async {
    if (formKey.currentState!.validate()) {
      //save form
      formKey.currentState!.save();
      setState(() {
        loading = true;
      });
      try {
        if (authMode == AuthMode.Login) {
          //login user
          await Provider.of<Auth>(context, listen: false).login(
            authData["email"]!,
            authData["password"]!,
          );
        } else {
          //register user
          await Provider.of<Auth>(context, listen: false).signUp(
            authData["email"]!,
            authData["password"]!,
          );
        }
      } on HttpException catch (error) {
        var errorMessage = "Xatolik sodir bo'ldi";
        if (error.message.contains("EMAIL_EXISTS")) {
          errorMessage = "Email band.";
        } else if (error.message.contains("INVALID_EMAIL")) {
          errorMessage = "To'g'ri email kiriting.";
        } else if (error.message.contains("WEAK_PASSWORD")) {
          errorMessage = "Parol juda oson.";
        } else if (error.message.contains("EMAIL_NOT_FOUND")) {
          errorMessage = "Bu emailli foydalanuvchi yo'q.";
        } else if (error.message.contains("INVALID_PASSWORD")) {
          errorMessage = "Parol noto'g'ri.";
        }
        _showErrorDialog(errorMessage);
      } catch (e) {
        var errorMessage = "Xatolik sodir bo'ldi.Qaytadan urinib ko'ring.";
        _showErrorDialog(errorMessage);
      }
      setState(() {
        loading = false;
      });
    }
  }

  void switchAuthMode() {
    if (authMode == AuthMode.Login) {
      setState(() {
        authMode = AuthMode.Register;
      });
    } else {
      setState(() {
        authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(35.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Image.asset(
                  "assets/images/logo2.png",
                  fit: BoxFit.cover,
                  //width: 300,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Email adresingiz",
                  ),
                  validator: (email) {
                    if (email == null || email.isEmpty) {
                      return "Email manzil kiriting";
                    } else if (!email.contains("@")) {
                      return "Email noto'g'ri";
                    }
                  },
                  onSaved: (email) {
                    authData["email"] = email!;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Parol",
                  ),
                  obscureText: true,
                  controller: passwordController,
                  validator: (password) {
                    if (password == null || password.isEmpty) {
                      return "Parol kiriting.";
                    } else if (password.length < 6) {
                      return "Parol juda qisqa.";
                    }
                  },
                  onSaved: (password) {
                    authData["password"] = password!;
                  },
                ),
                if (authMode == AuthMode.Register)
                  Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Parolni tasdiqlang",
                        ),
                        obscureText: true,
                        validator: (confirmedPassword) {
                          if (passwordController.text != confirmedPassword) {
                            return "Parollar bir xil emas";
                          }
                        },
                      ),
                    ],
                  ),
                const SizedBox(
                  height: 50,
                ),
                loading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: submit,
                        child: Text(authMode == AuthMode.Login
                            ? "Kirish"
                            : "Ro'yhatdan o'tish"),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                      ),
                const SizedBox(
                  height: 35,
                ),
                TextButton(
                  onPressed: switchAuthMode,
                  child: Text(
                    authMode == AuthMode.Login ? "Ro'yhatdan o'tish" : "Kirish",
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
