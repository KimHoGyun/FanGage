import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../mock/mock_data.dart';
import '../models/app_models.dart';
import '../services/settings_repository.dart';
import '../services/wearable_data_service.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepository.memory(),
);

final currentUserProvider = StateProvider<User>((ref) => MockData.user);
final selectedDeviceProvider = StateProvider<WearableDeviceType>(
  (ref) => ref.watch(settingsRepositoryProvider).deviceType,
);
final selectedGoodsProvider = StateProvider<String>(
  (ref) => ref.watch(settingsRepositoryProvider).selectedGoods,
);
final pushNotificationProvider = StateProvider<bool>(
  (ref) => ref.watch(settingsRepositoryProvider).pushNotifications,
);
final homeThemeProvider = StateProvider<String>(
  (ref) => ref.watch(settingsRepositoryProvider).homeTheme,
);
final calendarBackgroundModeProvider = StateProvider<CalendarBackgroundMode>(
  (ref) => ref.watch(settingsRepositoryProvider).calendarBackgroundMode,
);
final calendarCustomizationsProvider = StateNotifierProvider<
  CalendarCustomizationController,
  Map<String, CalendarDayCustomization>
>((ref) => CalendarCustomizationController());

final wearableDataServiceProvider = Provider<WearableDataService>(
  (ref) => MockWearableDataService(),
);

final wearableSnapshotProvider = Provider<WearableSnapshot>((ref) {
  final deviceType = ref.watch(selectedDeviceProvider);
  return ref.watch(wearableDataServiceProvider).snapshotFor(deviceType);
});

class CalendarCustomizationController
    extends StateNotifier<Map<String, CalendarDayCustomization>> {
  CalendarCustomizationController()
    : super({
        _key(DateTime.now()): CalendarDayCustomization(
          date: DateTime.now(),
          title: '오늘의 응원 배경',
          note: '직접 꾸민 캘린더 배경 예시',
          photoPreset: CalendarPhotoPreset.cheeringGoods,
        ),
      });

  void save(CalendarDayCustomization customization) {
    state = {...state, _key(customization.date): customization};
  }

  static String keyFor(DateTime date) => _key(date);

  static String _key(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
