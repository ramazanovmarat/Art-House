import 'package:art_house/src/features/auth/ui/controllers/auth_controller.dart';
import 'package:art_house/src/features/auth/ui/controllers/auth_page_controller.dart';
import 'package:art_house/src/features/editor/ui/pages/editor_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class GalleryAppbarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final WidgetRef ref;
  const GalleryAppbarWidget({super.key, required this.ref});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Галерея', style: TextStyle(color: Colors.white)),
      backgroundColor: Color(0xFF2E243C).withValues(alpha: 1.0),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => EditorPage()),
            );
          },
          icon: SvgPicture.asset(
            'assets/paint_roller.svg',
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
        ),
      ],
      leading: IconButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Выход'),
                content: const Text('Вы уверены, что хотите выйти?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Отмена'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ref.read(authControllerProvider.notifier).logout();
                      ref.read(authPageController.notifier).state = AuthPageType.login;
                    },
                    child: const Text('Выйти'),
                  ),
                ],
              );
            },
          );
        },
        icon: SvgPicture.asset('assets/logout.svg'),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
