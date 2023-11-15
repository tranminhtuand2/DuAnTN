import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managerfoodandcoffee/src/screen/mobile/alert_screen/message_page/widgets/chat_message.dart';
import 'package:managerfoodandcoffee/src/screen/mobile/alert_screen/message_page/widgets/input_send.dart';
import 'package:managerfoodandcoffee/src/utils/colortheme.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key, this.isFirstSend = false});
  final bool isFirstSend;

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final _controllerSend = TextEditingController();
  late DialogFlowtter dialogFlowtter;

  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    DialogFlowtter.fromFile().then((instance) {
      dialogFlowtter = instance;
      if (widget.isFirstSend) {
        sendMessage('Quan Tâm');
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    dialogFlowtter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: ChatMessage(
                        isSentByMe: messages[index]['isUserMessage'],
                        content: messages[index]['message'].text.text[0],
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
                        sendMessage(_controllerSend.text);
                        _controllerSend.clear();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void sendMessage(String text) async {
    if (text.isEmpty) return;

    setState(() {
      addMessage(
        Message(text: DialogText(text: [text])),
        true,
      );
    });

    DetectIntentResponse response = await dialogFlowtter.detectIntent(
      queryInput: QueryInput(text: TextInput(text: text)),
    );
//Người dùng nhập ok thì trở về home
    if (text == 'ok' || text == 'OK') {
      Future.delayed(const Duration(milliseconds: 1500), () {
        Get.back();
      });
    }

    if (response.message != null && response.message!.text != null) {
      setState(() {
        addMessage(response.message!);
      });
    }
  }

  void addMessage(Message message, [bool isUserMessage = false]) {
    messages.add({
      'message': message,
      'isUserMessage': isUserMessage,
    });
  }
}
