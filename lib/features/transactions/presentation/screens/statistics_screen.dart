import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:spend_wise/core/utils/colors.dart';
import 'package:spend_wise/core/widgets/loader_widget.dart';
import 'package:spend_wise/features/transactions/bloc/transaction_bloc.dart';
import 'package:spend_wise/features/transactions/domain/helpers/transaction_helper.dart';
import 'package:spend_wise/features/transactions/presentation/screens/add_transaction_screen.dart';
import 'package:spend_wise/features/transactions/presentation/widgets/filtering_options_bottom_sheet.dart';
import 'package:spend_wise/features/transactions/presentation/widgets/transaction_item_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreen();
}

class _StatisticsScreen extends State<StatisticsScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  TransactionBloc bloc = TransactionBloc();
  List<String> filters = [
    'Today',
    'Yesterday',
    'This month',
    'Last month',
    'This Week',
    'Last Week',
    'This year',
    'Last year',
    'Custom Date Selection'
  ];

  String currentAppliedFilter = 'All';

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
        // automaticallyImplyLeading: false,
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
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 5),
        child: FloatingActionButton(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const AddTransactionScreen()));
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
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
          List<Widget> children = [];
          if (type == 'all' && state.transactionSummary != null) {
            // final totalExpenses = state.transactionSummary!.expense;
            // final totalIncomes = state.transactionSummary!.income;
            final balance = state.transactionSummary!.balance;

            // Prepare data for the chart
            final expenseData = state.transactions
                .where((t) => t.transactionType == 'expense')
                .map((t) => ChartData(
                      DateTime.parse(t.date!),
                      t.amount!.toDouble(),
                    ))
                .toList();

            final incomeData = state.transactions
                .where((t) => t.transactionType == 'income')
                .map((t) => ChartData(
                      DateTime.parse(t.date!),
                      t.amount!.toDouble(),
                    ))
                .toList();

            children.add(
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Balance',
                              style: TextStyle(
                                color: AppColors.charcoal.withOpacity(0.8),
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '$balance USD',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppColors.charcoal,
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              showDragHandle: true,
                              backgroundColor: Colors.white,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              builder: (BuildContext context) {
                                return FilteringOptionsBottomSheet(
                                  filters: filters,
                                  onFilterAndDateRangeSelected:
                                      (selectedFilter, dateRange) {
                                    currentAppliedFilter = selectedFilter;
                                    if (selectedFilter ==
                                        'Custom Date Selection') {
                                      _applyFilter(selectedFilter,
                                          customDateRange: dateRange);
                                    } else {
                                      _applyFilter(selectedFilter);
                                    }
                                  },
                                );
                              },
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: AppColors.charcoal.withOpacity(0.5),
                                  width: 0.8),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  currentAppliedFilter,
                                  style: const TextStyle(
                                    color: AppColors.charcoal,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                                const Icon(Icons.arrow_drop_down,
                                    color: AppColors.charcoal),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Chart area
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: SfCartesianChart(
                        legend: const Legend(
                          isVisible: true,
                          position: LegendPosition.bottom,
                          overflowMode: LegendItemOverflowMode.wrap,
                        ),
                        primaryXAxis: DateTimeAxis(
                          dateFormat: DateFormat("MMM, dd"),
                          intervalType: DateTimeIntervalType.days,
                          edgeLabelPlacement: EdgeLabelPlacement.shift,
                        ),
                        primaryYAxis: const NumericAxis(
                          edgeLabelPlacement: EdgeLabelPlacement.shift,
                        ),
                        title: ChartTitle(
                          text: 'Income vs Expense',
                          alignment: ChartAlignment.near,
                          textStyle: TextStyle(
                            color: AppColors.charcoal.withOpacity(0.8),
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                        series: <CartesianSeries>[
                          if (type == 'income' || type == 'all')
                            SplineAreaSeries<ChartData, DateTime>(
                              dataSource: incomeData,
                              name: 'Income',
                              borderColor: Colors.green.withOpacity(0.7),
                              borderWidth: 1,
                              enableTooltip: true,
                              xValueMapper: (ChartData data, _) => data.date,
                              yValueMapper: (ChartData data, _) => data.amount,
                              color: Colors.green.withOpacity(0.3),
                              markerSettings: const MarkerSettings(
                                isVisible: false,
                              ),
                            ),
                          if (type == 'expense' || type == 'all')
                            SplineAreaSeries<ChartData, DateTime>(
                              dataSource: expenseData,
                              name: 'Expense',
                              borderColor: Colors.red.withOpacity(0.7),
                              borderWidth: 1,
                              enableTooltip: true,
                              xValueMapper: (ChartData data, _) => data.date,
                              yValueMapper: (ChartData data, _) => data.amount,
                              color: Colors.red.withOpacity(0.3),
                              markerSettings: const MarkerSettings(
                                isVisible: false,
                              ),
                            ),
                        ],
                        tooltipBehavior: TooltipBehavior(
                          enable: true,
                          header: '',
                          format: 'point.x: point.y',
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Transactions',
                      style: TextStyle(
                        color: AppColors.charcoal,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // Add the transaction items below the summary
          children.add(
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.transactions.length,
              itemBuilder: (context, index) {
                return TransactionItemWidget(
                    transaction: state.transactions[index]);
              },
            ),
          );

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: RefreshIndicator(
              onRefresh: () async {
                bloc.add(TransactionsInitialFetchEvent(type: type));
              },
              child: SingleChildScrollView(
                child: Column(
                  children: children,
                ),
              ),
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
          return const LoaderWidget();
        } else {
          return const SizedBox();
        }
      },
    );
  }

  void _applyFilter(String selectedFilter, {DateTimeRange? customDateRange}) {
    DateTimeRange dateRange = TransactionHelper.calculateDateRange(
        selectedFilter,
        customDateRange: customDateRange);

    bloc.add(TransactionsInitialFetchEvent(
      type: 'all', // Or any other type you want to pass
      startDate: dateRange.start.toIso8601String(),
      endDate: dateRange.end.toIso8601String(),
    ));
  }
}

class ChartData {
  final DateTime date;
  final double amount;

  ChartData(this.date, this.amount);
}
