part of 'budget_bloc.dart';

@immutable
sealed class BudgetEvent {}

class BudgetInitialBudgetsFetchEvent extends BudgetEvent {}
