import 'package:flutter/material.dart';
import 'profile_page.dart';
import 'achievements_screen.dart';
import 'tasks_screen.dart';
import 'progress_screen.dart';
import 'timetable_page.dart';
import 'chat_bubble.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 6, 114, 177), // Light blue shade
            Colors.white,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: AppBar(
            backgroundColor: Colors.blue,
            title: const Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: ClipOval(
                    child: Image(
                      image: AssetImage('assets/images/logo.png'),
                      width: 35,
                      height: 35,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Achivers',
                      style: TextStyle(fontSize: 26, color: Colors.white),
                    ),
                  ],
                ),
                Spacer(),
                Icon(Icons.notifications, color: Colors.white),
                SizedBox(width: 8),
                Icon(Icons.menu, color: Colors.white),
              ],
            ),
          ),
        ),
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _selectedIndex = index);
          },
          children: <Widget>[
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Image.asset('assets/images/logo.png',
                        height: 180), // use your actual path
                    const SizedBox(height: 24),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 20,
                      runSpacing: 16,
                      children: [
                        _buildFeatureCard(
                            'Practice Zone', Colors.orange, Icons.auto_graph),
                        _buildFeatureCard(
                            'Test Zone', Colors.pinkAccent, Icons.science),
                        _buildFeatureCard('Doubts Section', Colors.teal,
                            Icons.question_answer),
                        _buildFeatureCard(
                            'Reports', Colors.blue, Icons.bar_chart),
                        _buildFeatureCard(
                            'Classtable', Colors.purple, Icons.schedule),
                        _buildFeatureCard(
                            'Progress', Colors.yellow[700]!, Icons.show_chart),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const TasksScreen(),
            const AchievementsScreen(),
            const ProfilePage(),
          ],
        ),
        bottomNavigationBar: Container(
          constraints: const BoxConstraints(maxHeight: 65),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: BottomNavigationBar(
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                    backgroundColor: Colors.blue,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.assignment),
                    label: 'Tasks',
                    backgroundColor: Colors.blue,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.emoji_events),
                    label: 'Achievements',
                    backgroundColor: Colors.blue,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Profile',
                    backgroundColor: Colors.blue,
                  ),
                ],
                currentIndex: _selectedIndex,
                selectedItemColor: Colors.blue,
                unselectedItemColor: Colors.grey,
                onTap: _onItemTapped,
                type: BottomNavigationBarType.fixed,
                elevation: 0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(String title, Color color, IconData icon) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = MediaQuery.of(context).size.width;
        double cardWidth = screenWidth * 0.4; // 40% of screen width
        double cardHeight = 120; // Or use screenHeight * 0.x

        return SizedBox(
          width: cardWidth,
          height: cardHeight,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => switch (title) {
                    'Progress' => ProgressZonePage(),
                    'Practice Zone' => const TasksScreen(),
                    'Test Zone' => const TasksScreen(),
                    'Doubts Section' => DoubtsPage(),
                    'Reports' => const TasksScreen(),
                    'Classtable' => TimetablePage(),
                    _ => throw Exception('Unknown route: $title'),
                  },
                ),
              );
            },
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
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
