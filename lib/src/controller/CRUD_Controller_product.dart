import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:managerfoodandcoffee/src/common_widget/textform.dart';
import 'package:managerfoodandcoffee/src/firebasehelper/firebasestore_helper.dart';
import 'package:managerfoodandcoffee/src/model/sanpham_model.dart';
import 'package:managerfoodandcoffee/src/screen/desktop/pageadmin/DieuChinh/page_crud/widget/crudDialogsanpham/editsanpham.dart';
import 'package:managerfoodandcoffee/src/screen/desktop/pageadmin/DieuChinh/page_crud/widget/cruddialogdanhmuc/addDanhmucDialog.dart';
import 'package:managerfoodandcoffee/src/screen/desktop/pageadmin/DieuChinh/page_crud/widget/cruddialogdanhmuc/editDanhmucDialog.dart';
import 'package:progress_dialog2/progress_dialog2.dart';

class UploadAndViewImage extends StatefulWidget {
  const UploadAndViewImage({Key? key}) : super(key: key);

  @override
  _UploadAndViewImageState createState() => _UploadAndViewImageState();
}

class _UploadAndViewImageState extends State<UploadAndViewImage> {
  String _imageFile = '';
  late ProgressDialog pr;
  Uint8List? selectedImageInBytes;
  String linkanh = "";
  TextEditingController txtnamesp = TextEditingController();
  TextEditingController txtmieutasp = TextEditingController();
  TextEditingController txtgia = TextEditingController();
  String? selectedValue;
  final formKey = GlobalKey<FormState>();
  void _submidform() async {
    if (formKey.currentState!.validate() && selectedValue != null) {
      // Gọi phương thức uploadImage
      try {
        if (linkanh == "") {
          await uploadImage(selectedImageInBytes!);
        }
        await FirestoreHelper.creadsp(SanPham(
            tensp: txtnamesp.text,
            giasp: int.parse(txtgia.text),
            mieuta: txtmieutasp.text,
            danhmuc: selectedValue.toString(),
            hinhanh: linkanh));
        txtnamesp.clear();
        txtgia.clear();
        txtmieutasp.clear();

        // Get.to(() => dieuchinhSceen());
      } catch (e) {
        Get.rawSnackbar(
          message: "vui lòng chọn hình ảnh. hoặc danh mục",
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

  // Phương thức để resize hình ảnh trước khi tải lên Firebase Storage
  Future<void> resizeAndUploadImage(Uint8List selectedImageInBytes) async {
    try {
      // pr.show(); // Hiển thị hộp thoại đợi
      // Đọc hình ảnh từ dữ liệu bytes
      img.Image originalImage = img.decodeImage(selectedImageInBytes)!;

      // Kích thước mục tiêu cho hình ảnh sau khi resize
      int targetWidth = 300; // Đổi kích thước theo ý muốn
      // int targetHeight = 500;
      // Resize hình ảnh với kích thước mục tiêu
      img.Image resizedImage = img.copyResize(
        originalImage,
        width: targetWidth,
        // height: targetHeight,
      );

      // Chuyển hình ảnh đã resize thành dạng bytes
      Uint8List resizedImageBytes =
          Uint8List.fromList(img.encodeJpg(resizedImage));

      // Tiếp tục với tải lên Firebase Storage
      await uploadImage(resizedImageBytes);
      //crud
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Lỗi: $e")));
    }
    // finally {
    //   pr.hide(); // Ẩn hộp thoại đợi sau khi tải xong hoặc xảy ra lỗi
    // }
  }

  // Phương thức để tải lên hình ảnh đã chọn lên Firebase Storage
  Future<void> uploadImage(Uint8List selectedImageInBytes) async {
    try {
      pr.show(); // Hiển thị hộp thoại đợi
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
      pr.hide(); // Ẩn hộp thoại đợi sau khi tải xong hoặc xảy ra lỗi
    }
  }

  // phương thức xoá hình ảnh cũ dựa trên link
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
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 10,
                  ),
                  child: textformfield(
                    hintext: "tên sản phẩm",
                    labeltext: "tên sản phẩm",
                    icon: Icon(Icons.forest),
                    regExp: r'^[1-9a-zA-ZÀ-ỹ\s]+$',
                    isempty: "vui lòng điền thông tin",
                    wrongtype: "có ký tự đặc biệt",
                    textcontroller: txtnamesp,
                    hint: false,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 10,
                  ),
                  child: textformfield(
                    hintext: "miêu tả",
                    labeltext: "giới thiệu sản phẩm",
                    icon: Icon(Icons.description),
                    regExp: r'^[1-9a-zA-ZÀ-ỹ\s,.:-]*$',
                    isempty: "vui lòng điền thông tin",
                    wrongtype: "có ký tự đặc biệt",
                    textcontroller: txtmieutasp,
                    hint: false,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 10,
                  ),
                  child: textformfield(
                    hintext: "giá sản phẩm",
                    labeltext: "giá sản phẩm",
                    icon: Icon(Icons.payment),
                    regExp: r'^[0-9]+$',
                    isempty: "vui lòng điền giả của sản phẩm",
                    wrongtype:
                        "có ký tự đặc biệt hoặc chữ (vui lòng điền số tiền )",
                    textcontroller: txtgia,
                    hint: false,
                  ),
                ),
                //   //chon danhmuc
                StreamBuilder(
                  stream: FirestoreHelper.readdanhmuc(),
                  builder: (context, snapshot) {
                    final danhmuc = snapshot.data;
                    if (snapshot.connectionState == ConnectionState.waiting) {
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
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(danhmuc[i].tendanhmuc),
                                  Row(
                                    children: [
                                      IconButton(
                                        tooltip: "tạo mới ",
                                        onPressed: () async {
                                          print("tạo mới");
                                          await Get.dialog(addDanhmuc_dialog());
                                          Navigator.of(context).pop();
                                          // Sau khi dialog đóng xong, thực hiện các thay đổi cần thiết tại đây để làm tươi lại màn hình.
                                          setState(() {
                                            // Thực hiện các thay đổi cần thiết tại đây để làm tươi lại màn hình.
                                          });
                                        },
                                        icon: Icon(Icons.add),
                                      ),
                                      IconButton(
                                        tooltip: "sửa danh mục",
                                        onPressed: () async {
                                          await Get.dialog(Editdanhmuc_dialog(
                                              danhmuc: danhmuc[i]));
                                          Navigator.of(context).pop();

                                          // Sau khi dialog đóng xong, thực hiện các thay đổi cần thiết tại đây để làm tươi lại màn hình.

                                          print(
                                              "capnhap+${danhmuc[i].iddanhmuc}");
                                        },
                                        icon: Icon(Icons.edit),
                                      ),
                                      IconButton(
                                        tooltip: "xoá",
                                        onPressed: () async {
                                          await showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title:
                                                    const Text("xoá dữ liệu"),
                                                content: const Text(
                                                    "bạn có muốn xoá"),
                                                actions: [
                                                  ElevatedButton(
                                                      onPressed: () {
                                                        FirestoreHelper
                                                            .deletedanhmuc(
                                                                danhmuc[i]);
                                                        Navigator.of(context)
                                                            .pop();
                                                        // Sau khi dialog đóng xong, thực hiện các thay đổi cần thiết tại đây để làm tươi lại màn hình.
                                                      },
                                                      child:
                                                          const Text("delete"))
                                                ],
                                              );
                                            },
                                          );
                                          print("xoa+${danhmuc[i].iddanhmuc}");
                                        },
                                        icon: Icon(Icons.delete),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        }
                      }
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 1),
                              borderRadius: BorderRadius.circular(20)),
                          child: DropdownButton(
                            value: selectedValue,
                            underline: SizedBox(),
                            isExpanded: true,
                            hint: Text("chọn danh mục sản phẩm"),
                            items: danhmucItem,
                            onChanged: (value) {
                              setState(() {
                                selectedValue = value;
                                print(selectedValue);
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
                        width: 200,
                        height: 200,
                        scale: 1,
                        fit: BoxFit.cover,
                      )
                    : Text('Không có hình ảnh để hiển thị'),
                const SizedBox(height: 20),

                // nut nhan

                ElevatedButton(
                  onPressed: () {
                    print(selectedValue);
                    _submidform();
                  },
                  child: Text('THÊM MỚI'),
                ),
              ],
            ),
          ),
        ),
        StreamBuilder<List<SanPham>>(
          stream: FirestoreHelper.readsp(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text("lỗi"),
              );
            }
            if (snapshot.hasData) {
              final sanpham = snapshot.data;
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: SizedBox(
                    height: 800,
                    child: GridView.builder(
                      itemCount: sanpham!.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5, // Bạn có thể thay đổi số cột ở đây
                        mainAxisSpacing:
                            10.0, // Điều chỉnh khoảng cách giữa các mục theo chiều dọc
                        crossAxisSpacing:
                            10.0, // Điều chỉnh khoảng cách giữa các mục theo chiều ngang
                      ),
                      itemBuilder: (context, index) {
                        final sanphamindex = sanpham[index];
                        return Container(
                          height: 250,
                          width: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              Image.network(
                                sanphamindex.hinhanh,
                                height: 150,
                                width: 150,
                                fit: BoxFit.contain,
                              ),
                              Text(sanphamindex.tensp),
                              Text(sanphamindex.giasp.toString()),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    tooltip: "cập nhập",
                                    onPressed: () {
                                      Get.dialog(
                                          editSanpham(sanpham: sanphamindex));
                                    },
                                    icon: Icon(Icons.edit),
                                  ),
                                  IconButton(
                                    tooltip: "xoá",
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text("xoá dữ liệu"),
                                            content:
                                                const Text("bạn có muốn xoá"),
                                            actions: [
                                              ElevatedButton(
                                                  onPressed: () {
                                                    deleteImageByURL(
                                                        sanphamindex.hinhanh);
                                                    FirestoreHelper.deletesp(
                                                            sanphamindex)
                                                        .then((value) =>
                                                            Navigator.pop(
                                                                context));
                                                  },
                                                  child: const Text("delete"))
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    icon: Icon(Icons.delete),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        )
      ],
    );
  }
}
