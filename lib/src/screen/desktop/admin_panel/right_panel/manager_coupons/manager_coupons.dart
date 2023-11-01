import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:managerfoodandcoffee/src/common_widget/input_field.dart';
import 'package:managerfoodandcoffee/src/common_widget/my_button.dart';
import 'package:managerfoodandcoffee/src/common_widget/my_dialog.dart';
import 'package:managerfoodandcoffee/src/common_widget/snack_bar_getx.dart';
import 'package:managerfoodandcoffee/src/firebase_helper/firebasestore_helper.dart';
import 'package:managerfoodandcoffee/src/model/coupons_model.dart';
import 'package:managerfoodandcoffee/src/screen/mobile/alert_screen/notification_page/notification_page.dart';
import 'package:managerfoodandcoffee/src/utils/colortheme.dart';
import 'package:managerfoodandcoffee/src/utils/format_date.dart';
import 'package:managerfoodandcoffee/src/utils/texttheme.dart';
import 'package:ticket_widget/ticket_widget.dart';

class ManagerCoupons extends StatefulWidget {
  const ManagerCoupons({super.key});

  @override
  State<ManagerCoupons> createState() => _ManagerCouponsState();
}

class _ManagerCouponsState extends State<ManagerCoupons> {
  final controllerData = TextEditingController();
  final controllerPersent = TextEditingController();
  final controllersolandung = TextEditingController();
  final controllerEndDay = TextEditingController();
  final controllerBeginDay = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    ColorScheme color = colorScheme(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                  color: color.onPrimary.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(8)),
              child: StreamBuilder(
                stream: FirestoreHelper.getDataCoupons(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final couponsList = snapshot.data;
                    return Padding(
                      padding:
                          const EdgeInsets.only(top: 20, right: 6, left: 6),
                      child: ListView.builder(
                        itemCount: couponsList?.length,
                        itemBuilder: (context, index) {
                          Coupons coupons = couponsList![index];
                          //Kiểm tra số lượng lượt dùng và ngày hết hạn, nếu không đủ điều kiện sẽ tự động tắt mgg
                          if (coupons.soluotdung <= 0 ||
                              FormatDate().compareDate(coupons.endDay)) {
                            coupons.isEnable = false;
                            FirestoreHelper.updateMagiamGia(coupons);
                          }
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                            child: InkWell(
                              onLongPress: () =>
                                  _submitDeleteCoupons(coupons, context),
                              child: TicketWidget(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                width: MediaQuery.sizeOf(context).width,
                                height: 200,
                                child: CouponItem(
                                  discount: '${coupons.persent}%',
                                  details: '\'${coupons.data}\'',
                                  validDate:
                                      'Áp dụng từ ${coupons.beginDay} - ${coupons.endDay}',
                                  startColor: Colors.teal,
                                  endColor: Colors.teal[100]!,
                                  soluotdung: coupons.soluotdung,
                                  isEnable: coupons.isEnable,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: color.onPrimary.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(8)),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            InputField(
                              controller: controllerData,
                              inputType: TextInputType.text,
                              labelText: 'Nhập mã',
                              maxLength: 12,
                              prefixIcon: Icon(
                                Icons.code_rounded,
                                color: colorScheme(context).onBackground,
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Vui lòng nhập mã";
                                }
                                return null;
                              },
                              textInputFormatters: [
                                FilteringTextInputFormatter.deny(
                                    RegExp(r'[\[\]!@#\$%^&*(){}/:";|_=+]')),
                              ],
                            ),
                            // const SizedBox(height: 20),
                            InputField(
                              controller: controllerPersent,
                              inputType: TextInputType.number,
                              labelText: 'Phần trăm giảm giá',
                              maxLength: 3,
                              prefixIcon: Icon(
                                Icons.percent,
                                color: colorScheme(context).onBackground,
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Vui lòng điền phần trăm giảm giá";
                                }
                                if (int.parse(value) > 100 ||
                                    int.parse(value) == 0) {
                                  return "Phần trăm giảm giá trong khoảng 1 - 100";
                                }
                                return null;
                              },
                              textInputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]+')),
                              ],
                            ),
                            // const SizedBox(height: 10),
                            InputField(
                              controller: controllersolandung,
                              inputType: TextInputType.number,
                              labelText: 'Số lần sử dụng',
                              maxLength: 3,
                              prefixIcon: Icon(
                                Icons.numbers,
                                color: colorScheme(context).onBackground,
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Vui lòng điền số lần sử dụng";
                                }
                                if (int.parse(value) == 0) {
                                  return "Số lần sử dụng phải lớn hơn 0";
                                }
                                return null;
                              },
                              textInputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]+')),
                              ],
                            ),
                            // const SizedBox(height: 10),
                            InputField(
                              readOnly: true,
                              onTap: () async {
                                controllerBeginDay.text =
                                    await showCustomDatePicker(
                                        isShowTomorrow: false);
                              },
                              controller: controllerBeginDay,
                              inputType: TextInputType.number,
                              labelText: 'Ngày bắt đầu',
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Không để trống";
                                }
                                return null;
                              },
                              prefixIcon: Icon(
                                Icons.date_range,
                                color: colorScheme(context).onBackground,
                              ),
                            ),
                            const SizedBox(height: 20),
                            InputField(
                              readOnly: true,
                              onTap: () async {
                                controllerEndDay.text =
                                    await showCustomDatePicker(
                                        isShowTomorrow: true);
                              },
                              controller: controllerEndDay,
                              inputType: TextInputType.number,
                              labelText: 'Ngày kết thúc',
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Không để trống";
                                }
                                return null;
                              },
                              prefixIcon: Icon(
                                Icons.date_range,
                                color: colorScheme(context).onBackground,
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  ),
                  MyButton(
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        _submitFormCoupons();
                      }
                    },
                    backgroundColor: colorScheme(context).inversePrimary,
                    height: 60,
                    text: Text(
                      'THÊM MÃ',
                      style: TextStyle(color: colorScheme(context).tertiary),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submitFormCoupons() async {
    await FirestoreHelper.createMagiamGia(
      beginDay: controllerBeginDay.text,
      endDay: controllerEndDay.text,
      data: controllerData.text.toUpperCase(),
      soluotdung: int.parse(controllersolandung.text),
      persent: int.parse(controllerPersent.text),
    );
    controllerBeginDay.clear();
    controllerData.clear();
    controllerEndDay.clear();
    controllerPersent.clear();
    controllersolandung.clear();
  }

  void _submitDeleteCoupons(Coupons coupon, BuildContext context) async {
    Get.dialog(
      MyDialog(
        onTapLeading: () async {
          Navigator.of(context).pop();
          await FirestoreHelper.dateleMagiamGia(coupon);
        },
        onTapTrailling: () {
          Navigator.of(context).pop();
        },
        title: 'Xóa?',
        content: Text(
          'Bạn chắc chắn muốn xóa?',
          style: text(context)
              .titleMedium
              ?.copyWith(color: colorScheme(context).tertiary),
        ),
      ),
    );
  }

  Future<String> showCustomDatePicker({required bool isShowTomorrow}) async {
    DateTime currentDate = DateTime.now();
    DateTime tomorrow = currentDate.add(const Duration(days: 1));
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: isShowTomorrow ? tomorrow : DateTime.now(),
      firstDate: isShowTomorrow ? tomorrow : DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      String formattedDate = FormatDate().formatDateTime(selectedDate);
      return formattedDate;
    } else {
      return ''; // Hoặc giá trị mặc định nếu không có ngày nào được chọn.
    }
  }
}
