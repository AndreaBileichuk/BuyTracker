import 'package:buy_tracker/core/providers/AuthProvider.dart';
import 'package:buy_tracker/FirebaseOptions.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/providers/ShoppingListsProvider.dart';
import 'features/AppRouter.dart';

import 'features/reminders/providers/RemindersProvider.dart';
import 'core/services/NotificationService.dart';
import 'core/theme/AppTheme.dart';
import 'core/providers/ThemeProvider.dart';

late FirebaseAnalytics analytics;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
  );

  // Ініціалізуємо Firebase Analytics
  analytics = FirebaseAnalytics.instance;

  // Ініціалізуємо локальні сповіщення
  await NotificationService().init();

  // Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AppAuthProvider()),
        ChangeNotifierProxyProvider<AppAuthProvider, ShoppingListsProvider>(
          create: (_) => ShoppingListsProvider(),
          update: (context, auth, previousListsProvider) {
            return previousListsProvider!..updateUser(auth.currentUser);
          },
        ),
        ChangeNotifierProvider(create: (_) => RemindersProvider()),
      ],
      child: Consumer2<AppAuthProvider, ThemeProvider>(
        builder: (context, authProvider, themeProvider, _) {
          final router = AppRouter(authProvider).router;

          return MaterialApp.router(
            title: 'Buy Tracker',
            theme: themeProvider.currentTheme,
            routerConfig: router,
          );
        },
      ),
    );
  }
}
