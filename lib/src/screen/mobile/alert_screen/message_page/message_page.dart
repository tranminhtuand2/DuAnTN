import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:managerfoodandcoffee/src/model/message_model.dart';
import 'package:managerfoodandcoffee/src/screen/mobile/alert_screen/message_page/widgets/chat_message.dart';
import 'package:managerfoodandcoffee/src/screen/mobile/alert_screen/message_page/widgets/input_send.dart';
import 'package:managerfoodandcoffee/src/utils/colortheme.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final _controllerSend = TextEditingController();

  List<Message> listMessage = [
    Message(
      isSentByMe: true,
      content: "Hello!",
      idMessage: 1,
      time: "09:00 AM",
    ),
    Message(
      isSentByMe: false,
      content: "Hi there!",
      idMessage: 2,
      time: "09:05 AM",
    ),
    Message(
      isSentByMe: true,
      content: "How are you?",
      idMessage: 3,
      time: "09:10 AM",
    ),
    Message(
      isSentByMe: false,
      content: "I'm good, thanks!",
      idMessage: 4,
      time: "09:15 AM",
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: listMessage.length,
                itemBuilder: (context, index) {
                  final message = listMessage[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: ChatMessage(
                      isSentByMe: message.isSentByMe,
                      content: message.content,
                      idMessage: message.idMessage,
                      index: index,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      CupertinoIcons.photo,
                      color: colorScheme(context).onBackground,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      CupertinoIcons.mic,
                      color: colorScheme(context).onBackground,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: InputSend(
                    controllerSend: _controllerSend,
                    onTap: () async {
                      // _controllerSend.clear();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
