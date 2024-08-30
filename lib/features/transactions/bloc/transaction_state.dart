part of 'transaction_bloc.dart';

@immutable
sealed class TransactionState {}

abstract class TransactionActionState extends TransactionState {}

final class TransactionInitial extends TransactionState {}

final class TransactionLoading extends TransactionState {}

final class TransactionEmptyState extends TransactionState {}

final class TransactionErrorState extends TransactionState {
  final String message;

  TransactionErrorState(this.message);
}

final class TransactionsInitialFetchSuccessState extends TransactionState {
  final List<Transaction> transactions;
  final TransactionSummary? transactionSummary;

  TransactionsInitialFetchSuccessState({
    required this.transactions,
    this.transactionSummary,
  });
}

class TransactionCategoriesFetchSuccessState extends TransactionState {
  final List<Category> categories;

  TransactionCategoriesFetchSuccessState(this.categories);
}
