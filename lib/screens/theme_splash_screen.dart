import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'home_page.dart';

class ThemeSplashScreen extends StatefulWidget {
  final String selectedTheme;
  final VoidCallback? onThemeToggle;

  const ThemeSplashScreen({
    super.key,
    required this.selectedTheme,
    this.onThemeToggle,
  });

  @override
  State<ThemeSplashScreen> createState() => _ThemeSplashScreenState();
}

class _ThemeSplashScreenState extends State<ThemeSplashScreen> {
  late VideoPlayerController _videoController;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();

    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MyHomePage(
            selectedTheme: widget.selectedTheme,
            onThemeToggle: widget.onThemeToggle,
          ),
        ),
      );
    });
  }

  void _initializeVideo() {
    String videoAsset;
    switch (widget.selectedTheme) {
      case 'STUDENT DISPLAY':
        videoAsset = 'assets/videos/student_theme.mp4';
        break;
      case 'Park Display':
        videoAsset = 'assets/videos/park_theme.mp4';
        break;
      case 'Game Display':
        videoAsset = 'assets/videos/game_theme.mp4';
        break;
      default:
        videoAsset = 'assets/videos/student_theme.mp4';
    }

    _videoController = VideoPlayerController.asset(videoAsset)
      ..initialize().then((_) {
        if (mounted) {
          setState(() => _isVideoInitialized = true);
          _videoController
            ..setLooping(true)
            ..setVolume(0.0)
            ..play();
        }
      }).catchError((e) {
        print("Video error: $e");
      });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (_isVideoInitialized)
            FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _videoController.value.size.width,
                height: _videoController.value.size.height,
                child: VideoPlayer(_videoController),
              ),
            )
          else
            Container(
              decoration: BoxDecoration(
                gradient: _getThemeGradient(),
              ),
            ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 150,
                  height: 150,
                ),
                const SizedBox(height: 24),
                const CircularProgressIndicator(color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }

  LinearGradient _getThemeGradient() {
    switch (widget.selectedTheme) {
      case 'STUDENT DISPLAY':
        return const LinearGradient(
          colors: [Color(0xFFE0F7FA), Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 'Park Display':
        return const LinearGradient(
          colors: [Color(0xFF81C784), Color(0xFFA5D6A7)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 'Game Display':
        return const LinearGradient(
          colors: [Color(0xFFFF8A65), Color(0xFFFFAB91)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      default:
        return const LinearGradient(
          colors: [Color(0xFFE0F7FA), Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
    }
  }
}
