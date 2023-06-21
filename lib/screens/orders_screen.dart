import 'package:flutter/material.dart';
import 'package:my_shop/models/order.dart';
import 'package:my_shop/widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart';
import 'package:intl/intl.dart';
import '../widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  static const routeName = "/orders";

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late Future _ordersFuture;
  Future _getOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).getOrdersFromFirebase();
  }

  //var _isLoading = false;
  @override
  void initState() {
    _ordersFuture = _getOrdersFuture();
    // Future.delayed(Duration.zero).then((_) {
    //     setState(() {
    //       _isLoading = true;
    //     });
    //     Provider.of<Orders>(context, listen: false)
    //         .getOrdersFromFirebase()
    //         .then((_) {
    //       setState(() {
    //         _isLoading = false;
    //       });
    //     });
    //   },
    // );
    super.initState();
  }

  Widget build(BuildContext context) {
    //final orders = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Buyurtmalar"),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: _ordersFuture,
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (dataSnapshot.error != null) {
              return Consumer<Orders>(
                builder: (context, orders, child) => orders.items.isEmpty
                    ? const Center(
                        child: Text("Buyurtmalar mavjud emas!"),
                      )
                    : ListView.builder(
                        itemCount: orders.items.length,
                        itemBuilder: (ctx, i) {
                          final order = orders.items[i];
                          return OrderItem(
                            totalPrice: order.totalPrice,
                            date: order.date,
                            products: order.products,
                          );
                        },
                      ),
              );
            } else {
              //xatolik yuz berdi
              return const Center(
                child: Text("Xatolik yuz berdi!"),
              );
            }
          }
        },
      ),
      // : !_isLoading
      //     ? const Center(
      //         child: CircularProgressIndicator(),
      //       )
      // : ListView.builder(
      //     itemCount: orders.items.length,
      //     itemBuilder: (context, i) {
      //       final order = orders.items[i];
      //       return OrderItem(
      //         totalPrice: order.totalPrice,
      //         date: order.date,
      //         products: order.products,
      //       );
      //     }),
    );
  }
}
