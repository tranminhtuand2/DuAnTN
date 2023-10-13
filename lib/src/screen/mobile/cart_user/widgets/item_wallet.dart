import 'package:flutter/material.dart';

class ItemWallet extends StatefulWidget {
  final String pathImage;
  final String title;

  const ItemWallet({required this.pathImage, required this.title, Key? key})
      : super(key: key);

  @override
  _ItemWalletState createState() => _ItemWalletState();
}

class _ItemWalletState extends State<ItemWallet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Image.asset(
            widget.pathImage,
            width: 26,
            height: 26,
          ),
          const SizedBox(width: 12),
          Text(widget.title),
        ],
      ),
    );
  }
}
