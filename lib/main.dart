import 'package:flutter/material.dart';
import 'package:my_shop/providers/products.dart';
import 'package:my_shop/screens/cart_screen.dart';
import 'package:my_shop/screens/edit_product_screen.dart';
import 'package:my_shop/screens/manage_products_screen.dart';
import 'package:my_shop/screens/orders_screen.dart';
import 'package:my_shop/screens/product_details_screen.dart';
import 'package:my_shop/screens/splash-screen.dart';
import 'package:my_shop/styles/my_shop_style.dart';
import 'package:provider/provider.dart';
import '../screens/home_screen.dart';
import 'styles/my_shop_style.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './providers/auth.dart';
import './screens/auth_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  ThemeData theme = MyShopStyle.theme;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<Auth>(
            create: (context) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            create: (context) => Products(),
            update: (context, auth, previousProducts) =>
                previousProducts!..setParams(auth.token, auth.userId),
          ),
          ChangeNotifierProvider<Cart>(
            create: (context) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            create: (context) => Orders(),
            update: (context, auth, previousOrders) =>
                previousOrders!..setParams(auth.token, auth.userId),
          ),
        ],
        child: Consumer<Auth>(builder: (context, authData, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Mening Do'konim",
            theme: theme,
            home: authData.isAuth
                ? const HomeScreen()
                : FutureBuilder(
                    future: authData.autoLogin(),
                    builder: (ctx, autoLoginData) {
                      if (autoLoginData.connectionState ==
                          ConnectionState.waiting) {
                        return SplashScreen();
                      } else {
                        return const AuthScreen();
                      }
                    }),
            //initialRoute: HomeScreen.routeName,
            routes: {
              ProductDetailsScreen.routeName: (context) =>
                  ProductDetailsScreen(),
              CartScreen.routeName: (context) => CartScreen(),
              OrdersScreen.routeName: (context) => OrdersScreen(),
              HomeScreen.routeName: (context) => HomeScreen(),
              ManageProductsScreen.routeName: (context) =>
                  ManageProductsScreen(),
              EditProductScreen.routeName: (context) => EditProductScreen(),
            },
          );
        }));
  }
}
