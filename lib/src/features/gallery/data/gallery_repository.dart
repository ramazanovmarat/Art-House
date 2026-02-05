import 'package:art_house/src/features/gallery/domain/gallery_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final galleryRepositoryProvider = Provider<GalleryRepository>((ref) {
  return GalleryRepositoryImpl(FirebaseFirestore.instance);
});

abstract class GalleryRepository {
  Stream<List<GalleryModel>> getImages(String userId);
}

class GalleryRepositoryImpl implements GalleryRepository {
  final FirebaseFirestore _firestore;

  GalleryRepositoryImpl(this._firestore);

  @override
  Stream<List<GalleryModel>> getImages(String userId) {
    return _firestore
        .collection('data')
        .where('authorId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return GalleryModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

}