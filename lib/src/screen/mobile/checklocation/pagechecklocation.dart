import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:managerfoodandcoffee/src/screen/mobile/pagetrangtru.dart';

class LocationCheckPage extends StatefulWidget {
  final double vido;
  final double kinhdo;
  final String tenban;
  const LocationCheckPage(
      {super.key,
      required this.vido,
      required this.kinhdo,
      required this.tenban});

  @override
  State<LocationCheckPage> createState() => _LocationCheckPageState();
}

class _LocationCheckPageState extends State<LocationCheckPage> {
  @override
  void initState() {
    super.initState();
    checkLocation(widget.vido, widget.kinhdo);
    print("${widget.kinhdo},${widget.vido}");
  }

  Future<void> checkLocation(double vido, double kinhdo) async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      //xử lý dữ liệu khi người dùng không đáp ứng
      return;
    }
    Position currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
    //12.679977153272034, 108.02220482420341
    //12.702650385123615, 108.07410104860656
    double targetLat = vido; //12.679977153272034 /* Vĩ độ của vị trí cụ thể */;
    double targetLon =
        kinhdo; //108.02220482420341 /* Kinh độ của vị trí cụ thể */;

    double distance = Geolocator.distanceBetween(targetLat, targetLon,
        currentPosition.latitude, currentPosition.longitude);
    if (distance <= 10000000.0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => LoginPage(
                  tenban: widget.tenban,
                )),
      );
      // Điều kiện đáp ứng, chuyển hướng tới trang đăng nhập.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bạn dang nhap thanh cong.${distance.ceil()}'),
        ),
      );
    } else {
      // Người dùng không ở trong phạm vi 100m, hiển thị thông báo hoặc thực hiện hành động khác.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'bạn cách quán : ${distance.ceil()} m không nằm trong phạm vi của quán'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Scaffold(
          appBar: AppBar(
            title: const Text('Kiểm tra vị trí'),
          ),
          body: Center(
            child: Column(
              children: [
                Lottie.asset(
                  "assets/images/location.json",
                  animate: true,
                  height: 200,
                  width: 200,
                ),
                const Text("đang kiểm tra..."),
                const CircularProgressIndicator(),
              ],
            ),
          )),
    );
  }
}
