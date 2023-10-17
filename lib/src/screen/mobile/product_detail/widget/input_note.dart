import 'package:flutter/material.dart';
import 'package:managerfoodandcoffee/src/utils/colortheme.dart';

@override
Widget inputNoteProduct(
    TextEditingController controllerNode, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: TextFormField(
      controller: controllerNode,
      showCursor: true,
      decoration: const InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(right: 15),
          child: Icon(
            Icons.sticky_note_2_outlined,
            size: 35,
          ),
        ),
        hintStyle: TextStyle(fontSize: 15),
        hintText: 'Bạn có gì muốn nhắn tới nhà hàng không ?',
        border: InputBorder.none,
      ),
      maxLines: null,
    ),
  );
}
