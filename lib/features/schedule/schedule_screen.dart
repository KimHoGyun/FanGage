import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/mock/mock_data.dart';
import '../../core/models/app_models.dart';
import '../../shared/widgets/screen_layout.dart';
import '../../shared/widgets/section_card.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.confirmation_number_outlined), text: '티켓'),
              Tab(icon: Icon(Icons.mic_external_on_outlined), text: '공연'),
              Tab(icon: Icon(Icons.sports_baseball_outlined), text: '경기'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _ScheduleList(type: ScheduleType.ticket),
                _ScheduleList(type: ScheduleType.concert),
                _ScheduleList(type: ScheduleType.game),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScheduleList extends StatelessWidget {
  const _ScheduleList({required this.type});

  final ScheduleType type;

  @override
  Widget build(BuildContext context) {
    final items =
        MockData.schedules.where((item) => item.type == type).toList();

    return ScreenLayout(
      children:
          items
              .map(
                (item) => SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            _iconFor(item.type),
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text('${item.owner} · ${item.location}'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          InfoPill(
                            label: DateFormat(
                              'M월 d일 HH:mm',
                              'ko_KR',
                            ).format(item.startsAt),
                            icon: Icons.schedule,
                          ),
                          InfoPill(
                            label: item.alertEnabled ? '알림 켜짐' : '알림 꺼짐',
                            icon:
                                item.alertEnabled
                                    ? Icons.notifications_active_outlined
                                    : Icons.notifications_off_outlined,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
    );
  }

  IconData _iconFor(ScheduleType type) {
    return switch (type) {
      ScheduleType.ticket => Icons.confirmation_number_outlined,
      ScheduleType.concert => Icons.mic_external_on_outlined,
      ScheduleType.game => Icons.sports_baseball_outlined,
    };
  }
}
