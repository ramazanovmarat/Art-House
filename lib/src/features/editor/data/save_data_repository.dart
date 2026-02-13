import 'dart:convert';
import 'dart:typed_data';
import 'package:art_house/src/features/editor/domain/save_data_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final saveDataRepositoryProvider = Provider<SaveDataRepository>((ref) {
  return SaveDataRepositoryImpl(FirebaseFirestore.instance);
});

abstract class SaveDataRepository {
  Future<void> uploadAndSaveData({
    required Uint8List imageBytes,
    required String title,
    required String authorId,
    String? docId,
  });
}

class SaveDataRepositoryImpl implements SaveDataRepository {
  final FirebaseFirestore _firestore;

  SaveDataRepositoryImpl(this._firestore);

  @override
  Future<void> uploadAndSaveData({
    required Uint8List imageBytes,
    required String title,
    required String authorId,
    String? docId,
  }) async {
    try {

      final String base64Image = base64Encode(imageBytes);

      if (base64Image.length > 1000000) {
        throw Exception('Картинка слишком большая');
      }

      final model = SaveDataModel(
        id: docId,
        authorId: authorId,
        title: title,
        imageUrl: base64Image,
        date: DateTime.now(),
      );

      if(docId != null) {

        await _firestore
            .collection('users')
            .doc(authorId)
            .collection('images')
            .doc(docId)
            .set(model.toMap());

      } else {

        await _firestore
            .collection('users')
            .doc(authorId)
            .collection('images')
            .add(model.toMap());

      }

    } catch (e) {
      throw Exception('Ошибка сохранения: $e');
    }
  }
}