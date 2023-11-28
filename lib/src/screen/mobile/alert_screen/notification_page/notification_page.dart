import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:managerfoodandcoffee/src/common_widget/coupons_item.dart';
import 'package:managerfoodandcoffee/src/common_widget/snack_bar_getx.dart';
import 'package:managerfoodandcoffee/src/firebase_helper/firebasestore_helper.dart';
import 'package:managerfoodandcoffee/src/model/coupons_model.dart';
import 'package:managerfoodandcoffee/src/utils/format_date.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: StreamBuilder(
        stream: FirestoreHelper.getDataCoupons(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final couponsList = snapshot.data;
            return Padding(
              padding: const EdgeInsets.only(top: 20, right: 6, left: 6),
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
                  return GestureDetector(
                    onLongPress: () {
                      Clipboard.setData(ClipboardData(text: coupons.data));
                      showCustomSnackBar(
                          title: 'Copy',
                          message: "Đã sao chép mã giảm giá",
                          type: Type.success);
                    },
                    child: CouponItem(
                      soluotdung: coupons.soluotdung,
                      discount: '${coupons.persent}%',
                      details: '\'${coupons.data}\'',
                      validDate:
                          'Áp dụng từ ${coupons.beginDay} - ${coupons.endDay}',
                      startColor: Colors.teal,
                      endColor: Colors.teal[100]!,
                      isEnable: coupons.isEnable,
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
    );
  }

  @override
  bool get wantKeepAlive => true;
}
