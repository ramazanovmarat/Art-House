import 'package:art_house/src/features/gallery/data/gallery_repository.dart';
import 'package:art_house/src/features/gallery/domain/gallery_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final galleryProvider = StreamProvider.autoDispose<List<GalleryModel>>((ref) {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) return Stream.value([]);

  return ref.read(galleryRepositoryProvider).getImages(user.uid);
});