abstract final class DateFormatter {
  static String toYmd(DateTime date) {
    return '${date.year}-${_pad(date.month)}-${_pad(date.day)}';
  }

  static String toFull(DateTime date) {
    return '${toYmd(date)} ${_pad(date.hour)}:${_pad(date.minute)}';
  }

  static String _pad(int value) => value.toString().padLeft(2, '0');
}
