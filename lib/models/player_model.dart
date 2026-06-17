// lib/models/player_model.dart
class Player {
  String name;
  bool isImpostor; // Bu oyuncu sahtekar mı?
  String? assignedMovie; // Bu oyuncuya atanan dizi

  Player({
    required this.name,
    this.isImpostor = false,
    this.assignedMovie,
  });
}