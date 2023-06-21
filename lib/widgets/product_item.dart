import 'package:flutter/material.dart';
import 'package:my_shop/screens/product_details_screen.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';

class ProductItem extends StatelessWidget {
  // final String image;
  // final String title;
  // final String productId;
  const ProductItem({
    super.key,
    // required this.image,
    // required this.title,
    // required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(11),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailsScreen.routeName,
                arguments: product.id);
          },
          child: Image.network(
            product.imageURL,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          leading: Consumer<Product>(
            builder: (ctx, pro, child) {
              return IconButton(
                  onPressed: () {
                    pro.toggleisFavourite(
                      auth.token!,
                      auth.userId!,
                    );
                  },
                  icon: Icon(
                    pro.isFavourite ? Icons.favorite : Icons.favorite_outline,
                    color: Theme.of(context).primaryColor,
                  ));
            },
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.black87,
          trailing: IconButton(
              onPressed: () {
                cart.addToCart(
                  product.id,
                  product.title,
                  product.imageURL,
                  product.price,
                );
                // ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                // ScaffoldMessenger.of(context).showMaterialBanner(
                //   MaterialBanner(
                //     backgroundColor: Colors.grey.shade800,
                //     content: Text(
                //       "Savatga qo'shildi!",
                //       style: TextStyle(color: Colors.white),
                //     ),
                //     actions: [
                //       TextButton(
                //         onPressed: () {
                //           cart.removeSingleItem(
                //             product.id,
                //             isCartButton: true,
                //           );
                //           ScaffoldMessenger.of(context)
                //               .hideCurrentMaterialBanner();
                //         },
                //         child: const Text("Bekor qilish"),
                //       ),
                //     ],
                //   ),
                // );
                // Future.delayed(Duration(seconds: 2)).then((value) =>
                //     ScaffoldMessenger.of(context).hideCurrentMaterialBanner());
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Savatga qo'shildi!"),
                    duration: Duration(seconds: 2),
                    action: SnackBarAction(
                      label: "Bekor qilish",
                      onPressed: () {
                        cart.removeSingleItem(
                          product.id,
                          isCartButton: true,
                        );
                      },
                    ),
                  ),
                );
              },
              icon: Icon(
                Icons.shopping_cart,
                color: Theme.of(context).primaryColor,
              )),
        ),
      ),
    );
  }
}
