import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

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
  DateTime _focusedMonth = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final themeName = ref.watch(homeThemeProvider);
    final snapshot = ref.watch(wearableSnapshotProvider);
    final backgroundMode = ref.watch(calendarBackgroundModeProvider);
    final customizations = ref.watch(calendarCustomizationsProvider);
    final dayItems = _eventsForDay(_selectedDay);

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
        _MemoryMonthCalendar(
          focusedMonth: _focusedMonth,
          selectedDay: _selectedDay,
          backgroundMode: backgroundMode,
          customizations: customizations,
          onDaySelected: _openDayCustomizer,
          onMonthChanged: (month) => setState(() => _focusedMonth = month),
          onBackgroundModeChanged:
              (mode) =>
                  ref.read(calendarBackgroundModeProvider.notifier).state =
                      mode,
          eventsForDay: _eventsForDay,
          memoryForDay: _memoryForDay,
        ),
        _SelectedDayCard(date: _selectedDay, items: dayItems),
        _NewsCard(),
        _MemoryPreview(memory: MockData.memories.first),
      ],
    );
  }

  List<Object> _eventsForDay(DateTime day) {
    final schedules = MockData.schedules.where(
      (item) => DateUtils.isSameDay(item.startsAt, day),
    );
    final memories = MockData.memories.where(
      (item) => DateUtils.isSameDay(item.date, day),
    );
    return [...schedules, ...memories];
  }

  MemoryEntry? _memoryForDay(DateTime day) {
    for (final memory in MockData.memories) {
      if (DateUtils.isSameDay(memory.date, day)) {
        return memory;
      }
    }
    return null;
  }

  String _deviceLabel(WearableDeviceType type) {
    return type == WearableDeviceType.appleWatch
        ? 'Apple Watch 연결'
        : 'Galaxy Watch 연결';
  }

  void _openDayCustomizer(DateTime day) {
    setState(() => _selectedDay = day);

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder:
          (context) => Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: SingleChildScrollView(
              child: _DayCustomizeCard(selectedDay: day),
            ),
          ),
    );
  }
}

class _MemoryMonthCalendar extends StatelessWidget {
  const _MemoryMonthCalendar({
    required this.focusedMonth,
    required this.selectedDay,
    required this.backgroundMode,
    required this.customizations,
    required this.onDaySelected,
    required this.onMonthChanged,
    required this.onBackgroundModeChanged,
    required this.eventsForDay,
    required this.memoryForDay,
  });

  final DateTime focusedMonth;
  final DateTime selectedDay;
  final CalendarBackgroundMode backgroundMode;
  final Map<String, CalendarDayCustomization> customizations;
  final ValueChanged<DateTime> onDaySelected;
  final ValueChanged<DateTime> onMonthChanged;
  final ValueChanged<CalendarBackgroundMode> onBackgroundModeChanged;
  final List<Object> Function(DateTime day) eventsForDay;
  final MemoryEntry? Function(DateTime day) memoryForDay;

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(focusedMonth.year, focusedMonth.month);
    final lastDay = DateTime(focusedMonth.year, focusedMonth.month + 1, 0);
    final gridStart = firstDay.subtract(Duration(days: firstDay.weekday % 7));
    final gridEnd = lastDay.add(Duration(days: 6 - (lastDay.weekday % 7)));
    final days = List.generate(
      gridEnd.difference(gridStart).inDays + 1,
      (index) => gridStart.add(Duration(days: index)),
    );

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1F2220),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  DateFormat('yyyy년 M월', 'ko_KR').format(focusedMonth),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              _CalendarModeMenu(
                mode: backgroundMode,
                onSelected: onBackgroundModeChanged,
              ),
              const SizedBox(width: 6),
              IconButton.filledTonal(
                onPressed:
                    () => onMonthChanged(
                      DateTime(focusedMonth.year, focusedMonth.month - 1),
                    ),
                icon: const Icon(Icons.chevron_left),
                tooltip: '이전 달',
              ),
              const SizedBox(width: 6),
              IconButton.filledTonal(
                onPressed:
                    () => onMonthChanged(
                      DateTime(focusedMonth.year, focusedMonth.month + 1),
                    ),
                icon: const Icon(Icons.chevron_right),
                tooltip: '다음 달',
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children:
                const ['일', '월', '화', '수', '목', '금', '토']
                    .map(
                      (day) => Expanded(
                        child: Center(
                          child: Text(
                            day,
                            style: TextStyle(
                              color: Color(0xFFD6D9D3),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
          ),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: days.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 0.82,
            ),
            itemBuilder: (context, index) {
              final day = days[index];
              final key = CalendarCustomizationController.keyFor(day);
              return _CalendarDayTile(
                day: day,
                isCurrentMonth: day.month == focusedMonth.month,
                isSelected: DateUtils.isSameDay(day, selectedDay),
                isToday: DateUtils.isSameDay(day, DateTime.now()),
                events: eventsForDay(day),
                memory: memoryForDay(day),
                customization: customizations[key],
                backgroundMode: backgroundMode,
                onTap: () => onDaySelected(day),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CalendarDayTile extends StatelessWidget {
  const _CalendarDayTile({
    required this.day,
    required this.isCurrentMonth,
    required this.isSelected,
    required this.isToday,
    required this.events,
    required this.memory,
    required this.customization,
    required this.backgroundMode,
    required this.onTap,
  });

  final DateTime day;
  final bool isCurrentMonth;
  final bool isSelected;
  final bool isToday;
  final List<Object> events;
  final MemoryEntry? memory;
  final CalendarDayCustomization? customization;
  final CalendarBackgroundMode backgroundMode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final hasManualBackground =
        backgroundMode == CalendarBackgroundMode.manualPhoto &&
        customization != null;
    final hasAiBackground =
        backgroundMode == CalendarBackgroundMode.aiMemory && memory != null;
    final title =
        customization?.title ??
        (memory != null ? memory!.title : _firstScheduleTitle(events));

    return Padding(
      padding: const EdgeInsets.all(1),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            image:
                hasManualBackground && customization!.imageBytes != null
                    ? DecorationImage(
                      image: MemoryImage(customization!.imageBytes!),
                      fit: BoxFit.cover,
                    )
                    : null,
            gradient:
                hasManualBackground && customization!.imageBytes == null
                    ? _manualGradient(customization!.photoPreset)
                    : hasAiBackground
                    ? _aiGradient(memory!)
                    : null,
            color:
                hasManualBackground || hasAiBackground
                    ? null
                    : const Color(0xFF262927),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color:
                  isSelected
                      ? const Color(0xFFFF6B5F)
                      : const Color(0xFF3B3F3D),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Stack(
            children: [
              if (hasManualBackground || hasAiBackground)
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.28),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: _DayNumber(
                      day: day.day,
                      isToday: isToday,
                      isCurrentMonth: isCurrentMonth,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (title != null)
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withValues(
                          alpha: isCurrentMonth ? 1 : 0.45,
                        ),
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                      ),
                    ),
                  const Spacer(),
                  if (hasAiBackground)
                    const _TinyBadge(label: 'AI')
                  else if (hasManualBackground)
                    const _TinyBadge(label: '사진')
                  else if (events.isNotEmpty)
                    _EventDots(count: events.length),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _firstScheduleTitle(List<Object> events) {
    for (final event in events) {
      if (event is EventSchedule) {
        return event.title;
      }
    }
    return null;
  }

  LinearGradient _manualGradient(CalendarPhotoPreset preset) {
    return switch (preset) {
      CalendarPhotoPreset.concertLights => const LinearGradient(
        colors: [Color(0xFF714DFF), Color(0xFFE74776), Color(0xFFFFB15A)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      CalendarPhotoPreset.stadiumNight => const LinearGradient(
        colors: [Color(0xFF12383A), Color(0xFF267D76), Color(0xFFFFD166)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      CalendarPhotoPreset.cheeringGoods => const LinearGradient(
        colors: [Color(0xFF2F6F6A), Color(0xFF6AA84F), Color(0xFFF4D35E)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    };
  }

  LinearGradient _aiGradient(MemoryEntry memory) {
    final seed = memory.title.codeUnits.fold<int>(0, (sum, unit) => sum + unit);
    final palettes = [
      const [Color(0xFF263E73), Color(0xFFE95D5D), Color(0xFFFFC857)],
      const [Color(0xFF174C4F), Color(0xFF45A29E), Color(0xFFE0B84B)],
      const [Color(0xFF35275E), Color(0xFF8D5A97), Color(0xFFF4A261)],
    ];
    final colors = palettes[seed % palettes.length];
    return LinearGradient(
      colors: colors,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}

class _CalendarModeMenu extends StatelessWidget {
  const _CalendarModeMenu({required this.mode, required this.onSelected});

  final CalendarBackgroundMode mode;
  final ValueChanged<CalendarBackgroundMode> onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<CalendarBackgroundMode>(
      tooltip: '캘린더 배경 설정',
      initialValue: mode,
      onSelected: onSelected,
      itemBuilder:
          (context) => const [
            PopupMenuItem(
              value: CalendarBackgroundMode.none,
              child: ListTile(
                leading: Icon(Icons.grid_view),
                title: Text('기본'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            PopupMenuItem(
              value: CalendarBackgroundMode.manualPhoto,
              child: ListTile(
                leading: Icon(Icons.photo_library_outlined),
                title: Text('직접'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            PopupMenuItem(
              value: CalendarBackgroundMode.aiMemory,
              child: ListTile(
                leading: Icon(Icons.auto_awesome),
                title: Text('AI'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_modeIcon(mode), color: Colors.white, size: 18),
            const SizedBox(width: 5),
            Text(
              _modeLabel(mode),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static IconData _modeIcon(CalendarBackgroundMode mode) {
    return switch (mode) {
      CalendarBackgroundMode.none => Icons.grid_view,
      CalendarBackgroundMode.manualPhoto => Icons.photo_library_outlined,
      CalendarBackgroundMode.aiMemory => Icons.auto_awesome,
    };
  }

  static String _modeLabel(CalendarBackgroundMode mode) {
    return switch (mode) {
      CalendarBackgroundMode.none => '기본',
      CalendarBackgroundMode.manualPhoto => '직접',
      CalendarBackgroundMode.aiMemory => 'AI',
    };
  }
}

class _DayNumber extends StatelessWidget {
  const _DayNumber({
    required this.day,
    required this.isToday,
    required this.isCurrentMonth,
  });

  final int day;
  final bool isToday;
  final bool isCurrentMonth;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      alignment: Alignment.center,
      decoration:
          isToday
              ? const BoxDecoration(
                color: Color(0xFFFF4F45),
                shape: BoxShape.circle,
              )
              : null,
      child: Text(
        '$day',
        style: TextStyle(
          color:
              isToday
                  ? Colors.black
                  : Colors.white.withValues(alpha: isCurrentMonth ? 0.9 : 0.35),
          fontWeight: FontWeight.w900,
          fontSize: 13,
        ),
      ),
    );
  }
}

class _TinyBadge extends StatelessWidget {
  const _TinyBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.42),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _EventDots extends StatelessWidget {
  const _EventDots({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        count.clamp(1, 3),
        (index) => Container(
          width: 5,
          height: 5,
          margin: const EdgeInsets.only(right: 3),
          decoration: const BoxDecoration(
            color: Color(0xFF4EB7E6),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
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

class _DayCustomizeCard extends ConsumerStatefulWidget {
  const _DayCustomizeCard({required this.selectedDay});

  final DateTime selectedDay;

  @override
  ConsumerState<_DayCustomizeCard> createState() => _DayCustomizeCardState();
}

class _DayCustomizeCardState extends ConsumerState<_DayCustomizeCard> {
  late final TextEditingController _titleController;
  late final TextEditingController _noteController;
  CalendarPhotoPreset _preset = CalendarPhotoPreset.concertLights;
  XFile? _pickedPhoto;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _noteController = TextEditingController();
    _syncFields();
  }

  @override
  void didUpdateWidget(covariant _DayCustomizeCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!DateUtils.isSameDay(oldWidget.selectedDay, widget.selectedDay)) {
      _syncFields();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat(
      'M월 d일 EEEE',
      'ko_KR',
    ).format(widget.selectedDay);

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$formattedDate 꾸미기',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: '캘린더에 표시할 내용',
              prefixIcon: Icon(Icons.edit_note),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _noteController,
            minLines: 2,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: '기억 메모',
              prefixIcon: Icon(Icons.notes),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<CalendarPhotoPreset>(
            value: _preset,
            decoration: const InputDecoration(
              labelText: '배경 사진 프리셋',
              prefixIcon: Icon(Icons.image_outlined),
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(
                value: CalendarPhotoPreset.concertLights,
                child: Text('콘서트 조명'),
              ),
              DropdownMenuItem(
                value: CalendarPhotoPreset.stadiumNight,
                child: Text('야구장 밤'),
              ),
              DropdownMenuItem(
                value: CalendarPhotoPreset.cheeringGoods,
                child: Text('응원 굿즈'),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() => _preset = value);
              }
            },
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _pickPhoto,
            icon: const Icon(Icons.add_photo_alternate_outlined),
            label: Text(_pickedPhoto == null ? '배경 사진 선택' : '선택한 사진 변경'),
          ),
          if (_pickedPhoto != null) ...[
            const SizedBox(height: 8),
            Text(
              _pickedPhoto!.name,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _saveCustomization,
              icon: const Icon(Icons.wallpaper_outlined),
              label: const Text('이 날짜 배경으로 저장'),
            ),
          ),
        ],
      ),
    );
  }

  void _syncFields() {
    final key = CalendarCustomizationController.keyFor(widget.selectedDay);
    final customization = ref.read(calendarCustomizationsProvider)[key];
    _titleController.text =
        customization?.title ??
        DateFormat('M월 d일의 기억', 'ko_KR').format(widget.selectedDay);
    _noteController.text = customization?.note ?? '';
    _preset = customization?.photoPreset ?? CalendarPhotoPreset.concertLights;
    _pickedPhoto = null;
  }

  Future<void> _pickPhoto() async {
    final photo = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1400,
      imageQuality: 82,
    );
    if (photo != null && mounted) {
      setState(() => _pickedPhoto = photo);
    }
  }

  Future<void> _saveCustomization() async {
    final key = CalendarCustomizationController.keyFor(widget.selectedDay);
    final previous = ref.read(calendarCustomizationsProvider)[key];
    final imageBytes =
        await _pickedPhoto?.readAsBytes() ?? previous?.imageBytes;
    ref
        .read(calendarCustomizationsProvider.notifier)
        .save(
          CalendarDayCustomization(
            date: widget.selectedDay,
            title:
                _titleController.text.trim().isEmpty
                    ? '나만의 기억'
                    : _titleController.text.trim(),
            note: _noteController.text.trim(),
            photoPreset: _preset,
            imageBytes: imageBytes,
          ),
        );
    ref.read(calendarBackgroundModeProvider.notifier).state =
        CalendarBackgroundMode.manualPhoto;
    if (!mounted) {
      return;
    }
    FocusScope.of(context).unfocus();
    Navigator.of(context).pop();
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
