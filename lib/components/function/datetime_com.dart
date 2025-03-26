part of 'main_function.dart';

mixin DatetimeComponent {
  String date({
    required final String format,
    final DateTime? dateTime,
  }) {
    assert(format.isNotEmpty, 'Format tidak boleh kosong'); // Validasi format
    return DateFormat(format).format(dateTime ?? DateTime.now());
  }

  String datetime() {
    return date(format: "yyyy-MM-dd HH:mm:ss");
  }
}
