import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:managerfoodandcoffee/src/utils/colortheme.dart';

class InputSearch extends StatefulWidget {
  const InputSearch({
    super.key,
    required TextEditingController controllerSend,
    this.onTap,
  }) : _controllerSearch = controllerSend;

  final TextEditingController _controllerSearch;
  final Function? onTap;

  @override
  State<InputSearch> createState() => _InputSearchState();
}

class _InputSearchState extends State<InputSearch> {
  bool isIconClose = false;

  @override
  void initState() {
    super.initState();
    // Lắng nghe thay đổi nội dung của TextField
    widget._controllerSearch.addListener(_updateIconVisibility);
  }

  @override
  void dispose() {
    widget._controllerSearch.removeListener(_updateIconVisibility);
    widget._controllerSearch.dispose();
    super.dispose();
  }

  void _updateIconVisibility() {
    // Kiểm tra nếu có dữ liệu trong TextField thì hiển thị icon close
    // Ngược lại, ẩn icon close
    setState(() {
      isIconClose = widget._controllerSearch.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.center,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SizedBox(
            height: 48,
            // width: MediaQuery.sizeOf(context).width * 0.6,
            child: TextFormField(
              onFieldSubmitted: (value) {},
              onChanged: (value) {},
              controller: widget._controllerSearch,
              cursorColor: colorScheme(context).onBackground,
              decoration: InputDecoration(
                  hintText: 'Tìm kiếm',
                  alignLabelWithHint: true,
                  filled: true, // Hiển thị màu nền
                  fillColor: colorScheme(context).onSecondary.withOpacity(0.3),
                  hintStyle: const TextStyle(fontSize: 15),
                  contentPadding: const EdgeInsets.only(left: 16),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(width: 0.6),
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(width: 0.6),
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                  ),
                  suffixIcon: isIconClose
                      ? IconButton(
                          icon: Icon(
                            Icons.close,
                            color: colorScheme(context).onBackground,
                          ),
                          onPressed: () {
                            widget._controllerSearch.clear();
                            _updateIconVisibility();
                          },
                        )
                      : null,
                  floatingLabelBehavior: FloatingLabelBehavior.never),
            ),
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Visibility(
          visible: isIconClose,
          child: IconButton(
            onPressed: () {
              widget.onTap!();
            },
            icon: const Icon(
              CupertinoIcons.search,
              size: 30,
              color: Color.fromARGB(255, 36, 212, 186),
            ),
          ),
        ),
        const SizedBox(
          width: 6,
        ),
      ],
    );
  }
}
