import 'package:flutter/material.dart';

class CustomCart extends StatelessWidget {
  final Widget child;
  final String number;
  const CustomCart({super.key, required this.child, required this.number});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
          top: 13,
          right: 13,
          child: Container(
            alignment: Alignment.center,
            width: 9,
            height: 9,
            decoration: const BoxDecoration(
                color: Colors.red, shape: BoxShape.circle),
            child: Text(
              number,
              style: TextStyle(fontSize: 9),
            ),
          ),
        ),
      ],
    );
  }
}
