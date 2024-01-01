import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:reprohealth_app/constant/assets_constants.dart';
import 'package:reprohealth_app/constant/routes_navigation.dart';
import 'package:reprohealth_app/models/article_models/article_models.dart';
import 'package:reprohealth_app/screen/article/widgets/article_card.dart';
import 'package:reprohealth_app/screen/article/widgets/bottom_sheet.dart';
import 'package:reprohealth_app/services/article_services/article_services.dart';
import 'package:reprohealth_app/theme/theme.dart';

class BookmarkView extends StatefulWidget {
  const BookmarkView({super.key});

  @override
  State<BookmarkView> createState() => _BookmarkViewState();
}

class _BookmarkViewState extends State<BookmarkView> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool isDeleting = false;
  List<bool> selectedItem = [];
  List<ArticleModels> bookmarkedItem = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: secondary),
        ),
        title: Text('Bookmark', style: semiBold16Black),
        actions: [
          Builder(
            builder: (context) => IconButton(
              onPressed: () {
                setState(() {
                  isDeleting = !isDeleting;
                  if (isDeleting) {
                    resetSelectedItems();
                    showBottomSheet(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(
                          builder:
                              (BuildContext context, StateSetter setState) {
                            return BottomSheetContent(
                              selectedItem: selectedItem,
                              setState: setState,
                              onDelete: () async {
                                try {
                                  await deleteSelectedBookmarks(selectedItem);
                                  setState(() {});
                                  if (context.mounted) {
                                    Navigator.pop(context);
                                  }
                                } on DioException catch (e) {
                                  throw Exception(e.response);
                                }
                              },
                            );
                          },
                        );
                      },
                    );
                  } else {
                    Navigator.of(context).pop();
                  }
                });
              },
              icon: Icon(Icons.delete, color: negative),
            ),
          )
        ],
        backgroundColor: grey10,
        elevation: 0,
      ),
      body: FutureBuilder<List<ArticleModels>>(
        future: ArticleServices().getBookmarkedArticles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    Assets.assetsEmptyBookmark,
                  ),
                  const Text(
                    'Tidak ada artikel yang disimpan',
                  )
                ],
              ),
            );
          } else {
            bookmarkedItem = snapshot.data!;
            if (selectedItem.length != bookmarkedItem.length) {
              selectedItem =
                  List<bool>.generate(bookmarkedItem.length, (index) => false);
            }

            return ListView.builder(
              itemCount: bookmarkedItem.length,
              itemBuilder: (context, index) {
                ArticleModels article = bookmarkedItem[index];

                return Padding(
                  padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                  child: GestureDetector(
                    onTap: () {
                      if (!isDeleting) {
                        Navigator.pushNamed(
                            context, RoutesNavigation.articleDetailView,
                            arguments: article);
                      }
                    },
                    child: ArticleCard(
                      image: article.image,
                      title: article.title,
                      doctorImage: article.doctor?.profileImage ?? '',
                      doctorName: article.doctor?.name ?? '',
                      date: article.date,
                      showIcon: isDeleting,
                      onPressedIcon: () {
                        setState(() {
                          updateSelectedItem(index, !selectedItem[index]);
                        });
                      },
                      isSelected: selectedItem[index],
                      selectedIcon: Icon(Icons.check_box, color: green600),
                      unselectedIcon:
                          Icon(Icons.check_box_outline_blank, color: green600),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void resetSelectedItems() {
    setState(() {
      selectedItem =
          List<bool>.generate(bookmarkedItem.length, (index) => false);
    });
  }

  void updateSelectedItem(int index, bool value) {
    setState(() {
      selectedItem[index] = value;
    });

    updateBottomSheet();
  }

  Future<void> deleteSelectedBookmarks(List<bool> selectedItems) async {
    List<int> selectedIndices = [];
    for (int i = 0; i < selectedItems.length; i++) {
      if (selectedItems[i]) {
        selectedIndices.add(i);
      }
    }

    if (selectedIndices.isNotEmpty) {
      bool? confirmDeletion = await showDialog<bool?>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Hapus ${selectedIndices.length} dari bookmark?',
                  style: semiBold14Black,
                ),
                const SizedBox(
                  height: 8,
                ),
                SizedBox(
                  width: 255,
                  height: 54,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Jika Anda meninggalkan halaman ini, perubahan yang Anda buat akan hilang dan tidak dapat dikembalikan',
                        style: regular12Black400,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context, true),
                      child: Container(
                        width: 123.5,
                        height: 36,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: negative,
                        ),
                        child: Center(
                          child: Text('Ya, Hapus', style: semiBold12Grey10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => Navigator.pop(context, false),
                      child: Container(
                        width: 123.5,
                        height: 36,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: green500,
                        ),
                        child: Center(
                          child: Text('Tidak', style: semiBold12Grey10),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );

      if (confirmDeletion == true) {
        for (int index in selectedIndices) {
          ArticleModels article = bookmarkedItem[index];
          await ArticleServices().postBookmark(article.id!);
        }

        setState(() {
          isDeleting == false;
        });
      } else {
        setState(() {
          isDeleting = false;
        });
      }
    }
  }

  void updateBottomSheet() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();

      scaffoldKey.currentState!.showBottomSheet(
        (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return BottomSheetContent(
                selectedItem: selectedItem,
                setState: setState,
                onDelete: () async {
                  try {
                    await deleteSelectedBookmarks(selectedItem);
                    setState(() {});
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  } on DioException catch (e) {
                    throw Exception(e.response);
                  }
                },
              );
            },
          );
        },
      );
    }
  }
}
