import 'package:cloud_firestore/cloud_firestore.dart';

class SaveDataModel {
  final String? id;
  final String authorId;
  final String title;
  final String imageUrl;
  final DateTime date;

  SaveDataModel({
    this.id,
    required this.authorId,
    required this.title,
    required this.imageUrl,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'authorId': authorId,
      'title': title,
      'imageUrl': imageUrl,
      'date': Timestamp.fromDate(date),
    };
  }
}