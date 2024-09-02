part of 'transaction_bloc.dart';

@immutable
sealed class TransactionEvent {}

class TransactionsInitialFetchEvent extends TransactionEvent {
  final String? type;
  final String? startDate;
  final String? endDate;

  TransactionsInitialFetchEvent(
      {this.type = 'all', this.startDate, this.endDate});
}

class TransactionCategoriesFetchEvent extends TransactionEvent {}

class TransactionCreateTransactionEvent extends TransactionEvent {
  final Map<String, dynamic> body;
  final BuildContext context;

  TransactionCreateTransactionEvent(this.body, this.context);
}

class TransactionCreateCategoryEvent extends TransactionEvent {
  final Map<String, dynamic> body;
  final BuildContext context;

  TransactionCreateCategoryEvent(this.body, this.context);
}
