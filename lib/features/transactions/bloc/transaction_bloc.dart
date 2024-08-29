import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spend_wise/features/transactions/data/models/transaction.dart';
import 'package:spend_wise/features/transactions/domain/repo/transaction_repo.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc() : super(TransactionInitial()) {
    on<TransactionsInitialFetchEvent>(transactionsInitialFetchEvent);
  }

  Future<FutureOr<void>> transactionsInitialFetchEvent(
      TransactionsInitialFetchEvent event,
      Emitter<TransactionState> emit) async {
    emit(TransactionLoading());
    try {
      final transactions = await TransactionRepo.getTransactions(
          event.type.toString(),
          event.startDate.toString(),
          event.endDate.toString());
      emit(transactions.isNotEmpty
          ? TransactionsInitialFetchSuccessState(transactions)
          : TransactionEmptyState());
    } catch (err) {
      emit(TransactionErrorState(err.toString()));
    }
  }
}
