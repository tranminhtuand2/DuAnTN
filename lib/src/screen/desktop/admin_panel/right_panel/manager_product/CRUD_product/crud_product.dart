import 'dart:developer';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:managerfoodandcoffee/src/common_widget/cache_image.dart';
import 'package:managerfoodandcoffee/src/common_widget/input_field.dart';
import 'package:managerfoodandcoffee/src/common_widget/loading_dialog.dart';
import 'package:managerfoodandcoffee/src/common_widget/my_button.dart';
import 'package:managerfoodandcoffee/src/common_widget/my_dialog.dart';
import 'package:managerfoodandcoffee/src/common_widget/raw_snack_bar.dart';
import 'package:managerfoodandcoffee/src/controller_getx/categorry_controller.dart';
import 'package:managerfoodandcoffee/src/controller_getx/data_edit_product_controller.dart';
import 'package:managerfoodandcoffee/src/firebase_helper/firebasestore_helper.dart';
import 'package:managerfoodandcoffee/src/model/sanpham_model.dart';
import 'package:managerfoodandcoffee/src/utils/colortheme.dart';
import 'package:managerfoodandcoffee/src/utils/texttheme.dart';

class CRUDProductTab extends StatefulWidget {
  const CRUDProductTab({super.key});

  @override
  State<CRUDProductTab> createState() => _CRUDProductTabState();
}

class _CRUDProductTabState extends State<CRUDProductTab> {
  String _imageFile = '';
  Uint8List? selectedImageInBytes;
  // String linkanh = "";
  // final _nameController = TextEditingController();
  // final _descriptionController = TextEditingController();
  // final _priceController = TextEditingController();
  String? selectedValue;
  final formKey = GlobalKey<FormState>();
  final controllerDataEdit = Get.put(DataEditProductController());
  final categoryController = Get.put(CategoryController());

  void _submitForm() async {
    if (formKey.currentState!.validate()) {
      // Gọi phương thức uploadImage
      try {
        if (controllerDataEdit.urlImage.value.isEmpty) {
          await uploadImage(selectedImageInBytes!);
          controllerDataEdit.isEdit.value
              ? deleteImageByURL(controllerDataEdit.product.value.hinhanh)
              : null;
        }
        !controllerDataEdit.isEdit.value
            ? await FirestoreHelper.creadsp(
                SanPham(
                  tensp: controllerDataEdit.nameController.text,
                  giasp: int.parse(controllerDataEdit.priceController.text),
                  mieuta: controllerDataEdit.descriptionController.text,
                  danhmuc: controllerDataEdit.selectedValue.toString(),
                  hinhanh: controllerDataEdit.urlImage.value,
                ),
              )
            : FirestoreHelper.updatesp(
                SanPham(
                    tensp: controllerDataEdit.nameController.text,
                    giasp: int.parse(controllerDataEdit.priceController.text),
                    mieuta: controllerDataEdit.descriptionController.text,
                    danhmuc: controllerDataEdit.selectedValue.toString(),
                    hinhanh: controllerDataEdit.urlImage.value,
                    idsp: controllerDataEdit.product.value.idsp),
              );
        controllerDataEdit.removeData();
      } catch (e) {
        showRawSnackBar("Vui lòng chọn hình ảnh nếu bạn quên :)");
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
          controllerDataEdit.urlImage.value = "";
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
      showDialog(
        context: context,
        builder: (context) => LoadingDialog(
          onTapLeading: () {
            Navigator.of(context).pop(true);
          },
          title: 'Chờ một lát nhé ...',
        ),
      ); // Hiển thị hộp thoại đợi,

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

        controllerDataEdit.urlImage.value = downloadURL;

        // ignore: use_build_context_synchronously
        // Navigator.of(context).pop();
        // Nếu bạn muốn lưu địa chỉ URL cho sử dụng sau này, bạn có thể lưu nó vào một biến hoặc cơ sở dữ liệu.
      });
    } catch (e) {
      // Nếu có lỗi xảy ra trong quá trình tải lên, hiển thị SnackBar với thông báo lỗi
      log(e.toString());
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) => LoadingDialog(
          onTapLeading: () {
            Navigator.of(context).pop(true);
          },
          title: "LỖI: $e",
        ),
      );
    } finally {
      // ignore: use_build_context_synchronously
      Navigator.of(context)
          .pop(); // Ẩn hộp thoại đợi sau khi tải xong hoặc xảy ra lỗi
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
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Obx(
          () => controllerDataEdit.isEdit.value
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      const Expanded(flex: 2, child: SizedBox()),
                      Expanded(
                        child: MyButton(
                          onTap: () => controllerDataEdit.removeData(),
                          backgroundColor: colorScheme(context).inversePrimary,
                          height: 60,
                          text: Text(
                            'THÊM MÓN',
                            style:
                                TextStyle(color: colorScheme(context).tertiary),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              : const SizedBox(),
        ),
        Expanded(
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  InputField(
                    controller: controllerDataEdit.nameController,
                    inputType: TextInputType.text,
                    labelText: 'Tên món',
                    prefixIcon: Icon(
                      Icons.emoji_nature_rounded,
                      color: colorScheme(context).onBackground,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Vui lòng điền tên món";
                      }
                      return null;
                    },
                    textInputFormatters: [
                      FilteringTextInputFormatter.deny(
                          RegExp(r'[\[\]!@#\$%^&*(){}/:";|_=+]')),
                    ],
                  ),
                  const SizedBox(height: 20),
                  InputField(
                    controller: controllerDataEdit.descriptionController,
                    inputType: TextInputType.text,
                    labelText: 'Mô tả',
                    prefixIcon: Icon(
                      Icons.description,
                      color: colorScheme(context).onBackground,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Vui lòng điền mô tả";
                      }

                      return null;
                    },
                    textInputFormatters: [
                      FilteringTextInputFormatter.deny(
                          RegExp(r'[\[\]!@#\$%^&*(){}/:";|_=+]')),
                    ],
                  ),
                  const SizedBox(height: 20),
                  InputField(
                    controller: controllerDataEdit.priceController,
                    inputType: TextInputType.number,
                    labelText: 'Giá',
                    maxLength: 8,
                    prefixIcon: Icon(
                      Icons.price_check_outlined,
                      color: colorScheme(context).onBackground,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Vui lòng điền giá";
                      }

                      return null;
                    },
                    textInputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]+')),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Obx(
                    () => DropdownButtonFormField(
                      alignment: Alignment.center,
                      value: controllerDataEdit.selectedValue.value,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 20),
                        border: InputBorder.none,
                        filled: true,
                        fillColor: colorScheme(context).onPrimary,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      isExpanded: true,
                      hint: Text(
                        "Chọn danh mục sản phẩm",
                        style: text(context).titleSmall,
                      ),
                      items: categoryController.categories
                          .where((element) =>
                              element != categoryController.categories.first)
                          .map((element) {
                        return DropdownMenuItem(
                            alignment: Alignment.center,
                            value: element.tendanhmuc,
                            child: Text(element.tendanhmuc.toUpperCase()));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          controllerDataEdit.selectedValue.value =
                              value.toString();
                          print(controllerDataEdit.selectedValue);
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Mời chọn danh mục món';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Obx(
                    () => InkWell(
                      onTap: () => pickImage(),
                      child: _imageFile.isNotEmpty &&
                              controllerDataEdit.urlImage.isEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.memory(
                                selectedImageInBytes!,
                                width: 200,
                                height: 200,
                                scale: 1,
                                fit: BoxFit.cover,
                              ),
                            )
                          : controllerDataEdit.urlImage.isEmpty
                              ? Container(
                                  width: 120,
                                  height: 120,
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: colorScheme(context).onPrimary),
                                  child: Icon(
                                    Icons.image,
                                    size: 34,
                                    color: colorScheme(context).onBackground,
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: cacheNetWorkImage(
                                    controllerDataEdit.urlImage.value,
                                    width: 200,
                                    height: 200,
                                  ),
                                ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
        Obx(
          () => controllerDataEdit.isEdit.value
              ? Row(
                  children: [
                    Expanded(
                      child: MyButton(
                        onTap: () {
                          _submitForm();
                          setState(() {
                            _imageFile = '';
                          });
                        },
                        backgroundColor: colorScheme(context).inversePrimary,
                        height: 60,
                        text: Text(
                          'SỬA MÓN',
                          style:
                              TextStyle(color: colorScheme(context).tertiary),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => MyDialog(
                            onTapLeading: () {
                              deleteImageByURL(
                                  controllerDataEdit.urlImage.value);
                              FirestoreHelper.deletesp(
                                      controllerDataEdit.product.value)
                                  .then((value) {
                                Navigator.pop(context);
                                controllerDataEdit.removeData();
                              });
                            },
                            onTapTrailling: () {
                              Navigator.of(context).pop();
                            },
                            title: 'Xóa?',
                            content: Text(
                              'Bạn chắc chắn muốn xóa?',
                              style: text(context).titleMedium?.copyWith(
                                  color: colorScheme(context).tertiary),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: colorScheme(context).primary),
                        child: const Icon(
                          CupertinoIcons.trash,
                          size: 34,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],
                )
              : MyButton(
                  onTap: () {
                    _submitForm();
                    setState(() {
                      _imageFile = '';
                    });
                  },
                  backgroundColor: colorScheme(context).inversePrimary,
                  height: 60,
                  text: Text(
                    'THÊM MÓN',
                    style: TextStyle(color: colorScheme(context).tertiary),
                  ),
                ),
        )
      ],
    );
  }
}
