import 'package:flutter/services.dart';

import '../../../../core/utils/phone_number_utils.dart';

/// Formatador para campos de telefone,
/// permitindo digitar caracteres relacionados a números de telefone.
class PhoneNumberInputFormatter extends TextInputFormatter {

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String digits = PhoneNumberUtils.onlyDigits(newValue.text);

    final cursor = newValue.selection.end.clamp(0, newValue.text.length);

    int digitsBeforeCursor = PhoneNumberUtils.onlyDigits(
      newValue.text.substring(0, cursor)
    ).length;

    // Se o usuário apagou só um separador "()- +", apaga o dígito anterior
    if (newValue.text.length < oldValue.text.length &&
      digits == PhoneNumberUtils.onlyDigits(oldValue.text) &&
      digitsBeforeCursor > 0
    ) {
      digits = digits.substring(0, digitsBeforeCursor - 1) +
        digits.substring(digitsBeforeCursor);
      digitsBeforeCursor--;
    }

    if (digits.length > PhoneNumberUtils.maxDigits) {
      digits = digits.substring(0, PhoneNumberUtils.maxDigits);
    }

    digitsBeforeCursor = digitsBeforeCursor.clamp(0, digits.length);

    // Realiza a formatação
    final formatted = PhoneNumberUtils.format(digits);

    // Reposiciona o cursor após o último dígito
    int offset = digitsBeforeCursor == 0 ? 0 : formatted.length;
    int count = 0;
    for (int i = 0; i < formatted.length && digitsBeforeCursor > 0; i++) {
      if (RegExp(r'\d').hasMatch(formatted[i])) count++;
      if (count == digitsBeforeCursor) {
        offset = i + 1;
        break;
      }
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: offset),
    );
  }
}