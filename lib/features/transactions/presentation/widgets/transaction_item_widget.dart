import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:spend_wise/core/utils/colors.dart';
import 'package:spend_wise/features/transactions/data/models/transaction.dart';

class TransactionItemWidget extends StatelessWidget {
  final Transaction transaction;
  const TransactionItemWidget({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
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
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: transaction.transactionType == 'income'
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  transaction.transactionType == 'income'
                      ? Icons.arrow_upward_rounded
                      : Icons.arrow_downward_rounded,
                  color: transaction.transactionType == 'income'
                      ? Colors.green
                      : Colors.red,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.title.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: MediaQuery.of(context).size.height * 0.0185,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.43,
                    child: Text(
                      transaction.description.toString(),
                      style: TextStyle(
                        // color: AppColors.charcoal.withOpacity(0.8),
                        fontSize: MediaQuery.of(context).size.height * 0.015,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      transaction.category!.name.toString(),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                transaction.transactionType == 'income'
                    ? " + \$${transaction.amount.toString()}"
                    : " - \$${transaction.amount.toString()}",
                style: TextStyle(
                  color: transaction.transactionType == 'income'
                      ? Colors.green
                      : Colors.red,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              Text(
                DateFormat('MMM dd, yyyy')
                    .format(DateTime.parse(transaction.date!)),
                style: TextStyle(
                  color: AppColors.charcoal.withOpacity(0.8),
                  fontSize: MediaQuery.of(context).size.height * 0.015,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
