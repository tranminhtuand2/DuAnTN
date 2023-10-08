import 'package:flutter/material.dart';
import 'package:managerfoodandcoffee/src/model/sanpham_model.dart';
import 'package:managerfoodandcoffee/src/utils/colortheme.dart';
import 'package:managerfoodandcoffee/src/utils/texttheme.dart';

Widget infoProduct(SanPham sanPham, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Row(
      children: [
        Expanded(
          flex: 5,
          child: Text(
            sanPham.tensp,
            style: text(context).titleLarge?.copyWith(
                color: colorScheme(context).onTertiary,
                fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            '${sanPham.giasp} vnđ',
            textAlign: TextAlign.end,
            style: text(context).titleLarge?.copyWith(
                color: colorScheme(context).onTertiary,
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ),
  );
}
