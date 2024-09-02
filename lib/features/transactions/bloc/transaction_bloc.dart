import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:spend_wise/features/transactions/data/models/category.dart';
import 'package:spend_wise/features/transactions/data/models/transaction.dart';
import 'package:spend_wise/features/transactions/data/models/transaction_summary.dart';
import 'package:spend_wise/features/transactions/domain/repo/transaction_repo.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc() : super(TransactionInitial()) {
    on<TransactionsInitialFetchEvent>(transactionsInitialFetchEvent);
    on<TransactionCategoriesFetchEvent>(transactionCategoriesFetchEvent);
    on<TransactionCreateTransactionEvent>(transactionCreateTransactionEvent);
    on<TransactionCreateCategoryEvent>(transactionCreateCategoryEvent);
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
      if (event.type.toString() == 'all') {
        final TransactionSummary transactionSummary =
            await TransactionRepo.fetchTransactionSummary();
        emit(transactions.isNotEmpty
            ? TransactionsInitialFetchSuccessState(
                transactions: transactions,
                transactionSummary: transactionSummary)
            : TransactionEmptyState());
      } else {
        emit(transactions.isNotEmpty
            ? TransactionsInitialFetchSuccessState(transactions: transactions)
            : TransactionEmptyState());
      }
    } catch (err) {
      emit(TransactionErrorState(err.toString()));
    }
  }

  Future<FutureOr<void>> transactionCategoriesFetchEvent(
      TransactionCategoriesFetchEvent event,
      Emitter<TransactionState> emit) async {
    emit(TransactionLoading());
    try {
      final categories = await TransactionRepo.fetchCategories();
      emit(categories.isNotEmpty
          ? TransactionCategoriesFetchSuccessState(categories)
          : TransactionEmptyState());
    } catch (err) {
      emit(TransactionErrorState(err.toString()));
    }
  }

  FutureOr<void> transactionCreateTransactionEvent(
      TransactionCreateTransactionEvent event, Emitter<TransactionState> emit) {
    emit(TransactionLoading());
    try {
      TransactionRepo.addTransaction(event.body, event.context);
    } catch (err) {
      emit(TransactionErrorState(err.toString()));
    }
  }

  FutureOr<void> transactionCreateCategoryEvent(
      TransactionCreateCategoryEvent event, Emitter<TransactionState> emit) {
    emit(TransactionLoading());
    try {
      TransactionRepo.addCategory(event.body, event.context);
    } catch (err) {
      emit(TransactionErrorState(err.toString()));
    }
  }
}
