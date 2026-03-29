import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlad_ai/app/config/padding_extensions.dart';
import 'package:vlad_ai/l10n/l10n.dart';

import '../../../config/app_assets.dart';
import '../../../customWidgets/custom_app_bar.dart';
import '../../../customWidgets/help_center_expandable_tile.dart';
import '../../../utils/localization_helper.dart';

// FAQ Categories
class FaqCategory {
  static const String aboutVladai = "help_about";

  static const String support = "help_support";
  static const String accountInfo = "help_accountInfo";
  static const String tech = "help_tech";
  static const String privacySecurity = "help_privacySecurity";

}

// Example Controller
class FaqController extends GetxController {
  // Using RxList so Obx can rebuild UI
  var faqList = <Map<String, String>>[].obs;
  var filteredFaqList = <Map<String, String>>[].obs;
  var selectedCategory = ''.obs;

  @override
  void onInit() {
    super.onInit();
    faqList.value = [
      // 1. About VladAI
      {
        "category": FaqCategory.aboutVladai,
        "question": "What is VladAI?",
        "answer": "VladAI is a smart travel app that helps you discover attractions, restaurants, and places of interest and generate personalized travel itineraries based on your preferences."
      },
      {
        "category": FaqCategory.aboutVladai,
        "question": "Is VladAI a travel agency?",
        "answer": "No. VladAI is not a travel agency and does not sell tourist services (tickets, accommodation, packages). The app provides information and suggested itineraries to help you plan your trips more easily."
      },
      {
        "category": FaqCategory.aboutVladai,
        "question": "Who operates the app?",
        "answer": "The VladAI app is operated by Tech-Hub Horizon SRL, a company registered in Romania."
      },

      // 2. Account and Info
      {
        "category": FaqCategory.accountInfo,
        "question": "Do I need to create an account?",
        "answer": "Yes. Creating an account is necessary for:\n• generating personalized itineraries;\n• saving itineraries;\n• accessing the full functionality of the app."
      },
      {
        "category": FaqCategory.accountInfo,
        "question": "What happens to my data?",
        "answer": "Your data is processed in accordance with VladAI's Privacy Policy for legitimate purposes such as:\n• personalizing itineraries;\n• improving services."
      },
      {
        "category": FaqCategory.accountInfo,
        "question": "Does VladAI sell my data?",
        "answer": "No. We do not sell or rent your data to third parties."
      },
      {
        "category": FaqCategory.accountInfo,
        "question": "Can I use the app without an account?",
        "answer": "No. Without an account, the main features of the app cannot be provided."
      },

      // 3. Itineraries and Chatbot
      {
        "category": FaqCategory.tech,
        "question": "How are itineraries generated?",
        "answer": "Itineraries are generated automatically, based on:\n• the information you enter;\n• data available in the app.\nThe process is carried out using automated systems."
      },
      {
        "category": FaqCategory.tech,
        "question": "Are itineraries guaranteed?",
        "answer": "No. Itineraries are for guidance only. The schedule of attractions, availability of locations, access conditions, and prices may vary and must be verified by the user before use."
      },
      {
        "category": FaqCategory.tech,
        "question": "Am I talking to a real person when using the chatbot?",
        "answer": "No. When you use VladAI, you are interacting with an automated system based on artificial intelligence, not a human operator."
      },
      {
        "category": FaqCategory.tech,
        "question": "Are my messages analyzed?",
        "answer": "No. Your messages are not being saved or analyzed."
      },
      {
        "category": FaqCategory.tech,
        "question": "Can I enter sensitive data?",
        "answer": "It is particularly inadvisable to provide sensitive data."
      },

      // 4. Third-party services & Technical issues
      {
        "category": FaqCategory.privacySecurity,
        "question": "What external services does VladAI use?",
        "answer": "VladAI uses:\n• Mapbox – for displaying maps and locations;\n• Google Analytics – for statistical analysis and application improvement."
      },
      {
        "category": FaqCategory.privacySecurity,
        "question": "Does VladAI control these services?",
        "answer": "No. Third-party services operate according to their own privacy policies and terms."
      },
      {
        "category": FaqCategory.privacySecurity,
        "question": "The application is not working properly. What can I do?",
        "answer": "Try the following:\n• check your internet connection;\n• update the application to the latest version;\n• restart the application or device.\nIf the problem persists, contact us at vladairomania@gmail.com."
      },

      // 5. Contact Us
      {
        "category": FaqCategory.support,
        "question": "How can I contact the VladAI team?",
        "answer": "You can contact us at any time at:\n📧 vladairomania@gmail.com"
      }
    ];
  }

  void filterByCategory(String category) {
    selectedCategory.value = category;
    if (category.isEmpty) {
      filteredFaqList.value = faqList;
    } else {
      filteredFaqList.value = faqList.where((faq) => faq["category"] == category).toList();
    }
  }
}

class FaqView extends StatefulWidget {
  const FaqView({super.key});

  @override
  State<FaqView> createState() => _FaqViewState();
}

class _FaqViewState extends State<FaqView> {
  final FaqController controller = Get.put(FaqController());

  @override
  void initState() {
    super.initState();
    // Get the category from arguments if provided
    final String? category = Get.arguments as String?;
    if (category != null && category.isNotEmpty) {
      controller.filterByCategory(category);
    } else {
      controller.filterByCategory('');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        toolBarHeight: 70.h,
        title: controller.selectedCategory.value.isNotEmpty
            ? LocalizationHelper.get(context, controller.selectedCategory.value)
            : context.l10n!.faq,
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
        ),
      ),
      body: Container(
        height: ScreenUtil().screenHeight,
        width: ScreenUtil().screenWidth,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(AppAssets.scaffoldBg), fit: BoxFit.cover),
        ),
        child: SafeArea(
          child: Obx(() {
            final faqs = controller.filteredFaqList.isNotEmpty
                ? controller.filteredFaqList
                : controller.faqList;

            if (faqs.isEmpty) {
              return Center(
                child: Text(
                  context.l10n!.no_faqs_available_for_this_category,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16.sp,
                  ),
                ),
              );
            }

            return ListView.builder(
              itemCount: faqs.length,
              itemBuilder: (context, index) {
                final faq = faqs[index];
                return HelpCenterExpandableWidget(
                  onTap: (val) {},
                  answer: faq["answer"] ?? "",
                  question: faq["question"] ?? "",
                  index: index,
                );
              },
            );
          }).paddingHorizontal(20.sp).paddingTop(20.h),
        ),
      ),
    );
  }
}
