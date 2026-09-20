import 'package:expense_tracker/features/recurring/domain/recurring_transaction.dart';
import 'package:expense_tracker/features/recurring/data/recurring_transaction_repository.dart';
import 'package:expense_tracker/features/transactions/domain/usecases/add_transaction.dart';
import 'package:expense_tracker/domain/entities/transaction.dart' as domain;
import 'package:expense_tracker/features/notifications/data/notification_service.dart';

class ProcessRecurringTransactions {
  final RecurringTransactionRepository recurringRepository;
  final AddTransaction addTransactionUseCase;
  final NotificationService notificationService;

  ProcessRecurringTransactions(
    this.recurringRepository,
    this.addTransactionUseCase,
    this.notificationService,
  );

  Future<void> call() async {
    final now = DateTime.now();
    final templates = await recurringRepository.getActiveTemplates();

    for (final template in templates) {
      DateTime currentDueDate = template.nextDueDate;
      bool generatedAny = false;
      int generatedCount = 0;

      while (currentDueDate.isBefore(now) || currentDueDate.isAtSameMomentAs(now)) {
        // Create standard transaction
        final transaction = domain.Transaction(
          id: 0,
          amount: template.amount,
          date: currentDueDate, // Scheduled due date is the transaction date
          note: '[Recurring] ${template.name}',
          type: template.type,
          category: template.category,
          account: template.account,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await addTransactionUseCase.call(transaction, source: 'recurring');

        // Advance to next occurrence
        final lastGen = currentDueDate;
        currentDueDate = _calculateNextDueDate(currentDueDate, template.interval);

        // Update the template state locally
        final updatedTemplate = RecurringTransaction(
          id: template.id,
          walletId: template.walletId,
          name: template.name,
          amount: template.amount,
          type: template.type,
          category: template.category,
          account: template.account,
          interval: template.interval,
          startDate: template.startDate,
          nextDueDate: currentDueDate,
          lastGeneratedDate: lastGen,
          isActive: template.isActive,
        );

        await recurringRepository.update(updatedTemplate);
        generatedAny = true;
        generatedCount++;

        // Safety break to prevent infinite loops (e.g. if start/due dates are in the distant past)
        if (generatedCount > 100) break;
      }

      if (generatedAny) {
        // Show a local notification alert
        await notificationService.showRecurringNotification(
          template.name,
          '₹${template.amount.toStringAsFixed(2)}',
        );
      }
    }
  }

  DateTime _calculateNextDueDate(DateTime currentDate, RecurringInterval interval) {
    switch (interval) {
      case RecurringInterval.daily:
        return currentDate.add(const Duration(days: 1));
      case RecurringInterval.weekly:
        return currentDate.add(const Duration(days: 7));
      case RecurringInterval.monthly:
        final nextMonth = currentDate.month + 1;
        final yearOffset = (nextMonth - 1) ~/ 12;
        final resolvedMonth = (nextMonth - 1) % 12 + 1;
        final resolvedYear = currentDate.year + yearOffset;
        final maxDays = DateTime(resolvedYear, resolvedMonth + 1, 0).day;
        final resolvedDay = currentDate.day > maxDays ? maxDays : currentDate.day;
        return DateTime(resolvedYear, resolvedMonth, resolvedDay, currentDate.hour, currentDate.minute);
      case RecurringInterval.yearly:
        final resolvedYear = currentDate.year + 1;
        final maxDays = DateTime(resolvedYear, currentDate.month + 1, 0).day;
        final resolvedDay = currentDate.day > maxDays ? maxDays : currentDate.day;
        return DateTime(resolvedYear, currentDate.month, resolvedDay, currentDate.hour, currentDate.minute);
    }
  }
}
