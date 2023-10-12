String formatPrice(int price) {
  // Định dạng giá tiền
  String formattedPrice = price.toString();
  String result = '';

  int count = 0;
  for (int i = formattedPrice.length - 1; i >= 0; i--) {
    result = formattedPrice[i] + result;
    count++;
    if (count == 3 && i > 0) {
      result = '.' + result;
      count = 0;
    }
  }

  return result;
}
