import 'package:flutter/material.dart';
import 'package:my_shop/screens/cart_screen.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../providers/products.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({
    super.key,
  });

  static const routeName = "product-details-screen";

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments;
    final product = Provider.of<Products>(context, listen: false)
        .findById(productId as String);
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 300,
              width: double.infinity,
              child: Image.network(
                product.imageURL,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(product.description),
            ),
          ],
        ),
      ),
      bottomSheet: BottomAppBar(
        child: Container(
          height: 80,
          padding: const EdgeInsets.all(15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Narxi:",
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "\$${product.price}",
                    style: TextStyle(
                      fontSize: 19,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              Consumer<Cart>(
                builder: (ctx, cart, child) {
                  final isProductAdded = cart.items.containsKey(productId);
                  if (isProductAdded) {
                    return ElevatedButton.icon(
                      onPressed: () =>
                          Navigator.of(context).pushNamed(CartScreen.routeName),
                      icon: Icon(
                        Icons.shopping_bag_outlined,
                        size: 15,
                        color: Colors.black,
                      ),
                      label: Text(
                        "Savatchaga borish",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade200,
                        padding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 11),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                    );
                  } else {
                    return ElevatedButton(
                      onPressed: () => cart.addToCart(
                        productId,
                        product.title,
                        product.imageURL,
                        product.price,
                      ),
                      child: Text("Savatchaga qo'shish"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 11),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                    );
                  }
                  ;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
