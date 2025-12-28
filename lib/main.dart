import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newsreader_fe/main/presentation/screen/article_main.dart';

void main() {
  runApp(const ProviderScope(child: TechFeedApp()));
}

class TechFeedApp extends StatelessWidget {
  const TechFeedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF9FAFB), // gray-50
        fontFamily: 'Pretendard',
      ),
      home: const MainScreen(),
    );
  }
}
