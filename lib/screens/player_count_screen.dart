// lib/screens/player_count_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kostebek/providers/game_state_provider.dart';
import 'package:kostebek/screens/reveal_role_screen.dart';
import 'package:kostebek/models/game_model.dart'; // GameCategory enum'ı için import

class PlayerCountScreen extends StatefulWidget {
  const PlayerCountScreen({super.key});

  @override
  State<PlayerCountScreen> createState() => _PlayerCountScreenState();
}

class _PlayerCountScreenState extends State<PlayerCountScreen> {
  // int _selectedPlayerCount = 3; // Varsayılan oyuncu sayısı - ARTIK BUNU KALDIRIYORUZ VEYA DİKKATLİ KULLANIYORUZ

  // Kategori isimlerini daha okunaklı hale getirmek için bir yardımcı fonksiyon
  String _getCategoryName(GameCategory category) {
    switch (category) {
      case GameCategory.diziler:
        return 'Diziler';
      case GameCategory.unluler:
        return 'Ünlüler';
      case GameCategory.kitaplar:
        return 'Kitaplar';
      case GameCategory.oyunlar:
        return 'Oyunlar';
      case GameCategory.filmler:
        return 'Filmler';
      case GameCategory.animeler:
        return 'Animeler';
      case GameCategory.ulkeler:
        return 'Ülkeler';
      default:
        return category.toString().split('.').last;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final gameStateProvider = Provider.of<GameStateProvider>(context, listen: false);

      // Provider'dan mevcut totalPlayers değerini al
      // Eğer sıfırdan farklı bir değer varsa onu kullan, yoksa varsayılan 3'ü kullan.
      // Bu sayede PlayerCountScreen her açıldığında son seçilen değeri hatırlar.
      if (gameStateProvider.totalPlayers > 0) {
        // _selectedPlayerCount = gameStateProvider.totalPlayers; // Artık _selectedPlayerCount değişkenini kullanmayacağız
        // DropdownButton'ın value'su doğrudan gameStateProvider.totalPlayers'ı dinleyecek.
        // Ama initState'te bir kez setTotalPlayers'ı çağırmak, provider'ın da doğru state ile başlamasını sağlar.
        gameStateProvider.setTotalPlayers(gameStateProvider.totalPlayers); // Zaten provider'daki değeri set ediyor
      } else {
        // İlk açılışta veya sıfırlanmışsa varsayılanı set et
        gameStateProvider.setTotalPlayers(3); // Varsayılanı set etmek önemli
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final gameStateProvider = Provider.of<GameStateProvider>(context);

    // En az bir kategori seçili mi kontrolü
    bool isAnyCategorySelected = gameStateProvider.selectedCategories.isNotEmpty;

    // Sahtekar sayısı için maksimum izin verilen değeri hesapla
    int maxAllowedImpostorsForUI;
    if (gameStateProvider.totalPlayers <= 5) {
      maxAllowedImpostorsForUI = 1;
    } else if (gameStateProvider.totalPlayers >= 6 && gameStateProvider.totalPlayers <= 10) {
      maxAllowedImpostorsForUI = 2;
    } else { // totalPlayers > 10
      maxAllowedImpostorsForUI = 3;
    }

    // Sahtekar sayısı seçeneklerini dinamik olarak oluştur
    List<int> impostorOptions = List.generate(
      maxAllowedImpostorsForUI,
          (index) => index + 1,
    );

    // Dropdown'ın geçerli değeri, eğer yeni limitin üzerindeyse, limitin en yüksek değerine çekilir
    int currentImpostorValue = gameStateProvider.impostorCount;
    if (!impostorOptions.contains(currentImpostorValue)) {
      currentImpostorValue = impostorOptions.isNotEmpty ? impostorOptions.last : 1;
      // Bu durumu provider'a da bildirmek gerekebilir eğer impostorOptions değiştiyse
      // gameStateProvider.setImpostorCount(currentImpostorValue); // Gerekirse bunu da ekleyebiliriz
    }


    return Scaffold(
      appBar: AppBar(
        title: const Text('Oyun Ayarları'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Toplam Oyuncu Sayısı:',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              DropdownButton<int>(
                // value: _selectedPlayerCount, // Yerel state yerine doğrudan provider'daki değeri kullanıyoruz
                value: gameStateProvider.totalPlayers, // GÜNCELLENDİ
                items: List.generate(
                  18,
                      (index) => DropdownMenuItem(
                    value: index + 3,
                    child: Text((index + 3).toString()),
                  ),
                ),
                onChanged: (value) {
                  if (value != null) {
                    // setState(() { // Yerel state'e gerek yok, provider'ı güncelliyoruz
                    //   _selectedPlayerCount = value;
                    // });
                    gameStateProvider.setTotalPlayers(value); // Provider güncelleniyor
                  }
                },
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Sahtekar Sayısı:', style: TextStyle(fontSize: 20)),
                  DropdownButton<int>(
                    value: currentImpostorValue,
                    items: impostorOptions.map((int count) {
                      return DropdownMenuItem<int>(
                        value: count,
                        child: Text('$count'),
                      );
                    }).toList(),
                    onChanged: (int? newValue) {
                      if (newValue != null) {
                        gameStateProvider.setImpostorCount(newValue);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 40),
              const Text(
                'Oyun Kategorileri:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              // Kategori seçim kutucukları
              ...GameCategory.values.map((category) {
                return CheckboxListTile(
                  title: Text(_getCategoryName(category)),
                  value: gameStateProvider.selectedCategories.contains(category),
                  onChanged: (bool? newValue) {
                    gameStateProvider.toggleCategory(category, newValue);
                  },
                );
              }).toList(),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: (gameStateProvider.totalPlayers < 3 || !isAnyCategorySelected) // totalPlayers kullanıldı
                    ? null
                    : () {
                  gameStateProvider.startGame();

                  if (gameStateProvider.players.isNotEmpty && gameStateProvider.currentPlayer != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RevealRoleScreen()),
                    );
                  } else {
                    debugPrint('Hata: Oyun başlatılamadı, RevealRoleScreen\'e geçilemiyor.');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Oyunu başlatmak için yeterli oyuncu yok veya bir hata oluştu.')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('Oyunu Başlat'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}