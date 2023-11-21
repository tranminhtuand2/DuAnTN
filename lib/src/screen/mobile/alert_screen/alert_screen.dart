import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managerfoodandcoffee/src/screen/mobile/alert_screen/message_page/message_page.dart';
import 'package:managerfoodandcoffee/src/screen/mobile/alert_screen/notification_page/notification_page.dart';
import 'package:managerfoodandcoffee/src/utils/colortheme.dart';
import 'package:managerfoodandcoffee/src/utils/texttheme.dart';

class AlertScreen extends StatefulWidget {
  const AlertScreen({
    super.key,
    this.isFirstSendMessage = false,
    this.isPushNotificationPage = false,
  });
  final bool isFirstSendMessage;
  final bool isPushNotificationPage;

  @override
  State<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
//nếu như nhận thông báo và ấn vào thì sẽ chuyển qua trang thông báo
    widget.isPushNotificationPage ? _tabController.animateTo(1) : null;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tin nhắn & Thông báo'.toUpperCase(),
          style: text(context).titleSmall,
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            CupertinoIcons.back,
            size: 32,
            color: colorScheme(context).onBackground,
          ),
        ),
      ),
      body: SafeArea(
          child: DefaultTabController(
        length: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 10),
              child: ButtonsTabBar(
                controller: _tabController,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: colorScheme(context).onBackground.withOpacity(0.25),
                ),
                unselectedDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: colorScheme(context).onBackground.withOpacity(0.05),
                ),
                labelStyle: TextStyle(
                  color: colorScheme(context).onBackground,
                ),
                unselectedLabelStyle: TextStyle(
                  color: colorScheme(context).onBackground,
                ),
                // Add your tabs here
                tabs: const [
                  Tab(
                    text: 'Tin nhắn',
                    icon: Icon(
                      CupertinoIcons.captions_bubble,
                      size: 18,
                    ),
                  ),
                  Tab(
                    text: 'Thông báo',
                    icon: Icon(
                      CupertinoIcons.speaker_zzz,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                  controller: _tabController,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    Center(
                      child:
                          MessagePage(isFirstSend: widget.isFirstSendMessage),
                    ),
                    const Center(
                      child: NotificationPage(),
                    ),
                  ]),
            ),
          ],
        ),
      )
          //  Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: [
          //       const Text(
          //           'Bạn cần đăng nhập để xem tin nhắn & thông báo 🐧'),
          //       Center(
          //         child: Lottie.asset('assets/images/nodata.json'),
          //       ),
          //     ],
          //   ),
          ),
    );
  }
}
