import 'package:intl/intl.dart';

/// Utilitário para formatar datas.
final class DateFormatter {

  final String locale;

  DateFormatter({this.locale = 'pt_BR'}) :
    _weekday = DateFormat.EEEE(locale),
    _shortDate = DateFormat.MMMd(locale),
    _fullDate = DateFormat.yMMMMd(locale),
    _hourMinute = DateFormat.Hm(locale);

  final DateFormat _weekday;
  final DateFormat _shortDate;
  final DateFormat _fullDate;
  final DateFormat _hourMinute;

  /// Formato: 'Terça-feira, 3 nov.'
  String shortDate(DateTime date) {
    final weekday = _capitalize(_weekday.format(date));
    return '$weekday, ${_shortDate.format(date)}';
  }

  /// Formato: 'Hoje, 3 de novembro de 2026'
  String fullDate(DateTime date) {
    final today = DateTime.now();

    final isToday = date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;

    final formatted = _fullDate.format(date);

    // Por enquanto, apenas português (BR) informando o 'hoje'.
    final prefix = (isToday && locale == 'pt_BR') ? 'Hoje' : null;

    return prefix != null ? '$prefix, $formatted' : formatted;
  }

  /// Formato: '03 nov. • 09:30'
  String dayMonthAndHour(DateTime date) {
    return '${_shortDate.format(date)} • ${_hourMinute.format(date)}';
  }

  /// Apenas horário ('09:30')
  String hourMinute(DateTime date) {
    return _hourMinute.format(date);
  }

  String _capitalize(String value) {
    return '${value[0].toUpperCase()}${value.substring(1)}';
  }
}
