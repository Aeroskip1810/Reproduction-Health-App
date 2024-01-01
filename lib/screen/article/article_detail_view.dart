import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reprohealth_app/component/button_component.dart';
import 'package:reprohealth_app/component/text_form_component.dart';
import 'package:reprohealth_app/constant/routes_navigation.dart';
import 'package:reprohealth_app/models/article_models/article_models.dart';
import 'package:reprohealth_app/screen/article/view_model/articel_view_model.dart';
import 'package:reprohealth_app/screen/article/widgets/comment_card.dart';
import 'package:reprohealth_app/theme/theme.dart';

class ArticleDetailView extends StatefulWidget {
  const ArticleDetailView({super.key});

  @override
  State<ArticleDetailView> createState() => _ArticleDetailViewState();
}

class _ArticleDetailViewState extends State<ArticleDetailView> {
  bool isBookmark = false;

  late Future<List<CommentModel>> future;
  @override
  Widget build(BuildContext context) {
    final ArticleModels article =
        ModalRoute.of(context)?.settings.arguments as ArticleModels;
    final articleProvider =
        Provider.of<ArticleProvider>(context, listen: false);
    future = articleProvider.fetchCommentsForArticle(article.id!, context);

    Future<void> refresh() async {
      setState(() {
        future = articleProvider.fetchCommentsForArticle(article.id!, context);
      });
    }

    return Scaffold(
        body: RefreshIndicator(
      onRefresh: refresh,
      child: FutureBuilder<List<CommentModel>>(
              future: future,
              builder: (context, snapshot) {
                List<CommentModel> sortedComments = snapshot.data!
                  ..sort((a, b) => b.date.compareTo(a.date));
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Failed to load comments: ${snapshot.error}');
                } else {
                  return ListView(
                    children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(children: [
                              SizedBox(
                                height: 190,
                                width: double.infinity,
                                child: Image(
                                  image: NetworkImage(article.image),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 19),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      height: 40,
                                      width: 40,
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white),
                                      child: IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: Icon(Icons.arrow_back,
                                            color: secondary),
                                      ),
                                    ),
                                    Container(
                                      height: 40,
                                      width: 40,
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white),
                                      child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            isBookmark = !isBookmark;
                                          });
                                        },
                                        icon: Icon(
                                          isBookmark
                                              ? Icons.bookmark
                                              : Icons.bookmark_add_outlined,
                                          color: secondary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ]),
                            Padding(
                                padding: const EdgeInsets.only(
                                    top: 32, left: 16, right: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      article.title,
                                      style: semiBold20Black,
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Row(
                                      children:
                                          article.tags.split(',').map((tag) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 11, vertical: 5),
                                            decoration: BoxDecoration(
                                              color: green100,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Text(
                                              tag.trim(),
                                              style: regular8Black,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: CachedNetworkImage(
                                            fit: BoxFit.cover,
                                            width: 24,
                                            imageUrl:
                                                article.doctor?.profileImage ??
                                                    '',
                                            placeholder: (context, url) =>
                                                const CircularProgressIndicator(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Center(
                                              child: Icon(
                                                Icons.error,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(article.doctor?.name ?? '',
                                                  style: medium10Black500),
                                              Text(
                                                articleProvider
                                                    .formattedDateTime(
                                                        article.date),
                                                style: regular8Black,
                                              ),
                                            ])
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.visibility_outlined),
                                        const SizedBox(width: 2),
                                        SizedBox(
                                          width: 26,
                                          child: Text(
                                            article.views.toString(),
                                            style: regular8Black,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        const Icon(Icons.bookmark_outline),
                                        const SizedBox(width: 2),
                                        SizedBox(
                                          width: 26,
                                          child: Text(
                                            article.views.toString(),
                                            style: regular8Black,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        const Icon(Icons.comment_outlined),
                                        const SizedBox(width: 2),
                                        SizedBox(
                                            width: 26,
                                            child: Text(
                                              '${snapshot.data?.length ?? 0}',
                                              style: regular8Black,
                                            )),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Text(
                                      articleProvider
                                          .parseContent(article.content),
                                      style: regular12Black400,
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Referensi',
                                            style: medium10Black500,
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          Text(
                                            article.reference,
                                            style: regular8Black400Italic,
                                          ),
                                        ]),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Komentar (${snapshot.data?.length ?? 0})',
                                                style: medium10Black500,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          TextFormComponent(
                                            controller:
                                                articleProvider.controller,
                                            hintText: 'Tambahkan Komentar...',
                                            hinstStyle: regular10Grey400,
                                            suffixIcon: IconButton(
                                              onPressed: () {
                                                articleProvider.postComment(
                                                  articleId: article.id!,
                                                  context: context,
                                                );
                                                future = articleProvider
                                                    .fetchCommentsForArticle(
                                                        article.id!, context);

                                                setState(() {});
                                              },
                                              icon: const Icon(Icons.send),
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          ListView.builder(
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount:
                                                  snapshot.data!.length > 3
                                                      ? 3
                                                      : snapshot.data!.length,
                                              itemBuilder: (context, index) {
                                                CommentModel comment =
                                                    sortedComments[index];
                                                return Column(
                                                  children: [
                                                    CommentCard(
                                                      image: comment
                                                              .patientProfile ??
                                                          '',
                                                      name:
                                                          comment.patientName ??
                                                              '',
                                                      date: DateFormat(
                                                              'dd MMMM yyyy')
                                                          .format(comment.date
                                                              .toLocal()),
                                                      comment: comment.comment,
                                                    ),
                                                    const SizedBox(
                                                      height: 12,
                                                    )
                                                  ],
                                                );
                                              }),
                                          const SizedBox(height: 16),
                                          ButtonComponent(
                                              labelText: Center(
                                                child: Text(
                                                  'Lihat Semua Komentar',
                                                  style: semiBold12Green500,
                                                ),
                                              ),
                                              elevation: 0,
                                              border: BorderSide(
                                                  color: green500, width: 2),
                                              backgroundColor: Colors.white,
                                              onPressed: () {
                                                Navigator.pushNamed(
                                                    context,
                                                    RoutesNavigation
                                                        .commentView,
                                                    arguments:
                                                        article.comments);
                                              }),
                                          const SizedBox(
                                            height: 6,
                                          )
                                        ])
                                  ],
                                ))
                          ])
                    ],
                  );
                }
              }),
    ));
  }
}
