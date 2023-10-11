import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:managerfoodandcoffee/src/common_widget/my_button.dart';
import 'package:managerfoodandcoffee/src/common_widget/snack_bar_getx.dart';
import 'package:managerfoodandcoffee/src/firebasehelper/firebasestore_helper.dart';
import 'package:managerfoodandcoffee/src/screen/mobile/intro_page/widgets/table_selection.dart';
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
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/br.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Gradient overlay for transparency
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(1),
                ],
              ),
            ),
          ),
          Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.sizeOf(context).height * 0.6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Thức tỉnh cảm xúc \nTừng giọt cà phê",
                  style: text(context).displayMedium?.copyWith(
                      color: colorScheme(context).tertiary,
                      letterSpacing: 1.5,
                      fontFamily: GoogleFonts.pacifico().fontFamily),
                ),
                const SizedBox(height: 80),
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
                            List<int> listTableName = [];
                            if (listtenban != null) {
                              for (var i = 0; i < listtenban.length; i++) {
                                listTableName
                                    .add(int.parse(listtenban[i].tenban));
                              }
                              listTableName.sort((a, b) => a.compareTo(b));
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.4,
                                    margin: const EdgeInsets.only(right: 30),
                                    child: MyButton(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return TableSelectionDialog(
                                              tableNumbers: listTableName,
                                              vido: vido!,
                                              kinhdo: kinhdo!,
                                            );
                                          },
                                        );
                                      },
                                      backgroundColor:
                                          colorScheme(context).primary,
                                      height: 80,
                                      text: Text(
                                        "CHỌN BÀN",
                                        style: text(context)
                                            .titleMedium
                                            ?.copyWith(
                                              color:
                                                  colorScheme(context).tertiary,
                                            ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Get.to(() => QRViewExample(
                                            kinhdo: kinhdo ?? 0,
                                            vido: vido ?? 0,
                                          ));
                                    },
                                    child: Center(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: Lottie.asset(
                                          'assets/images/qr.json',
                                          width: 80,
                                          height: 80,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }
                          }

                          return const SizedBox();
                        },
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
