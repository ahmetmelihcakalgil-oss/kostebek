// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kostebek/providers/game_state_provider.dart'; // Proje adın 'kostebek' olduğu için bu şekilde olmalı
import 'package:kostebek/screens/home_screen.dart'; // Proje adın 'kostebek' olduğu için bu şekilde olmalı

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => GameStateProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dizi Impostor Basit',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreen(),
    );
  }
}