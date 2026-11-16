/// Classe utilitária para números de telefone
abstract final class PhoneNumberUtils {
  static const int maxDigits = 15; // E.164
  static const int minDigits = 7;

  static final _nonDigits = RegExp(r'\D');

  /// Remover o que não é dígito
  static String onlyDigits(String? s) => (s ?? '').replaceAll(_nonDigits, '');

  /// Validação básica do tamanho
  static bool isValid(String? digits) {
    final d = onlyDigits(digits);
    return d.length >= minDigits && d.length <= maxDigits;
  }

  /// Formata para a apresentação
  static String format(String? digits) {
    final d = onlyDigits(digits);
    if (d.isEmpty) return '';
    if (d.length <= 2) return '($d';
    if (d.length <= 6) return '(${d.substring(0, 2)}) ${d.substring(2)}';
    if (d.length <= 10) {
      return '(${d.substring(0, 2)}) ${d.substring(2, 6)}-${d.substring(6)}';
    }

    if (d.length == 11) { // (12) 3456-78901
      return '(${d.substring(0, 2)}) ${d.substring(2, 7)}-${d.substring(7)}';
    }

    // 12 a 13 dígitos começando com 55:
    // Código do Brasil com o número nacional.
    // +55 (34) 5678-9012 ou +55 (34) 56789-0123
    if ((d.length == 12 || d.length == 13) && d.startsWith('55')) {
      return '+55 ${format(d.substring(2))}';
    }

    return '+$d';
  }
}
