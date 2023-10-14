import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:managerfoodandcoffee/src/screen/mobile/alert_screen/message_page/widgets/button_bottom_sheet.dart';
import 'package:managerfoodandcoffee/src/utils/colortheme.dart';

class ChatMessage extends StatelessWidget {
  final bool isSentByMe;
  final String content;
  final int idMessage;
  final int index;

  const ChatMessage(
      {super.key,
      required this.isSentByMe,
      required this.content,
      required this.idMessage,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment:
            isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isSentByMe)
            const CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage('assets/images/avatar.png'),
            ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Container(
              alignment:
                  isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
              child: InkWell(
                onLongPress: () {
                  if (isSentByMe) {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (context) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: colorScheme(context).secondary,
                          ),
                          margin: const EdgeInsets.only(
                              left: 20, right: 20, bottom: 35),
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              BottomSheetItem(
                                icon: const Icon(CupertinoIcons.delete),
                                title: 'Xóa tin nhắn',
                                function: () {},
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSentByMe
                        ? const Color.fromARGB(255, 91, 200, 194)
                        : colorScheme(context).onBackground.withOpacity(0.3),
                    borderRadius: isSentByMe
                        ? const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10))
                        : const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                  ),
                  child: Text(
                    content,
                    style: TextStyle(color: colorScheme(context).tertiary),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
