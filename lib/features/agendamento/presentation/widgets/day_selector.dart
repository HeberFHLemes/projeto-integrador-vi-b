import 'package:flutter/material.dart';

import '../../../../core/utils/date_formatter.dart';

class DaySelector extends StatelessWidget {
  const DaySelector({
    super.key,
    required this.selectedDate,
    required this.onDateChanged,
    required this._dateFormatter,
    this.firstDate = 2025,
    this.lastDate = 2027,
  });

  final DateFormatter _dateFormatter;

  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateChanged;

  final int firstDate;
  final int lastDate;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: colorScheme.secondary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _openCalendar(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _dateFormatter.shortDate(selectedDate),
                    style: textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(
                    _dateFormatter.fullDate(selectedDate),
                    style: textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),

          // Botões com ícones para alterar o dia de um em um
          IconButton(
            color: colorScheme.primary,
            onPressed: () => _changeDay(-1),
            icon: const Icon(Icons.chevron_left),
          ),

          IconButton(
            color: colorScheme.primary,
            onPressed: () => _changeDay(1),
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }

  void _changeDay(int days) {
    final date = DateUtils.dateOnly(selectedDate);
    onDateChanged(date.add(Duration(days: days)));
  }

  Future<void> _openCalendar(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(firstDate),
      lastDate: DateTime(lastDate),
    );

    if (date != null) {
      onDateChanged(DateUtils.dateOnly(date));
    }
  }
}
