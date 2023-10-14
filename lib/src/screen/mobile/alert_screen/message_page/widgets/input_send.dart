import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:managerfoodandcoffee/src/utils/colortheme.dart';

class InputSend extends StatefulWidget {
  const InputSend({
    super.key,
    required TextEditingController controllerSend,
    this.onTap,
  }) : _controllerSend = controllerSend;

  final TextEditingController _controllerSend;
  final Function? onTap;

  @override
  State<InputSend> createState() => _InputSendState();
}

class _InputSendState extends State<InputSend> {
  bool isIconClose = false;

  @override
  void initState() {
    super.initState();
    // Lắng nghe thay đổi nội dung của TextField
    widget._controllerSend.addListener(_updateIconVisibility);
  }

  @override
  void dispose() {
    widget._controllerSend.removeListener(_updateIconVisibility);
    widget._controllerSend.dispose();
    super.dispose();
  }

  void _updateIconVisibility() {
    // Kiểm tra nếu có dữ liệu trong TextField thì hiển thị icon close
    // Ngược lại, ẩn icon close
    setState(() {
      isIconClose = widget._controllerSend.text.isNotEmpty;
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
              controller: widget._controllerSend,
              cursorColor: colorScheme(context).onBackground,
              decoration: InputDecoration(
                  hintText: 'Gửi tin nhắn',
                  alignLabelWithHint: true,
                  filled: true, // Hiển thị màu nền
                  fillColor: colorScheme(context).onBackground.withOpacity(0.3),
                  hintStyle: const TextStyle(fontSize: 15),
                  contentPadding: const EdgeInsets.only(left: 16),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                  ),
                  suffixIcon: isIconClose
                      ? IconButton(
                          icon: Icon(
                            Icons.close,
                            color: colorScheme(context).onBackground,
                          ),
                          onPressed: () {
                            widget._controllerSend.clear();
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
              CupertinoIcons.paperplane,
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
