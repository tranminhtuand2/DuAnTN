import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:managerfoodandcoffee/src/common_widget/snack_bar_getx.dart';

class CouponItem extends StatelessWidget {
  final String discount;
  final String details;
  final String validDate;
  final Color startColor;
  final Color endColor;
  final bool isEnable;
  final int soluotdung;

  const CouponItem({
    super.key,
    required this.discount,
    required this.details,
    required this.validDate,
    required this.startColor,
    required this.endColor,
    required this.isEnable,
    required this.soluotdung,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipPath(
          clipper: TicketClipper(),
          child: Opacity(
            opacity: isEnable ? 1 : 0.3,
            child: Container(
              width: double.infinity,
              height: 150,
              margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: const Color.fromARGB(255, 191, 85, 101)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            !isEnable ? "0%" : discount,
                            style: const TextStyle(
                              fontSize: 40,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'OFF',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Divider(color: Colors.white),
                          Center(
                            child: Text(
                              '$soluotdung lượt sử dụng'.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 14,
                                overflow: TextOverflow.ellipsis,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 60),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: const Color.fromARGB(255, 255, 218, 193)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text(
                            "Mã giảm giá",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            details,
                            style: const TextStyle(
                              fontSize: 32,
                              color: Color.fromARGB(255, 191, 85, 101),
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            validDate,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 14,
                              overflow: TextOverflow.ellipsis,
                              color: Colors.black.withOpacity(0.7),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 24,
          right: 24,
          child: Visibility(
            visible: isEnable,
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
        ),
      ],
    );
  }
}

class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);

    path.addOval(
        Rect.fromCircle(center: Offset(size.width / 3, 0), radius: 20.0));
    path.addOval(Rect.fromCircle(
        center: Offset(size.width / 3, size.height), radius: 20.0));

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
