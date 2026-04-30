import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../core/mock/mock_data.dart';
import '../../core/models/app_models.dart';
import '../../core/state/app_state.dart';
import '../../shared/widgets/screen_layout.dart';
import '../../shared/widgets/section_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final themeName = ref.watch(homeThemeProvider);
    final snapshot = ref.watch(wearableSnapshotProvider);
    final selected = _selectedDay ?? DateTime.now();
    final dayItems = _eventsForDay(selected);

    return ScreenLayout(
      children: [
        SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${user.name}님의 팬 캘린더',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  InfoPill(label: themeName, icon: Icons.palette_outlined),
                  InfoPill(
                    label: _deviceLabel(snapshot.deviceType),
                    icon: Icons.watch_outlined,
                  ),
                  InfoPill(
                    label: '현재 ${snapshot.currentBpm} bpm',
                    icon: Icons.favorite,
                    color: Colors.redAccent,
                  ),
                ],
              ),
            ],
          ),
        ),
        SectionCard(
          padding: const EdgeInsets.fromLTRB(8, 10, 8, 8),
          child: TableCalendar<Object>(
            locale: 'ko_KR',
            firstDay: DateTime.utc(2024, 1, 1),
            lastDay: DateTime.utc(2027, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            eventLoader: _eventsForDay,
            calendarFormat: CalendarFormat.month,
            availableCalendarFormats: const {CalendarFormat.month: '월'},
            headerStyle: const HeaderStyle(
              titleCentered: true,
              formatButtonVisible: false,
            ),
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.18),
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              markerDecoration: const BoxDecoration(
                color: Color(0xFFE06D3C),
                shape: BoxShape.circle,
              ),
            ),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
          ),
        ),
        _SelectedDayCard(date: selected, items: dayItems),
        _NewsCard(),
        _MemoryPreview(memory: MockData.memories.first),
      ],
    );
  }

  List<Object> _eventsForDay(DateTime day) {
    final schedules = MockData.schedules.where(
      (item) => isSameDay(item.startsAt, day),
    );
    final memories = MockData.memories.where(
      (item) => isSameDay(item.date, day),
    );
    return [...schedules, ...memories];
  }

  String _deviceLabel(WearableDeviceType type) {
    return type == WearableDeviceType.appleWatch
        ? 'Apple Watch 연결'
        : 'Galaxy Watch 연결';
  }
}

class _SelectedDayCard extends StatelessWidget {
  const _SelectedDayCard({required this.date, required this.items});

  final DateTime date;
  final List<Object> items;

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('M월 d일 EEEE', 'ko_KR');

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            formatter.format(date),
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          if (items.isEmpty)
            const Text('표시할 일정이나 기억이 없습니다.')
          else
            ...items.map((item) {
              final title =
                  item is EventSchedule
                      ? item.title
                      : (item as MemoryEntry).title;
              final location =
                  item is EventSchedule
                      ? item.location
                      : (item as MemoryEntry).location;
              final icon =
                  item is EventSchedule
                      ? Icons.event_available
                      : Icons.auto_awesome;
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(icon),
                title: Text(title),
                subtitle: Text(location),
              );
            }),
        ],
      ),
    );
  }
}

class _NewsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '간단한 소식',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          const ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.confirmation_number_outlined),
            title: Text('AURORA 서울 콘서트 티켓 오픈 D-2'),
            subtitle: Text('알림이 켜져 있어 예매 30분 전에 알려드려요.'),
          ),
          const Divider(height: 12),
          const ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.sports_baseball_outlined),
            title: Text('서울 스타즈 홈 3연전 일정 공개'),
            subtitle: Text('팔로잉 팀 일정이 관심 일정에 추가되었습니다.'),
          ),
        ],
      ),
    );
  }
}

class _MemoryPreview extends StatelessWidget {
  const _MemoryPreview({required this.memory});

  final MemoryEntry memory;

  @override
  Widget build(BuildContext context) {
    final peak = memory.peaks.first;

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '지난 기억 미리보기',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          Text(
            memory.title,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(memory.summary),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              InfoPill(label: 'GPS 인증 완료', icon: Icons.location_on_outlined),
              InfoPill(
                label: '최고 ${peak.bpm} bpm',
                icon: Icons.favorite,
                color: Colors.redAccent,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
