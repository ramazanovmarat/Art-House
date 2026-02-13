import 'package:art_house/src/core/background_app.dart';
import 'package:art_house/src/core/service_notification.dart';
import 'package:art_house/src/features/auth/ui/controllers/auth_controller.dart';
import 'package:art_house/src/features/auth/ui/pages/auth_page.dart';
import 'package:art_house/src/features/gallery/ui/pages/gallery_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await ServiceNotification().init();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: authState.when(
        loading: () => BackgroundApp(
          child: const Center(child: CircularProgressIndicator(color: Colors.white)),
        ),
        error: (_, _) {
          return const AuthPageSwitch();
        },
        data: (user) => user == null
            ? const AuthPageSwitch()
            : const GalleryPage(),
      ),
    );
  }
}

