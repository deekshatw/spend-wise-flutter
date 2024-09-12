import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:spend_wise/core/shared_prefs/shared_prefs.dart';
import 'package:spend_wise/core/utils/colors.dart';
import 'package:spend_wise/core/widgets/label_widget.dart';
import 'package:spend_wise/core/widgets/loader_widget.dart';
import 'package:spend_wise/core/widgets/primary_button.dart';
import 'package:spend_wise/core/widgets/text_field_widget.dart';
import 'package:spend_wise/features/transactions/bloc/transaction_bloc.dart';
import 'package:spend_wise/features/transactions/presentation/widgets/categories_bottom_sheet.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  TransactionBloc bloc = TransactionBloc();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _selectedChoice = 'expense';
  String? selectedCategory;
  String? selectedCategoryId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'New Transaction',
          style: TextStyle(
            color: AppColors.charcoal,
            fontWeight: FontWeight.w600,
          ),
        ),
        forceMaterialTransparency: true,
      ),
      body: BlocConsumer<TransactionBloc, TransactionState>(
        bloc: bloc,
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          if (state is TransactionLoading) {
            return LoaderWidget();
          } else {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add a new transaction',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.charcoal.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const LabelWidget(
                      label: 'Title',
                      isRequired: true,
                    ),
                    TextFieldWidget(
                      controller: _titleController,
                      label: 'Add your title here',
                      isPassword: false,
                    ),
                    const SizedBox(height: 8),
                    const LabelWidget(label: 'Description'),
                    TextFieldWidget(
                      controller: _descController,
                      label: 'Add your description here',
                      keyboardType: TextInputType.multiline,
                      isPassword: false,
                    ),
                    const SizedBox(height: 8),
                    const LabelWidget(label: 'Amount', isRequired: true),
                    TextFieldWidget(
                      controller: _amountController,
                      label: 'Add your amount here',
                      keyboardType: TextInputType.number,
                      isPassword: false,
                    ),
                    const SizedBox(height: 8),
                    const LabelWidget(
                        label: 'Transaction Date', isRequired: true),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            DateFormat('MMMM d, yyyy').format(_selectedDate),
                            style: TextStyle(
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
                          onPressed: _showDatePicker,
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
                    const LabelWidget(
                        label: 'Transaction Type', isRequired: true),
                    Row(
                      children: [
                        ChoiceChip(
                          label: const Text('expense'),
                          selected: _selectedChoice == 'expense',
                          onSelected: (bool selected) {
                            setState(() {
                              _selectedChoice = 'expense';
                            });
                          },
                          selectedColor: ColorScheme.fromSwatch()
                              .copyWith(
                                  secondary:
                                      AppColors.primary.withOpacity(0.45))
                              .secondary,
                        ),
                        const SizedBox(width: 8),
                        ChoiceChip(
                          selectedColor: ColorScheme.fromSwatch()
                              .copyWith(
                                  secondary:
                                      AppColors.primary.withOpacity(0.45))
                              .secondary,
                          label: const Text('income'),
                          selected: _selectedChoice == 'income',
                          onSelected: (bool selected) {
                            setState(() {
                              _selectedChoice = 'income';
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const LabelWidget(label: 'Category', isRequired: true),
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
                            title: Text(selectedCategory != null
                                ? "Change Category"
                                : 'Select a category'),
                            tileColor: AppColors.gray.withOpacity(0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            leading: HugeIcon(
                              icon: HugeIcons.strokeRoundedLabelImportant,
                              color: Colors.black,
                              size: 24.0,
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
                        : SizedBox(),
                    const SizedBox(height: 30),
                    PrimaryButton(
                      label: 'Add Transaction',
                      onTap: () async {
                        int? userId =
                            await SharedPrefs.getUserIdSharedPreference();
                        bloc.add(
                          TransactionCreateTransactionEvent(
                            {
                              "amount": _amountController.text,
                              "description": _descController.text,
                              "title": _titleController.text,
                              "date": _selectedDate.toString(),
                              "userId": userId,
                              "categoryId": selectedCategoryId,
                              "transactionType": _selectedChoice
                            },
                            context,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  void _showDatePicker() async {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
          actions: [
            Container(
              height: 300,
              color: CupertinoColors.white,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: _selectedDate,
                onDateTimeChanged: (DateTime newDate) {
                  setState(() {
                    _selectedDate = newDate;
                  });
                },
              ),
            ),
            CupertinoActionSheetAction(
              child: const Text(
                'Done',
                style: TextStyle(
                  color: CupertinoColors.systemBlue,
                ),
              ),
              onPressed: () {
                Navigator.pop(context); // Close the modal
                // Handle date selection
                print('Selected Date: $_selectedDate'); // Example of handling
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: CupertinoColors.systemRed,
              ),
            ),
            onPressed: () {
              Navigator.pop(context); // Close the modal
            },
          ),
        ),
      );
    } else {
      // Android Date Picker
      final DateTime? selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );

      if (selectedDate != null) {
        setState(() {
          _selectedDate = selectedDate;
        });
        print('Selected Date: $selectedDate');
      }
    }
  }
}
