import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/models/app_models.dart';
import '../../core/state/app_state.dart';
import '../../shared/widgets/screen_layout.dart';
import '../../shared/widgets/section_card.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final device = ref.watch(selectedDeviceProvider);
    final goods = ref.watch(selectedGoodsProvider);
    final notifications = ref.watch(pushNotificationProvider);
    final homeTheme = ref.watch(homeThemeProvider);
    final snapshot = ref.watch(wearableSnapshotProvider);

    return ScreenLayout(
      children: [
        SectionCard(
          child: Row(
            children: [
              const CircleAvatar(radius: 28, child: Icon(Icons.person)),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      user.isGuest ? '비로그인 이용 중' : '팔로잉: ${user.favoriteTeam}',
                    ),
                  ],
                ),
              ),
              FilledButton.tonalIcon(
                onPressed: () {},
                icon: const Icon(Icons.person_add_alt_1),
                label: const Text('친구'),
              ),
            ],
          ),
        ),
        SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '워치 연결',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 12),
              SegmentedButton<WearableDeviceType>(
                segments: const [
                  ButtonSegment(
                    value: WearableDeviceType.appleWatch,
                    icon: Icon(Icons.watch),
                    label: Text('Apple'),
                  ),
                  ButtonSegment(
                    value: WearableDeviceType.galaxyWatch,
                    icon: Icon(Icons.watch_outlined),
                    label: Text('Galaxy'),
                  ),
                ],
                selected: {device},
                onSelectionChanged: (selection) {
                  ref.read(selectedDeviceProvider.notifier).state =
                      selection.first;
                },
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  InfoPill(label: '연결됨', icon: Icons.bluetooth_connected),
                  InfoPill(
                    label: '${snapshot.currentBpm} bpm',
                    icon: Icons.favorite,
                    color: Colors.redAccent,
                  ),
                  InfoPill(
                    label:
                        '동기화 ${DateFormat('HH:mm').format(snapshot.syncedAt)}',
                    icon: Icons.sync,
                  ),
                ],
              ),
            ],
          ),
        ),
        SectionCard(
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: goods,
                decoration: const InputDecoration(
                  labelText: '착용 중인 굿즈',
                  prefixIcon: Icon(Icons.workspace_premium_outlined),
                ),
                items: const [
                  DropdownMenuItem(value: '응원 팔찌', child: Text('응원 팔찌')),
                  DropdownMenuItem(value: '팀 유니폼', child: Text('팀 유니폼')),
                  DropdownMenuItem(value: '공식 라이트스틱', child: Text('공식 라이트스틱')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    ref.read(selectedGoodsProvider.notifier).state = value;
                  }
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: homeTheme,
                decoration: const InputDecoration(
                  labelText: '홈 꾸미기 테마',
                  prefixIcon: Icon(Icons.palette_outlined),
                ),
                items: const [
                  DropdownMenuItem(value: '민트 응원 테마', child: Text('민트 응원 테마')),
                  DropdownMenuItem(value: '스테이지 블랙', child: Text('스테이지 블랙')),
                  DropdownMenuItem(value: '클래식 야구장', child: Text('클래식 야구장')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    ref.read(homeThemeProvider.notifier).state = value;
                  }
                },
              ),
            ],
          ),
        ),
        SectionCard(
          child: SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: notifications,
            onChanged: (value) {
              ref.read(pushNotificationProvider.notifier).state = value;
            },
            title: const Text('일정 및 티켓 알림'),
            subtitle: const Text('팔로잉한 그룹과 팀의 주요 일정을 알려줍니다.'),
            secondary: const Icon(Icons.notifications_active_outlined),
          ),
        ),
      ],
    );
  }
}
