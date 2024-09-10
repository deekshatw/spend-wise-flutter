import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:spend_wise/core/helpers/show_date_picker.dart';
import 'package:spend_wise/core/shared_prefs/shared_prefs.dart';
import 'package:spend_wise/core/utils/colors.dart';
import 'package:spend_wise/core/widgets/label_widget.dart';
import 'package:spend_wise/core/widgets/loader_widget.dart';
import 'package:spend_wise/core/widgets/primary_button.dart';
import 'package:spend_wise/core/widgets/text_field_widget.dart';
import 'package:spend_wise/features/budgets/bloc/budget_bloc.dart';
import 'package:spend_wise/features/transactions/presentation/widgets/categories_bottom_sheet.dart';

class AddBudgetScreen extends StatefulWidget {
  const AddBudgetScreen({super.key});

  @override
  State<AddBudgetScreen> createState() => _AddBudgetScreenState();
}

class _AddBudgetScreenState extends State<AddBudgetScreen> {
  BudgetBloc bloc = BudgetBloc();
  final TextEditingController _amountController = TextEditingController();
  String? selectedCategory;
  String? selectedCategoryId;
  DateTime _selectedStartDate = DateTime.now();
  DateTime _selectedEndDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'New Budget',
          style: TextStyle(
            color: AppColors.charcoal,
            fontWeight: FontWeight.w600,
          ),
        ),
        forceMaterialTransparency: true,
      ),
      body: BlocConsumer<BudgetBloc, BudgetState>(
        bloc: bloc,
        buildWhen: (previous, current) => current is! BudgetActionState,
        listenWhen: (previous, current) => current is BudgetActionState,
        listener: (context, state) {},
        builder: (context, state) {
          if (state is BudgetLoadingState) {
            return const LoaderWidget();
          } else if (state is BudgetErrorState) {
            return Center(child: Text(state.message));
          } else if (state is BudgetEmptyState) {
            return const Center(child: Text('No budgets found'));
          } else {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add a new budget',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.charcoal.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const SizedBox(height: 8),
                    const LabelWidget(label: 'Amount', isRequired: true),
                    TextFieldWidget(
                      controller: _amountController,
                      label: 'Add your amount here',
                      keyboardType: TextInputType.number,
                      isPassword: false,
                    ),
                    const LabelWidget(
                      label: 'Category',
                      isRequired: true,
                    ),
                    if (selectedCategory != null)
                      InkWell(
                        onTap: () {
                          setState(() {
                            selectedCategory = null;
                          });
                        },
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    selectedCategory.toString(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: AppColors.charcoal,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Icon(Icons.close,
                                      color:
                                          AppColors.charcoal.withOpacity(0.8)),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    selectedCategory == null
                        ? ListTile(
                            title: const Text('Select a category'),
                            tileColor: AppColors.gray.withOpacity(0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            leading: Icon(
                              Icons.category_outlined,
                              color: AppColors.charcoal.withOpacity(0.8),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 12,
                            ),
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.white,
                                isScrollControlled: true,
                                showDragHandle: true,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20)),
                                ),
                                builder: (BuildContext context) {
                                  return Container(
                                    height: MediaQuery.of(context).size.height,
                                    child: CategoriesBottomSheet(
                                      onCategorySelected: (category) {
                                        setState(() {
                                          selectedCategory = category.name;
                                        });
                                        selectedCategoryId =
                                            category.categoryId;
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                          )
                        : const SizedBox(),
                    const SizedBox(height: 8),
                    const LabelWidget(label: 'Start Date', isRequired: true),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            DateFormat('MMMM d, yyyy')
                                .format(_selectedStartDate),
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.charcoal,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                AppColors.orchidPink.withOpacity(0.45),
                            elevation: 6,
                            splashFactory: NoSplash.splashFactory,
                            shadowColor: AppColors.orchidPink.withOpacity(0.2),
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: _pickStartDate,
                          child: const Text(
                            'Select Date',
                            style: TextStyle(
                              color: AppColors.charcoal,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const LabelWidget(label: 'End Date', isRequired: true),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            DateFormat('MMMM d, yyyy').format(_selectedEndDate),
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.charcoal,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                AppColors.orchidPink.withOpacity(0.45),
                            elevation: 6,
                            splashFactory: NoSplash.splashFactory,
                            shadowColor: AppColors.orchidPink.withOpacity(0.2),
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: _pickEndDate,
                          child: const Text(
                            'Select Date',
                            style: TextStyle(
                              color: AppColors.charcoal,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    PrimaryButton(
                        label: 'Add Budget',
                        onTap: () async {
                          int? userId =
                              await SharedPrefs.getUserIdSharedPreference();
                          Map<String, dynamic> body = {
                            'userId': userId,
                            'amount': double.parse(_amountController.text),
                            'category': selectedCategoryId,
                            'startDate': _selectedStartDate.toString(),
                            'endDate': _selectedEndDate.toString(),
                          };
                          bloc.add(BudgetAddNewBudgetEvent(
                              body: body, context: context));
                        }),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  void _pickStartDate() async {
    showCustomDatePicker(
      context: context,
      initialDate: _selectedStartDate,
      onDateSelected: (DateTime selectedDate) {
        setState(() {
          _selectedStartDate = selectedDate;
        });
        print("date selected: $_selectedStartDate");
      },
    );
  }

  void _pickEndDate() async {
    showCustomDatePicker(
      context: context,
      initialDate: _selectedEndDate,
      onDateSelected: (DateTime selectedDate) {
        setState(() {
          _selectedEndDate = selectedDate;
        });
        print("date selected: $_selectedEndDate");
      },
    );
  }
}
