import 'package:cloud_firestore/cloud_firestore.dart';

class GalleryModel {
  final String? id;
  final String authorId;
  final String title;
  final String imageUrl;
  final DateTime date;

  GalleryModel({
    this.id,
    required this.authorId,
    required this.title,
    required this.imageUrl,
    required this.date,
  });

  factory GalleryModel.fromMap(Map<String, dynamic> map, String id) {
    return GalleryModel(
      id: id,
      authorId: map['authorId'] ?? '',
      title: map['title'] ?? 'Без названия',
      imageUrl: map['imageUrl'] ?? '',
      date: (map['date'] as Timestamp).toDate(),
    );
  }
}