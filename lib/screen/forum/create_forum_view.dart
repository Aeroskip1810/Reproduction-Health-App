import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reprohealth_app/component/button_component.dart';
import 'package:reprohealth_app/constant/routes_navigation.dart';
import 'package:reprohealth_app/screen/forum/view_model/create_forum_view_model.dart';
import 'package:reprohealth_app/screen/forum/view_model/forum_view_model.dart';
import 'package:reprohealth_app/screen/forum/widget/text_form_widget.dart';
import 'package:reprohealth_app/theme/theme.dart';

class CreateForumView extends StatefulWidget {
  const CreateForumView({super.key});

  @override
  State<CreateForumView> createState() => _CreateForumViewState();
}

class _CreateForumViewState extends State<CreateForumView> {
  @override
  void initState() {
    Provider.of<ForumViewModel>(context, listen: false)
        .getProfile(context: context);
    Provider.of<CreateForumViewModel>(context, listen: false).initController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: grey10,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            showDialog<void>(
              context: context,
              barrierDismissible: false, // user must tap button!
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Center(
                    child: Text(
                      'Yakin ingin membatalkan forum?',
                      style: semiBold14Black,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  content: Text(
                    'Jika Anda meninggalkan halaman ini, keluhan yang sedang Anda buat akan hilang dan tidak dapat dikembalikan lagi.',
                    style: regular12Grey300,
                    textAlign: TextAlign.center,
                  ),
                  actionsAlignment: MainAxisAlignment.center,
                  actions: <Widget>[
                    SizedBox(
                      height: 36,
                      width: 110,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: negative,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text('Ya, Batal', style: semiBold12Grey10),
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            RoutesNavigation.homeView,
                            (route) => false,
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 36,
                      width: 110,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: green500,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text('Tidak', style: semiBold12Grey10),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          },
          icon: Icon(
            Icons.arrow_back,
            color: grey700,
          ),
        ),
        title: Text(
          'Kembali ke Forum',
          style: semiBold16Grey700,
        ),
      ),
      body: Provider.of<ForumViewModel>(context, listen: false)
                  .profileList
                  ?.response
                  ?.isNotEmpty ==
              true
          ? Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SingleChildScrollView(
                  child: Consumer<CreateForumViewModel>(
                    builder: (context, createForumViewModel, child) {
                      return Column(
                        children: [
                          const SizedBox(height: 24),
                          TextFormWidget(
                            controller: createForumViewModel.titleController,
                            hintText: "Masukkan Judul",
                            hinstStyle: regular14Grey400,
                            maxLength: 30,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Maximum 30 Karakter';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 18),
                          TextFormWidget(
                            controller: createForumViewModel.messageController,
                            hintText:
                                """Apa yang ingin kamu tanyakan atau ceritakan tentang kesehatan reproduksimu?
                                
            Tulis pertanyaanmu di sini""",
                            hinstStyle: regular14Grey400,
                            textInputType: TextInputType.multiline,
                            maxLength: 255,
                            maxLines: 18,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Tidak boleh kosong';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  createForumViewModel.toggleRememberMe();
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(
                                    left: 4,
                                    right: 12,
                                  ),
                                  height: 24,
                                  width: 24,
                                  decoration: BoxDecoration(
                                    color: createForumViewModel.rememberMe
                                        ? green500
                                        : null,
                                    borderRadius: BorderRadius.circular(6),
                                    border: !createForumViewModel.rememberMe
                                        ? Border.all(
                                            width: 2,
                                            color: grey900,
                                          )
                                        : null,
                                  ),
                                  child: createForumViewModel.rememberMe
                                      ? Center(
                                          child: Icon(
                                            Icons.check,
                                            color: grey10,
                                          ),
                                        )
                                      : null,
                                ),
                              ),
                              Text(
                                'Kirim sebagai anonim',
                                style: medium12Grey400,
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Consumer<CreateForumViewModel>(
                            builder: (context, createForumViewModel, child) {
                              return ButtonComponent(
                                labelText:
                                    createForumViewModel.isLoading == true
                                        ? const Center(
                                            child: CircularProgressIndicator(),
                                          )
                                        : Text(
                                            "Kirim",
                                            style: semiBold12Grey10,
                                            textAlign: TextAlign.center,
                                          ),
                                backgroundColor:
                                    createForumViewModel.buttonColor,
                                onPressed: () {
                                  if (formKey.currentState?.validate() ??
                                      false) {
                                    createForumViewModel.createForum(
                                      patientId: Provider.of<ForumViewModel>(
                                                  context,
                                                  listen: false)
                                              .profileList
                                              ?.response
                                              ?.first
                                              .id ??
                                          '',
                                      context: context,
                                    );
                                  }
                                },
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  "Harap mendaftarkan pasien terlebih dahulu pada menu profile untuk dapat membuat forum diskusi!!",
                  style: semiBold16Grey900,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
    );
  }
}
