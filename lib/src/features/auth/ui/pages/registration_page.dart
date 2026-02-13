import 'package:art_house/src/core/background_app.dart';
import 'package:art_house/src/features/auth/ui/controllers/auth_controller.dart';
import 'package:art_house/src/features/auth/ui/widgets/custom_button.dart';
import 'package:art_house/src/features/auth/ui/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegistrationPage extends ConsumerStatefulWidget {
  const RegistrationPage({super.key});

  @override
  ConsumerState<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends ConsumerState<RegistrationPage> {

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _registrationOnTap() {

    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    ref.read(authControllerProvider.notifier).signUp(
      _emailController.text.trim(),
      _passwordController.text.trim(),
      _nameController.text.trim(),
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
          const SnackBar(content: Text('Регистрация прошла успешно')),
        );

      }
    });

    return BackgroundApp(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [

                      Expanded(
                        child: Center(
                          child: Container(
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
                                    'Регистрация',
                                    style: TextStyle(
                                      fontFamily: 'PixelFonts',
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
                                    label: 'Имя',
                                    hint: 'Введите ваше имя',
                                    controller: _nameController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) return 'Введите имя';
                                      return null;
                                    },
                                  ),

                                  SizedBox(height: 20),

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

                                  Divider(thickness: 1, color: Colors.grey),

                                  SizedBox(height: 20),

                                  CustomTextField(
                                    label: 'Пароль',
                                    hint: '8-16 символов',
                                    controller: _passwordController,
                                    isObscureText: true,
                                    validator: (value) {
                                      if (value == null || value.length < 8) {
                                        return 'Минимум 8 символов';
                                      }
                                      return null;
                                    },
                                  ),

                                  SizedBox(height: 20),

                                  CustomTextField(
                                    label: 'Подтверждение пароля',
                                    hint: '8-16 символов',
                                    controller: _confirmPasswordController,
                                    isObscureText: true,
                                    validator: (value) {
                                      if (value != _passwordController.text) {
                                        return 'Пароли не совпадают';
                                      }
                                      return null;
                                    },
                                  ),

                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 20),

                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 500),
                        child: authState.isLoading
                            ? Center(child: CircularProgressIndicator())
                            : CustomButton(
                          title: 'Зарегистрироваться',
                          isGradient: false,
                          onTap: _registrationOnTap,
                        ),
                      ),

                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          }
        ),
      ),
    );
  }
}
