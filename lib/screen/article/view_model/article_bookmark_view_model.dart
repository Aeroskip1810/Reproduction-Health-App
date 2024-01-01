import 'package:flutter/foundation.dart';
import 'package:reprohealth_app/models/article_models/article_models.dart';
import 'package:reprohealth_app/services/article_services/article_services.dart';

class ArticleViewModel with ChangeNotifier {
  List<bool> isBookmark = [];
  List<ArticleModels> articles = [];
  List<ArticleModels> bookmarkedItem = [];
  bool isLoading = false;
  String error = '';
  bool get hasError => error.isNotEmpty;

  Future<void> fetchArticles() async {
    try {
      isLoading = true;
      notifyListeners();

      articles = await ArticleServices().getArticles();

      isBookmark = isBookmark.isNotEmpty
          ? isBookmark
          : List.generate(articles.length, (index) => false);

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      error = 'Error fetching articles: $e';
      if (kDebugMode) {
        print(error);
      }
      notifyListeners();
    }
  }

  Future<void> checkBookmarkedStatus(int index, ArticleModels article) async {
    try {
      List<ArticleModels> bookmarkedArticles =
          await ArticleServices().getBookmarkedArticles();

      bool isBookmarked = bookmarkedArticles.any((a) => a.id == article.id);

      isBookmark[index] = isBookmarked;
      notifyListeners();
    } catch (e) {
      isBookmark[index] = false;
      notifyListeners();
    }
  }
}