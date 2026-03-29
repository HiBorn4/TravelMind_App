
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../config/app_colors.dart';
import '../config/app_text_style.dart';

class DropDownWidget<T> extends StatelessWidget {
  final T? selectedValue;
  final void Function(T?)? onChanged;
  final List<T> itemsList;
  final Color? borderColor;
  final TextStyle? textStyle;
  final Color? fillColor;
  final String title;
  final bool? isRequired;
  final List<DropdownMenuItem<T>>? items;
  final String Function(T)? displayItem; // Custom display function

  const DropDownWidget({
    super.key,
    required this.selectedValue,
    required this.onChanged,
    required this.itemsList,
    this.textStyle,
    this.fillColor,
    this.borderColor,
    required this.title,
    this.items,
    this.displayItem,
    this.isRequired = false, // Pass custom display logic if needed
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Theme(
            data: ThemeData(splashColor: Colors.transparent, highlightColor: Colors.transparent),
            child: SizedBox(
              height: 50.h,
              width: double.infinity,
              child: DropdownButtonHideUnderline(
                child: DropdownButton2<T>(
                  enableFeedback: false,
                  isExpanded: true,
                  items: itemsList.map((item) {
                    return DropdownMenuItem<T>(
                      value: item,
                      child: Text(
                        displayItem != null ? displayItem!(item) : item.toString(),
                        style:
                            textStyle ??
                            AppTextStyles.customText18(color: AppColors.black, fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  value: selectedValue,
                  onChanged: onChanged,
                  buttonStyleData: ButtonStyleData(
                    height: 55,
                    width: 160,
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.sp),
                      color: fillColor ?? AppColors.transparent,
                      border: Border.all(color: borderColor ?? AppColors.textLightBlack.withOpacity(0.4)),
                    ),
                  ),
                  iconStyleData: IconStyleData(
                    icon: Icon(Icons.keyboard_arrow_down_rounded, size: 25.sp),
                    iconSize: 25.sp,
                    iconEnabledColor: AppColors.textLightBlack,
                    iconDisabledColor: Colors.black.withOpacity(0.15),
                  ),
                  dropdownStyleData: DropdownStyleData(
                    offset: Offset(-15, 10),
                    direction: DropdownDirection.left,
                    maxHeight: 200,
                    width: 200,
                    padding: null,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      border: Border.all(color: AppColors.primary.withOpacity(0.1)),
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  menuItemStyleData: const MenuItemStyleData(height: 40, padding: EdgeInsets.only(left: 14, right: 14)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
