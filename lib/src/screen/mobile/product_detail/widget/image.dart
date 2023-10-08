import 'package:flutter/material.dart';

import 'package:managerfoodandcoffee/src/common_widget/cache_image.dart';

Widget imageProduct(String urlImage, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(top: 50.0),
    child: cacheNetWorkImage(
      urlImage,
      // width: double.infinity,
      height: MediaQuery.sizeOf(context).height * 0.5,
      fit: BoxFit.cover,
    ),
  );
}
