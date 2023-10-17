import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:managerfoodandcoffee/src/common_widget/snack_bar_getx.dart';
import 'package:managerfoodandcoffee/src/firebase_helper/firebasestore_helper.dart';
import 'package:managerfoodandcoffee/src/model/coupons_model.dart';
import 'package:ticket_widget/ticket_widget.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
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
                  double width = MediaQuery.sizeOf(context).width;
                  return GestureDetector(
                    onLongPress: () {
                      Clipboard.setData(ClipboardData(text: coupons.data));
                      showCustomSnackBar(
                          title: 'Copy',
                          message: "Đã sao chép mã giảm giá",
                          type: Type.success);
                    },
                    child: TicketWidget(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      width: width,
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
    );
  }
}

class CouponItem extends StatelessWidget {
  final String discount;
  final String details;
  final String validDate;
  final Color startColor;
  final Color endColor;

  const CouponItem({
    super.key,
    required this.discount,
    required this.details,
    required this.validDate,
    required this.startColor,
    required this.endColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [startColor, endColor],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                details,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                validDate,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 16,
          right: 16,
          child: Container(
            width: 50,
            height: 50,
            decoration:
                const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
            child: Center(
              child: Text(
                discount,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 24,
          right: 24,
          child: IconButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: details));
                showCustomSnackBar(
                    title: 'Copy',
                    message: "Đã sao chép mã giảm giá",
                    type: Type.success);
              },
              icon: const Icon(Icons.copy)),
        ),
      ],
    );
  }
}
