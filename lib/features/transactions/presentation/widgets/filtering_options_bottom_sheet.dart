import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spend_wise/core/utils/assets.dart';
import 'package:spend_wise/core/utils/colors.dart';

class FilteringOptionsBottomSheet extends StatefulWidget {
  final List<String> filters;
  final String? selectedFilter; // Changed to a single selected filter
  final void Function(String selectedFilter, DateTimeRange?)?
      onFilterAndDateRangeSelected; // Callback for both filter and date range

  const FilteringOptionsBottomSheet({
    super.key,
    required this.filters,
    this.selectedFilter,
    this.onFilterAndDateRangeSelected, // Initialize callback
  });

  @override
  _FilteringOptionsBottomSheetState createState() =>
      _FilteringOptionsBottomSheetState();
}

class _FilteringOptionsBottomSheetState
    extends State<FilteringOptionsBottomSheet> {
  late String _selectedFilter;

  @override
  void initState() {
    super.initState();
    _selectedFilter = widget.selectedFilter ?? ''; // Initialize selected filter
  }

  void _selectFilter(String filter) {
    setState(() {
      _selectedFilter = filter; // Update to the selected filter
      if (filter != widget.filters.last) {
        // Call callback with only selected filter
        widget.onFilterAndDateRangeSelected?.call(_selectedFilter, null);
        Navigator.of(context).pop(); // Close the bottom sheet
      }
    });
  }

  Future<void> _handleDateRangeSelection() async {
    DateTimeRange? selectedRange = await showCustomDateRangePicker(context);
    if (selectedRange != null) {
      widget.onFilterAndDateRangeSelected?.call(_selectedFilter,
          selectedRange); // Pass the selected filter and range back to the parent
      Navigator.of(context).pop(); // Close the bottom sheet
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filtering Options',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.charcoal.withOpacity(0.8),
                  ),
                ),
                if (_selectedFilter.isNotEmpty)
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedFilter = '';
                          });
                        },
                        child: const Text(
                          'Clear',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the bottom sheet
                        },
                        child: const Text(
                          'Done',
                          style: TextStyle(
                            color: CupertinoColors.activeBlue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: widget.filters.map((filter) {
                final isSelected = _selectedFilter == filter;
                return GestureDetector(
                  onTap: () => filter == widget.filters.last
                      ? _handleDateRangeSelection()
                      : _selectFilter(filter),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 20),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withOpacity(0.2)
                          : AppColors.gray.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color:
                            isSelected ? AppColors.primary : Colors.transparent,
                        width: 0.8,
                      ),
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          Assets.filterSVG,
                          color: AppColors.roseTaupe,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          filter,
                          style: TextStyle(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.charcoal,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (isSelected) const Spacer(),
                        if (isSelected)
                          const Icon(Icons.check_circle, color: Colors.green),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Future<DateTimeRange?> showCustomDateRangePicker(BuildContext context) async {
    return await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppColors.primary,
            indicatorColor: Colors.red,
            datePickerTheme: DatePickerThemeData(
              rangeSelectionBackgroundColor: AppColors.gray.withOpacity(0.3),
            ),
            hintColor: AppColors.primary,
            colorScheme: const ColorScheme.light(primary: AppColors.primary),
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
  }
}
