import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

/// Utility function for showing a date picker, compatible with both iOS and Android.
Future<void> showCustomDatePicker({
  required BuildContext context,
  required DateTime initialDate,
  required Function(DateTime) onDateSelected,
}) async {
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
              initialDateTime: initialDate,
              onDateTimeChanged: (DateTime newDate) {
                initialDate =
                    newDate; // Update the local variable, but not state
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
              onDateSelected(initialDate); // Pass the selected date
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
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      onDateSelected(selectedDate); // Pass the selected date
    }
  }
}
