import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/core/widgets/label_widget.dart';
import 'package:spend_wise/core/widgets/loader_widget.dart';
import 'package:spend_wise/core/widgets/primary_button.dart';
import 'package:spend_wise/core/widgets/text_field_widget.dart';
import 'package:spend_wise/features/transactions/bloc/transaction_bloc.dart';

class AddCategoryBottomSheet extends StatelessWidget {
  const AddCategoryBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    TransactionBloc bloc = TransactionBloc();
    TextEditingController _titleController = TextEditingController();
    TextEditingController _descController = TextEditingController();
    return BlocConsumer<TransactionBloc, TransactionState>(
      bloc: bloc,
      listener: (context, state) {},
      builder: (context, state) {
        if (state is TransactionLoading) {
          return const LoaderWidget();
        } else {
          return Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
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
                        const LabelWidget(
                          label: 'Description',
                          isRequired: true,
                        ),
                        TextFieldWidget(
                          controller: _descController,
                          label: 'Add your description here',
                          keyboardType: TextInputType.multiline,
                          isPassword: false,
                        ),
                      ],
                    )),
                const SizedBox(height: 20),
                PrimaryButton(
                  label: 'Add Category',
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      bloc.add(
                        TransactionCreateCategoryEvent(
                          {
                            'name': _titleController.text,
                            'description': _descController.text
                          },
                          context,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
