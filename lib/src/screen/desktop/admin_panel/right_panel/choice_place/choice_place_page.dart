import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:managerfoodandcoffee/src/common_widget/my_button.dart';
import 'package:managerfoodandcoffee/src/common_widget/snack_bar_getx.dart';
import 'package:managerfoodandcoffee/src/firebase_helper/firebasestore_helper.dart';
import 'package:managerfoodandcoffee/src/utils/colortheme.dart';
import 'package:managerfoodandcoffee/src/utils/texttheme.dart';
import 'package:latlong2/latlong.dart' as latlong; // Import LatLng từ gói đúng

class ChoicePlacePage extends StatefulWidget {
  const ChoicePlacePage({super.key});

  @override
  State<ChoicePlacePage> createState() => _ChoicePlacePageState();
}

class _ChoicePlacePageState extends State<ChoicePlacePage> {
  // final Completer<GoogleMapController> _controller =
  //     Completer<GoogleMapController>();

  // final controllerSearch = TextEditingController();

  double? longitude;
  double? latitude;
  double? longitudeNew;
  double? latitudeNew;
  String test = '';
  Future<void> setLocation() async {
    latitudeNew = null;
    longitudeNew = null;
    if (longitude != null && latitude != null) {
      await FirestoreHelper.updateMaps(
          longitude: longitude ?? 0, latitude: latitude ?? 0);
      showCustomSnackBar(
          title: 'Thành công',
          message: 'Thay đổi vị trí cửa hàng thành công ^^',
          type: Type.success);
    } else {
      showCustomSnackBar(
          title: 'Có lỗi',
          message: 'Có lỗi khi chọn vị trí !!!',
          type: Type.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        StreamBuilder(
          stream: FirestoreHelper.readmap(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              final maplocation = snapshot.data;
              if (maplocation != null) {
                latitude = maplocation[0].vido;
                longitude = maplocation[0].kinhdo;
              }
              return FlutterMap(
                options: MapOptions(
                  enableScrollWheel: true,
                  initialCenter: latlong.LatLng(
                      latitudeNew ?? latitude!, longitudeNew ?? longitude!),
                  initialZoom: 17.0,
                  onPositionChanged: (position, hasGesture) {
                    latitude = position.center?.latitude;
                    longitude = position.center?.longitude;
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.app',
                  ),
                ],
              );

              // return GoogleMap(
              //   mapType: MapType.none,
              //   initialCameraPosition: CameraPosition(
              //     bearing: 192.8334901395799,
              //     target: LatLng(
              //         latitudeNew ?? latitude!, longitudeNew ?? longitude!),
              //     tilt: 59.440717697143555,
              //     zoom: 17.151926040649414,
              //   ),
              //   onMapCreated: (GoogleMapController controller) {
              //     _controller.complete(controller);
              //   },
              //   onCameraMove: (position) {
              //     latitude = position.target.latitude;
              //     longitude = position.target.longitude;
              //   },
              // );
            }
            return const SizedBox();
          },
        ),
        const Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          child: Icon(
            CupertinoIcons.placemark_fill,
            color: Colors.red,
            size: 46,
          ),
        ),
        // Positioned(
        //     top: 50,
        //     left: 0,
        //     right: 0,
        //     child: Padding(
        //       padding: const EdgeInsets.symmetric(horizontal: 300),
        //       child: FlutterGooglePlacesWeb(
        //         onTap: (listLatLng) {
        //           setState(() {
        //             latitudeNew = listLatLng[0];
        //             longitudeNew = listLatLng[1];
        //           });
        //         },
        //         decoration: InputDecoration(
        //             prefixIcon: const Icon(CupertinoIcons.search),
        //             labelText: 'Tìm địa điểm',
        //             labelStyle: const TextStyle(color: Colors.white),
        //             contentPadding: const EdgeInsets.symmetric(horizontal: 28),
        //             filled: true,
        //             border: const OutlineInputBorder(
        //                 borderRadius: BorderRadius.all(Radius.circular(8)),
        //                 borderSide: BorderSide.none),
        //             fillColor: colorScheme(context).background),
        //         apiKey: kGoogleApiKey,
        //         // proxyURL: 'https://cors-anywhere.herokuapp.com/',
        //         required: true,
        //       ),
        //     )),
        Positioned(
          top: 50,
          right: 20,
          child: MyButton(
            onTap: () {
              setLocation();
            },
            backgroundColor: colorScheme(context).onSurfaceVariant,
            height: 48,
            width: 150,
            text: Text(
              'Chọn vị trí',
              style: text(context)
                  .titleSmall
                  ?.copyWith(color: colorScheme(context).tertiary),
            ),
          ),
        )
      ],
    );
  }
}
