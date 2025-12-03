import 'package:buy_tracker/features/common/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/AuthProvider.dart';
import 'widgets/custom_text_field.dart';

class RegisterPage extends StatefulWidget {
  final Function functionRedirect;

  const RegisterPage({
    super.key,
    required this.functionRedirect
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _agreedToTerms = false;

  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  String? _generalError;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateName(String name) {
    if (name.isEmpty) {
      return 'Ім\'я не може бути порожнім';
    }
    if (name.length < 2) {
      return 'Ім\'я має містити мінімум 2 символи';
    }
    return null;
  }

  String? _validateEmail(String email) {
    if (email.isEmpty) {
      return 'Email не може бути порожнім';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      return 'Невірний формат email';
    }
    return null;
  }

  String? _validatePassword(String password) {
    if (password.isEmpty) {
      return 'Пароль не може бути порожнім';
    }
    if (password.length < 8) {
      return 'Пароль має містити мінімум 8 символів';
    }
    if (!RegExp(r'[A-Za-z]').hasMatch(password)) {
      return 'Пароль має містити літери';
    }
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return 'Пароль має містити цифри';
    }
    return null;
  }

  String? _validateConfirmPassword(String password, String confirmPassword) {
    if (confirmPassword.isEmpty) {
      return 'Підтвердіть пароль';
    }
    if (password != confirmPassword) {
      return 'Паролі не збігаються';
    }
    return null;
  }

  Future<void> _handleSignUp() async {
    final auth = Provider.of<AppAuthProvider>(context, listen: false);

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    // Валідація всіх полів
    setState(() {
      _nameError = _validateName(name);
      _emailError = _validateEmail(email);
      _passwordError = _validatePassword(password);
      _confirmPasswordError = _validateConfirmPassword(password, confirmPassword);
      _generalError = null;
    });

    // Якщо є помилки валідації - не продовжуємо
    if (_nameError != null || _emailError != null ||
        _passwordError != null || _confirmPasswordError != null) {
      return;
    }

    if (!_agreedToTerms) {
      setState(() {
        _generalError = 'Ви маєте погодитись з умовами використання';
      });
      return;
    }

    setState(() => _isLoading = true);

    try {
      await auth.signUp(name, email, password);
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        setState(() {
          _generalError = _getErrorMessage(e.code);
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _generalError = 'Виникла помилка: ${e.toString()}';
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'weak-password':
        return 'Пароль занадто слабкий';
      case 'email-already-in-use':
        return 'Ця електронна адреса вже використовується';
      case 'invalid-email':
        return 'Невірний формат email';
      case 'operation-not-allowed':
        return 'Реєстрацію через Email/Password не активовано';
      case 'network-request-failed':
        return 'Помилка мережі. Перевірте з\'єднання';
      default:
        return 'Помилка реєстрації: $code';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            CustomTextField(
              label: "Ім'я",
              hintText: "Ваше ім'я",
              controller: _nameController,
              errorText: _nameError,
            ),
            CustomTextField(
              label: "Email",
              hintText: "your@email.com",
              controller: _emailController,
              errorText: _emailError,
            ),
            CustomTextField(
              label: "Пароль",
              hintText: "Мінімум 8 символів",
              controller: _passwordController,
              obscureText: true,
              errorText: _passwordError,
            ),
            CustomTextField(
              label: "Підтвердження пароля",
              hintText: "Повторіть пароль",
              controller: _confirmPasswordController,
              obscureText: true,
              errorText: _confirmPasswordError,
            ),
            if (_generalError != null)
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red.shade700, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _generalError!,
                        style: TextStyle(color: Colors.red.shade700, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            Container(
              margin: const EdgeInsets.fromLTRB(30, 20, 30, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: _agreedToTerms,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      activeColor: const Color(0xFF667EEA),
                      onChanged: (bool? value) {
                        setState(() => _agreedToTerms = value ?? false);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Wrap(
                      children: [
                        const Text(
                          "Я погоджуюся з ",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF666666),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            print("Open Terms of Use");
                          },
                          child: const Text(
                            "Умовами використання",
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF667EEA),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        const Text(
                          " та ",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF666666),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            print("Open Privacy Policy");
                          },
                          child: const Text(
                            "Політикою конфіденційності",
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF667EEA),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _isLoading
                ? Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              child: CircularProgressIndicator(),
            )
                : CustomButton(
              text: "Зареєструватись",
              clickHandler: _handleSignUp,
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Вже маєте акаунт?",
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                  SizedBox(width: 6),
                  GestureDetector(
                    onTap: () {
                      widget.functionRedirect();
                    },
                    child: Text(
                      "Увійти",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF3B5AFE),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}