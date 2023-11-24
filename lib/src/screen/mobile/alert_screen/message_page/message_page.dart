import 'dart:ui';

import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managerfoodandcoffee/src/common_widget/cache_image.dart';
import 'package:managerfoodandcoffee/src/common_widget/snack_bar_getx.dart';
import 'package:managerfoodandcoffee/src/controller_getx/brightness_controller.dart';
import 'package:managerfoodandcoffee/src/controller_getx/categorry_controller.dart';

import 'package:managerfoodandcoffee/src/firebase_helper/firebasestore_helper.dart';
import 'package:managerfoodandcoffee/src/model/table_model.dart';
import 'package:managerfoodandcoffee/src/screen/mobile/alert_screen/message_page/widgets/chat_message.dart';
import 'package:managerfoodandcoffee/src/screen/mobile/alert_screen/message_page/widgets/input_send.dart';
import 'package:managerfoodandcoffee/src/screen/mobile/product_detail/detail_product_screen.dart';
import 'package:managerfoodandcoffee/src/utils/colortheme.dart';
import 'package:managerfoodandcoffee/src/utils/constants.dart';
import 'package:managerfoodandcoffee/src/utils/format_price.dart';
import 'package:managerfoodandcoffee/src/utils/texttheme.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({
    super.key,
    this.isFirstSend = false,
    required this.tableModel,
  });
  final bool isFirstSend;
  final TableModel tableModel;

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage>
    with AutomaticKeepAliveClientMixin {
  final _controllerSend = TextEditingController();
  late DialogFlowtter dialogFlowtter;

  List<Map<String, dynamic>> messages = [];

  final brightnessController = Get.put(BrightnessController());
  final categoriesController = Get.put(CategoryController());

  @override
  void initState() {
    DialogFlowtter.fromFile().then((instance) {
      dialogFlowtter = instance;
      if (widget.isFirstSend) {
        sendMessage('Quan tâm');
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
    super.build(context);
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
                        content: messages[index]['widgetMessage'],
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
                      onPressed: () {
                        showCustomSnackBar(
                            title: "",
                            message: "Tính năng đang phát triển",
                            type: Type.warning);
                      },
                      icon: Icon(
                        CupertinoIcons.photo,
                        color: colorScheme(context).onBackground,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        showCustomSnackBar(
                            title: "",
                            message: "Tính năng đang phát triển",
                            type: Type.warning);
                      },
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
      addMessageWidget(
        Text(text),
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
    if (categoriesController.categories.any(
        (element) => element.tendanhmuc.toLowerCase() == text.toLowerCase())) {
      setState(() {
        // ignore: use_build_context_synchronously
        addMessageWidget(itemMessageProduct(context, text));
      });
    }
    if (response.message != null && response.message!.text != null) {
      setState(() {
        if (checkKeyWord(response.message!.text!.text![0])) {
          addMessageWidget(itemCategories(context));
        }
        addMessageWidget(Text(response.message!.text!.text![0]));
      });
    }
  }

  bool checkKeyWord(String text) {
    List<String> words = text.split(' ');
    if (words.any((element) => element == 'sau:')) {
      return true;
    }
    return false;
  }

  void addMessageWidget(Widget widget, [bool isUserMessage = false]) {
    messages.add({
      'widgetMessage': widget,
      'isUserMessage': isUserMessage,
    });
    //Ẩn bàn phím xuống
    FocusScope.of(context).unfocus();
  }

  Widget itemCategories(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.3,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: categoriesController.categories.length,
        itemBuilder: (context, index) {
          return Text(
              categoriesController.categories[index].tendanhmuc.toUpperCase());
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    );
  }

  Widget itemMessageProduct(BuildContext context, String keyword) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.6,
      height: MediaQuery.sizeOf(context).height * 0.5,
      child: StreamBuilder(
        stream: FirestoreHelper.filletsp(keyword),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            final productFillter = snapshot.data;
            return ListView.builder(
              itemCount: productFillter!.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Get.to(
                      () => ProductDetailPage(
                        product: productFillter[index],
                        tableModel: widget.tableModel,
                      ),
                    );
                  },
                  child: SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.16,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Obx(
                          () => ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              height: MediaQuery.sizeOf(context).height * 0.14,
                              decoration: BoxDecoration(
                                border: !brightnessController.isDarkMode.value
                                    ? Border.all(
                                        width: 1,
                                        color: const Color.fromARGB(
                                            255, 97, 200, 112))
                                    : null,
                                borderRadius: BorderRadius.circular(20),
                                gradient: !brightnessController.isDarkMode.value
                                    ? const LinearGradient(
                                        colors: [
                                          Color.fromARGB(255, 33, 64, 73),
                                          Color.fromARGB(255, 148, 148, 148),
                                        ], // Thay đổi màu gradient tùy ý
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      )
                                    : null,
                                color: colorScheme(context).primary,
                              ),
                              child: !brightnessController.isDarkMode.value
                                  ? BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 10.0, sigmaY: 10.0),
                                      child: Container(
                                        margin:
                                            const EdgeInsets.only(right: 10),
                                        decoration: BoxDecoration(
                                            boxShadow: const [kDefaultShadow],
                                            color: Theme.of(context)
                                                .colorScheme
                                                .background
                                                .withOpacity(0),
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                      ),
                                    )
                                  : Container(
                                      margin: const EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                        boxShadow: const [kDefaultShadow],
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background,
                                        borderRadius: BorderRadius.circular(
                                          20,
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        //hien thi ảnh sản phẩm
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: kDefaultPadding),
                            height: 160,
                            width: 200,
                            child: cacheNetWorkImage(
                              productFillter[index].hinhanh,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        //hiện thị thông tin sản phẩm
                        Positioned(
                          left: 0,
                          bottom: 0,
                          child: Container(
                            margin: const EdgeInsets.only(left: 30),
                            height: 136,
                            width: MediaQuery.sizeOf(context).width - 200,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  productFillter[index].tensp.toUpperCase(),
                                  style: text(context)
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "${formatPrice(productFillter[index].giasp)} VNĐ",
                                  style: text(context).titleSmall,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
