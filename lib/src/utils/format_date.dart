import 'package:intl/intl.dart';

class FormatDate {
  bool compareDate(String dateString) {
    // Định dạng ngày từ chuỗi
    DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    DateTime selectedDate = dateFormat.parse(dateString);
    // Lấy ngày hiện tại
    DateTime currentDate = DateTime.now();
    // So sánh ngày
    if (selectedDate.isBefore(currentDate) ||
        selectedDate.isAtSameMomentAs(currentDate)) {
      // Trả về true nếu ngày đã qua hết hoặc ngày hiện tại
      return true;
    }
    // Ngày ở tương lai
    return false;
  }

  String formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    final String formatted = formatter.format(dateTime);
    return formatted;
  }
}
