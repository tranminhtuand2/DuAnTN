import 'package:flutter/material.dart';

import 'package:managerfoodandcoffee/src/common_widget/cache_image.dart';
import 'package:managerfoodandcoffee/src/utils/colortheme.dart';

Widget imageProduct(String urlImage, BuildContext context) {
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
    decoration: BoxDecoration(
        color: colorScheme(context).primary.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16)),
    padding: const EdgeInsets.only(top: 50.0),
    child: cacheNetWorkImage(
      urlImage,
      // width: double.infinity,
      height: MediaQuery.sizeOf(context).height * 0.5,
      // fit: BoxFit.cover,
    ),
  );
}
