// ignore_for_file: public_member_api_docs, sort_constructors_firs

//model này dùng để đọc sản phẩm trong hoá đơn
class GioHang1 {
  String? idsp;
  String tensp;
  int giasp;
  int soluong;
  String? ghichu;
  String hinhanh;
  GioHang1({
    this.idsp,
    required this.tensp,
    required this.giasp,
    required this.soluong,
    this.ghichu = "",
    required this.hinhanh,
  });
  factory GioHang1.fromSnapshot(Map<String, dynamic> snapshot) {
    return GioHang1(
        idsp: snapshot['idsp'],
        tensp: snapshot['tensp'],
        giasp: snapshot['giasp'],
        soluong: snapshot['soluong'],
        ghichu: snapshot['ghichu'],
        hinhanh: snapshot['hinhanh']);
  }
  Map<String, dynamic> toJson() => {
        'idsp': idsp,
        'tensp': tensp,
        'giasp': giasp,
        'soluong': soluong,
        'ghichu': ghichu,
        'hinhanh': hinhanh,
      };
}
