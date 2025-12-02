import 'package:buy_tracker/features/auth/common/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/AuthProvider.dart';
import '../common/custom_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _emailError;
  String? _passwordError;
  String? _generalError;

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
    if (password.length < 6) {
      return 'Пароль має містити мінімум 6 символів';
    }
    return null;
  }

  Future<void> _handleLogin() async {
    final auth = Provider.of<AppAuthProvider>(context, listen: false);

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    setState(() {
      _emailError = _validateEmail(email);
      _passwordError = _validatePassword(password);
      _generalError = null;
    });

    if (_emailError != null || _passwordError != null) return;

    setState(() => _isLoading = true);

    try {
      await auth.signIn(email, password);
    } on FirebaseAuthException catch (e) {
      setState(() => _generalError = _getErrorMessage(e.code));
    } catch (e) {
      setState(() => _generalError = "Виникла помилка: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleForgotPassword() async {
    final auth = Provider.of<AppAuthProvider>(context, listen: false);

    if (_emailController.text.isEmpty) {
      setState(() => _generalError = "Введіть email для відновлення");
      return;
    }

    try {
      await auth.resetPassword(_emailController.text.trim());
    } catch (e) {
      setState(() => _generalError = "Не вдалося надіслати лист: $e");
    }
  }


  String _getErrorMessage(String code) {
    switch (code) {
      case 'invalid-credential':
        return 'Пароль або пошта неправильні';
      case 'user-not-found':
        return 'Користувача з такою адресою не знайдено';
      case 'wrong-password':
        return 'Невірний пароль';
      case 'invalid-email':
        return 'Невірний формат email';
      case 'user-disabled':
        return 'Цей обліковий запис вимкнено';
      case 'too-many-requests':
        return 'Забагато спроб. Спробуйте пізніше';
      case 'network-request-failed':
        return 'Помилка мережі. Перевірте з\'єднання';
      default:
        return 'Помилка входу: $code';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            CustomTextField(
              label: "Email",
              hintText: "your@email.com",
              controller: _emailController,
              errorText: _emailError,
            ),
            CustomTextField(
              label: "Пароль",
              hintText: "••••••••",
              controller: _passwordController,
              obscureText: true,
              errorText: _passwordError,
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
              alignment: Alignment.bottomRight,
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: TextButton(
                onPressed: _handleForgotPassword,
                child: Text(
                  "Забули пароль?",
                  style: TextStyle(
                    color: Color(0xFF667EEA),
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            _isLoading
                ? CircularProgressIndicator()
                : CustomButton(
              text: "Увійти",
              clickHandler: _handleLogin,
            ),
          ],
        ),
      ),
    );
  }
}