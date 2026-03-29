import 'package:flutter/material.dart';

import '../../config/app_colors.dart';
import '../../config/app_text_style.dart';

Future<DateTime?> ShowDatePicker(BuildContext context) {
  return showDatePicker(
    context: context,
    firstDate: DateTime(1985),
    lastDate: DateTime(2050),
    builder: (context, child) {
      return Theme(
        data: ThemeData(
          colorScheme: ColorScheme.light(
            primary: AppColors.primary, // ✅ Select & Cancel button color
            onPrimary: AppColors.white, // ✅ Text color on buttons
            surface: AppColors.white,
            onSurface: AppColors.primary, // ✅ Selected date text color
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: AppColors.black, // ✅ Cancel & Select text color
            ),
          ),
        ),
        child: DatePickerTheme(
          data: DatePickerThemeData(
            headerHelpStyle: AppTextStyles.customText24(color: AppColors.white),
            headerForegroundColor: AppColors.white,
            headerHeadlineStyle: TextStyle(color: AppColors.white, fontSize: 28),
            rangePickerBackgroundColor: AppColors.primary,
            rangePickerHeaderForegroundColor: AppColors.primary,
            rangePickerSurfaceTintColor: AppColors.primary,
            backgroundColor: AppColors.white,
            headerBackgroundColor: AppColors.primary,

            todayForegroundColor: WidgetStateProperty.all(AppColors.white), // ✅ Today's text color
            todayBackgroundColor: WidgetStateProperty.all(AppColors.textLightBlack.withOpacity(0.6)), // ✅ Today's background
            dayBackgroundColor: WidgetStateProperty.all(AppColors.white), // ✅ Default Day background color

            // ✅ Selected date background and text color
            dayOverlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
              if (states.contains(WidgetState.selected)) {
                return AppColors.primary; // Background color of selected date
              }
              return null;
            }),
            dayForegroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
              if (states.contains(WidgetState.selected)) {
                return AppColors.primary; // Text color of selected date
              }
              return AppColors.black;
            }),

            inputDecorationTheme: InputDecorationTheme(
              activeIndicatorBorder: BorderSide(color: AppColors.textLightBlack),
              focusColor: AppColors.primary,
            ),
          ),
          child: DatePickerDialog(
            helpText: '',
            cancelText: 'Cancel',
            confirmText: 'Select',
            initialCalendarMode: DatePickerMode.day,
            firstDate: DateTime(1985),
            lastDate: DateTime(3000),
            initialDate: DateTime.now(),
          ),
        ),
      );
    },
  );
}

Future showCustomTimePicker(BuildContext context) {
  return showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
    builder: (context, child) {
      return Theme(
        data: ThemeData.light().copyWith(
          primaryColor: Colors.blue, // Change the color of the selected time
          buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          timePickerTheme: TimePickerThemeData(
            backgroundColor: Colors.white,
            hourMinuteTextColor: Colors.black,
            dialBackgroundColor: Colors.grey[200],
            dialHandColor: Colors.blue,
          ),
        ),
        child: child!,
      );
    },
  );
}
