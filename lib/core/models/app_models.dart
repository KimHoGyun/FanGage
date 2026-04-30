enum WearableDeviceType { appleWatch, galaxyWatch }

enum ScheduleType { concert, game, ticket }

class User {
  const User({
    required this.name,
    required this.isGuest,
    required this.favoriteTeam,
  });

  final String name;
  final bool isGuest;
  final String favoriteTeam;
}

class FanPage {
  const FanPage({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.followers,
    required this.isFollowing,
  });

  final String id;
  final String name;
  final String category;
  final String description;
  final int followers;
  final bool isFollowing;
}

class FanPost {
  const FanPost({
    required this.author,
    required this.pageName,
    required this.message,
    required this.likes,
    required this.comments,
    required this.postedAt,
  });

  final String author;
  final String pageName;
  final String message;
  final int likes;
  final int comments;
  final DateTime postedAt;
}

class EventSchedule {
  const EventSchedule({
    required this.id,
    required this.title,
    required this.owner,
    required this.type,
    required this.startsAt,
    required this.location,
    required this.alertEnabled,
    this.result,
  });

  final String id;
  final String title;
  final String owner;
  final ScheduleType type;
  final DateTime startsAt;
  final String location;
  final bool alertEnabled;
  final String? result;
}

class HeartRatePeak {
  const HeartRatePeak({
    required this.rank,
    required this.title,
    required this.recordedAt,
    required this.bpm,
    required this.note,
  });

  final int rank;
  final String title;
  final DateTime recordedAt;
  final int bpm;
  final String note;
}

class MemoryEntry {
  const MemoryEntry({
    required this.id,
    required this.title,
    required this.date,
    required this.location,
    required this.summary,
    required this.gpsVerified,
    required this.peaks,
    this.result,
  });

  final String id;
  final String title;
  final DateTime date;
  final String location;
  final String summary;
  final bool gpsVerified;
  final List<HeartRatePeak> peaks;
  final String? result;
}

class WearableSnapshot {
  const WearableSnapshot({
    required this.deviceType,
    required this.connected,
    required this.syncedAt,
    required this.currentBpm,
    required this.dailyHighBpm,
  });

  final WearableDeviceType deviceType;
  final bool connected;
  final DateTime syncedAt;
  final int currentBpm;
  final int dailyHighBpm;
}
