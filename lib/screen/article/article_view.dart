// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:reprohealth_app/component/text_form_component.dart';
// import 'package:reprohealth_app/constant/routes_navigation.dart';
// import 'package:reprohealth_app/models/article_models.dart';
// import 'package:reprohealth_app/screen/article/view_model/article_bookmark_view_model.dart';
// import 'package:reprohealth_app/screen/article/widgets/article_card.dart';
// import 'package:reprohealth_app/services/article_services/article_services.dart';
// import 'package:reprohealth_app/theme/theme.dart';

// class ArticleView extends StatefulWidget {
//   const ArticleView({Key? key}) : super(key: key);

//   @override
//   _ArticleViewState createState() => _ArticleViewState();
// }

// class _ArticleViewState extends State<ArticleView> {
//   late TextEditingController controller;
  
//   Future<void> _refresh() async {
//     // Implement your refresh logic here, for example, refetch articles.
//     Provider.of<ArticleViewModel>(context, listen: false).fetchArticles();
//   }

//   late Future<List<CommentModel>> future;

//   @override
//   void initState() {
//     super.initState();
//     controller = TextEditingController();
//     Provider.of<ArticleViewModel>(context, listen: false).fetchArticles();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Artikel',
//           style: semiBold16Black,
//         ),
//         actions: [
//           IconButton(
//             onPressed: () {
//               Navigator.pushNamed(
//                 context,
//                 RoutesNavigation.bookmarkView,
//                 arguments: Provider.of<ArticleViewModel>(context, listen: false)
//                     .bookmarkedItem,
//               );
//             },
//             icon: Icon(Icons.bookmark_border, color: green600),
//           )
//         ],
//         elevation: 0,
//         backgroundColor: grey10,
//       ),
//       body: SingleChildScrollView(
//         child: RefreshIndicator(
//           onRefresh: _refresh,
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(
//                   top: 24,
//                   left: 16,
//                   right: 16,
//                   bottom: 24,
//                 ),
//                 child: TextFormComponent(
//                   controller: controller,
//                   hintText: 'Cari Artikel',
//                   hinstStyle: regular14Grey400,
//                   prefixIcon: Icons.search,
//                   onChanged: (query) {
//                     setState(() {});
//                   },
//                 ),
//               ),
//               Consumer<ArticleViewModel>(
//                 builder: (context, articleViewModel, child) {
//                   if (articleViewModel.isLoading) {
//                     return const Center(
//                       child: CircularProgressIndicator(),
//                     );
//                   } else if (articleViewModel.hasError) {
//                     return Center(
//                         child: Text('Error: ${articleViewModel.error}'));
//                   } else if (articleViewModel.articles.isEmpty) {
//                     return const Center(
//                       child: Text(
//                         'Tidak ada artikel',
//                       ),
//                     );
//                   } else {
//                     String query = controller.text.toLowerCase();
//                     List<ArticleModels> filteredArticles = articleViewModel
//                         .articles
//                         .where((articles) =>
//                             articles.title.toLowerCase().contains(query))
//                         .toList();
//                     return ListView.builder(
//                       shrinkWrap: true,
//                       physics: const NeverScrollableScrollPhysics(),
//                       itemCount: filteredArticles.length,
//                       itemBuilder: (context, index) {
//                         final article = filteredArticles[index];
        
//                         // Call checkBookmarkedStatus when building each item
//                         articleViewModel.checkBookmarkedStatus(index, article);
        
//                         return Padding(
//                           padding: const EdgeInsets.all(16),
//                           child: GestureDetector(
//                             onTap: () {
//                               Navigator.pushNamed(
//                                 context,
//                                 RoutesNavigation.articleDetailView,
//                                 arguments: article,
//                               );
//                             },
//                             child: ArticleCard(
//                               image: article.image,
//                               title: article.title,
//                               doctorImage: article.doctor?.profileImage ?? '',
//                               doctorName: article.doctor?.name ?? '',
//                               date: article.date,
//                               onPressedIcon: () async {
//                                 try {
//                                   await ArticleServices()
//                                       .postBookmark(article.id ?? '');
        
//                                   // Update bookmark state after successful removal
//                                   setState(() {
//                                     articleViewModel.isBookmark[index] =
//                                         !articleViewModel.isBookmark[index];
//                                   });
//                                 } catch (e) {
//                                   print('Failed to toggle bookmark: $e');
//                                 }
//                               },
//                               showIcon: true,
//                               isSelected: articleViewModel.isBookmark[index],
//                               selectedIcon: Icon(Icons.bookmark, color: green600),
//                               unselectedIcon: Icon(
//                                 Icons.bookmark_add_outlined,
//                                 color: green600,
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   }
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reprohealth_app/component/text_form_component.dart';
import 'package:reprohealth_app/constant/routes_navigation.dart';
import 'package:reprohealth_app/models/article_models/article_models.dart';
import 'package:reprohealth_app/screen/article/view_model/article_bookmark_view_model.dart';
import 'package:reprohealth_app/screen/article/widgets/article_card.dart';
import 'package:reprohealth_app/services/article_services/article_services.dart';
import 'package:reprohealth_app/theme/theme.dart';

class ArticleView extends StatefulWidget {
  const ArticleView({Key? key}) : super(key: key);

  @override
  _ArticleViewState createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {
  late TextEditingController controller;

  late Future<List<CommentModel>> future;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    Provider.of<ArticleViewModel>(context, listen: false).fetchArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Artikel',
          style: semiBold16Black,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                RoutesNavigation.bookmarkView,
                arguments: Provider.of<ArticleViewModel>(context, listen: false)
                    .bookmarkedItem,
              );
            },
            icon: Icon(Icons.bookmark_border, color: green600),
          )
        ],
        elevation: 0,
        backgroundColor: grey10,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 24,
                left: 16,
                right: 16,
                bottom: 24,
              ),
              child: TextFormComponent(
                controller: controller,
                hintText: 'Cari Artikel',
                hinstStyle: regular14Grey400,
                prefixIcon: Icons.search,
                onChanged: (query) {
                  setState(() {});
                },
              ),
            ),
            Consumer<ArticleViewModel>(
              builder: (context, articleViewModel, child) {
                if (articleViewModel.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (articleViewModel.hasError) {
                  return Center(
                      child: Text('Error: ${articleViewModel.error}'));
                } else if (articleViewModel.articles.isEmpty) {
                  return const Center(
                    child: Text(
                      'Tidak ada artikel',
                    ),
                  );
                } else {
                  String query = controller.text.toLowerCase();
                  List<ArticleModels> filteredArticles = articleViewModel
                      .articles
                      .where((articles) =>
                          articles.title.toLowerCase().contains(query))
                      .toList();
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredArticles.length,
                    itemBuilder: (context, index) {
                      final article = filteredArticles[index];

                      // Call checkBookmarkedStatus when building each item
                      articleViewModel.checkBookmarkedStatus(index, article);

                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              RoutesNavigation.articleDetailView,
                              arguments: article,
                            );
                          },
                          child: ArticleCard(
                            image: article.image,
                            title: article.title,
                            doctorImage: article.doctor?.profileImage ?? '',
                            doctorName: article.doctor?.name ?? '',
                            date: article.date,
                            onPressedIcon: () async {
                              try {
                                await ArticleServices()
                                    .postBookmark(article.id ?? '');

                                // Update bookmark state after successful removal
                                setState(() {
                                  articleViewModel.isBookmark[index];
                                });
                              } catch (e) {
                                if (kDebugMode) {
                                  print('Failed to toggle bookmark: $e');
                                }
                              }
                            },
                            showIcon: true,
                            isSelected: articleViewModel.isBookmark[index],
                            selectedIcon: Icon(Icons.bookmark, color: green600),
                            unselectedIcon: Icon(
                              Icons.bookmark_add_outlined,
                              color: green600,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}