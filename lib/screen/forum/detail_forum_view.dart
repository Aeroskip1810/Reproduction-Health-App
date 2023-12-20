import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reprohealth_app/constant/assets_constants.dart';
import 'package:reprohealth_app/constant/routes_navigation.dart';
import 'package:reprohealth_app/models/forum_models/forum_models.dart';
import 'package:reprohealth_app/screen/forum/view_model/forum_view_model.dart';
import 'package:reprohealth_app/screen/profile/widget/profile_widget/snackbar_widget.dart';
import 'package:reprohealth_app/services/forum_services/forum_services.dart';
import 'package:reprohealth_app/theme/theme.dart';

class DetailForumView extends StatelessWidget {
  const DetailForumView({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as ResponseDataForum?;
    final ResponseDataForum? detailForum = args;

    String? patientId;

    if (Provider.of<ForumViewModel>(context)
            .profileList
            ?.response
            ?.isNotEmpty ==
        true) {
      patientId =
          Provider.of<ForumViewModel>(context).profileList?.response?.first.id;
    }

    Future<void> showMyDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
              child: Text(
                'Yakin ingin menghapus forum?',
                style: semiBold14Black,
                textAlign: TextAlign.center,
              ),
            ),
            content: Text(
              'Forum akan dihapus secara permanen. Semua jawaban dari dokter akan hilang dan tidak dapat dikembalikan lagi.',
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
                  child: Text('Ya, Hapus', style: semiBold12Grey10),
                  onPressed: () {
                    ForumServices().deleteForum(
                      forumId: detailForum?.id ?? '',
                      title: detailForum?.title ?? '',
                      content: detailForum?.content ?? '',
                      anonymous: detailForum?.anonymous ?? false,
                      context: context,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(
                      contentText: 'Forum berhasil dihapus',
                      backgroundColor: positive,
                    ));

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
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: grey10,
        iconTheme: IconThemeData(
          color: grey700,
        ),
        elevation: 0,
        title: Text(
          'Kembali ke Forum',
          style: semiBold16Grey700,
        ),
        actions: [
          Provider.of<ForumViewModel>(context)
                      .profileList
                      ?.response
                      ?.isNotEmpty ==
                  true
              ? Visibility(
                  visible: detailForum?.patientId == patientId,
                  child: IconButton(
                    onPressed: showMyDialog,
                    icon: Image.asset(Assets.assetsTrashCan),
                  ),
                )
              : const SizedBox(),
        ],
      ),
      body: Provider.of<ForumViewModel>(context)
                  .profileList
                  ?.response
                  ?.isNotEmpty ==
              true
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView(
                children: [
                  const SizedBox(height: 24),
                  Text(
                    detailForum?.title ?? '',
                    style: semiBold16Grey900,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    detailForum?.content ?? '',
                    style: regular12Grey900,
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          width: 40,
                          imageUrl: detailForum?.patientProfile ?? '',
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Center(
                            child: Image.network(
                              'https://buffer.com/cdn-cgi/image/w=1000,fit=contain,q=90,f=auto/library/content/images/size/w1200/2023/10/free-images.jpg',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        "Ditanyakan oleh ",
                        style: regular12Grey900,
                      ),
                      Text(
                        "Pasien",
                        style: semiBold12Grey900,
                      ),
                    ],
                  ),
                  const SizedBox(height: 48),
                  detailForum?.forumReplies?.isNotEmpty == true
                      ? Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 13,
                                horizontal: 8,
                              ),
                              width: double.infinity,
                              color: green100,
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      width: 40,
                                      imageUrl: detailForum?.forumReplies?.first
                                              .doctor?.profileImage ??
                                          '',
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          Center(
                                        child: Image.network(
                                          'https://buffer.com/cdn-cgi/image/w=1000,fit=contain,q=90,f=auto/library/content/images/size/w1200/2023/10/free-images.jpg',
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    "Dijawab oleh ",
                                    style: regular12Grey900,
                                  ),
                                  Text(
                                    detailForum?.forumReplies?.first.doctor
                                            ?.name ??
                                        '',
                                    style: medium12Green700,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 8,
                              ),
                              color: green50,
                              width: double.infinity,
                              child: Text(
                                detailForum?.forumReplies?.first.content ?? '',
                                style: regular12Grey900,
                              ),
                            ),
                          ],
                        )
                      : const SizedBox()
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  "Buat pasien pada menu profile terlebih dahulu untuk dapat melihat percakapan antara dokter dan pasien!!",
                  style: semiBold16Grey900,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
    );
  }
}
