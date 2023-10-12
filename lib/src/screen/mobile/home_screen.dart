import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:managerfoodandcoffee/src/controller_getx/drawer_controller.dart';
import 'package:managerfoodandcoffee/src/screen/mobile/home_page/home_page.dart';

class HomeScreen extends GetView<MyDrawerController> {
  const HomeScreen({super.key, required this.tenban});
  final String tenban;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyDrawerController>(
      builder: (_) => ZoomDrawer(
        controller: _.zoomDrawerController,
        menuScreen: const MenuScreen(),
        mainScreen: HomePage(tenban: tenban),
        borderRadius: 24.0,
        showShadow: true,
        angle: 0,
        drawerShadowsBackgroundColor: Colors.grey,
        slideWidth: MediaQuery.of(context).size.width * 0.65,
      ),
    );
  }
}

class MenuScreen extends GetView<MyDrawerController> {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Center(
        child: ElevatedButton(
          onPressed: controller.toggleDrawer,
          child: const Text(
            "Close Drawer",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

// class MainScreen extends GetView<MyDrawerController> {
//   const MainScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.pink,
//       child: Center(
//         child: ElevatedButton(
//           onPressed: controller.toggleDrawer,
//           child: const Text("Toggle Drawer"),
//         ),
//       ),
//     );
//   }
// }
