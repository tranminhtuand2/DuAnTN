import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:managerfoodandcoffee/src/screen/mobile/cart_user/widgets/item_wallet.dart';
import 'package:managerfoodandcoffee/src/utils/colortheme.dart';
import 'package:managerfoodandcoffee/src/utils/texttheme.dart';

class ShowPayment extends StatefulWidget {
  const ShowPayment({
    super.key,
    required this.currentMethod,
  });
  final Function(int) currentMethod;
  @override
  State<ShowPayment> createState() => _ShowPaymentState();
}

class _ShowPaymentState extends State<ShowPayment> {
  final _showPayment = ValueNotifier(true);
  final _currentSelected = ValueNotifier<int>(0);

  List listWidgetPayment = [
    const ItemWallet(
        pathImage: 'assets/images/logo_dola.png', title: 'Tiền mặt'),
    const ItemWallet(
        pathImage: 'assets/images/logo_momo.png', title: 'Ví MoMo'),
    const ItemWallet(
        pathImage: 'assets/images/logo_vnpay.png', title: 'Ví VnPay'),
  ];
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _showPayment,
      builder: (context, value, child) {
        return InkWell(
          onTap: () => _showPayment.value = !_showPayment.value,
          child: Container(
            margin: const EdgeInsets.only(top: 10),
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
                        Icon(CupertinoIcons.money_dollar),
                        SizedBox(width: 10),
                        Text('Chọn phương thức thanh toán')
                      ],
                    ),
                    Icon(CupertinoIcons.chevron_down)
                  ],
                ),
                secondChild: listPayment(),
                crossFadeState: value
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 200)),
          ),
        );
      },
    );
  }

  Widget listPayment() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 10, bottom: 20),
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
        ListView.separated(
          shrinkWrap: true,
          itemCount: listWidgetPayment.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                _currentSelected.value = index;
                widget.currentMethod(index);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  listWidgetPayment[index],
                  ValueListenableBuilder(
                    valueListenable: _currentSelected,
                    builder: (context, value, child) {
                      return Visibility(
                        visible: value == index,
                        replacement: const SizedBox(),
                        child: const Icon(Icons.check),
                      );
                    },
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
        ),
      ],
    );
  }
}
