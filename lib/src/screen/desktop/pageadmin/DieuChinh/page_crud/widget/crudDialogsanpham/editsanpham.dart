import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:get/get.dart';
import 'package:managerfoodandcoffee/src/model/sanpham_model.dart';
import 'package:progress_dialog2/progress_dialog2.dart';

import '../../../../../../../firebase_helper/firebasestore_helper.dart';

class editSanpham extends StatefulWidget {
  final SanPham sanpham;
  const editSanpham({super.key, required this.sanpham});

  @override
  State<editSanpham> createState() => _editSanphamState();
}

class _editSanphamState extends State<editSanpham> {
  String _imageFile = '';
  late ProgressDialog pr;
  Uint8List? selectedImageInBytes;
  String linkanh = "";
  TextEditingController? txttensp;
  TextEditingController? txtgiasp;
  TextEditingController? txtmieuta;
  String? txtdanhmuc;
  final formKey = GlobalKey<FormState>();
  // Phương thức để chọn hình ảnh trong Flutter Web
  Future<void> pickImage() async {
    try {
      // Chọn hình ảnh bằng gói file_picker
      FilePickerResult? fileResult = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      // Nếu người dùng chọn một hình ảnh, lưu hình ảnh đã chọn vào biến
      if (fileResult != null) {
        setState(() {
          _imageFile = fileResult.files.first.name;
          selectedImageInBytes = fileResult.files.first.bytes;
          linkanh = "";
        });
      }
    } catch (e) {
      // Nếu có lỗi xảy ra, hiển thị SnackBar với thông báo lỗi
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Lỗi: $e")));
    }
  }

  // Phương thức để tải lên hình ảnh đã chọn lên Firebase Storage
  Future<void> uploadImage(Uint8List selectedImageInBytes) async {
    try {
      pr.show();
      // Đây là tham chiếu đến nơi hình ảnh được tải lên trong ngăn xếp Firebase Storage
      Reference ref =
          FirebaseStorage.instance.ref().child('sanpham').child(_imageFile);

      // Thiết lập siêu dữ liệu để lưu định dạng của hình ảnh
      final metadata = SettableMetadata(contentType: 'image/jpeg');

      // Tạo UploadTask để tải lên hình ảnh
      UploadTask uploadTask = ref.putData(selectedImageInBytes, metadata);

      // Sau khi tải lên thành công, hiển thị SnackBar
      // Đợi cho tải lên hoàn thành
      await uploadTask.whenComplete(() async {
        // Lấy địa chỉ URL của hình ảnh từ Firebase Storage
        String downloadURL = await ref.getDownloadURL();
        setState(() {
          linkanh = downloadURL;
        });

        // Hiển thị địa chỉ URL trong SnackBar hoặc thực hiện bất kỳ hành động nào bạn muốn
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Ảnh Đã Được Tải Lên: $downloadURL")));

        // Nếu bạn muốn lưu địa chỉ URL cho sử dụng sau này, bạn có thể lưu nó vào một biến hoặc cơ sở dữ liệu.
      });
    } catch (e) {
      // Nếu có lỗi xảy ra trong quá trình tải lên, hiển thị SnackBar với thông báo lỗi
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      pr.hide();
    }
  }

//phương thức xoá hình ảnh cũ dựa trên link
  Future<void> deleteImageByURL(String imageUrl) async {
    try {
      // Lấy tên tệp từ URL bằng cách tách chuỗi URL
      final Uri uri = Uri.parse(imageUrl);
      final String imagePath = uri.pathSegments.last;
      // Thực hiện xóa hình ảnh sử dụng tên tệp
      final Reference storageReference =
          FirebaseStorage.instance.ref().child(imagePath);
      await storageReference.delete();
      print('Hình ảnh đã được xóa thành công.');
    } catch (e) {
      print('Lỗi khi xóa hình ảnh: $e');
    }
  }

  void _submidform() async {
    if (formKey.currentState!.validate()) {
      try {
        if (linkanh == "") {
          uploadImage(selectedImageInBytes!);
          deleteImageByURL(widget.sanpham.hinhanh);
        }
        FirestoreHelper.updatesp(
          SanPham(
              tensp: txttensp!.text,
              giasp: int.parse(txtgiasp!.text),
              mieuta: txtmieuta!.text,
              danhmuc: txtdanhmuc.toString(),
              hinhanh: linkanh,
              idsp: widget.sanpham.idsp),
        ).then((value) => navigator!.pop(context));
        ;
      } catch (e) {
        Get.rawSnackbar(
          message: e.toString(),
          duration: Duration(seconds: 3), // Độ dài hiển thị
          isDismissible: true, // Cho phép đóng Snackbar bằng cách nhấn vào nó
          margin: EdgeInsets.all(16.0), // Đặt khoảng cách bên trái
          borderRadius: 12, // Bỏ viền bo tròn
          animationDuration: Duration(milliseconds: 300),
          backgroundGradient: LinearGradient(
            colors: [Colors.blue, Colors.green], // Màu nền
            stops: [0.1, 0.9],
          ),
        );
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pr = ProgressDialog(context);
    pr.style(
      message: 'Đang tải lên...',
      progressWidget: CircularProgressIndicator(),
      maxProgress: 100.0,
    );
    linkanh = widget.sanpham.hinhanh;
    txtgiasp = TextEditingController(text: widget.sanpham.giasp.toString());
    txttensp = TextEditingController(text: widget.sanpham.tensp);
    txtmieuta = TextEditingController(text: widget.sanpham.mieuta);
    txtdanhmuc = widget.sanpham.danhmuc;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    txttensp!.dispose();
    txtgiasp!.dispose();
    txtmieuta!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      title: Text("CẬP NHẬP"),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Center(
            child: Container(
              height: 800,
              width: 800,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 10,
                      ),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: txttensp,
                        decoration: InputDecoration(
                          hintText: "sản phẩm",
                          labelText: "sản phẩm",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        validator: (value) => value!.isEmpty
                            ? "vui lòng nhập dữ liệu"
                            : RegExp("").hasMatch(value)
                                ? null
                                : "sai định dạng",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 10,
                      ),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: txtmieuta,
                        decoration: InputDecoration(
                          hintText: "miêu tả sản phẩm",
                          labelText: " miêu tả sản phẩm",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        validator: (value) => value!.isEmpty
                            ? "vui lòng nhập dữ liệu"
                            : RegExp("").hasMatch(value)
                                ? null
                                : "sai định dạng",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 10,
                      ),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: txtgiasp,
                        decoration: InputDecoration(
                          hintText: "nhập giá sản phẩm",
                          labelText: "nhập giá sản phẩm",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        validator: (value) => value!.isEmpty
                            ? "vui lòng nhập dữ liệu"
                            : RegExp("").hasMatch(value)
                                ? null
                                : "sai định dạng",
                      ),
                    ),
                    //   //chon danhmuc
                    StreamBuilder(
                      stream: FirestoreHelper.readdanhmuc(),
                      builder: (context, snapshot) {
                        final danhmuc = snapshot.data;
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: Text("lỗi"),
                          );
                        }
                        List<DropdownMenuItem> danhmucItem = [];
                        if (snapshot.hasData) {
                          if (danhmuc != null) {
                            for (var i = 0; i < danhmuc.length; i++) {
                              danhmucItem.add(
                                DropdownMenuItem(
                                  value: danhmuc[i].tendanhmuc,
                                  child: Text(danhmuc[i].tendanhmuc),
                                ),
                              );
                            }
                          }
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.black, width: 1),
                                  borderRadius: BorderRadius.circular(20)),
                              child: DropdownButton(
                                value: txtdanhmuc,
                                underline: SizedBox(),
                                isExpanded: true,
                                hint: Text("chọn danh mục sản phẩm"),
                                items: danhmucItem,
                                onChanged: (value) {
                                  setState(() {
                                    txtdanhmuc = value;
                                  });
                                },
                              ),
                            ),
                          );
                        }
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                    //end chọn danh mục

                    //
                    ElevatedButton(
                      onPressed: () async {
                        pickImage();
                      },
                      child: Text('Chọn hình ảnh từ thư viện'),
                    ),
                    SizedBox(height: 20),
                    _imageFile.isNotEmpty
                        ? Image.memory(
                            selectedImageInBytes!,
                            width: 150,
                            height: 150,
                            scale: 1,
                            fit: BoxFit.fill,
                          )
                        : Image.network(
                            linkanh,
                            width: 150,
                            height: 150,
                            scale: 1,
                            fit: BoxFit.fill,
                          ),
                    const SizedBox(height: 20),

                    // nut nhan

                    ElevatedButton(
                      onPressed: () {
                        _submidform();
                        Navigator.of(context).pop();
                      },
                      child: Text('THÊM MỚI'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
