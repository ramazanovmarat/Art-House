import 'dart:typed_data';
import 'package:art_house/src/core/service_network.dart';
import 'package:art_house/src/features/editor/data/save_data_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final saveDataControllerProvider = StateNotifierProvider<SaveDataController, AsyncValue<void>>((ref) {
  return SaveDataController(
    ref.read(saveDataRepositoryProvider),
    ref.read(networkServiceProvider),
  );
});

class SaveDataController extends StateNotifier<AsyncValue<void>> {
  final SaveDataRepository _repository;
  final ServiceNetwork _serviceNetwork;

  SaveDataController(
      this._repository,
      this._serviceNetwork,
      ) : super(const AsyncValue.data(null));

  Future<void> saveData({
    required String title,
    required Uint8List imageBytes,
  }) async {
    state = const AsyncValue.loading();
    try {

      final hasInternet = await _serviceNetwork.hasInternet;
      if (!hasInternet) {
        throw Exception("Нет интернета");
      }

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('Пользователь не найден');

      await _repository.uploadAndSaveData(
        imageBytes: imageBytes,
        title: title,
        authorId: user.uid,
      );

      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}