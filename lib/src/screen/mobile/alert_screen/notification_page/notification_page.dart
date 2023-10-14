import 'package:flutter/material.dart';
import 'package:managerfoodandcoffee/src/firebase_helper/firebasestore_helper.dart';
import 'package:managerfoodandcoffee/src/model/coupons_model.dart';

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
              padding: const EdgeInsets.only(top: 20),
              child: ListView.builder(
                itemCount: couponsList?.length,
                itemBuilder: (context, index) {
                  Coupons coupons = couponsList![index];
                  return CouponItem(
                    discount: '- ${coupons.persent}%',
                    details: '\'${coupons.data}\'',
                    validDate:
                        'Áp dụng từ ${coupons.beginDay} - ${coupons.endDay}',
                    startColor: Colors.teal,
                    endColor: Colors.teal[100]!,
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
    return Container(
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
          Text(
            discount,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
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
    );
  }
}
