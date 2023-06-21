import 'package:flutter/material.dart';
import 'package:my_shop/providers/products.dart';
import 'package:my_shop/screens/edit_product_screen.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';

class UserProductItem extends StatelessWidget {
  const UserProductItem({super.key});

  void notifyUserAboutDelete(BuildContext context, Function() removeItem) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text("Ishonchingiz komilmi?"),
            content: const Text("Mahsulot o'chmoqda!"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  "Bekor qilish",
                  style: TextStyle(color: Colors.black54),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  removeItem();
                  Navigator.of(context).pop();
                },
                child: const Text("O'chirish"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).errorColor,
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final scaffoldmessenger = ScaffoldMessenger.of(context);
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(product.imageURL),
        ),
        title: Text(product.title),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  EditProductScreen.routeName,
                  arguments: product.id,
                );
              },
              icon: Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              onPressed: () {
                notifyUserAboutDelete(context, () async {
                  try {
                    await Provider.of<Products>(context, listen: false)
                        .deleteProduct(product.id);
                  } catch (e) {
                    scaffoldmessenger.showSnackBar(
                      SnackBar(
                        content: Text(
                          e.toString(),
                        ),
                      ),
                    );
                  }
                });
              },
              icon: Icon(Icons.delete),
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
