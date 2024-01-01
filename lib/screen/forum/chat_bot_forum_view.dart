import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reprohealth_app/component/button_component.dart';
import 'package:reprohealth_app/constant/routes_navigation.dart';
import 'package:reprohealth_app/screen/forum/view_model/chatbot_view_model.dart';
import 'package:reprohealth_app/theme/theme.dart';

class ChatBotForumView extends StatelessWidget {
  const ChatBotForumView({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<ChatbotViewModel>(
      context,
      listen: false,
    ).getHistoryChatbot();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: grey10,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.5),
          child: Text(
            'Kembali Ke Forum',
            style: semiBold16Primary4,
          ),
        ),
        iconTheme: IconThemeData(
          color: primary4,
        ),
      ),
      body: Consumer<ChatbotViewModel>(
        builder: (context, history, child) {
          return RefreshIndicator(
            onRefresh: () {
              return history.onRefresh();
            },
            child: Column(
              children: [
                const SizedBox(
                  height: 24,
                ),
                Container(
                  height: 150,
                  width: 355,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.black,
                  ),
                  child: Image.asset(
                    'assets/chatbot_logo.png',
                    height: 105,
                    width: 264,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'Riwayat Chat',
                      style: semiBold16Grey900,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount:
                        history.chatbotHistoryViewModel?.response?.length,
                    itemBuilder: (context, index) {
                      var historyData =
                          history.chatbotHistoryViewModel?.response?[index];
                      return GestureDetector(
                        onTap: () {
                          history.updateIsChatTrue();
                          Navigator.pushNamed(
                            context,
                            RoutesNavigation.assistantChatForumView,
                            arguments: historyData?.data?.id,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: grey400,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            historyData?.data?.pesan?.first.pesan ?? '',
                            style: regular14Grey400,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ButtonComponent(
                    labelText: Text(
                      "Buat Pesan Baru",
                      style: semiBold12Green500,
                      textAlign: TextAlign.center,
                    ),
                    border: BorderSide(color: green500, width: 2),
                    backgroundColor: grey10,
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        RoutesNavigation.assistantChatForumView,
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
