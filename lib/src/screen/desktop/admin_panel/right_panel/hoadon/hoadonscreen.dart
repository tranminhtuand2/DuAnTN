import 'package:flutter/material.dart';
import 'package:managerfoodandcoffee/src/firebase_helper/firebasestore_helper.dart';
import 'package:managerfoodandcoffee/src/utils/size.dart';

import '../../../../../model/Invoice_model.dart';

class hoaDonScreen extends StatefulWidget {
  const hoaDonScreen({super.key});

  @override
  State<hoaDonScreen> createState() => _hoaDonScreenState();
}

class _hoaDonScreenState extends State<hoaDonScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HOÁ ĐƠN CHECK"),
      ),
      body: Row(
        children: [
          Container(
            width: SizeConfig.screenWidth / 2,
            height: SizeConfig.screenHeight,
            color: Colors.amber,
            child: StreamBuilder<List<Invoice>>(
              stream: FirestoreHelper.readInvoices(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text("lỗi:$snapshot.error"),
                  );
                }
                if (snapshot.hasData) {}
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
          Expanded(child: Container()),
        ],
      ),
    );
  }
}
