String getSubStringBetween(String str, String begin, String end) {
  final startIndex = str.indexOf(begin);
  final endIndex = str.indexOf(end, startIndex + begin.length);
  return str.substring(startIndex + begin.length, endIndex);
}
