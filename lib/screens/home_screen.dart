import 'package:flutter/material.dart';
import 'package:my_shop/providers/products.dart';
import 'package:my_shop/screens/cart_screen.dart';
import 'package:my_shop/widgets/app_drawer.dart';
import 'package:my_shop/widgets/custom_cart.dart';
import '../widgets/products_grid.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

enum FiltersOption {
  Favourites,
  All,
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const routeName = "/home";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var showOnlyFavourites = false;
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Mening do'konim"),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            onSelected: (FiltersOption filter) {
              setState(() {
                if (filter == FiltersOption.All) {
                  showOnlyFavourites = false;
                } else {
                  showOnlyFavourites = true;
                }
              });
            },
            itemBuilder: (ctx) {
              return [
                PopupMenuItem(
                  child: const Text("Barchasi"),
                  value: FiltersOption.All,
                ),
                PopupMenuItem(
                  child: const Text("Sevimli"),
                  value: FiltersOption.Favourites,
                ),
              ];
            },
          ),
          Consumer<Cart>(
            builder: (context, cart, child) {
              return CustomCart(
                child: child!,
                number: cart.itemsCount().toString(),
              );
            },
            child: IconButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(CartScreen.routeName),
              icon: Icon(Icons.shopping_cart),
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: ProductsGrid(showOnlyFavourites),
    );
  }
}
