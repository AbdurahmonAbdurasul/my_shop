import 'package:flutter/material.dart';
import 'package:my_shop/screens/edit_product_screen.dart';
import 'package:my_shop/widgets/app_drawer.dart';
import 'package:my_shop/widgets/user_product_item.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

class ManageProductsScreen extends StatelessWidget {
  const ManageProductsScreen({super.key});

  static const routeName = "/manage-product";

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .getProductsFromFirebase(true);
  }

  @override
  Widget build(BuildContext context) {
    //final productProvider = Provider.of<Products>(context);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Mahsulotlarni boshqarish"),
          actions: [
            IconButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(EditProductScreen.routeName),
              icon: Icon(Icons.add),
            ),
          ],
        ),
        drawer: const AppDrawer(),
        body: FutureBuilder(
            future: _refreshProducts(context),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.connectionState == ConnectionState.done) {
                return RefreshIndicator(
                  onRefresh: () => _refreshProducts(context),
                  child: Consumer<Products>(
                    builder: (c, productProvider, _) {
                      return ListView.builder(
                        padding: const EdgeInsets.all(11),
                        itemCount: productProvider.list.length,
                        itemBuilder: (ctx, i) {
                          final product = productProvider.list[i];
                          return ChangeNotifierProvider.value(
                              value: product, child: UserProductItem());
                        },
                      );
                    },
                  ),
                );
              } else {
                return Center(
                  child: Text("Xatolik bo'ldi!"),
                );
              }
            }));
  }
}
