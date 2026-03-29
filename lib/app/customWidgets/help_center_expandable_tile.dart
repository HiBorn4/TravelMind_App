import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vlad_ai/app/config/padding_extensions.dart';
import '../config/app_colors.dart';
import '../config/app_text_style.dart';

class HelpCenterExpandableWidget extends StatefulWidget {
  final String answer;
  final String question;
  final int index;
  final void Function(bool)? onTap;

  const HelpCenterExpandableWidget({
    super.key,
    required this.onTap,
    required this.answer,
    required this.question,
    required this.index,
  });

  @override
  State<HelpCenterExpandableWidget> createState() => _HelpCenterExpandableWidgetState();
}

class _HelpCenterExpandableWidgetState extends State<HelpCenterExpandableWidget> with TickerProviderStateMixin {
  bool isExpanded = false;
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(useMaterial3: false),
      child: Container(
        decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(18.sp)),
        child: ExpansionTile(
          collapsedShape: const StadiumBorder(),
          enableFeedback: false,
          collapsedBackgroundColor: Colors.transparent,
          trailing: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            decoration: BoxDecoration(
              color: !isExpanded ? AppColors.white : AppColors.textLightBlack.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_outlined,
              color: AppColors.black,
            ).paddingFromAll(4),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: Text(
            widget.question,
            style: AppTextStyles.customText16(color: AppColors.textLightBlack, fontWeight: FontWeight.w500),
          ),
          onExpansionChanged: (val) {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.answer,
                textAlign: TextAlign.start,
                style: AppTextStyles.customText14(fontWeight: FontWeight.w600, color: AppColors.black, height: 1.3),
              ).paddingHorizontal(15).paddingBottom(16),
            ).paddingRight(20.w),
          ],
        ),
      ).paddingBottom(10.sp),
    );
  }
}
