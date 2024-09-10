part of 'budget_bloc.dart';

@immutable
sealed class BudgetEvent {}

class BudgetInitialBudgetsFetchEvent extends BudgetEvent {}

class BudgetAddNewBudgetEvent extends BudgetEvent {
  final Map<String, dynamic> body;
  final BuildContext context;

  BudgetAddNewBudgetEvent({required this.body, required this.context});
}
