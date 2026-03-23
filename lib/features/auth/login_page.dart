import 'widgets/custom_text_field.dart';
import 'package:buy_tracker/l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;
    if (email.isEmpty) {
      return l10n.emailCannotBeEmpty;
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      return l10n.invalidEmailFormat;
    }
    return null;
  }

  String? _validatePassword(String password) {
    final l10n = AppLocalizations.of(context)!;
    if (password.isEmpty) {
      return l10n.passwordCannotBeEmpty;
    }
    if (password.length < 6) {
      return l10n.passwordMinLength;
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
      setState(() => _generalError = "${AppLocalizations.of(context)!.generalErrorPrefix}$e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleForgotPassword() async {
    final auth = Provider.of<AppAuthProvider>(context, listen: false);
    final l10n = AppLocalizations.of(context)!;

    if (_emailController.text.isEmpty) {
      setState(() => _generalError = l10n.enterEmailToReset);
      return;
    }

    try {
      await auth.resetPassword(_emailController.text.trim());
    } catch (e) {
      setState(() => _generalError = "${l10n.failedToSendResetEmail}$e");
    }
  }


  String _getErrorMessage(String code) {
    final l10n = AppLocalizations.of(context)!;
    switch (code) {
      case 'invalid-credential':
        return l10n.invalidCredential;
      case 'user-not-found':
        return l10n.userNotFound;
      case 'wrong-password':
        return l10n.wrongPassword;
      case 'invalid-email':
        return l10n.invalidEmailFormat;
      case 'user-disabled':
        return l10n.userDisabled;
      case 'too-many-requests':
        return l10n.tooManyRequests;
      case 'network-request-failed':
        return l10n.networkRequestFailed;
      default:
        return '${l10n.loginError}$code';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            CustomTextField(
              label: l10n.email,
              hintText: l10n.emailHint,
              controller: _emailController,
              errorText: _emailError,
            ),
            CustomTextField(
              label: l10n.password,
              hintText: l10n.passwordHint,
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
                  l10n.forgotPassword,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            _isLoading
                ? CircularProgressIndicator()
                : CustomButton(
              text: l10n.signIn,
              clickHandler: _handleLogin,
            ),
          ],
        ),
      ),
    );
  }
}