import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'features/auth/auth_screen.dart';
import 'features/fan/fan_page_screen.dart';
import 'features/home/home_screen.dart';
import 'features/memory/memory_screen.dart';
import 'features/navigation/main_scaffold.dart';
import 'features/profile/profile_screen.dart';
import 'features/schedule/schedule_screen.dart';
import 'core/state/app_state.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const AuthScreen()),
      ShellRoute(
        builder:
            (context, state, child) =>
                MainScaffold(location: state.uri.path, child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/fan',
            builder: (context, state) => const FanPageScreen(),
          ),
          GoRoute(
            path: '/schedule',
            builder: (context, state) => const ScheduleScreen(),
          ),
          GoRoute(
            path: '/memory',
            builder: (context, state) => const MemoryScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
    ],
  );
});

class FanMemoryApp extends ConsumerWidget {
  const FanMemoryApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final settings = ref.watch(settingsRepositoryProvider);

    ref.listen(selectedDeviceProvider, (_, next) {
      settings.setDeviceType(next);
    });
    ref.listen(selectedGoodsProvider, (_, next) {
      settings.setSelectedGoods(next);
    });
    ref.listen(pushNotificationProvider, (_, next) {
      settings.setPushNotifications(next);
    });
    ref.listen(homeThemeProvider, (_, next) {
      settings.setHomeTheme(next);
    });
    ref.listen(calendarBackgroundModeProvider, (_, next) {
      settings.setCalendarBackgroundMode(next);
    });

    return MaterialApp.router(
      title: 'Fan Memory',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ko', 'KR'), Locale('en', 'US')],
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2F6F6A),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F8F3),
        cardTheme: CardTheme(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          backgroundColor: Color(0xFFF7F8F3),
          surfaceTintColor: Colors.transparent,
          titleTextStyle: TextStyle(
            color: Color(0xFF1B1D1C),
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
