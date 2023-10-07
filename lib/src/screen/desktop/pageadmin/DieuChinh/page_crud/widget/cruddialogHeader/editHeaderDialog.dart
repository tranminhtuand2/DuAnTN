import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managerfoodandcoffee/src/model/header_model.dart';
import 'package:progress_dialog2/progress_dialog2.dart';
import '../../../../../../../firebasehelper/firebasestore_helper.dart';

class editheader_Dialog extends StatefulWidget {
  final HeaderModel header;
  const editheader_Dialog({super.key, required this.header});

  @override
  State<editheader_Dialog> createState() => _editheader_DialogState();
}

class _editheader_DialogState extends State<editheader_Dialog> {
  String _imageFile = '';
  late ProgressDialog pr;
  Uint8List? selectedImageInBytes;
  String linkanh = "";
  TextEditingController? textcontent;

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
          FirebaseStorage.instance.ref().child('header').child(_imageFile);

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
    textcontent = TextEditingController(text: widget.header.content);
    linkanh = widget.header.headerImage;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    textcontent!.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      title: Text("CẬP NHẬP"),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  height: 300,
                  width: double.infinity,
                  color: Theme.of(context).colorScheme.onSecondary,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: ElevatedButton(
                            onPressed: () async {
                              pickImage();
                            },
                            child: Text('Chọn hình ảnh'),
                          ),
                        ),
                        SizedBox(height: 20),
                        _imageFile.isNotEmpty
                            ? Image.memory(
                                selectedImageInBytes!,
                                width: 150,
                                height: 100,
                                scale: 1,
                                fit: BoxFit.fill,
                              )
                            : Image.network(
                                linkanh,
                                width: 150,
                                height: 100,
                                scale: 1,
                                fit: BoxFit.fill,
                              ),
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            width: 600,
                            child: TextFormField(
                              controller: textcontent,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "nội dung"),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () async {
                            // pr.show();
                            // Gọi phương thức uploadImage
                            try {
                              if (linkanh == "") {
                                await uploadImage(selectedImageInBytes!);
                                deleteImageByURL(widget.header.headerImage);
                              }
                              FirestoreHelper.update(
                                HeaderModel(
                                    content: textcontent!.text,
                                    headerImage: linkanh,
                                    id: widget.header.id),
                              ).then((value) => navigator!.pop(context));
                            } catch (e) {
                              Get.rawSnackbar(
                                message: "vui lòng chọn hình ảnh.",
                                duration:
                                    Duration(seconds: 3), // Độ dài hiển thị
                                isDismissible:
                                    true, // Cho phép đóng Snackbar bằng cách nhấn vào nó
                                margin: EdgeInsets.all(
                                    16.0), // Đặt khoảng cách bên trái
                                borderRadius: 12, // Bỏ viền bo tròn
                                animationDuration: Duration(milliseconds: 300),
                                backgroundGradient: LinearGradient(
                                  colors: [
                                    Colors.blue,
                                    Colors.green
                                  ], // Màu nền
                                  stops: [0.1, 0.9],
                                ),
                              );
                            }

                            // pr.hide();
                          },
                          child: Text('THÊM MỚI'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
