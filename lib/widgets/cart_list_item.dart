import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../providers/cart.dart';

class CartListItem extends StatelessWidget {
  final String productId;
  final String imageUrl;
  final String title;
  final double price;
  final int quantity;
  const CartListItem({
    super.key,
    required this.productId,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.quantity,
  });

  void notifyUserAboutDelete(BuildContext context, Function() removeItem) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text("Ishonchingiz komilmi?"),
            content: const Text("Savatchadan bu mahsulot o'chmoqda!"),
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
    final cart = Provider.of<Cart>(context, listen: false);
    return Slidable(
      key: ValueKey(productId),
      endActionPane: ActionPane(
        extentRatio: 0.3,
        motion: ScrollMotion(),
        children: [
          ElevatedButton(
            onPressed: () => notifyUserAboutDelete(
              context,
              (() => cart.removeItem(productId)),
            ),
            child: Text(
              "O'chirish",
              style: TextStyle(fontSize: 19),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).errorColor,
              padding: EdgeInsets.symmetric(
                horizontal: 19,
                vertical: 23,
              ),
            ),
          ),
        ],
      ),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 11, vertical: 5),
        child: ListTile(
          leading: CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
          title: Text(title),
          subtitle: Text("Umumiy: \$${(price * quantity).toStringAsFixed(2)}"),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () => cart.removeSingleItem(productId),
                icon: Icon(
                  Icons.remove,
                  color: Colors.black,
                ),
                splashRadius: 21,
              ),
              Container(
                alignment: Alignment.center,
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.grey.shade100,
                ),
                child: Text(
                  "$quantity",
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              ),
              IconButton(
                onPressed: () => cart.addToCart(
                  productId,
                  title,
                  imageUrl,
                  price,
                ),
                icon: Icon(
                  Icons.add,
                  color: Colors.black,
                ),
                splashRadius: 21,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
