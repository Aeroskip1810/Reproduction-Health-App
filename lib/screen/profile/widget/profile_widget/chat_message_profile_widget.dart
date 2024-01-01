import 'package:flutter/material.dart';
import 'package:reprohealth_app/models/chatbot_models/chat_bot_models.dart';
import 'package:reprohealth_app/theme/theme.dart';

class ChatMessageProfileWidget extends StatelessWidget {
  final String text;
  final ChatBot chatBot;
  const ChatMessageProfileWidget(
      {super.key, required this.text, required this.chatBot});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: chatBot == ChatBot.bot
          ? const EdgeInsets.only(left: 48, right: 16)
          : const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: chatBot == ChatBot.bot
                  ? const BorderRadius.all(Radius.circular(8))
                  : const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                    ),
              color: chatBot == ChatBot.bot ? grey50 : green500,
            ),
            child: Text(
              text,
              style: chatBot == ChatBot.bot
                  ? semiBold12Grey500
                  : semiBold12Primary,
            ),
          ),
        ],
      ),
    );
  }
}
