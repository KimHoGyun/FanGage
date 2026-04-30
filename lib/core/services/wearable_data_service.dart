import '../models/app_models.dart';

abstract class WearableDataService {
  WearableSnapshot snapshotFor(WearableDeviceType deviceType);
}

class MockWearableDataService implements WearableDataService {
  @override
  WearableSnapshot snapshotFor(WearableDeviceType deviceType) {
    final now = DateTime.now();
    final isApple = deviceType == WearableDeviceType.appleWatch;

    return WearableSnapshot(
      deviceType: deviceType,
      connected: true,
      syncedAt: now.subtract(Duration(minutes: isApple ? 2 : 5)),
      currentBpm: isApple ? 83 : 88,
      dailyHighBpm: isApple ? 162 : 158,
    );
  }
}
