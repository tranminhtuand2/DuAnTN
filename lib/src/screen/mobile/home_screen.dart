import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:managerfoodandcoffee/src/controller_getx/brightness_controller.dart';
import 'package:managerfoodandcoffee/src/controller_getx/drawer_controller.dart';
import 'package:managerfoodandcoffee/src/controller_getx/table_controller.dart';
import 'package:managerfoodandcoffee/src/firebase_helper/firebasestore_helper.dart';
import 'package:managerfoodandcoffee/src/model/table_model.dart';
import 'package:managerfoodandcoffee/src/screen/mobile/home_page/home_page.dart';
import 'package:managerfoodandcoffee/src/shared_preferences/shared_preference.dart';
import 'package:managerfoodandcoffee/src/utils/colortheme.dart';
import 'package:managerfoodandcoffee/src/utils/texttheme.dart';

class HomeScreen extends GetView<MyDrawerController> {
  const HomeScreen({super.key, required this.tableModel});
  final TableModel tableModel;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyDrawerController>(
      builder: (_) => ZoomDrawer(
        controller: _.zoomDrawerController,
        menuScreen: MenuScreen(table: tableModel),
        mainScreen: HomePage(table: tableModel),
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
  const MenuScreen({Key? key, required this.table}) : super(key: key);
  final TableModel table;

  @override
  Widget build(BuildContext context) {
    final brightnessController = Get.put(BrightnessController());
    final tableController = Get.put(TableController());

    return Scaffold(
      body: Container(
        color: colorScheme(context).background,
        child: Column(
          children: [
            buttonBack(context),
            StreamBuilder(
              stream: FirestoreHelper.readtable(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasData) {
                  //Sắp xếp tên bàn theo thứ tự nhỏ đén lớn theo tên bàn
                  int compareByTenBan(TableModel a, TableModel b) {
                    return int.parse(a.tenban).compareTo(int.parse(b.tenban));
                  }

                  snapshot.data!.sort(compareByTenBan);
                  return Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics()),
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data!.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3, // Số cột trong GridView
                              ),
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: snapshot.data![index].isSelected!
                                      ? null
                                      : () async {
                                          // await tableController
                                          //     .updateSelectedTable(table);
                                          // await tableController
                                          //     .updateSelectedTable(
                                          //         snapshot.data![index]);
                                          Get.offAll(
                                            () => HomeScreen(
                                              tableModel: snapshot.data![index],
                                            ),
                                          );
                                        },
                                  child: Stack(
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        margin: const EdgeInsets.all(6),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4),
                                        decoration: BoxDecoration(
                                          color:
                                              snapshot.data![index].isSelected!
                                                  ? colorScheme(context)
                                                      .onBackground
                                                      .withOpacity(0.2)
                                                  : colorScheme(context)
                                                      .primary
                                                      .withOpacity(0.4),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          snapshot.data![index].tenban,
                                          style: text(context).titleLarge,
                                        ),
                                      ),
                                      snapshot.data![index].isSelected!
                                          ? Positioned(
                                              right: 0,
                                              top: 0,
                                              bottom: 0,
                                              left: 0,
                                              child: Opacity(
                                                opacity: 0.3,
                                                child: Icon(
                                                  Icons.close,
                                                  size: 60,
                                                  color: colorScheme(context)
                                                      .onBackground,
                                                ),
                                              ),
                                            )
                                          : const SizedBox()
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: colorScheme(context)
                                  .onBackground
                                  .withOpacity(0.3)),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "DARK MODE",
                                    style: text(context)
                                        .bodySmall
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 8),
                                  Switch(
                                    value:
                                        !brightnessController.isDarkMode.value,
                                    onChanged: (bool newValue) {
                                      brightnessController.toggleDarkMode();
                                      saveBrightnessPreference(!newValue);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }

  InkWell buttonBack(BuildContext context) {
    return InkWell(
      onTap: controller.closeDrawer,
      child: Container(
        margin: const EdgeInsets.only(top: 36, right: 20),
        alignment: Alignment.centerRight,
        child: CircleAvatar(
          backgroundColor: colorScheme(context).onBackground.withOpacity(0.4),
          radius: 26,
          child: const Icon(
            CupertinoIcons.back,
            size: 30,
            // color: Colors.black,
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:managerfoodandcoffee/src/controller_getx/brightness_controller.dart';
// import 'package:managerfoodandcoffee/src/controller_getx/table_controller.dart';
// import 'package:managerfoodandcoffee/src/firebase_helper/firebasestore_helper.dart';
// import 'package:managerfoodandcoffee/src/model/table_model.dart';
// import 'package:managerfoodandcoffee/src/screen/mobile/home_page/home_page.dart';
// import 'package:managerfoodandcoffee/src/shared_preferences/shared_preference.dart';
// import 'package:managerfoodandcoffee/src/utils/colortheme.dart';
// import 'package:managerfoodandcoffee/src/utils/texttheme.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({Key? key, required this.tableModel}) : super(key: key);
//   final TableModel tableModel;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: MenuScreen(table: tableModel),
//       body: HomePage(table: tableModel),
//     );
//   }
// }

// class MenuScreen extends StatelessWidget {
//   const MenuScreen({Key? key, required this.table}) : super(key: key);
//   final TableModel table;

//   @override
//   Widget build(BuildContext context) {
//     final brightnessController = Get.put(BrightnessController());
//     final tableController = Get.put(TableController());

//     return Drawer(
//       child: Container(
//         color: colorScheme(context).background,
//         child: Column(
//           children: [
//             buttonBack(context),
//             StreamBuilder(
//               stream: FirestoreHelper.readtable(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 }
//                 if (snapshot.hasData) {
//                   //Sắp xếp tên bàn theo thứ tự nhỏ đén lớn theo tên bàn
//                   int compareByTenBan(TableModel a, TableModel b) {
//                     return int.parse(a.tenban).compareTo(int.parse(b.tenban));
//                   }

//                   snapshot.data!.sort(compareByTenBan);
//                   return Expanded(
//                     child: Column(
//                       children: [
//                         Expanded(
//                           child: SingleChildScrollView(
//                             physics: const BouncingScrollPhysics(
//                                 parent: AlwaysScrollableScrollPhysics()),
//                             child: GridView.builder(
//                               shrinkWrap: true,
//                               physics: const NeverScrollableScrollPhysics(),
//                               itemCount: snapshot.data!.length,
//                               gridDelegate:
//                                   const SliverGridDelegateWithFixedCrossAxisCount(
//                                 crossAxisCount: 3, // Số cột trong GridView
//                               ),
//                               itemBuilder: (context, index) {
//                                 return InkWell(
//                                   onTap: snapshot.data![index].isSelected!
//                                       ? null
//                                       : () async {
//                                           await tableController
//                                               .updateSelectedTable(table);
//                                           await tableController
//                                               .updateSelectedTable(
//                                                   snapshot.data![index]);
//                                           Get.offAll(
//                                             () => HomeScreen(
//                                               tableModel: snapshot.data![index],
//                                             ),
//                                           );
//                                         },
//                                   child: Stack(
//                                     children: [
//                                       Container(
//                                         alignment: Alignment.center,
//                                         margin: const EdgeInsets.all(6),
//                                         padding: const EdgeInsets.symmetric(
//                                             vertical: 4),
//                                         decoration: BoxDecoration(
//                                           color:
//                                               snapshot.data![index].isSelected!
//                                                   ? colorScheme(context)
//                                                       .onBackground
//                                                       .withOpacity(0.2)
//                                                   : colorScheme(context)
//                                                       .primary
//                                                       .withOpacity(0.4),
//                                           borderRadius:
//                                               BorderRadius.circular(8),
//                                         ),
//                                         child: Text(
//                                           snapshot.data![index].tenban,
//                                           style: text(context).titleLarge,
//                                         ),
//                                       ),
//                                       snapshot.data![index].isSelected!
//                                           ? Positioned(
//                                               right: 0,
//                                               top: 0,
//                                               bottom: 0,
//                                               left: 0,
//                                               child: Opacity(
//                                                 opacity: 0.3,
//                                                 child: Icon(
//                                                   Icons.close,
//                                                   size: 60,
//                                                   color: colorScheme(context)
//                                                       .onBackground,
//                                                 ),
//                                               ),
//                                             )
//                                           : const SizedBox()
//                                     ],
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                         ),
//                         Container(
//                           decoration: BoxDecoration(
//                               color: colorScheme(context)
//                                   .onBackground
//                                   .withOpacity(0.3)),
//                           child: Column(
//                             children: [
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Text(
//                                     "DARK MODE",
//                                     style: text(context)
//                                         .bodySmall
//                                         ?.copyWith(fontWeight: FontWeight.bold),
//                                   ),
//                                   const SizedBox(width: 8),
//                                   Switch(
//                                     value:
//                                         !brightnessController.isDarkMode.value,
//                                     onChanged: (bool newValue) {
//                                       brightnessController.toggleDarkMode();
//                                       saveBrightnessPreference(!newValue);
//                                     },
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 }
//                 return const SizedBox();
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   InkWell buttonBack(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         Navigator.pop(context); // Đóng Drawer khi bấm nút back
//       },
//       child: Container(
//         margin: const EdgeInsets.only(top: 36, right: 20),
//         alignment: Alignment.centerRight,
//         child: CircleAvatar(
//           backgroundColor: colorScheme(context).onBackground.withOpacity(0.4),
//           radius: 26,
//           child: const Icon(
//             Icons.arrow_back,
//             size: 30,
//           ),
//         ),
//       ),
//     );
//   }
// }
