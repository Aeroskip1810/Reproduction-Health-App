import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:reprohealth_app/models/article_models/article_models.dart';
import 'package:reprohealth_app/models/profile_models/profile_models.dart';
import 'package:reprohealth_app/services/article_services/article_services.dart';
import 'package:reprohealth_app/services/profile_service/profile_service.dart';

class ArticleProvider with ChangeNotifier {
  TextEditingController controller = TextEditingController();

  bool? _isLoading;
  bool? get isLoading => _isLoading;

  String formattedDateTime(DateTime dateTime) {
    String formattedDate = DateFormat('dd MMMM yyyy "pukul" HH:mm "WIB"')
        .format(dateTime.toLocal());
    return 'Diunggah pada $formattedDate';
  }

  String parseContent(String content) {
    final document = parse(content);
    final String parsedContent =
        parse(document.body!.text).documentElement!.text;
    return parsedContent;
  }

  Future<String?> getLoggedInPatientId(BuildContext context) async {
    try {
      ProfileModel profile =
          await ProfileService().getProfileModel(context: context);

      if (profile.response != null && profile.response!.isNotEmpty) {
        String? patientId = profile.response![0].id;

        if (patientId != null && patientId.isNotEmpty) {
          return patientId;
        } else {
          if (kDebugMode) {
            print('Patient ID is null or empty');
          }
          return null;
        }
      } else {
        if (kDebugMode) {
          print('Profile response is empty');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to get logged-in patient ID: $e');
      }
      return null;
    }
  }

  Future<ProfileModel?> getLoggedInPatient({
    required BuildContext context,
  }) async {
    try {
      ProfileModel profile =
          await ProfileService().getProfileModel(context: context);

      if (profile.response != null && profile.response!.isNotEmpty) {
        return profile;
      } else {
        if (kDebugMode) {
          print('Profile response is empty');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to get logged-in patient data: $e');
      }
      return null;
    }
  }

  Future<List<CommentModel>> fetchCommentsForArticle(
      String articleId, BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    try {
      ProfileModel? loggedInPatient =
          await getLoggedInPatient(context: context);

      if (loggedInPatient != null) {
        List<CommentModel> comments =
            await ArticleServices().getComment(articleId);

        for (CommentModel comment in comments) {
          comment.patientDetails = loggedInPatient.response![0];
        }

        return comments;
      } else {
        throw Exception(
            'Failed to fetch comments: Logged-in patient data is null');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to fetch comments: $e');
      }
      return [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> postComment(
      {required String articleId, required BuildContext context}) async {
    try {
      String? patientId = await getLoggedInPatientId(context);
      String? comment = controller.text.trim();
      controller.clear();
      if (kDebugMode) {
        print(patientId);
        print(comment);
      }
      notifyListeners();

      if (articleId != null && patientId != null && comment.isNotEmpty) {
        await ArticleServices().postComment(
          patientId: patientId,
          comment: comment,
          articleId: articleId,
        );
      } else {
        if (kDebugMode) {
          print(
            'Comment cannot be empty, or patient ID or article ID is missing');
        }
      }
      await fetchCommentsForArticle(articleId, context);
    } catch (e) {
      if (kDebugMode) {
        print('halo 1 $e');
      }
      throw Exception(e);
    }
  }
}
