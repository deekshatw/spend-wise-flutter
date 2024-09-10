import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:spend_wise/features/budgets/data/models/budget_model.dart';
import 'package:spend_wise/features/budgets/domain/repo/budget_repo.dart';

part 'budget_event.dart';
part 'budget_state.dart';

class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {
  BudgetBloc() : super(BudgetInitial()) {
    on<BudgetInitialBudgetsFetchEvent>(budgetInitialBudgetsFetchEvent);
  }

  FutureOr<void> budgetInitialBudgetsFetchEvent(
      BudgetInitialBudgetsFetchEvent event, Emitter<BudgetState> emit) async {
    emit(BudgetLoadingState());
    try {
      List<BudgetModel> budgets = await BudgetRepo.fetchBudgets();
      emit(budgets.isNotEmpty
          ? BudgetInitialBudgetsFetchEventSuccessState(budgets)
          : BudgetEmptyState());
    } catch (error) {
      emit(BudgetErrorState(error.toString()));
    }
  }
}
