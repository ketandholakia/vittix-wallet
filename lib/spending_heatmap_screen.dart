import 'package:expense_tracker/core/providers/settings_providers.dart';
import 'package:expense_tracker/core/providers/repository_providers.dart';
import 'package:expense_tracker/domain/entities/transaction.dart' as domain;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class SpendingHeatmapScreen extends ConsumerStatefulWidget {
  const SpendingHeatmapScreen({super.key});

  @override
  ConsumerState<SpendingHeatmapScreen> createState() => _SpendingHeatmapScreenState();
}

class _SpendingHeatmapScreenState extends ConsumerState<SpendingHeatmapScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, double> _dailySpending = {};
  double _maxDailySpend = 1.0;

  @override
  void initState() {
    super.initState();
    _loadSpendingData();
  }

  Future<void> _loadSpendingData() async {
    final month = DateTime(_focusedDay.year, _focusedDay.month, 1);
    final transactions = await ref
        .read(transactionRepositoryProvider)
        .watchTransactionsInMonth(month)
        .first;

    final spending = <DateTime, double>{};
    for (final tx in transactions) {
      if (tx.type == domain.TransactionType.expense) {
        final day = DateTime(tx.date.year, tx.date.month, tx.date.day);
        spending[day] = (spending[day] ?? 0) + tx.amount;
      }
    }
    final maxSpend = spending.values.fold(1.0, (a, b) => a > b ? a : b);

    if (mounted) {
      setState(() {
        _dailySpending = spending;
        _maxDailySpend = maxSpend;
      });
    }
  }

  Color _getHeatColor(DateTime day) {
    final normalizedDay = DateTime(day.year, day.month, day.day);
    final amount = _dailySpending[normalizedDay];
    if (amount == null || amount == 0) {
      return Colors.transparent;
    }
    final intensity = (amount / _maxDailySpend).clamp(0.0, 1.0);
    // Gradient from green (low) → yellow (medium) → red (high)
    if (intensity < 0.33) {
      return Color.lerp(Colors.green.shade100, Colors.green.shade400, intensity * 3)!;
    } else if (intensity < 0.66) {
      return Color.lerp(Colors.yellow.shade200, Colors.orange.shade400, (intensity - 0.33) * 3)!;
    } else {
      return Color.lerp(Colors.orange.shade400, Colors.red.shade600, (intensity - 0.66) * 3)!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = ref.watch(currencyFormatProvider);
    final theme = Theme.of(context);
    final selectedAmount = _selectedDay != null
        ? _dailySpending[DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day)]
        : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Spending Heatmap'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime(2020),
            lastDay: DateTime.now(),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
              _loadSpendingData();
            },
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                border: Border.all(color: theme.colorScheme.primary, width: 2),
                shape: BoxShape.circle,
              ),
              todayTextStyle: TextStyle(color: theme.colorScheme.onSurface),
              selectedDecoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
              ),
              defaultDecoration: const BoxDecoration(shape: BoxShape.circle),
              weekendDecoration: const BoxDecoration(shape: BoxShape.circle),
            ),
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                final heatColor = _getHeatColor(day);
                return Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: heatColor,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${day.day}',
                    style: TextStyle(
                      color: heatColor == Colors.transparent
                          ? theme.colorScheme.onSurface
                          : Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),

          // Legend
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _legendDot(Colors.green.shade300, 'Low'),
                const SizedBox(width: 16),
                _legendDot(Colors.orange.shade400, 'Medium'),
                const SizedBox(width: 16),
                _legendDot(Colors.red.shade600, 'High'),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Selected day detail
          if (_selectedDay != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat.yMMMd().format(_selectedDay!),
                        style: theme.textTheme.titleMedium,
                      ),
                      Text(
                        selectedAmount != null
                            ? currencyFormat.format(selectedAmount)
                            : 'No expenses',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: selectedAmount != null && selectedAmount > 0
                              ? Colors.red
                              : Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
