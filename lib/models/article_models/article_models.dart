import 'package:reprohealth_app/models/doctor_models/doctor_models.dart';
import 'package:reprohealth_app/models/profile_models/profile_models.dart';

class ArticleModels {
  String? id;
  String title;
  String tags;
  String reference;
  DateTime date;
  String image;
  String imageDesc;
  String content;
  bool published;
  int views;
  ResponseDataDoctor? doctor;
  List<CommentModel> comments = [];
  ArticleModels({
    required this.id,
    required this.title,
    required this.tags,
    required this.reference,
    required this.date,
    required this.image,
    required this.imageDesc,
    required this.content,
    required this.published,
    required this.views,
    this.doctor,
    required this.comments,
  });

  factory ArticleModels.fromJson(
      Map<String, dynamic> json, ResponseDataDoctor? doctor) {
    return ArticleModels(
      id: json['id'],
      title: json['title'],
      tags: json['tags'],
      reference: json['reference'],
      date: DateTime.parse(json['date']),
      image: json['image'],
      imageDesc: json['image_desc'],
      content: json['content'],
      published: json['published'] ?? false,
      views: json['views'],
      doctor: doctor,
      comments: json['comments'] != null
          ? List<CommentModel>.from(
              json['comments'].map((comment) => CommentModel.fromJson(comment)),
            )
          : [],
    );
  }
}

class CommentModel {
  String id;
  String articleId;
  String patientId;
  String comment;
  DateTime date;
  ResponseDataProfile? patientDetails;
  String? patientProfile;
  String? patientName;

  CommentModel(
      {required this.id,
      required this.articleId,
      required this.patientId,
      required this.comment,
      required this.date,
      this.patientDetails,
      this.patientProfile,
      this.patientName});

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'],
      articleId: json['article_id'],
      patientId: json['patient_id'],
      comment: json['comment'],
      date: DateTime.parse(json['date']),
      patientDetails: json['response'] != null &&
              json['response']['patients'] != null &&
              json['response']['patients'].isNotEmpty
          ? ResponseDataProfile.fromMap(json['response']['patients'][0])
          : null,
      patientProfile: json['patient_profile'],
      patientName: json['patient_name'],
    );
  }
}
