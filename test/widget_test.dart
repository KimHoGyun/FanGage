import 'package:fan_memory_app/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('guest can enter and navigate MVP tabs', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: FanMemoryApp()));
    await tester.pumpAndSettle();

    expect(find.text('Fan Memory'), findsOneWidget);

    await tester.tap(find.text('비로그인으로 둘러보기'));
    await tester.pumpAndSettle();
    expect(find.text('게스트님의 팬 캘린더'), findsOneWidget);

    await tester.tap(find.text('팬'));
    await tester.pumpAndSettle();
    expect(find.text('팔로잉 팬 페이지'), findsOneWidget);

    await tester.tap(find.text('일정'));
    await tester.pumpAndSettle();
    expect(find.text('티켓'), findsWidgets);

    await tester.tap(find.text('기억'));
    await tester.pumpAndSettle();
    expect(find.text('GPS 행사 참여 인증'), findsOneWidget);

    await tester.tap(find.text('마이'));
    await tester.pumpAndSettle();
    expect(find.text('워치 연결'), findsOneWidget);
  });
}
