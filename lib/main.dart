import 'package:flutter/material.dart';
import 'screens/signin_screen.dart';

void main() {
  runApp(const TouristSpotFinderApp());
}

class TouristSpotFinderApp extends StatelessWidget {
  const TouristSpotFinderApp({super.key});
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tourist Spot Finder',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SignInScreen(),
    );
  }
}
