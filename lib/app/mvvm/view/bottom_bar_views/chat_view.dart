import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:vlad_ai/app/config/app_assets.dart';
import 'package:vlad_ai/app/config/app_routes.dart';
import 'package:vlad_ai/app/config/padding_extensions.dart';
import 'package:vlad_ai/app/config/utils.dart';
import 'package:vlad_ai/app/customWidgets/bottom_sheets/rating_sheet.dart';
import 'package:vlad_ai/app/customWidgets/sizedbox_extension.dart';
import 'package:vlad_ai/app/mvvm/model/api_response/login_resp_model.dart';
import 'package:vlad_ai/app/mvvm/view_model/bottom_bar_controller.dart';
import 'package:vlad_ai/app/mvvm/view_model/chat_controller.dart';
import 'package:vlad_ai/app/services/shared_preferences_service.dart';
import 'package:vlad_ai/l10n/l10n.dart';


import '../../../../l10n/generated/app_localizations.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_text_style.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final BottomBarController navController = Get.find();
  final ChatController chatController = Get.find();

  @override
  void initState() {
    super.initState();
    getAppUser();
    // Add dummy response for testing
    // chatController.messages.add(
    //     MessageModel(message: "This is a dummy response from the AI.", isUser: false));
  }

  getAppUser() async {
    appUser = await SharedPreferencesService().readUserData();
    setState(() {});
  }

  AppUser? appUser;

  @override
  Widget build(BuildContext context) {
    final amenities = [
      {"title": context.l10n!.create_a_new_itinerary},
      {"title": context.l10n!.explore_nearby},
      {"title": context.l10n!.leave_us_a_review_emoji},
    ];

    return Scaffold(
      body: Container(
        height: ScreenUtil().screenHeight,
        width: ScreenUtil().screenWidth,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssets.scaffoldBg),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Obx(
            () => Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Logo
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (chatController.isKeyBoardOpen.value)
                      Visibility(
                        visible: false,
                        child: GestureDetector(
                          onTap: () => chatController.clearChat(),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(38.sp),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(0xFF717171).withOpacity(0.1),
                                  Colors.black.withOpacity(0.1),
                                ],
                              ),
                            ),
                            child: Text(
                              'Clear Chat',
                              style: AppTextStyles.customText14(
                                color: AppColors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ).paddingFromAll(10.sp),
                          ),
                        ),
                      ),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.transparent,
                        borderRadius: BorderRadius.circular(38.sp),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          AppAssets.pushNotificationIcon,
                          color: Colors.transparent,
                        ),
                      ).paddingFromAll(10.sp),
                    ),
                    chatController.isKeyBoardOpen.value
                        ? SizedBox.shrink()
                        : Lottie.asset(AppAssets.dancingLottie, height: 70.h),

                    GestureDetector(
                      onTap: () {
                        Get.toNamed(AppRoutes.notificationsView);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(38.sp),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFF717171).withOpacity(0.1), // gray
                              Colors.black.withOpacity(
                                0.1,
                              ), // black with 20% opacity
                            ],
                          ),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            AppAssets.pushNotificationIcon,
                          ),
                        ).paddingFromAll(10.sp),
                      ),
                    ),
                  ],
                ).paddingHorizontal(15.w).paddingTop(10.h),
                if (chatController.isKeyBoardOpen.value) SizedBox(height: 10.h),
                chatController.isKeyBoardOpen.value
                    ? Expanded(
                        child: ListView(
                          reverse: true,
                          shrinkWrap: true,
                          controller: chatController.scrollController,
                          children: chatController.messages
                              .map(
                                (msg) => Container(
                                  alignment: msg.isUser
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  child: Column(
                                    crossAxisAlignment: msg.isUser
                                        ? CrossAxisAlignment.end
                                        : CrossAxisAlignment.start,
                                    children: [
                                      msg.isUser
                                          ? ConstrainedBox(
                                              constraints: BoxConstraints(
                                                maxWidth: MediaQuery.of(context).size.width * 0.8,
                                              ),
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                  top: 10,
                                                  right: 20,
                                                  left: 20,
                                                ),
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 8,
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(22),
                                                  color: AppColors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black.withOpacity(0.2),
                                                      blurRadius: 3,
                                                      offset: Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 3),
                                                  child: Text(
                                                    msg.message,
                                                    textAlign: TextAlign.left,
                                                    style: AppTextStyles.customText16(
                                                      color: AppColors.black,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          : ConstrainedBox(
                                              constraints: BoxConstraints(
                                                maxWidth: MediaQuery.of(context).size.width * 0.8,
                                              ),
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                  top: 10,
                                                  right: 20,
                                                  left: 20,
                                                ),
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 8,
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(22),
                                                  color: Colors.transparent,
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 3),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Flexible(
                                                        child: Text(
                                                          msg.message.isEmpty ? " " : msg.message,
                                                          textAlign: TextAlign.left,
                                                          style: AppTextStyles.customText16(
                                                            color: AppColors.black,
                                                            fontWeight: FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                      // Show streaming cursor when message is being streamed
                                                      if (msg.isStreaming)
                                                        Padding(
                                                          padding: const EdgeInsets.only(left: 2),
                                                          child: _StreamingCursor(),
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                      const SizedBox(height: 5),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(AppAssets.worldIcon, height: 100.h),
                          Text(
                            AppLocalizations.of(context)!.chat_title(appUser?.firstName ?? ""),
                            style: AppTextStyles.customText24(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            context.l10n!.plan_explore_and_navigate,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.customText16(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ).paddingHorizontal(25.w),
                          20.h.height,
                          Align(
                            alignment: Alignment.center,
                            child: Wrap(
                              spacing: 5.w,
                              runSpacing: 5.h,
                              alignment: WrapAlignment.center,
                              children: List.generate(amenities.length, (i) {
                                final item = amenities[i];
                                return GestureDetector(
                                  onTap: () {
                                    if (i == 1) {
                                      navController.selectedIndex.value = 1;
                                    } else if (i == 2) {
                                      Utils.showBottomSheet(
                                        context: context,
                                        child: RatingSheet(iteneryId: ''),
                                      );
                                    } else {
                                      Get.toNamed(AppRoutes.planTripView);
                                    }
                                  },
                                  child: _buildAmenityTile(item["title"]!),
                                );
                              }),
                            ),
                          ).paddingHorizontal(15.w),
                        ],
                      ),
                Container(
                  // height: 40.h,
                  // width: 360.w,
                  margin: EdgeInsets.only(
                    bottom: chatController.isKeyBoardOpen.value
                        ? MediaQuery.of(context).viewInsets.bottom
                        : 20.h,
                    top: 10.h,
                    left: 15.w,
                    right: 15.w,
                  ),

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.sp),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.09),
                        blurRadius: 5,
                        offset: Offset(5, 4),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    textInputAction: TextInputAction.newline,
                    maxLines: 3,
                    minLines: 1,
                    controller: chatController.messageController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      // prefixIcon: Image.asset(AppAssets.loveLogo, height: 15.h).paddingFromAll(8.sp),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          print(true);
                          chatController.initalMessage();
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [SvgPicture.asset(AppAssets.sendIcon)],
                        ).paddingRight(10.w),
                      ),

                      contentPadding: EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 10,
                      ),
                      hintText: context.l10n!.ask_anything,
                      hintStyle: AppTextStyles.customText14(
                        color: AppColors.textLightBlack,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.sp),

                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.sp),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.sp),
                        borderSide: BorderSide(color: AppColors.transparent),
                      ),
                    ),
                  ).paddingHorizontal(0.w).paddingBottom(0.h),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAmenityTile(String title) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 13.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(50.sp),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.09),
            blurRadius: 5,
            offset: Offset(5, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: AppTextStyles.customText14(
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }
}

// Animated cursor widget for streaming effect
class _StreamingCursor extends StatefulWidget {
  @override
  State<_StreamingCursor> createState() => _StreamingCursorState();
}

class _StreamingCursorState extends State<_StreamingCursor>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Container(
        width: 2,
        height: 16,
        decoration: BoxDecoration(
          color: AppColors.black,
          borderRadius: BorderRadius.circular(1),
        ),
      ),
    );
  }
}