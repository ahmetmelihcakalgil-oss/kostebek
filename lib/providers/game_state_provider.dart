// lib/providers/game_state_provider.dart
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:kostebek/models/game_model.dart'; // GameCategory enum'ı için import

class GameStateProvider with ChangeNotifier {
  GameModel _gameModel = GameModel(players: []);
  int _currentPlayerIndex = 0;

  // Başlangıçta tüm kategorilerin seçili olması için güncellendi
  Set<GameCategory> _selectedCategories = GameCategory.values.toSet();

  List<Player> get players => _gameModel.players;
  int get impostorCount => _gameModel.impostorCount;
  int get totalPlayers => _gameModel.totalPlayers;
  GameCategory? get selectedCategory => _gameModel.selectedCategory;
  String? get selectedWord => _gameModel.selectedWord;
  String? get impostorWord => _gameModel.impostorWord;
  Player? get currentPlayer => _gameModel.players.isNotEmpty && _currentPlayerIndex < _gameModel.players.length
      ? _gameModel.players[_currentPlayerIndex]
      : null;
  int get currentPlayerIndex => _currentPlayerIndex;
  Set<GameCategory> get selectedCategories => _selectedCategories;

  // Tüm kategorilerin kelime kütüphanesi (Güncel ve Genişletilmiş)
  static const Map<GameCategory, List<String>> _wordLibrary = {
    GameCategory.diziler: [
      'Leyla ile Mecnun', 'Behzat Ç.', 'Ezel', 'Kurtlar Vadisi', 'Aşk-ı Memnu',
      'Çukur', 'Arka Sokaklar', 'Prison Break', 'Tom ve Jerry', 'Bakugan', 'Bugs Bunny',
      'Game of Thrones', 'Breaking Bad', 'Friends', 'The Office', 'Stranger Things',
      'La Casa de Papel', 'Squid Game', 'Black Mirror', 'Chernobyl', 'The Queen\'s Gambit',
      'Peaky Blinders', 'The Crown', 'Narcos', 'Dark', 'Lucifer', 'The Witcher',
      'Euphoria', 'House of the Dragon', 'Better Call Saul', 'Teen Wolf', 'Şirinler',
      'Wednesday', 'The Last of Us', 'Ozark', 'Regular Show', 'Adventure Time', 'Keloğlan',
      'Elite', 'Sex Education', 'You', 'The Boys', 'Invincible', 'Arcane', 'Caillou',
      'Dune: Prophecy', 'Fallout', 'Shōgun', 'Rick and Morty', 'Gumball', 'Garfield',
      'Vikings', 'The Mandalorian', 'The Walking Dead', 'Fargo', 'Beyblade', 'Taş Devri',
      'Westworld', 'The Reacher', 'Bojack Horseman', 'Powerpuff Girls',
      'Money Heist', 'The Bear', 'Baby Reindeer', 'Sherlock', 'Teen Titans Go',
      'Doctor Who', 'The Big Bang Theory', 'How I Met Your Mother', 'Dexter',
      'Sopranos', 'True Detective', 'Mr. Robot','The Simpsons', 'South Park', 'Family Guy',
    ],
    GameCategory.unluler: [
      'Acun Ilıcalı', 'Tarkan', 'Hadise', 'Kenan İmirzalıoğlu', 'Cem Yılmaz',
      'Şener Şen', 'Haluk Bilginer', 'Arda Turan', 'Hülya Avşar', 'Beyoncé',
      'Leonardo DiCaprio', 'Brad Pitt', 'Angelina Jolie', 'Tom Hanks', 'Meryl Streep',
      'Elon Musk', 'Bill Gates', 'Jeff Bezos', 'Taylor Swift', 'Cristiano Ronaldo',
      'Lionel Messi', 'Michael Jordan', 'Oprah Winfrey', 'Dwayne Johnson', 'Adele',
      'Rihanna', 'Justin Bieber', 'Selena Gomez', 'Kim Kardashian', 'Kanye West',
      'LeBron James', 'Serena Williams', 'Roger Federer', 'Rafael Nadal', 'Novak Djokovic',
      'Zendaya', 'Timothée Chalamet', 'Billie Eilish', 'Olivia Rodrigo', 'Harry Styles',
      'Chris Pratt', 'Jennifer Lawrence', 'Ryan Reynolds', 'Gal Gadot', 'Margot Robbie',
      'Robert Downey Jr.', 'Scarlett Johansson', 'Tom Cruise', 'Will Smith', 'Julia Roberts',
      'Mustafa Kemal Atatürk', 'Barış Manço', 'Kemal Sunal', 'Adile Naşit', 'Müslüm Gürses',
      'Zeki Müren', 'Sezen Aksu', 'Ajda Pekkan', 'Filiz Akın', 'Türkan Şoray',
      'Cüneyt Arkın', 'Hakan Şükür', 'Naim Süleymanoğlu', 'Aziz Sancar', 'Can Yaman',
      'Ezhel', 'Şeyma Subaşı', 'Arda Güler', 'Gigi Hadid',
      'Keanu Reeves', 'Emma Watson', 'Denzel Washington', 'Morgan Freeman'
    ],
    GameCategory.kitaplar: [
      'Suç ve Ceza', 'Sefiller', 'Nutuk', 'Don Kişot', 'Küçük Prens',
      'Harry Potter', 'Yüzüklerin Efendisi', 'Dönüşüm', 'Fareler ve İnsanlar',
      'Kürk Mantolu Madonna', '1984', 'Hayvan Çiftliği', 'Uçurtma Avcısı',
      'Bülbülü Öldürmek', 'Otomatik Portakal', 'Savaş ve Barış', 'Gurur ve Önyargı',
      'Simyacı', 'Körlük', 'Şeker Portakalı', 'Anna Karenina', 'İnce Memed',
      'Tutunamayanlar', 'Saatleri Ayarlama Enstitüsü', 'Çalıkuşu', 'Yaprak Dökümü',
      'Aylak Adam', 'Puslu Kıtalar Atlası', 'Cesur Yeni Dünya',
      'Deniz Feneri', 'Gülün Adı', 'Notre Dame\'ın Kamburu', 'Dracula', 'Frankenstein',
      'Sherlock Holmes', 'Arsene Lupin', 'Robinson Crusoe', 'Gulliver\'in Seyahatleri',
      'Devlet', 'Karamazov Kardeşler', 'İlyada', 'Odysseia', 'Sineklerin Tanrısı',
      'Satranç', 'Dorian Gray\'in Portresi', 'Gazap Üzümleri', 'Vadideki Zambak', 'İki Şehrin Hikayesi',
      'Monte Kristo Kontu', 'Yabancı', 'Çanlar Kimin İçin Çalıyor', 'Aşk ve Gurur', 'Madame Bovary',
      'Uğultulu Tepeler', 'Büyük Umutlar', 'Oliver Twist', 'Romeo ve Juliet', 'Hamlet'
    ],
    GameCategory.oyunlar: [
      'Satranç', 'Tavla', 'Monopoly', 'Tabu', 'Scrabble',
      'Valorant', 'League of Legends', 'Counter-Strike', 'Minecraft', 'Grand Theft Auto V',
      'The Witcher 3', 'Red Dead Redemption 2', 'Cyberpunk 2077', 'Elden Ring',
      'Assassin\'s Creed', 'FIFA', 'NBA 2K', 'Call of Duty', 'Fortnite',
      'PUBG', 'Apex Legends', 'Overwatch', 'Among Us',
      'Stardew Valley', 'Terraria', 'Rocket League', 'Fall Guys', 'God of War',
      'The Legend of Zelda', 'Super Mario Bros.', 'Pokémon', 'Pac-Man', 'Tetris',
      'Street Fighter', 'Mortal Kombat', 'Tekken',
      'Portal 2', 'Half-Life 2', 'Resident Evil 4', 'Dark Souls',
      'Balatro', 'Brawlhalla', 'Clash Royale', 'Brawl Stars',
      'Clash of Clans', 'Boom Beach', 'Dr. Driving', 'F1', 'Okey', 'İskambil',
      'League of Legends: Wild Rift', 'Call of Duty: Mobile', 'Genshin Impact', 'Roblox', 'Free Fire',
      'Candy Crush Saga', 'Subway Surfers', 'Temple Run',
      'Minecraft: Pocket Edition', 'Asphalt 9', 'Real Racing 3', 'PUBG Mobile', 'Fortnite Mobile',
      'Dota 2', 'World of Warcraft', 'Overwatch 2', 'Apex Legends Mobile', 'Diablo Immortal',
      'Red Dead Online', 'Grand Theft Auto Online', 'Forza Horizon 5', 'The Sims 4'
    ],
    GameCategory.filmler: [
      'Yüzüklerin Efendisi', 'Esaretin Bedeli', 'Kara Şövalye', 'Pulp Fiction', 'Forrest Gump',
      'Matrix', 'Inception', 'Dövüş Kulübü', 'Gladyatör', 'Yeşil Yol', 'The Prestige', 'Scarface',
      'Titanic', 'Avatar', 'Star Wars', 'Avengers', 'Harry Potter', 'Fight Club', '12 Angry man',
      'Interstellar', 'Sicario', 'Whiplash', 'Birdman', 'Parazit', 'Goodfellas', 'Se7en', '3 Idiots',
      'Joker', 'Kuzuların Sessizliği', 'Leon', 'Baba', 'Godfather Part II', 'Taxi Driver', 'Reservoir Dogs',
      'Cesur Yürek', 'Kill Bill', 'V for Vendetta', 'Spirited Away', 'Eternal Sunshine of the Spotless Mind',
      'Geleceğe Dönüş', 'Terminator 2', 'Alien', 'Blade Runner', 'Schindler\'in Listesi', 'Madmax',
      'Büyük Lebowski', 'Truman Show', 'Matrix Revolutions', 'The Silence of the Lambs', 'The Glorius Bastards',
      'Yenilmezler: Sonsuzluk Savaşı', 'Yenilmezler: Oyun Sonu', 'Spider-Man: Örümcek Evreninde',
      'Dune', 'Oppenheimer', 'Barbie', 'Wonka', 'Godzilla Minus One', 'The Pianist', 'Her Çocuk Özeldir',
      'Karanlık Su', 'Amelie', 'Canavar', 'Gora', 'Arog', 'Vizontele', 'Hababam Sınıfı', 'IT',
      'Tosun Paşa', 'Neşeli Günler', 'Çiçek Abbas', 'Züğürt Ağa', 'Eşkıya', 'The Caribbean Pirates',
    ],
    GameCategory.animeler: [
      'Naruto', 'One Piece', 'Dragon Ball', 'Attack on Titan', 'Death Note', 'Hellsing', 'Devil May Cry', 'Doraemon',
      'Fullmetal Alchemist: Brotherhood', 'My Hero Academia', 'Demon Slayer', 'Jujutsu Kaisen', 'Hunter x Hunter',
      'Spirited Away', 'Princess Mononoke', 'Your Name', 'A Silent Voice', 'Perfect Blue', 'Violet Evergarden',
      'Cowboy Bebop', 'Neon Genesis Evangelion', 'Berserk', 'Fire Force', 'Kuroko no Basket',
      'Code Geass', 'Steins;Gate', 'Haikyuu!!', 'Black Clover', 'Fairy Tail', 'Jojo', 'The Promised Neverland',
      'Tokyo Ghoul', 'One-Punch Man', 'Re:Zero', 'Sword Art Online', 'Bleach', 'Assasination Classroom',
      'Dr. Stone', 'Vinland Saga', 'Mob Psycho 100', 'Erased', 'Mushoku Tensei',
      'Konosuba', 'Rent-A-Girlfriend', 'The Rising of the Shield Hero', 'That Time I Got Reincarnated as a Slime',
      'Chainsaw Man', 'Spy x Family', 'Cyberpunk Edgerunners', 'Blue Lock',
      'Solo Leveling', 'Frieren: Beyond Journey\'s End', 'Made in Abyss', 'Baki',
      'Masha and the Bear', 'Gintama', 'Hajime no Ippo', 'Tengen Toppa Gurren Lagan',
    ],
    GameCategory.ulkeler: [
      'Amerika Birleşik Devletleri', 'Çin', 'Hindistan', 'Endonezya', 'Pakistan',
      'Brezilya', 'Nijerya', 'Bangladeş', 'Rusya', 'Meksika',
      'Japonya', 'Etiyopya', 'Filipinler', 'Mısır', 'Vietnam',
      'Almanya', 'İran', 'Türkiye', 'Tayland', 'Fransa',
      'Birleşik Krallık', 'İtalya', 'Güney Afrika', 'Myanmar', 'Güney Kore',
      'Kolombiya', 'İspanya', 'Arjantin', 'Ukrayna', 'Cezayir',
      'Kanada', 'Polonya', 'Fas', 'Suudi Arabistan', 'Peru',
      'Özbekistan', 'Malezya', 'Yemen', 'Angola', 'Gana',
      'Mozambik', 'Madagaskar', 'Nepal', 'Avustralya', 'Venezuela',
      'Kamerun', 'Nijer', 'Kuzey Kore', 'Suriye', 'Sri Lanka',
      'Irak', 'Afganistan', 'Kuzey Makedonya', 'Finlandiya', 'İsveç',
      'Norveç', 'Danimarka', 'İrlanda', 'Portekiz', 'Yunanistan',
      'Belçika', 'Hollanda', 'Avusturya', 'İsviçre', 'Çek Cumhuriyeti',
      'Macaristan', 'Romanya', 'Bulgaristan', 'Sırbistan', 'Hırvatistan'
    ],
  };

  void setTotalPlayers(int count) {
    if (_gameModel.totalPlayers != count) {
      _gameModel.totalPlayers = count;
      debugPrint('GameStateProvider: setTotalPlayers çağrıldı, yeni sayı: $count');

      // Yeni kurala göre sahtekar sayısı üst limitini belirle
      int newMaxImpostors;
      if (count <= 5) {
        newMaxImpostors = 1;
      } else if (count >= 6 && count <= 10) {
        newMaxImpostors = 2;
      } else { // count > 10
        newMaxImpostors = 3;
      }

      // Mevcut sahtekar sayısı yeni maksimumdan büyükse veya 0 ise ayarla
      // Minimum 1 sahtekar her zaman olmalı (3+ oyuncu için)
      if (_gameModel.impostorCount > newMaxImpostors || _gameModel.impostorCount == 0 || (_gameModel.totalPlayers >=3 && _gameModel.impostorCount == 0)) {
        setImpostorCount(newMaxImpostors); // setImpostorCount içinde de limit kontrolü var
      }
      notifyListeners();
    }
  }

  void setImpostorCount(int count) {
    // Yeni kurala göre izin verilen maksimum sahtekar sayısını hesapla
    int maxAllowedImpostors;
    if (_gameModel.totalPlayers <= 5) {
      maxAllowedImpostors = 1;
    } else if (_gameModel.totalPlayers >= 6 && _gameModel.totalPlayers <= 10) {
      maxAllowedImpostors = 2;
    } else { // _gameModel.totalPlayers > 10
      maxAllowedImpostors = 3;
    }

    // Sahtekar sayısının geçerli aralıkta olmasını sağla
    int finalImpostorCount = count;

    if (finalImpostorCount < 1) { // Sahtekar sayısı 0'dan az olamaz
      finalImpostorCount = 1;
    }
    if (finalImpostorCount > maxAllowedImpostors) { // Maksimumu aşamaz
      finalImpostorCount = maxAllowedImpostors;
    }
    // Ayrıca sahtekar sayısı total oyunculardan 1 eksik bile olamaz (kendisi hariç herkesi sahtekar yapamazsın)
    if (finalImpostorCount >= _gameModel.totalPlayers) {
      finalImpostorCount = _gameModel.totalPlayers - 1;
      if (finalImpostorCount < 1) finalImpostorCount = 1; // Minimum 1 sahtekar garanti
    }


    if (_gameModel.impostorCount != finalImpostorCount) {
      _gameModel.impostorCount = finalImpostorCount;
      debugPrint('GameStateProvider: setImpostorCount çağrıldı, yeni sayı: $finalImpostorCount (Max: $maxAllowedImpostors, Total: ${_gameModel.totalPlayers})');
      notifyListeners();
    }
  }

  void toggleCategory(GameCategory category, bool? isSelected) {
    if (isSelected == true) {
      _selectedCategories.add(category);
    } else {
      _selectedCategories.remove(category);
    }
    debugPrint('Seçilen Kategoriler: $_selectedCategories');
    notifyListeners();
  }

  void startGame() {
    debugPrint('GameStateProvider: startGame() çağrıldı.');
    debugPrint('GameStateProvider: totalPlayers (startGame başlangıç): ${_gameModel.totalPlayers}');

    if (_gameModel.totalPlayers < 3) {
      debugPrint('Hata: En az 3 oyuncu olmalı, oyun başlatılamaz. totalPlayers: ${_gameModel.totalPlayers}');
      notifyListeners();
      return;
    }

    // Seçili kategori kontrolü burada daha önemli hale geldi
    if (_selectedCategories.isEmpty) {
      debugPrint('Hata: Hiç kategori seçilmedi. Oyun başlatılamaz.');
      // Kullanıcıya bildirim gösterebilirsiniz (SnackBar gibi)
      notifyListeners();
      return;
    }


    _gameModel.players.clear();
    for (int i = 0; i < _gameModel.totalPlayers; i++) {
      _gameModel.players.add(Player());
    }
    _currentPlayerIndex = 0;

    debugPrint('GameStateProvider: Oyuncular oluşturuldu. players.length: ${_gameModel.players.length}');

    _selectRandomCategoryAndWord();

    _assignRolesAndWords();

    notifyListeners();
    debugPrint('GameStateProvider: Oyun Başlatıldı. Final durum: Total Oyuncu: ${_gameModel.totalPlayers}, Kelime: ${_gameModel.selectedWord}, Sahtekar Sayısı: ${_gameModel.impostorCount}, players.length: ${_gameModel.players.length}, Current Player Index: $_currentPlayerIndex, Sahtekar Kelimesi: ${_gameModel.impostorWord}');
  }

  void _selectRandomCategoryAndWord() {
    final random = Random();

    if (_selectedCategories.isEmpty) {
      // Bu kontrol startGame içinde de var, burası daha çok fallback gibi düşünülebilir.
      debugPrint('Hata: Hiç kategori seçilmedi. Lütfen en az bir kategori seçin.');
      _selectedCategories = GameCategory.values.toSet(); // Varsayılan olarak tüm kategorileri seç
      debugPrint('Varsayılan olarak tüm kategoriler seçildi: $_selectedCategories');
    }

    final List<GameCategory> availableCategories = _selectedCategories.toList();
    _gameModel.selectedCategory = availableCategories[random.nextInt(availableCategories.length)];
    debugPrint('GameStateProvider: Seçilen kategori (rastgele): ${_gameModel.selectedCategory}');


    final List<String> wordsInSelectedCategory = _wordLibrary[_gameModel.selectedCategory]!;
    _gameModel.selectedWord = wordsInSelectedCategory[random.nextInt(wordsInSelectedCategory.length)];

    String tempImpostorWord = _gameModel.selectedWord!;
    // Sahtekar kelimesinin ana kelime ile aynı olmaması için kontrol
    if (wordsInSelectedCategory.length > 1) { // Kategoride birden fazla kelime varsa
      while (tempImpostorWord == _gameModel.selectedWord) {
        tempImpostorWord = wordsInSelectedCategory[random.nextInt(wordsInSelectedCategory.length)];
      }
    } else {
      // Eğer kategoride sadece 1 kelime varsa, sahtekara farklı bir kelime atayamayız.
      // Bu durumda, sahtekarın kelimesini kategorinin adıyla değiştirmek daha mantıklı olabilir.
      // Ya da bu durumda hata verilebilir/oyun başlatılmayabilir. Şimdilik kategori adını kullanıyoruz.
      tempImpostorWord = "Kategori: ${(_gameModel.selectedCategory.toString().split('.').last).toUpperCase()}";
    }
    _gameModel.impostorWord = tempImpostorWord;

    debugPrint('GameStateProvider: Kategori Seçildi: ${_gameModel.selectedCategory}, Ana Kelime: ${_gameModel.selectedWord}, Sahtekar Kelimesi: ${_gameModel.impostorWord}');
  }

  void _assignRolesAndWords() {
    final random = Random();
    List<int> playerIndices = List.generate(_gameModel.players.length, (index) => index);
    playerIndices.shuffle(random);

    // impostorCount'un oyuncu sayısından az olmasına dikkat et
    int actualImpostorCount = min(_gameModel.impostorCount, _gameModel.players.length - 1);
    // Minimum 1 sahtekar (oyuncu sayısı 3 ve üzeriyse)
    if (actualImpostorCount <= 0 && _gameModel.players.length >= 3) {
      actualImpostorCount = 1;
    }
    // Eğer oyuncu sayısı 2 ise ve 1 sahtekar atanmak isteniyorsa, bu hala geçerli
    if (_gameModel.players.length == 2 && actualImpostorCount >= 1) {
      actualImpostorCount = 1;
    }

    for (int i = 0; i < actualImpostorCount; i++) {
      _gameModel.players[playerIndices[i]].isImpostor = true;
      debugPrint('GameStateProvider: Oyuncu ${playerIndices[i] + 1} İçten Sahtekar olarak atandı.');
    }

    for (int i = 0; i < _gameModel.players.length; i++) {
      var player = _gameModel.players[i];
      if (player.isImpostor) {
        player.assignedWord = _gameModel.impostorWord!;
        debugPrint('GameStateProvider: Oyuncu ${i + 1} (İçten Sahtekar): Kelime: "${player.assignedWord}"');
      } else {
        player.assignedWord = _gameModel.selectedWord!;
        debugPrint('GameStateProvider: Oyuncu ${i + 1} (Normal): Kelime: "${player.assignedWord}"');
      }
    }
  }

  void nextPlayer() {
    if (_currentPlayerIndex < _gameModel.players.length - 1) {
      _currentPlayerIndex++;
      debugPrint('GameStateProvider: Bir sonraki oyuncuya geçildi. Yeni index: $_currentPlayerIndex');
    } else {
      _currentPlayerIndex = _gameModel.players.length;
      debugPrint('GameStateProvider: Tüm oyuncular rolleri gördü, oyun tamamlandı. Index: $_currentPlayerIndex');
    }
    notifyListeners();
  }

  void resetGame() {
    debugPrint('GameStateProvider: resetGame() çağrıldı.');
    _gameModel.reset(); // GameModel'daki reset metodu çağrılıyor
    _currentPlayerIndex = 0;
    // Note: If you want totalPlayers and impostorCount to persist after reset,
    // you should modify the GameModel's reset method to NOT clear them.
    // As per previous discussions, GameModel's reset was modified to preserve them.
    notifyListeners();
    debugPrint('GameStateProvider: Oyun tamamen sıfırlandı.');
  }
}