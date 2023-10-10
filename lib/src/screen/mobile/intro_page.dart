import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:managerfoodandcoffee/src/common_widget/my_button.dart';
import 'package:managerfoodandcoffee/src/common_widget/snack_bar_getx.dart';
import 'package:managerfoodandcoffee/src/firebasehelper/firebasestore_helper.dart';
import 'package:managerfoodandcoffee/src/screen/mobile/check_location_page.dart';
import 'package:managerfoodandcoffee/src/screen/mobile/scan_qr_screen.dart';
import 'package:managerfoodandcoffee/src/utils/colortheme.dart';
import 'package:managerfoodandcoffee/src/utils/texttheme.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  double? vido;
  double? kinhdo;
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Lottie.asset(
                  "assets/images/ani_location.json",
                  animate: true,
                ),
              ),
              Text(
                "Vui lòng chọn số bàn & \n nhấn vào nút kiểm tra !",
                style: text(context).titleLarge,
              ),
              const SizedBox(height: 30),
              StreamBuilder(
                stream: FirestoreHelper.readmap(),
                builder: (context, snapshot) {
                  final maplocation = snapshot.data;
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    showCustomSnackBar(
                        title: 'Lỗi',
                        message: 'Đã có lỗi xảy ra',
                        type: Type.error);
                  }
                  if (snapshot.hasData) {
                    if (maplocation != null) {
                      vido = maplocation[0].vido;
                      kinhdo = maplocation[0].kinhdo;
                    }
                    return StreamBuilder(
                      stream: FirestoreHelper.readtable(),
                      builder: (context, snapshot) {
                        final listtenban = snapshot.data;
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.hasError) {
                          showCustomSnackBar(
                              title: 'Lỗi',
                              message: 'Đã có lỗi xảy ra',
                              type: Type.error);
                        }
                        if (snapshot.hasData) {
                          List<DropdownMenuItem> tenbanItem = [];
                          if (listtenban != null) {
                            for (var i = 0; i < listtenban.length; i++) {
                              tenbanItem.add(
                                DropdownMenuItem(
                                  value: listtenban[i].tenban,
                                  child: Text(listtenban[i].tenban),
                                ),
                              );
                            }
                          }
                          if (tenbanItem.isNotEmpty) {
                            return myDropDown(tenbanItem);
                          }
                        }

                        return const SizedBox();
                      },
                    );
                  }
                  return const SizedBox();
                },
              ),
              InkWell(
                onTap: () {
                  Get.to(() => QRViewExample(
                        kinhdo: kinhdo ?? 0,
                        vido: vido ?? 0,
                      ));
                },
                child: Lottie.asset('assets/images/qr.json',
                    width: 100, height: 100),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: MyButton(
                  onTap: () {
                    if (selectedValue != null) {
                      print("kinh do+$kinhdo");
                      print("vido do+$vido");
                      Get.dialog(
                        LocationCheckPage(
                          vido: vido!,
                          kinhdo: kinhdo!,
                          tenban: selectedValue.toString(),
                        ),
                      );
                    } else {
                      showCustomSnackBar(
                          title: 'Lỗi',
                          message: 'Vui lòng chọn bàn!!',
                          type: Type.error);
                    }
                  },
                  backgroundColor: colorScheme(context).primary,
                  height: 60,
                  text: Text(
                    'Kiểm tra',
                    style: text(context)
                        .titleMedium
                        ?.copyWith(color: colorScheme(context).tertiary),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container myDropDown(
    List<DropdownMenuItem<dynamic>> tenbanItem,
  ) {
    return Container(
      padding: const EdgeInsets.all(6),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(8)),
      child: DropdownButton(
        value: selectedValue,
        underline: const SizedBox(),
        isExpanded: true,
        hint: const Text("Vui lòng chọn bàn"),
        items: tenbanItem,
        onChanged: (value) {
          setState(() {
            selectedValue = value;
            print(selectedValue);
          });
        },
      ),
    );
  }
}
