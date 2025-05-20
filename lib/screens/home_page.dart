import 'package:flutter/material.dart';
import 'profile_page.dart';
import 'achievements_screen.dart';
import 'tasks_screen.dart';
import 'progress_screen.dart';
import 'timetable_page.dart';

class MyHomePage extends StatefulWidget {
  final VoidCallback? onThemeToggle;
  final String selectedTheme;

  const MyHomePage({
    super.key,
    this.onThemeToggle,
    required this.selectedTheme,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late PageController _pageController;
  int _selectedIndex = 0;

  final List<String> _labels = ['Home', 'Tasks', 'Achievements', 'Profile'];
  late final Map<String, List<String>> _iconAssets;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _iconAssets = {
      'STUDENT DISPLAY': [
        'assets/nav_icons/student/home.png',
        'assets/nav_icons/student/tasks.png',
        'assets/nav_icons/student/achievements.png',
        'assets/nav_icons/student/profile.png',
      ],
      'Park Display': [
        'assets/nav_icons/park/home.png',
        'assets/nav_icons/park/tasks.png',
        'assets/nav_icons/park/achievements.png',
        'assets/nav_icons/park/profile.png',
      ],
      'Game Display': [
        'assets/nav_icons/game/home.png',
        'assets/nav_icons/game/tasks.png',
        'assets/nav_icons/game/achievements.png',
        'assets/nav_icons/game/profile.png',
      ],
    };
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  Widget _buildNavItem(int index) {
    final bool isSelected = _selectedIndex == index;
    final iconPath = _iconAssets[widget.selectedTheme]?[index] ?? '';

    return Expanded(
      child: InkWell(
        onTap: () => _onItemTapped(index),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                iconPath,
                height: 24,
                color: isSelected ? _getThemeColor() : Colors.grey,
              ),
              const SizedBox(height: 4),
              if (isSelected)
                Text(
                  _labels[index],
                  style: TextStyle(
                    fontSize: 12,
                    color: _getThemeColor(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _getThemeDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: _getThemeColor(),
          title: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 35,
                    height: 35,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                _labels[_selectedIndex],
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.white),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("No new notifications.")),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.brightness_6, color: Colors.white),
              onPressed: widget.onThemeToggle ?? () {},
            ),
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Menu not implemented.")),
                );
              },
            ),
          ],
        ),
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) => setState(() => _selectedIndex = index),
          children: [
            _buildHomePage(context, _getFeatureIcons()),
            const TasksScreen(),
            const AchievementsScreen(),
            const ProfilePage(),
          ],
        ),
        bottomNavigationBar: Container(
          color: Colors.white,
          child: Row(
            children:
                List.generate(_labels.length, (index) => _buildNavItem(index)),
          ),
        ),
      ),
    );
  }

  Widget _buildHomePage(BuildContext context, Map<String, IconData> icons) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Image.asset(_getLogoAsset(), height: 150),
            const SizedBox(height: 24),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 20,
              runSpacing: 16,
              children: [
                _buildFeatureCard('Practice Zone', Colors.orange,
                    icons['practice']!, () => const TasksScreen()),
                _buildFeatureCard('Test Zone', Colors.pinkAccent,
                    icons['test']!, () => const TasksScreen()),
                _buildFeatureCard('Doubts Section', Colors.teal,
                    icons['doubts']!, () => const TasksScreen()),
                _buildFeatureCard('Reports', Colors.blue, icons['reports']!,
                    () => const TasksScreen()),
                _buildFeatureCard('Classtable', Colors.purple,
                    icons['timetable']!, () => TimetablePage()),
                _buildFeatureCard('Progress', Colors.yellow[700]!,
                    icons['progress']!, () => ProgressZonePage()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
      String title, Color color, IconData icon, Widget Function() pageBuilder) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.4,
      height: 120,
      child: InkWell(
        onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => pageBuilder())),
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: Colors.white),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getThemeColor() {
    switch (widget.selectedTheme) {
      case 'STUDENT DISPLAY':
        return Colors.blue;
      case 'Park Display':
        return Colors.green;
      case 'Game Display':
        return Colors.deepOrange;
      default:
        return Colors.blue;
    }
  }

  BoxDecoration _getThemeDecoration() {
    switch (widget.selectedTheme) {
      case 'STUDENT DISPLAY':
        return const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE0F7FA), Colors.white],
          ),
        );
      case 'Park Display':
        return const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF81C784), Color(0xFFA5D6A7)],
          ),
        );
      case 'Game Display':
        return const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFF8A65), Color(0xFFFFAB91)],
          ),
        );
      default:
        return const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE0F7FA), Colors.white],
          ),
        );
    }
  }

  String _getLogoAsset() {
    switch (widget.selectedTheme) {
      case 'STUDENT DISPLAY':
        return 'assets/logo/logo_student.png';
      case 'Park Display':
        return 'assets/logo/logo_park.png';
      case 'Game Display':
        return 'assets/logo/logo_game.png';
      default:
        return 'assets/images/logo.png';
    }
  }

  Map<String, IconData> _getFeatureIcons() {
    switch (widget.selectedTheme) {
      case 'Park Display':
        return {
          'practice': Icons.eco,
          'test': Icons.bug_report,
          'doubts': Icons.nature_people,
          'reports': Icons.park,
          'timetable': Icons.grass,
          'progress': Icons.spa,
        };
      case 'Game Display':
        return {
          'practice': Icons.sports_esports,
          'test': Icons.videogame_asset,
          'doubts': Icons.help,
          'reports': Icons.leaderboard,
          'timetable': Icons.timer,
          'progress': Icons.trending_up,
        };
      case 'STUDENT DISPLAY':
      default:
        return {
          'practice': Icons.auto_graph,
          'test': Icons.science,
          'doubts': Icons.question_answer,
          'reports': Icons.bar_chart,
          'timetable': Icons.schedule,
          'progress': Icons.show_chart,
        };
    }
  }
}
