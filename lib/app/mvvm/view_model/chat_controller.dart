import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
// import 'package:vlad_ai/app/services/shared_preferences_service.dart';

class ChatController extends GetxController {
  RxBool isKeyBoardOpen = false.obs;
  ScrollController scrollController = ScrollController();
  List<MessageModel> messages = <MessageModel>[].obs;
  TextEditingController messageController = TextEditingController();
  
  // For streaming effect
  Timer? _streamTimer;
  RxBool isStreaming = false.obs;
  
  // Store full query with context for API (separate from display)
  String? fullContextQuery;

  @override
  void onClose() {
    _streamTimer?.cancel();
    super.onClose();
  }

  initalMessage() async {
    isKeyBoardOpen.value = true;

    // Use fullContextQuery if available (from hotel detail), otherwise use text field
    final userMessage = (fullContextQuery ?? messageController.text).trim();
    
    // Get the display message (only user query without context)
    final displayMessage = messageController.text.trim();
    
    if (userMessage.isEmpty) return;

    // Show only the user's query in UI (not the context)
    messages.insert(
      0,
      MessageModel(message: displayMessage.isEmpty ? userMessage : displayMessage, isUser: true),
    );

    if (scrollController.hasClients) {
      scrollController.animateTo(
        0.0,
        duration: Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
      );
    }

    messageController.clear();
    fullContextQuery = null; // Clear after using

    try {
      const endPoint = 'http://69.62.126.195:9000/api/query';

      // Add empty AI message that will be streamed
      final aiMessageIndex = 0;
      messages.insert(
        0,
        MessageModel(
          message: "",
          isUser: false,
          isStreaming: true,
        ),
      );

      if (scrollController.hasClients) {
        scrollController.animateTo(
          0.0,
          duration: Duration(milliseconds: 300),
          curve: Curves.fastOutSlowIn,
        );
      }

      isStreaming.value = true;

      final response = await http.post(
        Uri.parse(endPoint),
        headers: {
          "Content-Type": "application/json",
          "accept": "application/json",
        },
        body: jsonEncode({
          "query": userMessage, // Send full query with context to API
          "user_id": "default_user",
          "trip_id": 0,
          "top_k": 5,
          "max_tokens": 0,
        }),
      );

      if (kDebugMode) {
        print("STATUS: ${response.statusCode}");
        print("BODY: ${response.body}");
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final fullResponse = data['answer'] ?? "No response";

        // Start streaming the response token by token
        await _streamResponse(fullResponse, aiMessageIndex);
      } else {
        developer.log("❌ API Error: ${response.statusCode}");
        messages[aiMessageIndex] = MessageModel(
          message: "Sorry, something went wrong. Please try again.",
          isUser: false,
          isStreaming: false,
        );
        isStreaming.value = false;
      }
    } catch (e) {
      developer.log('❌ API Exception: $e');
      if (messages.isNotEmpty && !messages[0].isUser) {
        messages[0] = MessageModel(
          message: "Sorry, something went wrong. Please try again.",
          isUser: false,
          isStreaming: false,
        );
      }
      isStreaming.value = false;
    }
  }

  Future<void> _streamResponse(String fullText, int messageIndex) async {
    if (fullText.isEmpty) {
      isStreaming.value = false;
      return;
    }

    // Split by words for more natural streaming
    final words = fullText.split(' ');
    String currentText = '';
    final random = Random();

    for (int i = 0; i < words.length; i++) {
      if (messageIndex >= messages.length) break;

      currentText += (i == 0 ? '' : ' ') + words[i];
      
      messages[messageIndex] = MessageModel(
        message: currentText,
        isUser: false,
        isStreaming: true,
      );

      // Scroll to bottom as text streams
      if (scrollController.hasClients) {
        scrollController.animateTo(
          0.0,
          duration: Duration(milliseconds: 100),
          curve: Curves.easeOut,
        );
      }

      // Variable delay between words (20-80ms for realistic streaming)
      // Longer words get slightly longer delays
      final wordLength = words[i].length;
      final baseDelay = 30 + random.nextInt(30); // 30-60ms base
      final lengthDelay = (wordLength / 10 * 20).toInt(); // Extra delay for longer words
      final totalDelay = baseDelay + lengthDelay;

      await Future.delayed(Duration(milliseconds: totalDelay));
    }

    // Mark streaming as complete
    if (messageIndex < messages.length) {
      messages[messageIndex] = MessageModel(
        message: currentText,
        isUser: false,
        isStreaming: false,
      );
    }
    
    isStreaming.value = false;
  }

  clearChat() {
    _streamTimer?.cancel();
    messages = <MessageModel>[].obs;
    isKeyBoardOpen.value = false;
    isStreaming.value = false;
    fullContextQuery = null;
  }
}

class MessageModel {
  String message;
  bool isUser;
  bool isStreaming;

  MessageModel({
    required this.message,
    required this.isUser,
    this.isStreaming = false,
  });

  MessageModel copyWith({String? message, bool? isUser, bool? isStreaming}) {
    return MessageModel(
      message: message ?? this.message,
      isUser: isUser ?? this.isUser,
      isStreaming: isStreaming ?? this.isStreaming,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'isUser': isUser,
      'isStreaming': isStreaming,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      message: map['message'] ?? '',
      isUser: map['isUser'] ?? false,
      isStreaming: map['isStreaming'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageModel.fromJson(String source) =>
      MessageModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'MessageModel(message: $message, isUser: $isUser, isStreaming: $isStreaming)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MessageModel &&
        other.message == message &&
        other.isUser == isUser &&
        other.isStreaming == isStreaming;
  }

  @override
  int get hashCode => message.hashCode ^ isUser.hashCode ^ isStreaming.hashCode;
}