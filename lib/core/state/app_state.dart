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

final wearableDataServiceProvider = Provider<WearableDataService>(
  (ref) => MockWearableDataService(),
);

final wearableSnapshotProvider = Provider<WearableSnapshot>((ref) {
  final deviceType = ref.watch(selectedDeviceProvider);
  return ref.watch(wearableDataServiceProvider).snapshotFor(deviceType);
});
