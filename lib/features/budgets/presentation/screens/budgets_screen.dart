import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/core/utils/colors.dart';
import 'package:spend_wise/core/widgets/loader_widget.dart';
import 'package:spend_wise/features/budgets/bloc/budget_bloc.dart';
import 'package:spend_wise/features/budgets/presentation/widgets/budget_item_widget.dart';

class BudgetsScreen extends StatefulWidget {
  const BudgetsScreen({super.key});

  @override
  State<BudgetsScreen> createState() => _BudgetsScreenState();
}

class _BudgetsScreenState extends State<BudgetsScreen> {
  BudgetBloc bloc = BudgetBloc();

  @override
  void initState() {
    bloc.add(BudgetInitialBudgetsFetchEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budgets'),
      ),
      body: BlocConsumer<BudgetBloc, BudgetState>(
        bloc: bloc,
        buildWhen: (previous, current) => current is! BudgetActionState,
        listenWhen: (previous, current) => current is BudgetActionState,
        listener: (context, state) {},
        builder: (context, state) {
          if (state is BudgetLoadingState) {
            return const LoaderWidget();
          } else if (state is BudgetInitialBudgetsFetchEventSuccessState) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Budgets',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.charcoal,
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.budgets.length,
                      itemBuilder: (context, index) {
                        return BudgetItemWidget(budget: state.budgets[index]);
                      },
                    ),
                  ),
                ],
              ),
            );
          } else if (state is BudgetErrorState) {
            return Center(child: Text(state.message));
          } else if (state is BudgetEmptyState) {
            return const Center(child: Text('No budgets found'));
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
