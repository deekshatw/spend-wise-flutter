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
