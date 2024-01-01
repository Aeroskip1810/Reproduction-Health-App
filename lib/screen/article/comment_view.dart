import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reprohealth_app/models/article_models/article_models.dart';
import 'package:reprohealth_app/screen/article/view_model/articel_view_model.dart';
import 'package:reprohealth_app/screen/article/widgets/comment_card.dart';
import 'package:reprohealth_app/theme/theme.dart';

class CommentView extends StatefulWidget {
  const CommentView({super.key});

  @override
  State<CommentView> createState() => _CommentViewState();
}

class _CommentViewState extends State<CommentView> {
  String _sortingOption = 'Terbaru';

  @override
  Widget build(BuildContext context) {
    final articleProvider =
        Provider.of<ArticleProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Komentar',
          style: semiBold16Black,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: secondary),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: FutureBuilder(
        future: articleProvider.getLoggedInPatient(context: context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.hasData) {
            return Text('Failed to load patient details: ${snapshot.error}');
          } else {
            final List<CommentModel> comments = ModalRoute.of(context)
                ?.settings
                .arguments as List<CommentModel>;

            if (_sortingOption == 'Terbaru') {
              comments.sort((a, b) => b.date.compareTo(a.date));
            } else if (_sortingOption == 'Terlama') {
              comments.sort((a, b) => a.date.compareTo(b.date));
            }
            return Padding(
              padding: const EdgeInsets.only(top: 24, left: 16, right: 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _sortingOption = 'Terbaru';
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: _sortingOption == 'Terbaru'
                                  ? green600
                                  : grey10,
                              border: Border.all(
                                  color: _sortingOption == 'Terbaru'
                                      ? green800
                                      : green500)),
                          child: Text(
                            'Terbaru',
                            style: _sortingOption == 'Terbaru'
                                ? medium14Primary
                                : medium14Green500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _sortingOption = 'Terlama';
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: _sortingOption == 'Terlama'
                                  ? green600
                                  : grey10,
                              border: Border.all(
                                  color: _sortingOption == 'Terlama'
                                      ? green800
                                      : green500)),
                          child: Text(
                            'Terlama',
                            style: _sortingOption == 'Terlama'
                                ? medium14Primary
                                : medium14Green500,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        CommentModel comment = comments[index];

                        return Column(
                          children: [
                            CommentCard(
                              image: comment.patientProfile ?? '',
                              name: comment.patientName ?? '',
                              date: DateFormat('dd MMMM yyyy')
                                  .format(comment.date.toLocal()),
                              comment: comment.comment,
                            ),
                            const Divider(
                              thickness: 1,
                            )
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
