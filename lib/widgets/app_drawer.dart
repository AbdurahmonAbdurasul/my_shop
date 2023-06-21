import 'package:flutter/material.dart';
import 'package:my_shop/providers/auth.dart';
import 'package:my_shop/screens/home_screen.dart';
import 'package:my_shop/screens/manage_products_screen.dart';
import 'package:my_shop/screens/orders_screen.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: const Text("Salom Do'stim"),
          ),
          ListTile(
            leading: Icon(
              Icons.shop,
              color: Colors.black,
            ),
            title: Text(
              "Magazin",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(HomeScreen.routeName),
          ),
          const Divider(),
          ListTile(
            leading: Icon(
              Icons.payment,
              color: Colors.black,
            ),
            title: Text(
              "Buyurtmalar",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(OrdersScreen.routeName),
          ),
          const Divider(),
          ListTile(
            leading: Icon(
              Icons.settings,
              color: Colors.black,
            ),
            title: Text(
              "Mahsulotlarni boshqarish",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(ManageProductsScreen.routeName),
          ),
          const Divider(),
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
              color: Colors.black,
            ),
            title: Text(
              "Chiqish",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed("/");
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
