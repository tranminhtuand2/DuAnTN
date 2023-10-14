import 'package:momo_vn/momo_vn.dart';

MomoPaymentInfo setOptionsPayment({
  required int amount,
  required String orderId,
  required String description,
  required String username,
}) {
  final options = MomoPaymentInfo(
    merchantName: "Thanh toán hóa đơn",
    appScheme: "HoangNgoc",
    merchantCode: 'MOMOC2IC20220510',
    partnerCode: 'MOMOC2IC20220510',
    amount: amount,
    orderId: orderId,
    orderLabel: 'Gói combo',
    merchantNameLabel: "HLGD",
    fee: 10,
    description: description,
    username: username,
    partner: 'merchant',
    extra: "{\"key1\":\"value1\",\"key2\":\"value2\"}",
    isTestMode: true,
  );
  return options;
}

  // void _setState() {
  //   _payment_status = 'Đã chuyển thanh toán';
  //   if (_momoPaymentResult.isSuccess!) {
  //     _payment_status += "\nTình trạng: Thành công.";
  //     _payment_status += "\nSố điện thoại: ${_momoPaymentResult.phoneNumber!}";
  //     _payment_status += "\nExtra: ${_momoPaymentResult.extra}";
  //     _payment_status += "\nToken: ${_momoPaymentResult.token}";
  //   } else {
  //     _payment_status += "\nTình trạng: Thất bại.";
  //     _payment_status += "\nExtra: ${_momoPaymentResult.extra}";
  //     _payment_status += "\nMã lỗi: ${_momoPaymentResult.status}";
  //   }
  // }

