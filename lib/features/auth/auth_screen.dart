import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/app_models.dart';
import '../../core/state/app_state.dart';

class AuthScreen extends ConsumerWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Icon(Icons.watch_outlined, size: 56, color: scheme.primary),
              const SizedBox(height: 22),
              Text(
                'Fan Memory',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF17211F),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '공연과 경기를 다녀온 순간을 캘린더, 위치, 심박수 기록으로 남겨요.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: const Color(0xFF5E6966),
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 36),
              FilledButton.icon(
                onPressed: () {
                  ref.read(currentUserProvider.notifier).state = const User(
                    name: '하린',
                    isGuest: false,
                    favoriteTeam: '서울 스타즈',
                  );
                  context.go('/home');
                },
                icon: const Icon(Icons.login),
                label: const Text('로그인하고 시작'),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () {
                  ref.read(currentUserProvider.notifier).state = const User(
                    name: '게스트',
                    isGuest: true,
                    favoriteTeam: 'AURORA',
                  );
                  context.go('/home');
                },
                icon: const Icon(Icons.person_outline),
                label: const Text('비로그인으로 둘러보기'),
              ),
              const Spacer(),
              Text(
                'Apple Watch · Galaxy Watch mock data',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: const Color(0xFF79837F),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
