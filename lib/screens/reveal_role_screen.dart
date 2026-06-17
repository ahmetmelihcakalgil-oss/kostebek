// lib/screens/reveal_role_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kostebek/providers/game_state_provider.dart'; // Proje adın 'kostebek' olduğu için bu şekilde olmalı
import 'package:flutter/scheduler.dart';
import 'package:kostebek/screens/home_screen.dart'; // Proje adın 'kostebek' olduğu için bu şekilde olmalı

class RevealRoleScreen extends StatefulWidget {
  const RevealRoleScreen({super.key});

  @override
  State<RevealRoleScreen> createState() => _RevealRoleScreenState();
}

class _RevealRoleScreenState extends State<RevealRoleScreen> {
  bool _isRoleRevealed = false;
  bool _initialCheckDone = false;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _performInitialGameCheckAndNavigation();
      if (mounted) {
        setState(() {
          _initialCheckDone = true;
        });
      }
    });
  }

  void _performInitialGameCheckAndNavigation() {
    if (!mounted) {
      debugPrint('RevealRoleScreen: _performInitialGameCheckAndNavigation() called but widget not mounted.');
      return;
    }

    final gameStateProvider = Provider.of<GameStateProvider>(context, listen: false);

    debugPrint('RevealRoleScreen: İlk durum kontrolü başladı.');
    debugPrint('  Players empty: ${gameStateProvider.players.isEmpty}');
    debugPrint('  Current index: ${gameStateProvider.currentPlayerIndex}');
    debugPrint('  Players length: ${gameStateProvider.players.length}');
    debugPrint('  Current player is null: ${gameStateProvider.currentPlayer == null}');

    if (gameStateProvider.players.isEmpty ||
        gameStateProvider.currentPlayerIndex >= gameStateProvider.players.length ||
        gameStateProvider.currentPlayer == null) {

      debugPrint('RevealRoleScreen: Hatalı oyun durumu algılandı, ana ekrana dönülüyor.');
      gameStateProvider.resetGame();

      if (ModalRoute.of(context)?.isCurrent ?? false) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
              (Route<dynamic> route) => false,
        );
      }
    } else {
      debugPrint('RevealRoleScreen: Oyun durumu geçerli, devam ediliyor.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameStateProvider = Provider.of<GameStateProvider>(context);

    if (!_initialCheckDone) {
      debugPrint('RevealRoleScreen: İlk kontrol bekleniyor...');
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (gameStateProvider.players.isEmpty ||
        gameStateProvider.currentPlayerIndex >= gameStateProvider.players.length ||
        gameStateProvider.currentPlayer == null) {
      debugPrint('RevealRoleScreen: Build metodunda hatalı durum tespiti, muhtemelen bir race condition.');
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final currentPlayer = gameStateProvider.currentPlayer!;

    return Scaffold(
      appBar: AppBar(
        title: Text('Sıra: Oyuncu ${gameStateProvider.currentPlayerIndex + 1}'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!_isRoleRevealed)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isRoleRevealed = true;
                  });
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: const TextStyle(fontSize: 20),
                ),
                child: const Text('Kelimeyi Görmek İçin Dokun'),
              )
            else
              Column(
                children: [
                  const Text(
                    'Kelimeniz:',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    currentPlayer.assignedWord,
                    style: const TextStyle(fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      if (gameStateProvider.currentPlayerIndex == gameStateProvider.players.length - 1) {
                        debugPrint('RevealRoleScreen: Son oyuncu, Oyunu Bitir.');
                        gameStateProvider.nextPlayer(); // Bu son oyuncunun kelimesini gördüğünü işaretler
                        gameStateProvider.resetGame(); // Oyunu tamamen sıfırla

                        // Ana ekrana dön ve tüm rotaları temizle
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const HomeScreen()),
                              (Route<dynamic> route) => false,
                        );
                      } else {
                        debugPrint('RevealRoleScreen: Sonraki oyuncuya geçiliyor.');
                        gameStateProvider.nextPlayer();
                        setState(() {
                          _isRoleRevealed = false; // Bir sonraki oyuncu için kelimeyi gizle
                        });
                        Navigator.pushReplacement( // Geçerli ekranı yenisiyle değiştir
                          context,
                          MaterialPageRoute(builder: (context) => const RevealRoleScreen()),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child: Text(
                      gameStateProvider.currentPlayerIndex == gameStateProvider.players.length - 1
                          ? 'Oyunu Başlatın!'
                          : 'Telefonu Bir Sonraki Oyuncuya Ver',
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '(Diğer oyuncunun görmediğinden emin ol!)',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const Text(
                    'Kelimeniz diğerlerinden farklıysa, siz sahtekarsınız!',
                    style: TextStyle(fontSize: 12, color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}