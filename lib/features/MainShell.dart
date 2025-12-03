import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF667EEA),
        selectedFontSize: 16,
        unselectedItemColor: Colors.grey[600],
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onItemTapped(index, context),
        items: const [
          BottomNavigationBarItem(
            icon: Text("🏠", style: TextStyle(fontSize: 24)),
            label: "Головна",
          ),
          BottomNavigationBarItem(
            icon: Text("📋", style: TextStyle(fontSize: 24)),
            label: "Списки",
          ),
          BottomNavigationBarItem(
            icon: Text("📊", style: TextStyle(fontSize: 24)),
            label: "Статистика",
          ),
        ],
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/lists')) {
      return 1;
    }
    if (location.startsWith('/stats')) {
      return 2;
    }
    return 0;
  }

  // Функція для навігації
  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/lists');
        break;
      case 2:
        context.go('/stats');
        break;
    }
  }
}
