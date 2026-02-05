import 'dart:typed_data';

import 'package:art_house/src/features/editor/domain/save_data_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final saveDataRepositoryProvider = Provider<SaveDataRepository>((ref) {
  return SaveDataRepositoryImpl(FirebaseFirestore.instance);
});

abstract class SaveDataRepository {
  Future<void> uploadAndSaveData({
    required Uint8List imageBytes,
    required String title,
    required String authorId,
  });
}

class SaveDataRepositoryImpl implements SaveDataRepository {
  final FirebaseFirestore _firestore;

  final _cloudinary = CloudinaryPublic(
    'dyl3dolus',
    'arthouse_preset',
  );

  SaveDataRepositoryImpl(this._firestore);

  @override
  Future<void> uploadAndSaveData({
    required Uint8List imageBytes,
    required String title,
    required String authorId,
  }) async {
    try {

      CloudinaryResponse response = await _cloudinary.uploadFile(
        CloudinaryFile.fromByteData(
          ByteData.view(imageBytes.buffer),
          identifier: const Uuid().v4(),
          folder: 'art_house_images',
          resourceType: CloudinaryResourceType.Image,
        ),
      );

      final String imageUrl = response.secureUrl;

      final model = SaveDataModel(
        authorId: authorId,
        title: title,
        imageUrl: imageUrl,
        date: DateTime.now(),
      );

      await _firestore.collection('data').add(model.toMap());

    } catch (e) {
      throw Exception('Ошибка сохранения: $e');
    }
  }
}