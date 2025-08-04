class ListFormatter {
  static String formatList(List<dynamic> items) {
    String formattedString = '';
    if (items.isEmpty) {
      return '';
    }
    for (int i = 0; i < items.length; i++) {
      formattedString += items[i];
      if (i != items.length - 1 && items.length > 1) {
        formattedString += ', ';
      }else{
        formattedString += ' ';
      }
    }
    return formattedString.trim();
  }
}
