import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:reprohealth_app/screen/profile/widget/profile_widget/button_widget.dart';
import 'package:reprohealth_app/theme/theme.dart';

class PusatBantuanWidget extends StatelessWidget {
  final String title;
  final String? text1;
  final String? text2;
  final String? text3;
  final String? text4;
  final String? text5;
  final String? text6;
  final double height;
  final bool isActive;
  final bool? isActive2;
  const PusatBantuanWidget({super.key, this.text1, this.text2, this.text3, this.text4, this.text5, required this.height, required this.isActive, this.text6, this.isActive2, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE9E9E9),
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: grey10,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: secondary,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        titleSpacing: 0,
        title: Text(title,
        style: semiBold16Primary4,
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 1),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
              width: double.infinity,
              height: height,
              decoration: const BoxDecoration(
                color: Color(0xFFFAFAFA),
                ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  Text(text1?? "",
                  style: medium14Black
                  ),
                  Text("${text2?? ""} \n",
                  style: regular12Black400
                  ),
                  Visibility(
                    visible: isActive,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${text3?? ""} \n",
                          style: regular12Black400
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: isActive2?? false,
                    child: Text(text4?? "",
                    style: regular12Black400
                    ),
                  ),
                ],
              ),
          ),
          const SizedBox(height: 1),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
              width: double.infinity,
              height: 176,
              decoration: const BoxDecoration(
                color: Color(0xFFFAFAFA),
                ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text("Ada pertanyaan lain?",
                  style: medium14Black
                  ),
                  const SizedBox(height: 16),
                  Text("Beri tahu kami apabila pertanyaanmu belum tersedia \natau jawaban yang kamu temukan tidak memuaskan.",
                  style: regular12Black400
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: ButtonWidget(
                      title: "Kirim Email",
                      onPressed: () async {
                        try {
                          final Email email = Email(
                            subject: 'Saya ingin bertanya sesuatu',
                            recipients: ['reprohealth@gmail.com'],
                          );
                          await FlutterEmailSender.send(email);
                        } catch (error) {
                          if (kDebugMode) {
                            print('Error sending email: $error');
                          }
                        }
                      },
                      color: green500
                      ),
                  )
                ],
              ),
          )
        ],
      )
    );
  }
}