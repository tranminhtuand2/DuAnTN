import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:managerfoodandcoffee/src/common_widget/input_field.dart';
import 'package:managerfoodandcoffee/src/common_widget/snack_bar_getx.dart';
import 'package:managerfoodandcoffee/src/firebase_helper/firebasestore_helper.dart';
import 'package:managerfoodandcoffee/src/model/coupons_model.dart';
import 'package:managerfoodandcoffee/src/screen/mobile/alert_screen/notification_page/notification_page.dart';
import 'package:managerfoodandcoffee/src/utils/colortheme.dart';
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
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                            child: TicketWidget(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              width: MediaQuery.sizeOf(context).width,
                              height: 170,
                              child: CouponItem(
                                discount: '${coupons.persent}%',
                                details: '\'${coupons.data}\'',
                                validDate:
                                    'Áp dụng từ ${coupons.beginDay} - ${coupons.endDay}',
                                startColor: Colors.teal,
                                endColor: Colors.teal[100]!,
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
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    InputField(
                      controller: controllerData,
                      inputType: TextInputType.text,
                      labelText: 'Nhập mã',
                      prefixIcon: Icon(
                        Icons.code_rounded,
                        color: colorScheme(context).onBackground,
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Vui lòng nhập mã";
                        }
                        if (int.parse(value) > 100) {
                          return "Phần trăm giảm phải dưới 100%";
                        }
                        return null;
                      },
                      textInputFormatters: [
                        FilteringTextInputFormatter.deny(
                            RegExp(r'[\[\]!@#\$%^&*(){}/:";|_=+]')),
                      ],
                    ),
                    const SizedBox(height: 20),
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
                        return null;
                      },
                      textInputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]+')),
                      ],
                    ),
                    const SizedBox(height: 10),
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
                        return null;
                      },
                      textInputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]+')),
                      ],
                    ),
                    const SizedBox(height: 10),
                    InputField(
                      readOnly: true,
                      onTap: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        ).then((selectedDate) {
                          if (selectedDate != null) {
                            controllerBeginDay.text = selectedDate.toString();
                          }
                        });
                      },
                      controller: controllerBeginDay,
                      inputType: TextInputType.number,
                      labelText: 'Ngày bắt đầu',
                      prefixIcon: Icon(
                        Icons.date_range,
                        color: colorScheme(context).onBackground,
                      ),
                    ),
                    const SizedBox(height: 10),
                    InputField(
                      readOnly: true,
                      onTap: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        ).then((selectedDate) {
                          if (selectedDate != null) {
                            controllerEndDay.text = selectedDate.toString();
                          }
                        });
                      },
                      controller: controllerEndDay,
                      inputType: TextInputType.number,
                      labelText: 'Ngày kết thúc',
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
        ],
      ),
    );
  }
}
