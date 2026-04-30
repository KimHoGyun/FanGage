import '../models/app_models.dart';

class MockData {
  static final now = DateTime.now();

  static const user = User(name: '하린', isGuest: false, favoriteTeam: '서울 스타즈');

  static const fanPages = [
    FanPage(
      id: 'stars',
      name: '서울 스타즈',
      category: '야구',
      description: '직관 후기, 응원법, 굿즈 정보를 나누는 팬 페이지',
      followers: 18420,
      isFollowing: true,
    ),
    FanPage(
      id: 'aurora',
      name: 'AURORA',
      category: '아이돌',
      description: '콘서트 일정과 무대 순간을 함께 기록하는 팬 페이지',
      followers: 42310,
      isFollowing: true,
    ),
    FanPage(
      id: 'bluewhales',
      name: '부산 블루웨일즈',
      category: '축구',
      description: '원정 경기와 티켓 오픈 알림 중심 커뮤니티',
      followers: 12880,
      isFollowing: false,
    ),
  ];

  static final fanPosts = [
    FanPost(
      author: '민재',
      pageName: '서울 스타즈',
      message: '오늘 8회 응원 소리 진짜 최고였어요. 심박수도 같이 터졌습니다.',
      likes: 92,
      comments: 18,
      postedAt: now.subtract(const Duration(hours: 3)),
    ),
    FanPost(
      author: '유나',
      pageName: 'AURORA',
      message: '앙코르 때 워치 기록이 151bpm 찍혔어요. 나의 기억에 바로 저장!',
      likes: 138,
      comments: 31,
      postedAt: now.subtract(const Duration(hours: 7)),
    ),
    FanPost(
      author: '도윤',
      pageName: '서울 스타즈',
      message: '다음 홈경기 티켓 오픈 알림 켜두세요. 5월 4일 오후 2시입니다.',
      likes: 57,
      comments: 9,
      postedAt: now.subtract(const Duration(days: 1)),
    ),
  ];

  static final schedules = [
    EventSchedule(
      id: 'ticket-aurora',
      title: 'AURORA 서울 콘서트 티켓 오픈',
      owner: 'AURORA',
      type: ScheduleType.ticket,
      startsAt: DateTime(now.year, now.month, now.day + 2, 14),
      location: '온라인 예매',
      alertEnabled: true,
    ),
    EventSchedule(
      id: 'stars-game',
      title: '서울 스타즈 vs 인천 포스',
      owner: '서울 스타즈',
      type: ScheduleType.game,
      startsAt: DateTime(now.year, now.month, now.day + 4, 18, 30),
      location: '잠실 야구장',
      alertEnabled: true,
    ),
    EventSchedule(
      id: 'aurora-concert',
      title: 'AURORA LIVE: Bloom Night',
      owner: 'AURORA',
      type: ScheduleType.concert,
      startsAt: DateTime(now.year, now.month, now.day + 8, 19),
      location: 'KSPO DOME',
      alertEnabled: false,
    ),
  ];

  static final memories = [
    MemoryEntry(
      id: 'stars-memory',
      title: '서울 스타즈 역전승 직관',
      date: DateTime(now.year, now.month, now.day - 2, 18, 30),
      location: '잠실 야구장',
      summary: '9회말 끝내기 안타로 완성된 시즌 최고의 직관 기록',
      gpsVerified: true,
      result: '서울 스타즈 7 : 6 인천 포스',
      peaks: [
        HeartRatePeak(
          rank: 1,
          title: '끝내기 안타',
          recordedAt: DateTime(now.year, now.month, now.day - 2, 21, 42),
          bpm: 162,
          note: '응원석 전체가 일어난 순간',
        ),
        HeartRatePeak(
          rank: 2,
          title: '동점 홈런',
          recordedAt: DateTime(now.year, now.month, now.day - 2, 20, 58),
          bpm: 151,
          note: '7회말 분위기가 완전히 바뀜',
        ),
        HeartRatePeak(
          rank: 3,
          title: '만루 위기 탈출',
          recordedAt: DateTime(now.year, now.month, now.day - 2, 19, 36),
          bpm: 144,
          note: '수비 성공 직후 기록',
        ),
      ],
    ),
    MemoryEntry(
      id: 'aurora-memory',
      title: 'AURORA 팬미팅',
      date: DateTime(now.year, now.month, now.day - 9, 17),
      location: '올림픽공원',
      summary: '첫 팬미팅 참여와 포토카드 교환까지 남긴 하루',
      gpsVerified: true,
      result: '앙코르 2곡 추가 진행',
      peaks: [
        HeartRatePeak(
          rank: 1,
          title: '최애 멤버 인사',
          recordedAt: DateTime(now.year, now.month, now.day - 9, 18, 12),
          bpm: 155,
          note: '무대 중앙 돌출 구간',
        ),
        HeartRatePeak(
          rank: 2,
          title: '단체 슬로건 이벤트',
          recordedAt: DateTime(now.year, now.month, now.day - 9, 19, 6),
          bpm: 148,
          note: '팬들이 함께 만든 장면',
        ),
        HeartRatePeak(
          rank: 3,
          title: '포토타임',
          recordedAt: DateTime(now.year, now.month, now.day - 9, 17, 40),
          bpm: 137,
          note: '가장 가까이 본 순간',
        ),
      ],
    ),
  ];
}
