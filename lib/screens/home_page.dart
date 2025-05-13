import 'package:flutter/material.dart';
import 'profile_page.dart';
import 'achievements_screen.dart';
import 'tasks_screen.dart';

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
    return Scaffold(
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatCard('2,450', 'XP', Icons.star),
                      _buildStatCard('15', 'Badges', Icons.military_tech),
                      _buildStatCard('8th', 'Rank', Icons.emoji_events),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Top Learners',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildLeaderboard(),
                  const SizedBox(height: 24),
                  const Text(
                    'Progress Report',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildProgressReport(),
                  const SizedBox(height: 24),
                  const Text(
                    'Recent Achievements',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildRecentAchievements(),
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
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.blue, size: 30),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTopLearner('Sarah', '3,200 XP', true),
              _buildTopLearner('Alex', '3,500 XP', true),
              _buildTopLearner('Mike', '3,100 XP', true),
            ],
          ),
          const Divider(),
          _buildLearnerListItem('Emma', '2,900 XP', '4'),
          _buildLearnerListItem('Tom', '2,700 XP', '5'),
        ],
      ),
    );
  }

  Widget _buildTopLearner(String name, String score, bool hasAvatar) {
    return Column(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: Colors.blue.shade100,
          child: const Icon(Icons.person, color: Colors.blue),
        ),
        const SizedBox(height: 8),
        Text(name),
        Text(score, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  Widget _buildLearnerListItem(String name, String score, String rank) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text('#$rank'),
          const SizedBox(width: 16),
          CircleAvatar(
            backgroundColor: Colors.blue.shade100,
            child: const Icon(Icons.person, color: Colors.blue),
          ),
          const SizedBox(width: 16),
          Text(name),
          const Spacer(),
          Text(score),
        ],
      ),
    );
  }

  Widget _buildProgressReport() {
    return Column(
      children: [
        _buildSubjectProgress('Math', 0.92, Colors.amber),
        const SizedBox(height: 8),
        _buildSubjectProgress('Science', 0.88, Colors.blue),
        const SizedBox(height: 8),
        _buildSubjectProgress('English', 0.95, Colors.purple),
      ],
    );
  }

  Widget _buildSubjectProgress(String subject, double progress, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(subject),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: color.withValues(alpha: 0.2),
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 8,
        ),
      ],
    );
  }

  Widget _buildRecentAchievements() {
    return Row(
      children: [
        _buildAchievementCard('Quiz', 'Today', Colors.amber),
        const SizedBox(width: 16),
        _buildAchievementCard('Test -2', 'Yesterday', Colors.amber),
        const SizedBox(width: 16),
        _buildAchievementCard('Test -3', '2 days ago', Colors.amber),
      ],
    );
  }

  Widget _buildAchievementCard(String title, String date, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              date,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
