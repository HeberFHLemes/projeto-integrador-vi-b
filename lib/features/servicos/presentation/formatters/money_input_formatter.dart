import 'package:flutter/services.dart';

import '../../../../core/utils/money_formatter.dart';

class MoneyInputFormatter extends TextInputFormatter {
  MoneyInputFormatter({this._maxLength = 12})
    : _formatter = MoneyFormatter();

  // Reutilizando lógica de formatação do MoneyFormatter
  // (retorna com prefixo, como R$, em vez de usar prefixText)
  final MoneyFormatter _formatter;

  final int _maxLength;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    // Valor padrão (R$ 0,00)
    if (digits.isEmpty) {
      return TextEditingValue(
        text: _formatter.format(0),
        selection: const TextSelection.collapsed(offset: 7),
      );
    }

    // Se tiver mais caracteres numéricos do que o limite, não altera nada.
    if (digits.length > _maxLength) {
      return oldValue;
    }

    final cents = int.parse(digits);
    final formatted = _formatter.format(cents);

    // Valor formatado
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(
        offset: formatted.length,
      ),
    );
  }
}