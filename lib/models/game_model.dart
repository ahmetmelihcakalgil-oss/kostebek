// lib/models/game_model.dart

enum GameCategory {
  diziler,
  unluler,
  kitaplar,
  oyunlar,
  filmler,
  animeler,
  ulkeler,
}

class Player {
  bool isImpostor;
  String assignedWord;

  Player({
    this.isImpostor = false,
    this.assignedWord = '',
  });

  void reset() {
    isImpostor = false;
    assignedWord = '';
  }
}

class GameModel {
  int totalPlayers;
  int impostorCount;
  GameCategory? selectedCategory;
  String? selectedWord;
  String? impostorWord;
  List<Player> players;

  GameModel({
    this.totalPlayers = 0,
    this.impostorCount = 1,
    this.selectedCategory,
    this.selectedWord,
    this.impostorWord,
    List<Player>? players,
  }) : players = players ?? [];

  void reset() {
    // totalPlayers ve impostorCount'u SIFIRLAMAYALIM, sadece oyunla ilgili geçici verileri sıfırlayalım
    // totalPlayers = 0; // BU SATIRI KALDIRIN VEYA YORUM SATIRI YAPIN
    // impostorCount = 1; // BU SATIRI KALDIRIN VEYA YORUM SATIRI YAPIN
    selectedCategory = null;
    selectedWord = null;
    impostorWord = null;
    players.clear();
  }
}