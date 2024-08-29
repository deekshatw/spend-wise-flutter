import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/core/utils/colors.dart';
import 'package:spend_wise/core/widgets/loader_widget.dart';
import 'package:spend_wise/features/transactions/bloc/transaction_bloc.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  TransactionBloc bloc = TransactionBloc();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    bloc = TransactionBloc();
    bloc.add(TransactionsInitialFetchEvent(type: 'all'));
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Statistics',
          style: TextStyle(
            color: AppColors.charcoal,
            fontWeight: FontWeight.w600,
          ),
        ),
        // forceMaterialTransparency: false,
        bottom: TabBar(
          dividerColor: Colors.transparent,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          splashFactory: NoSplash.splashFactory,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.normal,
          ),
          controller: _tabController,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Expenses'),
            Tab(text: 'Incomes'),
          ],
          onTap: (index) {
            String type;
            switch (index) {
              case 1:
                type = 'expense';
                break;
              case 2:
                type = 'income';
                break;
              default:
                type = 'all';
            }
            bloc.add(TransactionsInitialFetchEvent(type: type));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        onPressed: () {},
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTransactionList('all'),
          _buildTransactionList('expense'),
          _buildTransactionList('income'),
        ],
      ),
    );
  }

  Widget _buildTransactionList(String type) {
    return BlocConsumer<TransactionBloc, TransactionState>(
      bloc: bloc,
      listenWhen: (previous, current) => current is TransactionActionState,
      buildWhen: (previous, current) => current is! TransactionActionState,
      listener: (context, state) {},
      builder: (context, state) {
        if (state is TransactionsInitialFetchSuccessState) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView.builder(
              itemCount: state.transactions.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.gray.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                              state.transactions[index].transactionType ==
                                      'income'
                                  ? Icons.arrow_upward_rounded
                                  : Icons.arrow_downward_rounded,
                              color:
                                  state.transactions[index].transactionType ==
                                          'income'
                                      ? Colors.green
                                      : Colors.red),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(state.transactions[index].description
                                  .toString()),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                decoration: BoxDecoration(
                                  color: AppColors.orchidPink.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  state.transactions[index].category!.name
                                      .toString(),
                                  style: const TextStyle(
                                    color: AppColors.charcoal,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text(
                        state.transactions[index].transactionType == 'income'
                            ? " + \$${state.transactions[index].amount.toString()}"
                            : " - \$${state.transactions[index].amount.toString()}",
                        style: TextStyle(
                          color: state.transactions[index].transactionType ==
                                  'income'
                              ? Colors.green
                              : Colors.red,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        } else if (state is TransactionErrorState) {
          return Center(
            child: Text(state.message),
          );
        } else if (state is TransactionEmptyState) {
          return const Center(
            child: Text('No transactions found'),
          );
        } else if (state is TransactionLoading) {
          return LoaderWidget();
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
