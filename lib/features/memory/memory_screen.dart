import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/mock/mock_data.dart';
import '../../core/models/app_models.dart';
import '../../shared/widgets/screen_layout.dart';
import '../../shared/widgets/section_card.dart';

class MemoryScreen extends StatelessWidget {
  const MemoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenLayout(
      children: [
        SectionCard(
          child: Row(
            children: [
              const Icon(Icons.location_on_outlined),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'GPS 행사 참여 인증',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text('현재 위치가 행사장 반경 안이면 자동으로 캘린더에 기록됩니다.'),
                  ],
                ),
              ),
              const Icon(Icons.verified, color: Color(0xFF2F6F6A)),
            ],
          ),
        ),
        ...MockData.memories.map((memory) => _MemoryCard(memory: memory)),
      ],
    );
  }
}

class _MemoryCard extends StatelessWidget {
  const _MemoryCard({required this.memory});

  final MemoryEntry memory;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      memory.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      DateFormat(
                        'yyyy년 M월 d일 HH:mm',
                        'ko_KR',
                      ).format(memory.date),
                    ),
                  ],
                ),
              ),
              if (memory.gpsVerified)
                const InfoPill(label: 'GPS 인증', icon: Icons.verified_outlined),
            ],
          ),
          const SizedBox(height: 12),
          Text(memory.summary),
          const SizedBox(height: 12),
          if (memory.result != null)
            InfoPill(label: memory.result!, icon: Icons.emoji_events_outlined),
          const SizedBox(height: 14),
          Text(
            '가장 뜨거웠던 순간 TOP3',
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          ...memory.peaks.map(
            (peak) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(child: Text('${peak.rank}')),
              title: Text('${peak.title} · ${peak.bpm} bpm'),
              subtitle: Text(
                '${DateFormat('HH:mm').format(peak.recordedAt)} · ${peak.note}',
              ),
              trailing: const Icon(Icons.favorite, color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }
}
