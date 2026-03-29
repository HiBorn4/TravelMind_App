import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vlad_ai/app/config/padding_extensions.dart';
import 'package:vlad_ai/l10n/l10n.dart';
import '../../config/app_colors.dart';
import '../../config/app_text_style.dart';
import '../app_custom_field.dart';

class CountryPickerWidget extends StatefulWidget {
  final Widget? suffixIcon;
  final String labelText;
  final String? hintText;
  final bool? isReadOnly;
  final bool? isRequired;
  final TextEditingController? controller;
  final EdgeInsets? contentPadding;
  final Country? selectedCountry;
  final Color? fillColor;
  final void Function(Country)? onCountrySelected;
  final void Function(String)? onPhoneNumberChanged;

  // final

  const CountryPickerWidget({
    super.key,
    required this.labelText,
    this.suffixIcon,
    this.hintText,
    this.contentPadding,
    this.controller,
    this.isReadOnly,
    this.selectedCountry,
    this.onCountrySelected,
    this.onPhoneNumberChanged,
    this.fillColor,
    this.isRequired,
  });

  @override
  _CountryPickerWidgetState createState() => _CountryPickerWidgetState();
}

class _CountryPickerWidgetState extends State<CountryPickerWidget> {
  // final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(() {
      if (widget.onPhoneNumberChanged != null) {
        widget.onPhoneNumberChanged!(widget.controller?.text ?? "");
      }
    });
  }

  @override
  void dispose() {
    widget.controller?.removeListener(() {});
    super.dispose();
  }

  // String? _validatePhoneNumber(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return 'Please enter a phone number';
  //   }

  //   // Remove all non-digit characters
  //   final digitsOnly = value.replaceAll(RegExp(r'[^0-9]'), '');

  //   if (digitsOnly.length < 6) {
  //     return 'Phone number must contain at least 6 digits';
  //   }

  //   return null; // Return null if valid
  // }

  @override
  Widget build(BuildContext context) {
    return AppCustomField(
      suffixIcon: widget.suffixIcon,
      contentPadding: widget.contentPadding ?? EdgeInsets.symmetric(vertical: 0.h, horizontal: 12.w),
      filled: true,
      fillColor: widget.fillColor ?? AppColors.transparent,
      focusedBorder: 30.sp,
      isReadOnly: widget.isReadOnly,
      enabledBorder: 30.sp,
      validator: (validator) {
        if (validator == null || validator.isEmpty || validator.length <= 6) {
          return context.l10n!.enter_phone_number_here;
        }
        return null;
      },
      labelTitle: widget.labelText,
      isRequired: widget.isRequired ?? false,
      keyboardType: TextInputType.phone,
      controller: widget.controller,
      textColor: Colors.black,
      hintText: widget.hintText ?? context.l10n!.enter_phone_number_here,
      hintTextFontSize: 14,
      prefixIcon: Padding(
        padding: EdgeInsets.zero,
        child: GestureDetector(
          onTap: () {
            showCountryPicker(
              context: context,
              countryListTheme: CountryListThemeData(
                flagSize: 25,
                backgroundColor: widget.fillColor ?? Colors.white,
                textStyle: const TextStyle(fontSize: 16, color: Colors.blueGrey),
                bottomSheetHeight: 500,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
                inputDecoration: InputDecoration(
                  labelText: context.l10n!.search,
                  hintText: context.l10n!.start_typing_to_search,
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(borderSide: BorderSide(color: const Color(0xFF8C98A8).withOpacity(0.2))),
                ),
              ),
              onSelect: (Country country) {
                if (widget.onCountrySelected != null) {
                  widget.onCountrySelected!(country);
                }
                // widget.controller?.clear(); // Clear the text field for phone number entry
              },
            );
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.selectedCountry != null)
                Text(widget.selectedCountry!.flagEmoji, style: const TextStyle(fontSize: 16))
              else
                const SizedBox(width: 24),
              if (widget.selectedCountry != null)
                Text("  + ${widget.selectedCountry!.phoneCode}", style: AppTextStyles.customText14(color: Colors.black))
              else
                const SizedBox(width: 14),
              Icon(Icons.arrow_drop_down_rounded, size: 20, color: AppColors.black),
              SizedBox(
                height: 50.h,
                child: VerticalDivider(color: Colors.black.withOpacity(0.1)).paddingVertical(12.h),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
