import 'package:expense_tracker/features/recurring/domain/recurring_transaction.dart';
import 'package:expense_tracker/core/providers/usecase_providers.dart';
import 'package:expense_tracker/core/providers/settings_providers.dart';
import 'package:expense_tracker/core/database/app_database.dart' hide Column;
import 'package:expense_tracker/domain/entities/transaction.dart' as domain;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class SubscriptionCalendarScreen extends ConsumerStatefulWidget {
  const SubscriptionCalendarScreen({super.key});

  @override
  ConsumerState<SubscriptionCalendarScreen> createState() => _SubscriptionCalendarScreenState();
}

class _SubscriptionCalendarScreenState extends ConsumerState<SubscriptionCalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  // A helper function to project upcoming occurrences of a template within a given month.
  List<DateTime> _projectDatesForMonth(RecurringTransaction template, DateTime month) {
    List<DateTime> dates = [];
    DateTime current = template.nextDueDate;
    final lastDayOfMonth = DateTime(month.year, month.month + 1, 0);

    // If next due date is after this month, no occurrences this month.
    if (current.isAfter(lastDayOfMonth)) return dates;

    // Fast forward to the start of the target month
    final firstDayOfMonth = DateTime(month.year, month.month, 1);
    while (current.isBefore(firstDayOfMonth)) {
      current = _getNextDate(current, template.interval);
    }

    // Collect all occurrences within the target month
    while (current.isBefore(lastDayOfMonth) || current.isAtSameMomentAs(lastDayOfMonth)) {
      if (current.month == month.month && current.year == month.year) {
         dates.add(current);
      }
      current = _getNextDate(current, template.interval);
    }
    return dates;
  }

  DateTime _getNextDate(DateTime current, RecurringInterval interval) {
    switch (interval) {
      case RecurringInterval.daily:
        return current.add(const Duration(days: 1));
      case RecurringInterval.weekly:
        return current.add(const Duration(days: 7));
      case RecurringInterval.monthly:
        return DateTime(current.year, current.month + 1, current.day);
      case RecurringInterval.yearly:
        return DateTime(current.year + 1, current.month, current.day);
    }
  }

  @override
  Widget build(BuildContext context) {
    final templatesStream = ref.watch(watchAllRecurringUseCaseProvider).call();
    final currencyFormat = ref.watch(currencyFormatProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscriptions & Bills'),
      ),
      body: StreamBuilder<List<RecurringTransaction>>(
        stream: templatesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final templates = snapshot.data ?? [];

          // Map each day to a list of templates due on that day
          Map<DateTime, List<RecurringTransaction>> events = {};
          
          for (final template in templates) {
            final dates = _projectDatesForMonth(template, _focusedDay);
            for (final date in dates) {
              final normalizedDate = DateTime(date.year, date.month, date.day);
              events.putIfAbsent(normalizedDate, () => []).add(template);
            }
          }

          final selectedDateNormalized = DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day);
          final selectedEvents = events[selectedDateNormalized] ?? [];

          return Column(
            children: [
              TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                onPageChanged: (focusedDay) {
                  setState(() {
                    _focusedDay = focusedDay;
                  });
                },
                eventLoader: (day) {
                  final normalizedDate = DateTime(day.year, day.month, day.day);
                  return events[normalizedDate] ?? [];
                },
                calendarStyle: CalendarStyle(
                  markerDecoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const Divider(),
              Expanded(
                child: selectedEvents.isEmpty
                    ? Center(
                        child: Text(
                          'No bills due on ${DateFormat.yMMMd().format(_selectedDay!)}',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: selectedEvents.length,
                        itemBuilder: (context, index) {
                          final template = selectedEvents[index];
                          final isExpense = template.type == domain.TransactionType.expense;

                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: template.category.color.withValues(alpha: 0.2),
                              child: Icon(template.category.icon, color: template.category.color),
                            ),
                            title: Text(template.name),
                            subtitle: Text(template.category.name),
                            trailing: Text(
                              '${isExpense ? '-' : '+'}${currencyFormat.format(template.amount)}',
                              style: TextStyle(
                                color: isExpense ? Colors.red : Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
