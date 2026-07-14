import 'package:intl/intl.dart';

/// Abstract interface for date/time formatting.
///
/// Can be mocked independently in unit tests.
abstract class DatetimeService {
  /// Formats a [dateTime] (or now if null) using the given [format] string.
  String date({required String format, DateTime? dateTime});

  /// Returns the current date/time formatted as `yyyy-MM-dd HH:mm:ss`.
  String datetime();
}

/// Implementation using the `intl` package [DateFormat].
class DatetimeServiceImpl implements DatetimeService {
  @override
  String date({required String format, DateTime? dateTime}) {
    assert(format.isNotEmpty, 'Format tidak boleh kosong');
    return DateFormat(format).format(dateTime ?? DateTime.now());
  }

  @override
  String datetime() {
    return date(format: 'yyyy-MM-dd HH:mm:ss');
  }
}
