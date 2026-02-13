import 'package:flutter_riverpod/legacy.dart';

enum AuthPageType {
  login,
  registration,
}

final authPageController = StateProvider<AuthPageType>((ref) => AuthPageType.login);