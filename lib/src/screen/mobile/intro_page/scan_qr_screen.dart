import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managerfoodandcoffee/src/common_widget/snack_bar_getx.dart';
import 'package:managerfoodandcoffee/src/controller_getx/table_controller.dart';
import 'package:managerfoodandcoffee/src/firebase_helper/firebasestore_helper.dart';
import 'package:managerfoodandcoffee/src/model/table_model.dart';
import 'package:managerfoodandcoffee/src/screen/mobile/intro_page/check_location_page.dart';
import 'package:managerfoodandcoffee/src/utils/colortheme.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key, required this.vido, required this.kinhdo})
      : super(key: key);
  final double vido;
  final double kinhdo;

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  List<TableModel> listTable = [];

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (result != null)
                    Text(
                        'Type: ${describeEnum(result!.format)}   Bàn: ${result!.code}'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                            onPressed: () async {
                              await controller?.toggleFlash();
                              setState(() {});
                            },
                            child: FutureBuilder(
                              future: controller?.getFlashStatus(),
                              builder: (context, snapshot) {
                                return Text(
                                  'Đèn: ${snapshot.data}',
                                  style: TextStyle(
                                      color: colorScheme(context).tertiary),
                                );
                              },
                            )),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                            onPressed: () async {
                              await controller?.flipCamera();
                              setState(() {});
                            },
                            child: FutureBuilder(
                              future: controller?.getCameraInfo(),
                              builder: (context, snapshot) {
                                if (snapshot.data != null) {
                                  return Text(
                                    'Máy ảnh trước: ${describeEnum(snapshot.data!)}',
                                    style: TextStyle(
                                        color: colorScheme(context).tertiary),
                                  );
                                } else {
                                  return const Text('loading');
                                }
                              },
                            )),
                      )
                    ],
                  ),
                  StreamBuilder(
                    stream: FirestoreHelper.readtable(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.hasData) {
                        final controllerTable = Get.put(TableController());
                        //Sắp xếp tên bàn theo thứ tự nhỏ đén lớn theo tên bàn
                        int compareByTenBan(TableModel a, TableModel b) {
                          return int.parse(a.tenban)
                              .compareTo(int.parse(b.tenban));
                        }

                        snapshot.data!.sort(compareByTenBan);
                        controllerTable.addTable(snapshot.data!);

                        listTable = snapshot.data!;
                        return const SizedBox();
                      }
                      return const SizedBox();
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Quay lại',
                            style:
                                TextStyle(color: colorScheme(context).tertiary),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller?.pauseCamera();
                          },
                          child: Text(
                            'Dừng',
                            style:
                                TextStyle(color: colorScheme(context).tertiary),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller?.resumeCamera();
                          },
                          child: Text(
                            'Tiếp tục',
                            style:
                                TextStyle(color: colorScheme(context).tertiary),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });

    controller.scannedDataStream.listen((scanData) {
      bool isTableFound = false;
      TableModel? tableModel;

      if (listTable.isNotEmpty) {
        for (var element in listTable) {
          if (element.tenban == scanData.code) {
            tableModel = element;
            isTableFound = true;
            break;
          }
        }
      }

      setState(() {
        result = scanData;
      });

      if (isTableFound) {
        _showLocationCheckDialog(tableModel!);
      } else {
        _showErrorSnackBar("Lỗi", "Hãy quét lại mã bàn");
        return;
      }
    });
  }

  void _showLocationCheckDialog(TableModel tableModel) async {
    Get.dialog(
      LocationCheckPage(
        vido: widget.vido,
        kinhdo: widget.kinhdo,
        table: tableModel,
      ),
    );
    await controller?.pauseCamera();
  }

  void _showErrorSnackBar(String title, String message) {
    showCustomSnackBar(
      title: title,
      message: message,
      type: Type.error,
    );
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
//commit