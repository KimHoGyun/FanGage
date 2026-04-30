import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainScaffold extends StatelessWidget {
  const MainScaffold({super.key, required this.location, required this.child});

  final String location;
  final Widget child;

  static const _routes = ['/home', '/fan', '/schedule', '/memory', '/profile'];
  static const _titles = ['홈', '팬 페이지', '관심 일정', '나의 기억', '마이페이지'];

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _selectedIndex(location);

    return Scaffold(
      appBar: AppBar(title: Text(_titles[selectedIndex])),
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) => context.go(_routes[index]),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: '홈',
          ),
          NavigationDestination(
            icon: Icon(Icons.groups_2_outlined),
            selectedIcon: Icon(Icons.groups_2),
            label: '팬',
          ),
          NavigationDestination(
            icon: Icon(Icons.event_note_outlined),
            selectedIcon: Icon(Icons.event_note),
            label: '일정',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: '기억',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: '마이',
          ),
        ],
      ),
    );
  }

  int _selectedIndex(String path) {
    final index = _routes.indexWhere(path.startsWith);
    return index < 0 ? 0 : index;
  }
}
