import 'package:buy_tracker/core/providers/AuthProvider.dart';
import 'package:buy_tracker/features/lists/widgets/shopping_list_item_card.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:buy_tracker/l10n/app_localizations.dart';
import '../../core/providers/ShoppingListsProvider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseAnalytics.instance.logEvent(name: 'home_page_opened');

    final shoppingLists = context.watch<ShoppingListsProvider>().lists.take(3);
    final user = context.watch<AppAuthProvider>().currentUser;
    final l10n = AppLocalizations.of(context)!;

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Stack(
      children: [
        Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.helloGlimpse,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.displayName ?? 'User',
                        style: const TextStyle(fontSize: 18, color: Colors.white70),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => context.go('/profile'),
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.white30,
                      backgroundImage: user.photoURL != null && user.photoURL!.isNotEmpty
                          ? NetworkImage(user.photoURL!)
                          : null,
                      child: user.photoURL == null || user.photoURL!.isEmpty
                          ? const Icon(Icons.person, color: Colors.white, size: 28)
                          : null,
                    ),
                  )
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.recentLists,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () => context.go('/lists'),
                    child: Text(
                      "${l10n.viewAll} →",
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: shoppingLists.isEmpty
                  ? Center(
                child: Text(
                  l10n.noListsHere,
                  style: TextStyle(fontSize: 16, color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6)),
                ),
              )
                  : ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                children: shoppingLists.map((list) {
                  return ShoppingListItemCard(list: list);
                }).toList(),
              ),
            ),
          ],
        ),

        Positioned(
          bottom: 12,
          right: 24,
          child: Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(32),
                onTap: () => context.go('/lists/create'),
                child: const Icon(Icons.add, size: 32, color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}