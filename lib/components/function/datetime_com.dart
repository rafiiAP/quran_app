part of 'main_function.dart';

mixin DatetimeComponent {
  String date({
    required String format,
    DateTime? dateTime,
  }) {
    dateTime ??= DateTime.now();
    return DateFormat(format).format(dateTime);
  }

  String datetime() {
    return date(format: "yyyy-MM-dd HH:mm:ss");
  }
}
