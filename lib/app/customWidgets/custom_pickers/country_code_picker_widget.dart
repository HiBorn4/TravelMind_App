import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vlad_ai/app/config/padding_extensions.dart';
import 'package:vlad_ai/app/customWidgets/sizedbox_extension.dart';
import 'package:vlad_ai/l10n/l10n.dart';
import '../../config/app_colors.dart';
import '../../config/app_text_style.dart';
import '../app_custom_field.dart';

class CountryCodePickerWidget extends StatefulWidget {
  final Widget? suffixIcon;
  final String labelText;
  final String? hintText;
  final bool? isReadOnly;
  final TextEditingController? controller;
  final EdgeInsets? contentPadding;
  final Country? selectedCountry;
  final void Function(Country)? onCountrySelected;
  final void Function(String)? onPhoneNumberChanged;

  const CountryCodePickerWidget({
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
  });

  @override
  _CountryCodePickerWidgetState createState() => _CountryCodePickerWidgetState();
}

class _CountryCodePickerWidgetState extends State<CountryCodePickerWidget> {
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

  @override
  Widget build(BuildContext context) {
    return AppCustomField(
      suffixIcon: widget.suffixIcon,
      contentPadding: widget.contentPadding ?? EdgeInsets.only(left: 12.w, right: 12.w, top: 15.h),
      isReadOnly: widget.isReadOnly,
      validator: (validator) {
        if (validator == null || validator.isEmpty) {
          return context.l10n!.enter_phone_number_here;
        }
        return null;
      },
      labelTitle: widget.labelText,
      keyboardType: TextInputType.phone,
      controller: widget.controller,
      hintText: widget.hintText ?? context.l10n!.enter_phone_number_here,
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: GestureDetector(
          onTap: () {
            showCountryPicker(
              context: context,
              countryListTheme: CountryListThemeData(
                flagSize: 25.sp,
                textStyle: AppTextStyles.customText16(),
                bottomSheetHeight: 450,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
                inputDecoration: InputDecoration(
                  fillColor: AppColors.textLightBlack.withOpacity(0.8),
                  filled: true,
                  hintText: context.l10n!.search_country_here,
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.sp),
                    borderSide: BorderSide(color: AppColors.textLightBlack.withOpacity(0.8)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.sp),
                    borderSide: BorderSide(color: AppColors.textLightBlack.withOpacity(0.8)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.sp),
                    borderSide: BorderSide(color: AppColors.textLightBlack.withOpacity(0.8)),
                  ),
                ),
              ),
              onSelect: (Country country) {
                if (widget.onCountrySelected != null) {
                  widget.onCountrySelected!(country);
                }
              },
            );
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.selectedCountry != null) ...[
                Text(widget.selectedCountry!.flagEmoji, style: const TextStyle(fontSize: 24)),
                5.w.width,
                Text(widget.selectedCountry!.phoneCode, style: TextStyle(fontSize: 16.sp)),
              ] else
                const SizedBox(width: 24),
              Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: AppColors.textLightBlack),
              SizedBox(
                height: 50.h,
                child: VerticalDivider(color: Colors.black.withOpacity(0.1)).paddingVertical(6.h),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
