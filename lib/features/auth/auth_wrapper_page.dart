import 'package:buy_tracker/features/auth/register_page.dart';
import 'package:flutter/material.dart';

import 'login_page.dart';

class AuthWrapperPage extends StatefulWidget {
  const AuthWrapperPage({
    super.key
  });

  @override
  State<AuthWrapperPage> createState() => _AuthWrapperPageState();
}

class _AuthWrapperPageState extends State<AuthWrapperPage> {
  bool _isLoginMode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 80),
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text("🛒", style: TextStyle(fontSize: 48)),
              ),
              Container(
                margin: EdgeInsets.only(top: 12),
                child: Text(
                  "Buy Tracker",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 8),
                child: Text(
                  "Твій помічник у покупках",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF666666),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(30, 50, 30, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() => _isLoginMode = true);
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: _isLoginMode
                              ? Color(0xFF667EEA)
                              : Color(0xFFF5F5F5),
                          padding: EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text(
                          "Вхід",
                          style: TextStyle(
                            color: _isLoginMode
                                ? Colors.white
                                : Color(0xFF666666),
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() => _isLoginMode = false);
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: !_isLoginMode
                              ? Color(0xFF667EEA)
                              : Color(0xFFF5F5F5),
                          padding: EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text(
                          "Реєстрація",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: !_isLoginMode
                                ? Colors.white
                                : Color(0xFF666666),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              _isLoginMode
                  ? LoginPage()
                  : RegisterPage(
                      functionRedirect: () => setState(() {
                        _isLoginMode = true;
                      })
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
