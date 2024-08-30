import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/core/utils/colors.dart';
import 'package:spend_wise/core/widgets/loader_widget.dart';
import 'package:spend_wise/core/widgets/primary_button.dart';
import 'package:spend_wise/features/transactions/bloc/transaction_bloc.dart';
import 'package:spend_wise/features/transactions/data/models/category.dart';

class CategoriesBottomSheet extends StatefulWidget {
  final Function(Category)
      onCategorySelected; // Change this to pass the whole category

  const CategoriesBottomSheet({super.key, required this.onCategorySelected});

  @override
  State<CategoriesBottomSheet> createState() => _CategoriesBottomSheetState();
}

class _CategoriesBottomSheetState extends State<CategoriesBottomSheet> {
  TransactionBloc bloc = TransactionBloc();
  Category _selectedCategory = Category(); // Store the entire category model

  @override
  void initState() {
    super.initState();
    bloc.add(TransactionCategoriesFetchEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransactionBloc, TransactionState>(
      bloc: bloc,
      listener: (context, state) {},
      builder: (context, state) {
        if (state is TransactionCategoriesFetchSuccessState) {
          return Container(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Choose your category',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.charcoal.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.categories.length,
                    itemBuilder: (context, index) {
                      final category = state.categories[index];
                      final isSelected =
                          _selectedCategory?.categoryId == category.categoryId;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 20,
                          ),
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary.withOpacity(0.2)
                                : AppColors.gray.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : Colors.transparent,
                              width: 0.8,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.category,
                                color: AppColors.roseTaupe,
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    category.name.toString(),
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: AppColors.charcoal,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    child: Text(
                                      category.description.toString(),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color:
                                            AppColors.charcoal.withOpacity(0.8),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                PrimaryButton(
                  onTap: _selectedCategory == null
                      ? null
                      : () {
                          if (_selectedCategory != null) {
                            widget.onCategorySelected(_selectedCategory!);
                            Navigator.pop(context); // Close the bottom sheet
                          }
                        },
                  label: 'Select',
                ),
              ],
            ),
          );
        } else if (state is TransactionLoading) {
          return LoaderWidget();
        } else if (state is TransactionErrorState) {
          return Center(
            child: Text('Error: ${state.message}'),
          );
        } else if (state is TransactionEmptyState) {
          return Center(
            child: Text('No categories found'),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
