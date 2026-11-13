import 'package:intl/intl.dart';

/// Utilitário para formatar valores monetários.
final class MoneyFormatter {
  final String locale;
  final String symbol;

  MoneyFormatter({
    this.locale = 'pt_BR',
    this.symbol = 'R\$',
  }) : _formatter = NumberFormat.currency(
    locale: locale,
    symbol: symbol,
    decimalDigits: 2,
  );

  final NumberFormat _formatter;

  /// Recebe valor em centavos (int) e retorna String formatada.
  String format(int cents) {
    return _formatter.format(cents / 100);
  }
}
