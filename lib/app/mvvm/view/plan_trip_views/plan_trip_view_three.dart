import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vlad_ai/app/config/app_text_style.dart';
import 'package:vlad_ai/app/config/padding_extensions.dart';
import 'package:vlad_ai/app/customWidgets/app_custom_button.dart';
import 'package:vlad_ai/app/customWidgets/sizedbox_extension.dart';
import 'package:vlad_ai/app/mvvm/view_model/plan_trip_controller.dart';
import 'package:vlad_ai/l10n/l10n.dart';
import '../../../config/app_colors.dart';

class PlanTripViewThree extends StatefulWidget {
  const PlanTripViewThree({super.key});

  @override
  State<PlanTripViewThree> createState() => _PlanTripViewThreeState();
}

class _PlanTripViewThreeState extends State<PlanTripViewThree> {
  final PlanTripController controller = Get.find();
  final GlobalKey<CustomCalendarState> _calendarKey = GlobalKey(); // 🔹 key to control calendar state

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            padding: EdgeInsets.all(10.sp),
                            decoration: BoxDecoration(color: Colors.white.withOpacity(0.3), shape: BoxShape.circle),
                            child: Icon(Icons.close, color: Colors.black, size: 20.sp),
                          ),
                        ),
                      ),
                    ),
                  ],
                ).paddingHorizontal(18.w),
                10.h.height,

                // 🔹 Blurred container with Calendar
                ClipRRect(
                  borderRadius: BorderRadius.circular(24.sp),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.3), borderRadius: BorderRadius.circular(24.sp)),
                      child: Column(
                        children: [
                          // 🔹 Our Custom Calendar here
                          CustomCalendar(key: _calendarKey),

                          20.h.height,
                          Row(
                            children: [
                              Expanded(
                                child: AppCustomButton(
                                  height: 40.h,
                                  title: context.l10n!.reset,
                                  bgColor: Colors.transparent,
                                  textStyle: AppTextStyles.customText16(color: AppColors.secondaryBlack, fontWeight: FontWeight.w600),
                                  borderColor: AppColors.secondaryBlack,
                                  onPressed: () {
                                    _calendarKey.currentState?.resetSelection(); // 🔹 clear highlight
                                  },
                                ),
                              ),
                              15.w.width,
                              Expanded(
                                child: AppCustomButton(
                                  height: 40.h,
                                  title: context.l10n!.confirm,
                                  onPressed: () {
                                    controller.pageController.nextPage(duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ).paddingFromAll(12.sp).paddingHorizontal(6.w),
                    ).paddingHorizontal(10.w).paddingBottom(10.h),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 🔹 Calendar Widget
class CustomCalendar extends StatefulWidget {
  const CustomCalendar({super.key});

  @override
  State<CustomCalendar> createState() => CustomCalendarState();
}

class CustomCalendarState extends State<CustomCalendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  void resetSelection() {
    setState(() {
      _selectedDay = null;
      _rangeStart = null;
      _rangeEnd = null;
    });
  }

  bool _isPastDate(DateTime day) {
    final today = DateTime.now();
    final currentDate = DateTime(today.year, today.month, today.day);
    return day.isBefore(currentDate);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        calendarFormat: CalendarFormat.month,
        availableCalendarFormats: const {CalendarFormat.month: 'Month'},
        headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: true),
        startingDayOfWeek: StartingDayOfWeek.sunday,
        calendarStyle: CalendarStyle(
          isTodayHighlighted: true,
          todayDecoration: BoxDecoration(color: Colors.grey.shade300, shape: BoxShape.circle),

          // Transparent selection
          selectedDecoration: const BoxDecoration(color: Color(0xffE6F88D), shape: BoxShape.circle),

          // Range highlighting
          rangeHighlightColor: Color(0xffE6F88D),
          rangeStartDecoration: const BoxDecoration(color: Color(0xffE6F88D), shape: BoxShape.circle),
          rangeEndDecoration: const BoxDecoration(color: Color(0xffE6F88D), shape: BoxShape.circle),
          withinRangeDecoration: BoxDecoration(color: Color(0xffE6F88D), shape: BoxShape.circle),
        ),

        onDaySelected: (selectedDay, focusedDay) {
          if (_isPastDate(selectedDay)) return; // ❌ block past

          setState(() {
            _focusedDay = focusedDay;

            if (_rangeStart == null || (_rangeStart != null && _rangeEnd != null)) {
              // Start a new range
              _rangeStart = selectedDay;
              _rangeEnd = null;
              _selectedDay = selectedDay;
            } else if (_rangeStart != null && _rangeEnd == null) {
              if (selectedDay.isBefore(_rangeStart!)) {
                // ❌ Can't go backwards
                _rangeStart = selectedDay;
                _rangeEnd = null;
                _selectedDay = selectedDay;
              } else {
                // ✅ Check range length
                final difference = selectedDay.difference(_rangeStart!).inDays;
                if (difference <= 6) {
                  // ✅ Valid range (7 days max including start)
                  _rangeEnd = selectedDay;
                  _selectedDay = null;
                } else {
                  // ❌ Do nothing if more than 7 days
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(context.l10n!.you_can_select_up_to_7_days_only), duration: Duration(milliseconds: 500)));
                }
              }
            }
          });
        },

        selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
        rangeStartDay: _rangeStart,
        rangeEndDay: _rangeEnd,
      ),
    );
  }
}
