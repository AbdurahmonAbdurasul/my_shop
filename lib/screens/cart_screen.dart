import 'package:flutter/material.dart';
import 'package:my_shop/widgets/cart_list_item.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../providers/orders.dart';
import '../screens/orders_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  static const routeName = "/cart";

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Sizning savatchangiz"),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Umumiy: ",
                    style: TextStyle(fontSize: 19),
                    //Theme.of(context).textTheme.headline6
                  ),
                  const Spacer(),
                  Chip(
                    label: Text(
                      "\$${cart.totalPrice.toStringAsFixed(2)}",
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cart: cart),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                final cartItem = cart.items.values.toList()[index];
                return CartListItem(
                  productId: cart.items.keys.toList()[index],
                  imageUrl: cartItem.image,
                  title: cartItem.title,
                  price: cartItem.price,
                  quantity: cartItem.quantity,
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (widget.cart.items.isEmpty || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<Orders>(context, listen: false).addToOrders(
                widget.cart.items.values.toList(),
                widget.cart.totalPrice,
              );
              setState(() {
                _isLoading = false;
              });
              widget.cart.clearCart();
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
            },
      child: _isLoading
          ? const CircularProgressIndicator()
          : const Text("BUYURTMA QILISH"),
    );
  }
}
