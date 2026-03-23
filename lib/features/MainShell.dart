import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:buy_tracker/l10n/app_localizations.dart';

class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).cardColor,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        selectedFontSize: 16,
        unselectedItemColor: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6) ?? Colors.grey[600],
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onItemTapped(index, context),
        items: [
          BottomNavigationBarItem(
            icon: const Text("🏠", style: TextStyle(fontSize: 24)),
            label: l10n.home,
          ),
          BottomNavigationBarItem(
            icon: const Text("📋", style: TextStyle(fontSize: 24)),
            label: l10n.lists,
          ),
          BottomNavigationBarItem(
            icon: const Text("📊", style: TextStyle(fontSize: 24)),
            label: l10n.statistics,
          ),
          BottomNavigationBarItem(
            icon: const Text("⏰", style: TextStyle(fontSize: 24)),
            label: l10n.reminders,
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
    if (location.startsWith('/reminders')) {
      return 3;
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
      case 3:
        context.go('/reminders');
        break;
    }
  }
}
