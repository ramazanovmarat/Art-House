import 'package:art_house/src/core/background_app.dart';
import 'package:art_house/src/features/auth/ui/controllers/auth_controller.dart';
import 'package:art_house/src/features/auth/ui/pages/registration_page.dart';
import 'package:art_house/src/features/auth/ui/widgets/custom_button.dart';
import 'package:art_house/src/features/auth/ui/widgets/custom_textfield.dart';
import 'package:art_house/src/features/gallery/ui/pages/gallery_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _loginOnTap() {

    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    ref.read(authControllerProvider.notifier).login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {

    final authState = ref.watch(authControllerProvider);

    ref.listen(authControllerProvider, (previous, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }

      if (next.hasValue && next.value != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Вход прошел успешно')),
        );

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const GalleryPage()),
        );
      }
    });

    return BackgroundApp(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Stack(
            children: [

              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 500,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Вход',
                          style: GoogleFonts.tiny5(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            shadows: [
                              Shadow(
                                blurRadius: 8,
                                color: Colors.purple,
                              ),
                              Shadow(
                                blurRadius: 16,
                                color: Colors.purple,
                              ),
                              Shadow(
                                blurRadius: 42,
                                color: Colors.purple,
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 10),

                        CustomTextField(
                          label: 'e-mail',
                          hint: 'Введите электронную почту',
                          controller: _emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Введите email';
                            if (!value.contains('@')) return 'Некорректный email';
                            return null;
                          },
                        ),

                        SizedBox(height: 20),

                        CustomTextField(
                          label: 'Подтверждение пароля',
                          hint: 'Введите пароль',
                          controller: _passwordController,
                          isObscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Пароль не может быть пустым';
                            }
                            return null;
                          },
                        ),

                      ],
                    ),
                  ),
                ),
              ),

              Positioned(
                left: MediaQuery.of(context).size.width > 600 ? 150 : 0,
                right: MediaQuery.of(context).size.width > 600 ? 150 : 0,
                bottom: 10,
                child: Column(
                  spacing: 19,
                  children: [

                    authState.isLoading
                        ? Center(child: CircularProgressIndicator())
                        : CustomButton(
                      title: 'Войти',
                      onTap: _loginOnTap,
                    ),

                    CustomButton(
                      title: 'Регистрация',
                      isGradient: false,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => RegistrationPage()),
                        );
                      },
                    ),

                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
