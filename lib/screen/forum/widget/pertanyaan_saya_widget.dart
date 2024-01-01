import 'package:avatar_stack/avatar_stack.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reprohealth_app/constant/assets_constants.dart';
import 'package:reprohealth_app/constant/routes_navigation.dart';
import 'package:reprohealth_app/screen/forum/view_model/forum_view_model.dart';
import 'package:reprohealth_app/theme/theme.dart';

class PertanyaanSayaWidget extends StatefulWidget {
  const PertanyaanSayaWidget({Key? key}) : super(key: key);

  @override
  State<PertanyaanSayaWidget> createState() => _PertanyaanSayaWidgetState();
}

class _PertanyaanSayaWidgetState extends State<PertanyaanSayaWidget> {
  @override
  void initState() {
    Provider.of<ForumViewModel>(context, listen: false)
        .getProfile(context: context);
    Provider.of<ForumViewModel>(context, listen: false).getMyForumList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ForumViewModel>(
      builder: (context, forumViewModel, child) {
        final myForumList = forumViewModel.myForumList;
        final searchResults = forumViewModel.searchResults;
        final displayedList = searchResults ?? myForumList?.response;

        // Urutan daftar berdasarkan kategori yang berbeda
        myForumList?.response?.sort((a, b) {
          // Terbaru
          if (forumViewModel.kategoriListMap.contains('Terbaru')) {
            return b.date!.compareTo(a.date!);
          }

          // Terlama
          else if (forumViewModel.kategoriListMap.contains('Terlama')) {
            return a.date!.compareTo(b.date!);
          }

          // Populer
          else if (forumViewModel.kategoriListMap.contains('Populer')) {
            return b.view!.compareTo(a.view!);
          }

          // filter berdasarkan tanggal
          return b.date!.compareTo(a.date!);
        });

        return myForumList?.response!.isNotEmpty == true
            ? ListView.builder(
                itemCount: displayedList?.length,
                itemBuilder: (context, index) {
                  final myForum = displayedList?[index];
                  return SizedBox(
                    width: 360.0,
                    height: 220.0,
                    child: GestureDetector(
                      onTap: () {},
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Row(
                                  children: [
                                    Text(
                                      myForum?.status == true
                                          ? "Terjawab"
                                          : "Belum Terjawab",
                                      style: myForum?.status == true
                                          ? regular10Green500
                                          : regular10Red,
                                    ),
                                    const SizedBox(width: 8),
                                    Image.asset(
                                      Assets.assetsEllips,
                                      width: 2,
                                      height: 2,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      myForum?.date != null
                                          ? "Diunggah ${forumViewModel.calculateDaysAgo(myForum!.date!)} yang lalu"
                                          : '',
                                      style: regular10Grey200,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  myForum?.title ?? '',
                                  style: medium14Grey900,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  myForum?.content ?? '',
                                  textAlign: TextAlign.justify,
                                  style: regular10Grey400,
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Spacer(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  myForum != null &&
                                          myForum.forumReplies != null &&
                                          myForum.forumReplies?.isNotEmpty == true
                                      ? AvatarStack(
                                          height: 32,
                                          width: 53.82,
                                          avatars: [
                                            NetworkImage(
                                              myForum.forumReplies?.first.doctor
                                                      ?.profileImage ??
                                                  '',
                                            ),
                                            myForum?.anonymous == true ? const NetworkImage("https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png") : NetworkImage(
                                              myForum.patientProfile ?? '',
                                            ),
                                          ],
                                        )
                                      : AvatarStack(
                                          height: 32,
                                          width: 53.82,
                                          avatars: [
                                            myForum?.anonymous == true ? const NetworkImage("https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png") : NetworkImage(
                                              myForum?.patientProfile ?? '',
                                            ),
                                          ],
                                        ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        RoutesNavigation.detailForumView,
                                        arguments: myForum,
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          'Lihat Pertanyaan',
                                          style: regular12Grey400,
                                        ),
                                        const SizedBox(width: 8),
                                        Image.asset(
                                          Assets.assetsNextIcon,
                                          width: 6.59,
                                          height: 11.17,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
            : Center(
                child: Text(
                  'Tidak terdapat pertanyaan',
                  style: medium14Grey900,
                ),
              );
      },
    );
  }
}
