import 'dart:convert';

import 'package:art_house/src/core/background_app.dart';
import 'package:art_house/src/core/service_network.dart';
import 'package:art_house/src/features/auth/ui/widgets/custom_button.dart';
import 'package:art_house/src/features/editor/ui/pages/editor_pages.dart';
import 'package:art_house/src/features/gallery/ui/controllers/gallery_controller.dart';
import 'package:art_house/src/features/gallery/ui/widgets/gallery_appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class GalleryPage extends ConsumerWidget {
  const GalleryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final galleryController = ref.watch(galleryProvider);

    ref.listen(internetStatusProvider, (previous, next) {
      if (next.hasValue && next.value == InternetStatus.disconnected) {

        if (context.mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Нет интернета'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      }
    });

    return BackgroundApp(
      appBar: GalleryAppbarWidget(ref: ref),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: [

            Expanded(
              child: galleryController.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) {
                  return Center(
                    child: Text(
                      'Ошибка: $err',
                      style: const TextStyle(color: Colors.white),
                    ));
                  },
                data: (images) {
                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      final image = images[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => EditorPage(imageUrl: image.imageUrl, isEditing: true, docId: image.id),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: FutureBuilder(
                                  future: Future.microtask(() => base64Decode(image.imageUrl)),
                                  builder: (context, asyncSnapshot) {

                                    if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                                      return const Center(child: CircularProgressIndicator());
                                    }

                                    if (asyncSnapshot.hasError || !asyncSnapshot.hasData) {
                                      return const Icon(Icons.error);
                                    }

                                    return Image.memory(
                                      asyncSnapshot.data!,
                                      fit: BoxFit.cover,
                                    );
                                  }
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: CustomButton(
                title: 'Создать',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => EditorPage()),
                  );
                },
              ),
            ),

            SizedBox(height: 10),

          ],
        ),
      ),
    );
  }
}
