// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:managerfoodandcoffee/src/model/Invoice_model.dart';
import 'package:managerfoodandcoffee/src/model/payment_status_model.dart';
import 'package:managerfoodandcoffee/src/model/card_model.dart';
import 'package:managerfoodandcoffee/src/model/coupons_model.dart';
import 'package:managerfoodandcoffee/src/model/danhmuc_model.dart';
import 'package:managerfoodandcoffee/src/model/diachimap_model.dart';
import 'package:managerfoodandcoffee/src/model/sanpham_model.dart';
import 'package:managerfoodandcoffee/src/model/table_model.dart';
import 'package:managerfoodandcoffee/src/utils/enum_status_payment.dart';

import '../model/header_model.dart';

class FirestoreHelper {
  // CRUD HEADER
  //creater
  static Future<void> createheader(HeaderModel header) async {
    final headerColection = FirebaseFirestore.instance.collection("header");
    final uid = headerColection.doc().id;
    final docRef = headerColection.doc(uid);
    final newheader = HeaderModel(
            content: header.content, headerImage: header.headerImage, id: uid)
        .toJson();

    try {
      await docRef.set(newheader);
    } catch (e) {
      Get.snackbar("lỗi", e.toString());
    }
  }

  //read
  static Stream<List<HeaderModel>> read() {
    final headerCollection = FirebaseFirestore.instance.collection("header");
    return headerCollection.snapshots().map((QuerySnapshot) =>
        QuerySnapshot.docs.map((e) => HeaderModel.fromSnapshot(e)).toList());
  }

  //update
  static Future update(HeaderModel header) async {
    final headerCollection = FirebaseFirestore.instance.collection("header");
    final docRef = headerCollection.doc(header.id);
    final newheader = HeaderModel(
            content: header.content,
            headerImage: header.headerImage,
            id: header.id)
        .toJson();
    try {
      await docRef.update(newheader);
    } catch (e) {
      Get.snackbar("lỗi", e.toString());
    }
  }

  //delete
  static Future delete(HeaderModel header) async {
    final headerCollection = FirebaseFirestore.instance.collection("header");
    final docRef = headerCollection.doc(header.id).delete();
  }

  //crud sanpham
  //create sanpham
  static Future<void> creadsp(SanPham sanpham) async {
    final sanphamCollection = FirebaseFirestore.instance.collection("sanpham");
    final uid = sanphamCollection.doc().id;
    final docRef = sanphamCollection.doc(uid);
    final newsanpham = SanPham(
            idsp: uid,
            tensp: sanpham.tensp,
            giasp: sanpham.giasp,
            mieuta: sanpham.mieuta,
            danhmuc: sanpham.danhmuc,
            hinhanh: sanpham.hinhanh)
        .toJson();
    try {
      await docRef.set(newsanpham);
    } catch (e) {
      Get.snackbar("lỗi", e.toString());
    }
  }

  //read
  static Stream<List<SanPham>> readsp() {
    final sanphamCollection = FirebaseFirestore.instance.collection("sanpham");
    return sanphamCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => SanPham.fromSnapshot(e)).toList());
  }

  //filter sp
  static Stream<List<SanPham>> filletsp(String searchQuery) {
    final sanphamCollection = FirebaseFirestore.instance.collection("sanpham");
    Query query = sanphamCollection.where("danhmuc", isEqualTo: searchQuery);
    return query.snapshots().map((QuerySnapshot) =>
        QuerySnapshot.docs.map((e) => SanPham.fromSnapshot(e)).toList());
  }

  //updatesp
  static Future updatesp(SanPham sanpham) async {
    final headerCollection = FirebaseFirestore.instance.collection("sanpham");
    final docRef = headerCollection.doc(sanpham.idsp);
    final newsanpham = SanPham(
            idsp: sanpham.idsp,
            tensp: sanpham.tensp,
            giasp: sanpham.giasp,
            mieuta: sanpham.mieuta,
            danhmuc: sanpham.danhmuc,
            hinhanh: sanpham.hinhanh)
        .toJson();
    try {
      await docRef.update(newsanpham);
    } catch (e) {
      Get.snackbar("lỗi", e.toString());
    }
  }

  //deletesp
  static Future deletesp(SanPham sanpham) async {
    final headerCollection = FirebaseFirestore.instance.collection("sanpham");
    final docRef = headerCollection.doc(sanpham.idsp).delete();
  }

  //cruddanhmuc
  static Future<void> createdanhmuc(DanhMuc danhmuc) async {
    final danhmucColection = FirebaseFirestore.instance.collection("danhmuc");
    final uid = danhmucColection.doc().id;
    final docRef = danhmucColection.doc(uid);
    final newdanhmuc =
        DanhMuc(tendanhmuc: danhmuc.tendanhmuc.toLowerCase(), iddanhmuc: uid)
            .toJson();

    try {
      await docRef.set(newdanhmuc);
    } catch (e) {
      Get.snackbar("lỗi", e.toString());
    }
  }

  //read
  static Stream<List<DanhMuc>> readdanhmuc() {
    final danhmucCollection = FirebaseFirestore.instance.collection("danhmuc");
    return danhmucCollection.snapshots().map((QuerySnapshot) =>
        QuerySnapshot.docs.map((e) => DanhMuc.fromSnapshot(e)).toList());
  }

  //update
  static Future updatedanhmuc(DanhMuc danhmuc) async {
    final headerCollection = FirebaseFirestore.instance.collection("danhmuc");
    final docRef = headerCollection.doc(danhmuc.iddanhmuc);
    final newdanhmuc = DanhMuc(
            tendanhmuc: danhmuc.tendanhmuc.toLowerCase(),
            iddanhmuc: danhmuc.iddanhmuc)
        .toJson();
    try {
      await docRef.update(newdanhmuc);
    } catch (e) {
      Get.snackbar("lỗi", e.toString());
    }
  }

  //delete
  static Future deletedanhmuc(String idDanhmuc) async {
    final headerCollection = FirebaseFirestore.instance.collection("danhmuc");
    final docRef = headerCollection.doc(idDanhmuc).delete();
  }

  /// dia chi map
  static Stream<List<diachimap>> readmap() {
    final diachimapColection = FirebaseFirestore.instance.collection("map");
    return diachimapColection.snapshots().map((QuerySnapshot) =>
        QuerySnapshot.docs.map((e) => diachimap.fromsnapshot(e)).toList());
    // final diachimapcolection = FirebaseFirestore.instance.collection("map");
    // return diachimapcolection.snapshots().map(
    //     (event) => event.docs.map((e) => diachimap.fromsnapshot(e)).toList());
  }

  ///table
  //create a table
  static Future<void> createdtable(TableModel table) async {
    final tableColection = FirebaseFirestore.instance.collection("table");

    final docref = tableColection.doc(table.tenban);
    final newtable =
        TableModel(tenban: table.tenban, maban: table.tenban, isSelected: false)
            .toJson();
    try {
      await docref.set(newtable);
    } catch (e) {
      Get.snackbar("lỗi", e.toString());
    }
  }

  //readtable
  static Stream<List<TableModel>> readtable() {
    final danhmucCollection = FirebaseFirestore.instance.collection("table");
    return danhmucCollection.snapshots().map((QuerySnapshot) =>
        QuerySnapshot.docs.map((e) => TableModel.fromsnapshot(e)).toList());
  }

  //updatetable
  static Future updatetable(TableModel table) async {
    final headerCollection = FirebaseFirestore.instance.collection("table");
    final docRef = headerCollection.doc(table.maban);
    final newtable = TableModel(
            tenban: table.tenban,
            maban: table.maban,
            isSelected: table.isSelected)
        .toJson();
    try {
      print('UPDATE');
      await docRef.update(newtable);
    } catch (e) {
      Get.snackbar("lỗi", e.toString());
    }
  }

  //delete
  static Future deletetable(TableModel table) async {
    final tableColection = FirebaseFirestore.instance.collection("table");
    final docRef = tableColection.doc(table.maban).delete();
  }

  ///end table
  ///gio hang
  //read
  static Stream<List<GioHang>> readgiohang(String table) {
    final GiohangCollection = FirebaseFirestore.instance
        .collection("giohang")
        .doc("table")
        .collection(table);
    return GiohangCollection.snapshots().map((QuerySnapshot) =>
        QuerySnapshot.docs.map((e) => GioHang.fromSnapshot(e)).toList());
  }

  //create
  static Future<void> createdgiohang(GioHang giohang, String table) async {
    final giohangColection = FirebaseFirestore.instance
        .collection("giohang")
        .doc("table")
        .collection(table);
    final uid = giohangColection.doc().id;
    final docRef = giohangColection.doc(uid);
    final newgiohang = GioHang(
            idsp: uid,
            tensp: giohang.tensp,
            giasp: giohang.giasp,
            soluong: giohang.soluong,
            ghichu: giohang.ghichu,
            hinhanh: giohang.hinhanh)
        .toJson();

    try {
      await docRef.set(newgiohang);
    } catch (e) {
      Get.snackbar("lỗi", e.toString());
    }
  }

  //update
  static Future<void> updategiohang(GioHang giohang, String table) async {
    final giohangColection = FirebaseFirestore.instance
        .collection("giohang")
        .doc("table")
        .collection(table);
    final docRef = giohangColection.doc(giohang.idsp);
    final newgiohang = GioHang(
            idsp: giohang.idsp,
            tensp: giohang.tensp,
            giasp: giohang.giasp,
            soluong: giohang.soluong,
            ghichu: giohang.ghichu,
            hinhanh: giohang.hinhanh)
        .toJson();

    try {
      await docRef.update(newgiohang);
    } catch (e) {
      Get.snackbar("lỗi", e.toString());
    }
  }

  //delete
  static Future deletegiohang(GioHang giohang, String table) async {
    final giohangColection = FirebaseFirestore.instance
        .collection("giohang")
        .doc("table")
        .collection(table);

    final docRef = giohangColection.doc(giohang.idsp).delete();
  }

  //delete all giohang
  static Future deleteAllgiohang(String table) async {
    final giohangColection = FirebaseFirestore.instance
        .collection("giohang")
        .doc("table")
        .collection(table);
    var snapshot = await giohangColection.get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  ///enđ gio hang
  ///s
  ///tinh trang
  //read
  static Stream<List<TinhTrangThanhToan>> readtinhtrang(String table) {
    final tinhtrangCollection =
        FirebaseFirestore.instance.collection("tinhtrang");

    return tinhtrangCollection.snapshots().map((QuerySnapshot) => QuerySnapshot
        .docs
        .map((e) => TinhTrangThanhToan.fromSnapshot(e))
        .toList());
  }

  static Stream<List<TinhTrangThanhToan>> readtinhtrangtt() {
    final tinhtrangCollection =
        FirebaseFirestore.instance.collection("tinhtrang");

    return tinhtrangCollection.snapshots().map((QuerySnapshot) => QuerySnapshot
        .docs
        .map((e) => TinhTrangThanhToan.fromSnapshot(e))
        .toList());
  }
  //creater

  static Future<void> createtinhtrang(
      PaymentStatus status, TableModel table) async {
    final tinhtrangCl = FirebaseFirestore.instance.collection("tinhtrang");

    final docRef = tinhtrangCl.doc(table.tenban);

    final newtinhtrang = TinhTrangThanhToan(
            trangthai: status == PaymentStatus.ordered ? "ordered" : 'success',
            idtinhtrang: table.tenban)
        .toJson();
    try {
      await docRef.set(newtinhtrang);
    } catch (e) {
      Get.snackbar("lỗi", e.toString());
    }
  }

  //update

  static Future updatetinhtrang(
      TinhTrangThanhToan tinhtrang, String table) async {
    final tinhtrangCl = FirebaseFirestore.instance.collection("tinhtrang");

    final docRef = tinhtrangCl.doc(table);
    final newtinhtrang =
        TinhTrangThanhToan(trangthai: tinhtrang.trangthai, idtinhtrang: table)
            .toJson();
    try {
      await docRef.update(newtinhtrang);
    } catch (e) {
      Get.snackbar(
        "lỗi",
        e.toString(),
      );
    }
  }

  //delete tinhtrang
  //delete
  static Future deletetinhtrang(String table) async {
    final tinhtrangban = FirebaseFirestore.instance.collection("tinhtrang");

    final docRef = tinhtrangban.doc(table).delete();
  }

  ////////////////////////////COUPONS ///////////////////////////
  static Future<void> createMagiamGia({
    required String beginDay,
    required String endDay,
    required String data,
    required int soluotdung,
    required int persent,
  }) async {
    final couponsColection = FirebaseFirestore.instance.collection("coupons");
    final uid = couponsColection.doc().id;
    final docRef = couponsColection.doc(uid);
    final coupons = Coupons(
      id: uid,
      beginDay: beginDay,
      endDay: endDay,
      data: data,
      soluotdung: soluotdung,
      persent: persent,
      isEnable: true,
    );
    try {
      await docRef.set(coupons.toJson());
    } catch (e) {
      print(e);
    }
  }

  static Future<void> updateMagiamGia(Coupons coupon) async {
    final couponsColection = FirebaseFirestore.instance.collection("coupons");

    final docRef = couponsColection.doc(coupon.id);

    try {
      await docRef.update(coupon.toJson());
    } catch (e) {
      print(e);
    }
  }

  static Future<void> dateleMagiamGia(Coupons coupon) async {
    final couponsColection = FirebaseFirestore.instance.collection("coupons");

    final docRef = couponsColection.doc(coupon.id);

    try {
      await docRef.delete();
    } catch (e) {
      print(e);
    }
  }

  static Stream<List<Coupons>> getDataCoupons() {
    final couponsColection = FirebaseFirestore.instance.collection("coupons");

    return couponsColection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => Coupons.fromsnapshot(e)).toList());
  }

  //hoá đơn
  //create
  static Future<void> createHoadon(List<GioHang> giohang, String date,
      String nhanvien, double tongtien, String tableName) async {
    final hoadonCl = FirebaseFirestore.instance.collection("hoadon");
    final uid = hoadonCl.doc().id;
    final docRef = hoadonCl.doc(uid);

    final newhoadon = Invoice(
            id: uid,
            products: giohang,
            date: date,
            nhanvien: nhanvien,
            totalAmount: tongtien,
            tableName: tableName)
        .toJson();
    try {
      await docRef.set(newhoadon);
    } catch (e) {
      Get.snackbar("lỗi", e.toString());
    }
  }

  //read hoa don
  static Stream<List<Invoice>> readInvoices() {
    final hoadonCollection = FirebaseFirestore.instance.collection("hoadon");
    return hoadonCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((doc) => Invoice.fromSnapshot(doc)).toList());
  }
}
