import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';
import 'package:spend_wise/core/utils/colors.dart';
import 'package:spend_wise/features/budgets/data/models/budget_model.dart';

class BudgetItemWidget extends StatelessWidget {
  final BudgetModel budget;
  const BudgetItemWidget({super.key, required this.budget});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.gray.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.category,
                    color: AppColors.primary,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          budget.category!.name.toString(),
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: AppColors.charcoal,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              '${budget.percentageSpent}%',
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.charcoal,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              ' already spent',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.charcoal.withOpacity(0.7),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${DateFormat('MMM dd').format(DateTime.parse(budget.startDate.toString()))} - ${DateFormat('MMM dd').format(DateTime.parse(budget.endDate.toString()))}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.charcoal,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${budget.spent}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: budget.percentageSpent! >= 50 &&
                              budget.percentageSpent! < 75
                          ? Colors.deepOrangeAccent
                          : budget.percentageSpent! >= 75
                              ? Colors.red
                              : Colors.blueAccent,
                    ),
                  ),
                  Text(
                    '\$${budget.amount} limit',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.charcoal.withOpacity(0.7),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          SimpleAnimationProgressBar(
            height: 5,
            width: 300,
            backgroundColor: AppColors.roseTaupe.withOpacity(0.3),
            foregrondColor:
                budget.percentageSpent! >= 50 && budget.percentageSpent! < 75
                    ? Colors.deepOrangeAccent
                    : budget.percentageSpent! >= 75
                        ? Colors.red
                        : Colors.blueAccent,
            ratio: budget.percentageSpent! / 100,
            direction: Axis.horizontal,
            curve: Curves.fastLinearToSlowEaseIn,
            duration: const Duration(seconds: 3),
            borderRadius: BorderRadius.circular(10),
          )
          // LinearProgressIndicator(),
        ],
      ),
    );
  }
}
