import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Utilitário para formatar datas.
final class DateFormatter {

  final String locale;

  DateFormatter({this.locale = 'pt_BR'}) :
    _weekday = DateFormat.EEEE(locale),
    _shortDate = DateFormat.MMMd(locale),
    _fullDate = DateFormat.yMMMMd(locale),
    _dayMonthYear = DateFormat('dd/MM/yyyy', locale),
    _hourMinute = DateFormat.Hm(locale);

  final DateFormat _weekday;
  final DateFormat _shortDate;
  final DateFormat _fullDate;
  final DateFormat _dayMonthYear;
  final DateFormat _hourMinute;

  String dayMonthYear(DateTime date) => _dayMonthYear.format(date);

  /// Formato: 'Terça-feira, 3 nov.'
  String shortDate(DateTime date) {
    final weekday = _capitalize(_weekday.format(date));
    return '$weekday, ${_shortDate.format(date)}';
  }

  /// Formato: 'Terça-feira, 3 de novembro de 2026'
  String detailedDate(DateTime date) {
    final weekday = _capitalize(_weekday.format(date));
    return '$weekday, ${_fullDate.format(date)}';
  }

  /// Formato: 'Hoje, 3 de novembro de 2026'
  String fullDate(DateTime date) {
    final today = DateTime.now();

    final isToday = DateUtils.isSameDay(today, date);

    final formatted = _fullDate.format(date);

    // Por enquanto, apenas português (BR) informando o 'hoje'.
    final prefix = (isToday && locale == 'pt_BR') ? 'Hoje' : null;

    return prefix != null ? '$prefix, $formatted' : formatted;
  }

  /// Formato: '03 nov.';
  String dayMonth(DateTime date) {
    return _shortDate.format(date);
  }

  /// Formato: '03 nov. • 09:30'
  String dayMonthAndHour(DateTime date) {
    return '${_shortDate.format(date)} • ${_hourMinute.format(date)}';
  }

  /// Apenas horário ('09:30')
  String hourMinute(DateTime date) {
    return _hourMinute.format(date);
  }

  /// Representação de um intervalo/período
  /// Formato: '01 a 30 de novembro de 2026'
  /// Formatos possíveis:
  /// 'Hoje, 20 de novembro de 2026'
  /// '01 a 30 de novembro de 2026'
  /// '30 de outubro a 30 de novembro de 2026'
  /// '30/12/2026 - 05/01/2027'
  String dateRange(DateTime inicio, DateTime fim) {
    // 'Hoje, 20 de novembro de 2026'
    if (DateUtils.isSameDay(inicio, fim)) {
      return fullDate(fim);
    }

    final mesmoAno = inicio.year == fim.year;
    final mesmoMes = mesmoAno && inicio.month == fim.month;

    // '01 a 30 de novembro de 2026'
    if (mesmoMes) {
      final diaInicio = inicio.day.toString().padLeft(2, '0');

      return '$diaInicio a ${_fullDate.format(fim)}';
    }

    // '30 de outubro a 30 de novembro de 2026'
    if (mesmoAno) {
      final inicioFormatado = DateFormat.MMMd(locale).format(inicio);
      final fimFormatado = DateFormat.MMMd(locale).format(fim);

      return '$inicioFormatado a $fimFormatado de ${fim.year}';
    }

    // '30/12/2026 - 05/01/2027'
    return '${dayMonthYear(inicio)} - ${dayMonthYear(fim)}';
  }

  String _capitalize(String value) {
    return '${value[0].toUpperCase()}${value.substring(1)}';
  }
}
