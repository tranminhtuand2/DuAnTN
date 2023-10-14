import 'package:flutter/material.dart';
import 'package:managerfoodandcoffee/src/common_widget/cache_image.dart';
import 'package:managerfoodandcoffee/src/constants/size.dart';
import 'package:managerfoodandcoffee/src/firebase_helper/firebasestore_helper.dart';
import 'package:managerfoodandcoffee/src/model/card_model.dart';
import 'package:managerfoodandcoffee/src/model/sanpham_model.dart';

class DetailPage extends StatefulWidget {
  final SanPham sanpham;
  final String tenban;
  const DetailPage({super.key, required this.sanpham, required this.tenban});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int soluong = 1;
  int giasanpham = 1;
  TextEditingController txtghichu = TextEditingController();
  // final getAlert showdialog = Get.put(getAlert());
  // late ProgressDialog pr;
  // @override
  // void initState() {
  //   super.initState();
  //   giasanpham = soluong * widget.sanpham.giasp;
  //   pr = ProgressDialog(context);
  //   pr.style(
  //     message: 'Đang thêm',
  //     progressWidget: const CircularProgressIndicator(),
  //     maxProgress: 100.0,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(
              child: cacheNetWorkImage(
                widget.sanpham.hinhanh,
                height: SizeConfig.screenHeight / 2,
                fit: BoxFit.contain,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    widget.sanpham.tensp,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).colorScheme.onSecondary),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: bangtinhtien(context),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    height: 50,
                    child: TextFormField(
                      controller: txtghichu,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        suffixIcon: txtghichu.text.isEmpty
                            ? Container(
                                width: 0,
                              )
                            : IconButton(
                                onPressed: () => txtghichu.clear(),
                                icon: const Icon(Icons.close),
                              ),
                        labelText: "Ghi Chú",
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  child: InkWell(
                    onTap: () async {
                      // pr.show();
                      try {
                        await FirestoreHelper.createdgiohang(
                            GioHang(
                                tensp: widget.sanpham.tensp,
                                giasp: widget.sanpham.giasp,
                                soluong: soluong,
                                ghichu: txtghichu.text,
                                hinhanh: widget.sanpham.hinhanh),
                            widget.tenban);
                      } finally {
                        // pr.hide();
                      }
                      // Get.to(() => HomePage(tenban: widget.tenban));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(width: 1),
                          color:
                              Theme.of(context).colorScheme.primaryContainer),
                      child: const Text(
                        "THÊM VÀO GIỎ HÀNG",
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Row bangtinhtien(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            widget.sanpham.tensp,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            width: 120,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(width: 2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (soluong > 1) {
                        soluong--;
                      } else {
                        // showdialog.showAlertDialog(
                        //     "thông báo", "sản phẩm tối thiểu là 1");
                      }
                      giasanpham = soluong * widget.sanpham.giasp;
                    });
                  },
                  icon: const Icon(
                    Icons.remove,
                    size: 20,
                  ),
                ),
                Text(
                  "$soluong",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (soluong >= 10) {
                        soluong = 10;
                        // showdialog.showAlertDialog(
                        //     "thông báo", "sản phẩm tối đa là 10");
                      } else {
                        soluong++;
                      }
                      giasanpham = soluong * widget.sanpham.giasp;
                    });
                  },
                  icon: const Icon(
                    Icons.add,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
        Text(
          "$giasanpham vnd",
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(letterSpacing: 1.5),
        ),
      ],
    );
  }
}
