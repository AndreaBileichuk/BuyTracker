import 'package:buy_tracker/features/common/custom_button.dart';
import 'package:buy_tracker/l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;
    if (name.isEmpty) {
      return l10n.nameCannotBeEmpty;
    }
    if (name.length < 2) {
      return l10n.nameMinLength;
    }
    return null;
  }

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
    if (password.length < 8) {
      return l10n.passwordMinLength;
    }
    if (!RegExp(r'[A-Za-z]').hasMatch(password)) {
      return l10n.passwordMustContainLetters;
    }
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return l10n.passwordMustContainNumbers;
    }
    return null;
  }

  String? _validateConfirmPassword(String password, String confirmPassword) {
    final l10n = AppLocalizations.of(context)!;
    if (confirmPassword.isEmpty) {
      return l10n.confirmPasswordEmpty;
    }
    if (password != confirmPassword) {
      return l10n.passwordsDoNotMatch;
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
        _generalError = AppLocalizations.of(context)!.mustAgreeToTerms;
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
          _generalError = '${AppLocalizations.of(context)!.generalErrorPrefix}${e.toString()}';
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _getErrorMessage(String code) {
    final l10n = AppLocalizations.of(context)!;
    switch (code) {
      case 'weak-password':
        return l10n.weakPassword;
      case 'email-already-in-use':
        return l10n.emailAlreadyInUse;
      case 'invalid-email':
        return l10n.invalidEmailFormat;
      case 'operation-not-allowed':
        return l10n.operationNotAllowed;
      case 'network-request-failed':
        return l10n.networkRequestFailed;
      default:
        return '${l10n.registerError}$code';
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
              label: l10n.nameLabel,
              hintText: l10n.nameHint,
              controller: _nameController,
              errorText: _nameError,
            ),
            CustomTextField(
              label: l10n.email,
              hintText: l10n.emailHint,
              controller: _emailController,
              errorText: _emailError,
            ),
            CustomTextField(
              label: l10n.password,
              hintText: l10n.passwordMinHint,
              controller: _passwordController,
              obscureText: true,
              errorText: _passwordError,
            ),
            CustomTextField(
              label: l10n.confirmPassword,
              hintText: l10n.repeatPasswordHint,
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
                      activeColor: Theme.of(context).colorScheme.primary,
                      onChanged: (bool? value) {
                        setState(() => _agreedToTerms = value ?? false);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Wrap(
                      children: [
                        Text(
                          l10n.iAgreeWith,
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).brightness == Brightness.dark 
                                ? Colors.grey[400] 
                                : const Color(0xFF666666),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            print("Open Terms of Use");
                          },
                          child: Text(
                            l10n.termsOfUse,
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.primary,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        Text(
                          l10n.andLabel,
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).brightness == Brightness.dark 
                                ? Colors.grey[400] 
                                : const Color(0xFF666666),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            print("Open Privacy Policy");
                          },
                          child: Text(
                            l10n.privacyPolicy,
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.primary,
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
              text: l10n.signUp,
              clickHandler: _handleSignUp,
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.alreadyHaveAccount,
                    style: TextStyle(
                      fontSize: 16, 
                      color: Theme.of(context).brightness == Brightness.dark 
                          ? Colors.grey[400] 
                          : Colors.grey[700],
                    ),
                  ),
                  SizedBox(width: 6),
                  GestureDetector(
                    onTap: () {
                      widget.functionRedirect();
                    },
                    child: Text(
                      l10n.signIn,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.primary,
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