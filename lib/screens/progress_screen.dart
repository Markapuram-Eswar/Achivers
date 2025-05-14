import 'package:flutter/material.dart';

class ProgressZonePage extends StatelessWidget {
  final User user = User(
    name: 'Eswar',
    xp: 2300,
    badges: 8,
    rank: 1,
    avatarUrl: 'https://via.placeholder.com/150',
  );

  final List<Learner> learners = List.generate(
    5,
    (index) => Learner(
      name: 'Learner ${index + 1}',
      rank: index + 1,
      avatarUrl: 'https://via.placeholder.com/150',
    ),
  );

  final List<SubjectReport> reports = [
    SubjectReport(
        name: 'AI', percent: 85.6, icon: Icons.computer, color: Colors.green),
    SubjectReport(
        name: 'DSA', percent: 72.3, icon: Icons.code, color: Colors.orange),
  ];

  final List<Achievement> achievements = [
    Achievement(title: 'Quiz - 1', color: Colors.blue),
    Achievement(title: 'DSA Master', color: Colors.purple),
  ];

  final List<SubjectProgress> progressList = [
    SubjectProgress(name: 'DSA', completed: 5, total: 6, color: Colors.blue),
    SubjectProgress(name: 'AI', completed: 4, total: 7, color: Colors.green),
  ];

  final QAStats qaStats = QAStats(questions: 12, answers: 30, likes: 85);

  final List<OverviewItem> overviewItems = [
    OverviewItem(icon: Icons.task_alt, title: 'Tests Taken', count: 10),
    OverviewItem(icon: Icons.help, title: 'Doubts', count: 5),
    OverviewItem(icon: Icons.question_answer, title: 'Answers', count: 30),
    OverviewItem(icon: Icons.emoji_events, title: 'Badges', count: 8),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Progress Zone'),
        backgroundColor: Colors.lightBlue,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserSummary(user: user),
            TopLearners(learners: learners),
            ProgressReport(reports: reports),
            SizedBox(height: 8),
            RecentAchievements(achievements: achievements),
            SizedBox(height: 8),
            LearningProgress(progressList: progressList),
            SizedBox(height: 8),
            QASummary(stats: qaStats),
            SizedBox(height: 8),
            AchievementOverview(items: overviewItems),
          ],
        ),
      ),
    );
  }
}

class User {
  final String name;
  final int xp, badges, rank;
  final String avatarUrl;
  User(
      {required this.name,
      required this.xp,
      required this.badges,
      required this.rank,
      required this.avatarUrl});
}

class Learner {
  final String name, avatarUrl;
  final int rank;
  Learner({required this.name, required this.avatarUrl, required this.rank});
}

class SubjectReport {
  final String name;
  final double percent;
  final IconData icon;
  final Color color;
  SubjectReport(
      {required this.name,
      required this.percent,
      required this.icon,
      required this.color});
}

class Achievement {
  final String title;
  final Color color;
  Achievement({required this.title, required this.color});
}

class SubjectProgress {
  final String name;
  final int completed, total;
  final Color color;
  SubjectProgress(
      {required this.name,
      required this.completed,
      required this.total,
      required this.color});
}

class QAStats {
  final int questions, answers, likes;
  QAStats(
      {required this.questions, required this.answers, required this.likes});
}

class OverviewItem {
  final IconData icon;
  final String title;
  final int count;
  OverviewItem({required this.icon, required this.title, required this.count});
}

class UserSummary extends StatelessWidget {
  final User user;
  const UserSummary({required this.user});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                    radius: 30, backgroundImage: NetworkImage(user.avatarUrl)),
                SizedBox(width: 16),
                Text('Hi, ${user.name}! Level 3 Superman!',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _stat(Icons.star, 'XP', user.xp.toString()),
                _stat(Icons.emoji_events, 'Badges', user.badges.toString()),
                _stat(Icons.military_tech, 'Rank', user.rank.toString()),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _stat(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.orange),
        Text(value),
        Text(label),
      ],
    );
  }
}

class TopLearners extends StatelessWidget {
  final List<Learner> learners;
  const TopLearners({required this.learners});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Top Learners',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Container(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: learners.length,
            itemBuilder: (context, index) {
              final l = learners[index];
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    CircleAvatar(backgroundImage: NetworkImage(l.avatarUrl)),
                    Text(l.name, style: TextStyle(fontSize: 12)),
                    Text('Rank ${l.rank}', style: TextStyle(fontSize: 10))
                  ],
                ),
              );
            },
          ),
        )
      ],
    );
  }
}

class ProgressReport extends StatelessWidget {
  final List<SubjectReport> reports;
  const ProgressReport({required this.reports});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Progress Report',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ...reports.map((r) => Row(
                  children: [
                    Icon(r.icon, color: r.color),
                    SizedBox(width: 8),
                    Expanded(child: Text(r.name)),
                    Text('${r.percent.toStringAsFixed(1)}%'),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}

class RecentAchievements extends StatelessWidget {
  final List<Achievement> achievements;
  const RecentAchievements({required this.achievements});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recent Achievements',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: achievements
                .map((a) => Container(
                      width: 100,
                      height: 60,
                      margin: EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: a.color,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.all(8),
                      child: Center(
                        child: Text(a.title,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                    ))
                .toList(),
          ),
        )
      ],
    );
  }
}

class LearningProgress extends StatelessWidget {
  final List<SubjectProgress> progressList;
  const LearningProgress({required this.progressList});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Learning Progress',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ...progressList.map((e) {
          final value = e.total > 0 ? e.completed / e.total : 0.0;
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                SizedBox(width: 60, child: Text(e.name)),
                Expanded(
                  child: LinearProgressIndicator(
                      value: value,
                      color: e.color,
                      backgroundColor: e.color.withOpacity(0.3)),
                ),
                SizedBox(width: 8),
                Text('${e.completed}/${e.total}')
              ],
            ),
          );
        })
      ],
    );
  }
}

class QASummary extends StatelessWidget {
  final QAStats stats;
  const QASummary({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Q&A Summary',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _item(Icons.help, 'Questions', stats.questions),
            _item(Icons.question_answer, 'Answers', stats.answers),
            _item(Icons.thumb_up, 'Likes', stats.likes),
          ],
        )
      ],
    );
  }

  Widget _item(IconData icon, String label, int value) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue),
        Text('$value'),
        Text(label, style: TextStyle(fontSize: 12))
      ],
    );
  }
}

class AchievementOverview extends StatelessWidget {
  final List<OverviewItem> items;
  const AchievementOverview({required this.items});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      childAspectRatio: 3,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      children: items
          .map((item) => Card(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Icon(item.icon, color: Colors.green),
                      SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(item.title, style: TextStyle(fontSize: 12)),
                          Text('${item.count}',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold))
                        ],
                      )
                    ],
                  ),
                ),
              ))
          .toList(),
    );
  }
}
