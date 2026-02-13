import 'package:art_house/src/features/auth/ui/controllers/auth_page_controller.dart';
import 'package:art_house/src/features/auth/ui/pages/login_page.dart';
import 'package:art_house/src/features/auth/ui/pages/registration_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthPageSwitch extends ConsumerWidget {
  const AuthPageSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = ref.watch(authPageController);

    switch (page) {
      case AuthPageType.login:
        return const LoginPage();

      case AuthPageType.registration:
        return const RegistrationPage();
    }
  }
}