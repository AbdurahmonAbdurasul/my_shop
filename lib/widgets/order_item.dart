import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_shop/models/cart_item.dart';
import '../models/order.dart';

class OrderItem extends StatefulWidget {
  final double totalPrice;
  final DateTime date;
  final List<CartItem> products;
  OrderItem({
    Key? key,
    required this.totalPrice,
    required this.date,
    required this.products,
  }) : super(key: key);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _expandItem = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal:13,vertical: 7),
      child: Column(
        children: [
          ListTile(
            //ExpansionTile pasa qaragan sterelkali
            title: Text("\$${widget.totalPrice}"),
            subtitle: Text(
              DateFormat("dd/MM/yyyy  hh:mm").format(widget.date),
            ),
            trailing: IconButton(
              onPressed: () {
                setState(() {
                  _expandItem = !_expandItem;
                });
              },
              icon: Icon(_expandItem ? Icons.expand_less : Icons.expand_more),
            ),
          ),
          if (_expandItem)
            Container(
              padding: const EdgeInsets.all(5),
              height: min(widget.products.length * 20 + 50, 100),
              width: double.infinity,
              child: ListView.builder(
                  itemCount: widget.products.length,
                  itemExtent: 30,
                  itemBuilder: (ctx, i) {
                    final product = widget.products[i];
                    return ListTile(
                      title: Text(
                        product.title,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: Text(
                        "${product.quantity}x \$${product.price},",
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }),
            ),
        ],
      ),
    );
  }
}
