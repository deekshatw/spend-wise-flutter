part of 'budget_bloc.dart';

@immutable
sealed class BudgetState {}

abstract class BudgetActionState extends BudgetState {}

final class BudgetInitial extends BudgetState {}

class BudgetLoadingState extends BudgetState {}

class BudgetErrorState extends BudgetState {
  final String message;

  BudgetErrorState(this.message);
}

class BudgetEmptyState extends BudgetState {}

class BudgetInitialBudgetsFetchEventSuccessState extends BudgetState {
  final List<BudgetModel> budgets;

  BudgetInitialBudgetsFetchEventSuccessState(this.budgets);
}
