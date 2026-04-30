import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_models.dart';

class SettingsRepository {
  SettingsRepository(this._preferences);
  SettingsRepository.memory() : _preferences = null;

  final SharedPreferences? _preferences;
  final Map<String, Object> _memory = {};

  static const _deviceKey = 'selectedDevice';
  static const _goodsKey = 'selectedGoods';
  static const _notificationsKey = 'pushNotifications';
  static const _themeKey = 'homeTheme';
  static const _calendarBackgroundModeKey = 'calendarBackgroundMode';

  WearableDeviceType get deviceType {
    final value = _readString(_deviceKey);
    return value == WearableDeviceType.galaxyWatch.name
        ? WearableDeviceType.galaxyWatch
        : WearableDeviceType.appleWatch;
  }

  String get selectedGoods => _readString(_goodsKey) ?? '응원 팔찌';
  bool get pushNotifications => _readBool(_notificationsKey) ?? true;
  String get homeTheme => _readString(_themeKey) ?? '민트 응원 테마';
  CalendarBackgroundMode get calendarBackgroundMode {
    final value = _readString(_calendarBackgroundModeKey);
    return CalendarBackgroundMode.values.firstWhere(
      (mode) => mode.name == value,
      orElse: () => CalendarBackgroundMode.aiMemory,
    );
  }

  Future<void> setDeviceType(WearableDeviceType type) {
    return _writeString(_deviceKey, type.name);
  }

  Future<void> setSelectedGoods(String value) {
    return _writeString(_goodsKey, value);
  }

  Future<void> setPushNotifications(bool value) {
    return _writeBool(_notificationsKey, value);
  }

  Future<void> setHomeTheme(String value) {
    return _writeString(_themeKey, value);
  }

  Future<void> setCalendarBackgroundMode(CalendarBackgroundMode value) {
    return _writeString(_calendarBackgroundModeKey, value.name);
  }

  String? _readString(String key) {
    return _preferences?.getString(key) ?? _memory[key] as String?;
  }

  bool? _readBool(String key) {
    return _preferences?.getBool(key) ?? _memory[key] as bool?;
  }

  Future<void> _writeString(String key, String value) async {
    _memory[key] = value;
    await _preferences?.setString(key, value);
  }

  Future<void> _writeBool(String key, bool value) async {
    _memory[key] = value;
    await _preferences?.setBool(key, value);
  }
}
