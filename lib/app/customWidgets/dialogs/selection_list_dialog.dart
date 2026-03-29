import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vlad_ai/app/config/app_text_style.dart';
import 'package:vlad_ai/app/config/padding_extensions.dart';

/// ✅ Generic Cupertino Selection List
/// Works with any object list (String, model, etc.)
class CupertinoSelectionList<T> extends StatefulWidget {
  /// Generic list of items (can be String, model, etc.)
  final List<T> items;

  /// Callback returns the selected item
  final ValueChanged<T> onSelected;

  /// Optional custom label extractor for display
  final String Function(T)? labelBuilder;

  /// Initial selection index
  final int initialIndex;

  const CupertinoSelectionList({
    super.key,
    required this.items,
    required this.onSelected,
    this.labelBuilder,
    this.initialIndex = 0,
  });

  @override
  State<CupertinoSelectionList<T>> createState() => _CupertinoSelectionListState<T>();
}

class _CupertinoSelectionListState<T> extends State<CupertinoSelectionList<T>> {
  late FixedExtentScrollController _controller;

  static const double _rowHeight = 40;

  @override
  void initState() {
    super.initState();
    _controller = FixedExtentScrollController(initialItem: widget.initialIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            child: SizedBox(
              height: 200,
              child: Stack(
                children: [
                  IgnorePointer(
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: _rowHeight,
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.sp)),
                      ),
                    ),
                  ),
                  CupertinoPicker(
                    scrollController: _controller,
                    itemExtent: _rowHeight,
                    magnification: 1.1,
                    squeeze: 1.2,
                    useMagnifier: true,
                    selectionOverlay: const SizedBox.shrink(),
                    onSelectedItemChanged: (index) {
                      widget.onSelected(widget.items[index]);
                    },
                    children: widget.items.map((item) {
                      final text = widget.labelBuilder != null ? widget.labelBuilder!(item) : item.toString();
                      return Center(
                        child: Text(
                          text,
                          style: AppTextStyles.customText18(color: Colors.black, fontWeight: FontWeight.w500),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ).paddingHorizontal(15.sp),
    );
  }
}
