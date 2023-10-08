import 'package:flutter/material.dart';
import 'package:managerfoodandcoffee/src/common_widget/my_button.dart';
import 'package:managerfoodandcoffee/src/utils/colortheme.dart';
import 'package:managerfoodandcoffee/src/utils/texttheme.dart';

class QuanityButtonProduct extends StatefulWidget {
  const QuanityButtonProduct(
      {super.key, required this.price, required this.onClick});
  final int? price;
  final Function? onClick;

  @override
  State<QuanityButtonProduct> createState() => _QuanityButtonProductState();
}

class _QuanityButtonProductState extends State<QuanityButtonProduct> {
  int count = 1;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Container(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if (count != 1) {
                            count--;
                          }
                        });
                      },
                      icon: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: const Color.fromARGB(255, 215, 215, 214)),
                        child: const Icon(
                          Icons.remove,
                          size: 25,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '$count',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          count++;
                        });
                      },
                      icon: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: const Color.fromARGB(255, 215, 215, 214)),
                        child: const Icon(
                          Icons.add_outlined,
                          size: 25,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: MyButton(
                    onTap: () {
                      widget.onClick?.call(count);
                    },
                    backgroundColor: colorScheme(context).primary,
                    height: 60,
                    text: Text(
                      'Thêm - ${widget.price! * count} vnđ',
                      style: text(context)
                          .titleMedium
                          ?.copyWith(color: colorScheme(context).tertiary),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
