import 'package:flutter/material.dart';
import 'theme_splash_screen.dart';

class WelcomePage extends StatefulWidget {
  final VoidCallback? onThemeToggle;

  const WelcomePage({super.key, this.onThemeToggle});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  String _selectedTheme = 'STUDENT DISPLAY';

  LinearGradient _getThemeGradient() {
    switch (_selectedTheme) {
      case 'STUDENT DISPLAY':
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFE0F7FA), Colors.white],
        );
      case 'Park Display':
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF81C784), Color(0xFFA5D6A7)],
        );
      case 'Game Display':
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFF8A65), Color(0xFFFFAB91)],
        );
      default:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFE0F7FA), Colors.white],
        );
    }
  }

  Color _getThemeColor() {
    switch (_selectedTheme) {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: _getThemeGradient(),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: 200,
                ),
                const SizedBox(height: 40),
                Text(
                  'Welcome to Achievers',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: _getThemeColor(),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Your journey to success starts here',
                  style: TextStyle(
                    fontSize: 16,
                    color: _getThemeColor().withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Theme',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _getThemeColor(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      RadioListTile<String>(
                        title: const Text('STUDENT DISPLAY'),
                        value: 'STUDENT DISPLAY',
                        groupValue: _selectedTheme,
                        activeColor: _getThemeColor(),
                        onChanged: (value) {
                          setState(() {
                            _selectedTheme = value!;
                          });
                        },
                      ),
                      RadioListTile<String>(
                        title: const Text('Park Display'),
                        value: 'Park Display',
                        groupValue: _selectedTheme,
                        activeColor: _getThemeColor(),
                        onChanged: (value) {
                          setState(() {
                            _selectedTheme = value!;
                          });
                        },
                      ),
                      RadioListTile<String>(
                        title: const Text('Game Display'),
                        value: 'Game Display',
                        groupValue: _selectedTheme,
                        activeColor: _getThemeColor(),
                        onChanged: (value) {
                          setState(() {
                            _selectedTheme = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_selectedTheme.isNotEmpty) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ThemeSplashScreen(
                              selectedTheme: _selectedTheme,
                              onThemeToggle: widget.onThemeToggle,
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _getThemeColor(),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Get Started',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
