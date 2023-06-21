import 'package:flutter/material.dart';
import 'package:my_shop/widgets/product_item.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../models/product.dart';

class ProductsGrid extends StatefulWidget {
  final bool showFavourites;
  const ProductsGrid(
    this.showFavourites, {
    Key? key,
  }) : super(key: key);

  @override 
  State<ProductsGrid> createState() => _ProductsGridState();
}

class _ProductsGridState extends State<ProductsGrid> {
  late Future _productsFuture;
  Future _getProductsFuture() {
    return Provider.of<Products>(context, listen: false)
        .getProductsFromFirebase();
  }

  // @override
  // var _init = true;
  // var _isLoading = false;
  // void initState() {
  // Future.delayed(
  //   Duration.zero,
  // ).then((value) {
  //   Provider.of<Products>(context, listen: false).getProductsFromFirebase();
  // });

  // Provider.of<Products>(context, listen: false).getProductsFromFirebase();
  // super.initState();
  //}

  // @override
  // void didChangeDependencies() {
  //   if (_init) {
  //     setState(() {
  //       _isLoading = true;
  //     });
  //     Provider.of<Products>(context, listen: false)
  //         .getProductsFromFirebase()
  //         .then((reponse) {
  //       setState(() {
  //         _isLoading = false;
  //       });
  //     });
  //   }
  //   _init = false;
  //   super.didChangeDependencies();
  // }
  @override
  void initState() {
    _productsFuture = _getProductsFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final productsData = Provider.of<Products>(context);
    // final products =
    //     widget.showFavourites ? productsData.favourite : productsData.list;

    return FutureBuilder(
        future: _productsFuture,
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapshot.error == null) {
              return Consumer<Products>(builder: (context, value, child) {
                final products = widget.showFavourites
                    ? value.favourite
                    : value.list;

                return products.isNotEmpty
                    ? GridView.builder(
                        padding: const EdgeInsets.all(20),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 3 / 2,
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 20,
                            crossAxisCount: 1),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          return ChangeNotifierProvider<Product>.value(
                            value: products[index],
                            child: ProductItem(
                                // image: products[index].imageURL,
                                // title: products[index].title,
                                // productId: products[index].id,
                                ),
                          );
                        },
                      )
                    : const Center(
                        child: Text(
                          "Mahsulotlar mavjud emas!",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
              });
            } else {
              return const Center(
                child: Text("Xatolik sodir bo'ldi!"),
              );
            }
          }
        });
    // _isLoading
    //     ? Center(child: CircularProgressIndicator())
    //     : products.isNotEmpty
    //         ? GridView.builder(
    //             padding: const EdgeInsets.all(20),
    //             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //                 childAspectRatio: 3 / 2,
    //                 mainAxisSpacing: 20,
    //                 crossAxisSpacing: 20,
    //                 crossAxisCount: 1),
    //             itemCount: products.length,
    //             itemBuilder: (context, index) {
    //               return ChangeNotifierProvider<Product>.value(
    //                 value: products[index],
    //                 child: ProductItem(
    //                     // image: products[index].imageURL,
    //                     // title: products[index].title,
    //                     // productId: products[index].id,
    //                     ),
    //               );
    //             },
    //           )
    //         : const Center(
    //             child: Text(
    //               "Mahsulotlar mavjud emas!",
    //               style: TextStyle(
    //                 fontSize: 20,
    //                 fontWeight: FontWeight.bold,
    //               ),
    //             ),
    //           );
  }
}
