import 'package:buy_tracker/features/MainShell.dart';
import 'package:buy_tracker/features/profile/profile_page.dart';
import 'package:buy_tracker/features/statistics/StatisticsPage.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../core/providers/AuthProvider.dart';
import '../main.dart';
import 'auth/auth_wrapper_page.dart';
import 'home/home_page.dart';
import 'lists/pages/EditListPage.dart';
import 'lists/pages/ListsPage.dart';
import 'lists/pages/ShoppingListDetails.dart';
import 'lists/pages/CreateListPage.dart';

class AppRouter {
  final AppAuthProvider authProvider;

  AppRouter(this.authProvider);

  late final GoRouter router = GoRouter(
    refreshListenable: authProvider,

    initialLocation: '/login',

    redirect: (BuildContext context, GoRouterState state) {
      final bool isLoggedIn = authProvider.isLoggedIn;
      final bool isLoggingIn = state.uri.toString() == '/login';

      // 1. Якщо користувач не увійшов і йде НЕ на сторінку логіну -> відправляємо на /login
      if (!isLoggedIn && !isLoggingIn) {
        return '/login';
      }

      // 2. Якщо користувач увійшов і йде на сторінку логіну -> відправляємо на головну
      if (isLoggedIn && isLoggingIn) {
        return '/';
      }

      // 3. В усіх інших випадках нічого не робимо
      return null;
    },

    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => AuthWrapperPage(),
      ),

      ShellRoute(
        builder: (context, state, child) {
          return MainShell(
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: '/lists',
            builder: (context, state) => const ListsPage(),
            routes: [
              GoRoute(
                path: 'create',
                builder: (context, state) => const CreateListPage(),
              ),
              GoRoute(
                path: ':id',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return ShoppingListDetailsPage(listId: id);
                },
                routes: [
                  GoRoute(
                    path: 'edit',
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return EditListPage(listId: id);
                    },
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfilePage(),
          ),
          GoRoute(
            path: '/stats',
            builder: (context, state) => const StatisticsPage()
          )
        ],
        observers: [
          FirebaseAnalyticsObserver(analytics: analytics),
        ],
      ),
    ],
  );
}
