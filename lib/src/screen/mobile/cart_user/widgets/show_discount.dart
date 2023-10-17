import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:managerfoodandcoffee/src/utils/colortheme.dart';
import 'package:managerfoodandcoffee/src/utils/texttheme.dart';

class ShowDiscount extends StatefulWidget {
  const ShowDiscount({
    super.key,
    required this.discountController,
  });
  final TextEditingController discountController;
  @override
  State<ShowDiscount> createState() => _ShowDiscountState();
}

class _ShowDiscountState extends State<ShowDiscount> {
  final _showDiscount = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _showDiscount,
      builder: (context, value, child) {
        return InkWell(
          onTap: () => _showDiscount.value = !_showDiscount.value,
          child: Container(
            margin: const EdgeInsets.only(top: 20),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: colorScheme(context).secondary),
            child: AnimatedCrossFade(
                sizeCurve: Curves.linearToEaseOut,
                firstChild: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.confirmation_num),
                        SizedBox(width: 10),
                        Text('Áp dụng ưu đãi để được giảm giá')
                      ],
                    ),
                    Icon(CupertinoIcons.chevron_down)
                  ],
                ),
                secondChild: maGiamGia(context),
                crossFadeState: value
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 200)),
          ),
        );
      },
    );
  }

  Widget maGiamGia(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 10, bottom: 36),
          child: const Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                CupertinoIcons.chevron_up,
                size: 16,
              ),
              SizedBox(
                width: 6,
              ),
              Text('Thu gọn'),
            ],
          )),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.confirmation_num,
              color: colorScheme(context).onBackground,
            ),
            const SizedBox(width: 10),
            Text("Mã giảm giá: ", style: text(context).titleSmall),
            const SizedBox(width: 10),
            Expanded(
              child: SizedBox(
                height: 54,
                child: TextFormField(
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                    LengthLimitingTextInputFormatter(10)
                  ],
                  controller: widget.discountController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
